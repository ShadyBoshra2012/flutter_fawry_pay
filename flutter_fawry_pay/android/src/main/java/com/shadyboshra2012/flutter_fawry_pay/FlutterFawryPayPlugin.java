package com.shadyboshra2012.flutter_fawry_pay;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

import androidx.annotation.NonNull;

import com.emeint.android.fawryplugin.Plugininterfacing.FawrySdk;
import com.emeint.android.fawryplugin.Plugininterfacing.PayableItem;
import com.emeint.android.fawryplugin.exceptions.FawryException;
import com.emeint.android.fawryplugin.interfaces.FawrySdkCallback;
import com.emeint.android.fawryplugin.managers.FawryPluginAppClass;
import com.emeint.android.fawryplugin.models.FawryCardToken;
import com.emeint.android.fawryplugin.utils.UiUtils;
import com.shadyboshra2012.flutter_fawry_pay.models.Item;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.UUID;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;

import static android.app.Activity.RESULT_OK;

/**
 * FlutterFawryPayPlugin
 */
public class FlutterFawryPayPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
    /// The channel name which it's the bridge between Dart and JAVA
    private static final String CHANNEL_NAME = "shadyboshra2012/flutterfawrypay";

    /// Methods name which detect which it called from Flutter.
    private static final String METHOD_INIT = "init";
    private static final String METHOD_INITIALIZE = "initialize";
    private static final String METHOD_INITIALIZE_CARD_TOKENIZER = "initialize_card_tokenizer";
    private static final String METHOD_START_PAYMENT = "start_payment";
    private static final String METHOD_RESET = "reset";

    private static final String EVENT_CHANNEL_CALLBACK_RESULT = "flutterfawrypay/callback_result_stream";

    /// Error codes returned to Flutter if there's an error.
    private static final String ERROR_INIT = "1";
    private static final String ERROR_INITIALIZE = "2";
    private static final String ERROR_START_PAYMENT = "3";
    private static final String ERROR_INITIALIZE_CARD_TOKENIZER = "4";
    private static final String ERROR_RESET = "5";

    private final int PAYMENT_PLUGIN_REQUEST = 1023;
    private final int CARD_TOKENIZER_REQUEST = 1024;
    private static final String ALPHA_NUMERIC_STRING = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;

    /// Activity to hold it for Payment SDK needs.
    private static Activity activity;

    /// Variable to hold the result object when it need to be coded inside callbacks.
    private static Result pendingResult;

    /// Variable to send the result object when it need to be coded inside callbacks
    private static EventChannel.EventSink eventSink;

    /// Variable to store static data.
    private static String merchantID, endPointURL;
    FawrySdk.Language language;

    /// Variable of callback SDK results.
    private static final FawrySdkCallback callback = new FawrySdkCallback() {
        @Override
        public void paymentOperationSuccess(String trx_id, Object o) {
            final Bundle object = (Bundle) o;
            Log.i("0", trx_id + o.toString());
            try {
                int requestResult = object.getInt(FawryPluginAppClass.REQUEST_RESULT);
                if (requestResult == FawryPluginAppClass.SUCCESS_CODE) {
                    final String trxID = object.getString(FawryPluginAppClass.TRX_ID_KEY, "");
                    final long expDate = object.getLong(FawryPluginAppClass.EXPIRY_DATE_KEY, -1);
                    final HashMap<String, Object> result = new HashMap<String, Object>() {{
                        put(FawryPluginAppClass.TRX_ID_KEY, trxID);
                        put(FawryPluginAppClass.EXPIRY_DATE_KEY, expDate);
                        if (object.getSerializable(FawryPluginAppClass.CUSTOM_PARAMS) != null)
                            put(FawryPluginAppClass.CUSTOM_PARAMS, object.getSerializable(FawryPluginAppClass.CUSTOM_PARAMS));
                    }};
                    if (pendingResult != null) {
                        pendingResult.success(result);
                        pendingResult = null;
                    }
                    if (eventSink != null)
                        eventSink.success(result);
                } else if (requestResult == FawryPluginAppClass.FAILURE_CODE) {
                    String errorMessage = object.getString(FawryPluginAppClass.ERROR_MESSAGE_KEY, "");
                    if (pendingResult != null) {
                        pendingResult.error(ERROR_INITIALIZE, errorMessage, "");
                        pendingResult = null;
                    }
                    if (eventSink != null)
                        eventSink.error(ERROR_INITIALIZE, errorMessage, "");
                }
            } catch (Exception ex) {
                // Return an error.
                if (pendingResult != null) {
                    pendingResult.error("0", ex.getMessage(), ex.getLocalizedMessage());
                    pendingResult = null;
                }
                if (eventSink != null)
                    eventSink.error("0", ex.getMessage(), ex.getLocalizedMessage());
            }
        }

        @Override
        public void paymentOperationFailure(String s, Object o) {
            Log.i("1", s + o.toString());
        }
    };

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), CHANNEL_NAME);
        channel.setMethodCallHandler(this);

        flutterPluginBinding
                .getPlatformViewRegistry()
                .registerViewFactory("FawryButton", new NativeFawryButtonFactory(flutterPluginBinding.getBinaryMessenger(), null));


        new EventChannel(flutterPluginBinding.getBinaryMessenger(), EVENT_CHANNEL_CALLBACK_RESULT).setStreamHandler(
                new EventChannel.StreamHandler() {
                    @Override
                    public void onListen(Object args, EventChannel.EventSink events) {
                        eventSink = events;
                    }

                    @Override
                    public void onCancel(Object args) {
                        eventSink = null;
                    }
                }
        );
    }

    @Override
    public void onAttachedToActivity(ActivityPluginBinding activityPluginBinding) {
        activity = activityPluginBinding.getActivity();
        activityPluginBinding.addActivityResultListener(new PluginRegistry.ActivityResultListener() {
            @Override
            public boolean onActivityResult(int requestCode, int resultCode, final Intent data) {
                try {
                    if (requestCode == PAYMENT_PLUGIN_REQUEST) {
                        if (resultCode == RESULT_OK) {
                            int requestResult = data.getIntExtra(FawryPluginAppClass.REQUEST_RESULT, -1);
                            if (requestResult == FawryPluginAppClass.SUCCESS_CODE) {
                                final String trxID = data.getStringExtra(FawryPluginAppClass.TRX_ID_KEY);
                                final long expDate = data.getLongExtra(FawryPluginAppClass.EXPIRY_DATE_KEY, -1);
                                final HashMap<String, Object> result = new HashMap<String, Object>() {{
                                    put(FawryPluginAppClass.TRX_ID_KEY, trxID);
                                    put(FawryPluginAppClass.EXPIRY_DATE_KEY, expDate);
                                    if (data.getSerializableExtra(FawryPluginAppClass.CUSTOM_PARAMS) != null)
                                        put(FawryPluginAppClass.CUSTOM_PARAMS, data.getSerializableExtra(FawryPluginAppClass.CUSTOM_PARAMS));
                                    if (data.getStringExtra(FawryPluginAppClass.ERROR_MESSAGE_KEY) != null)
                                        put(FawryPluginAppClass.ERROR_MESSAGE_KEY, data.getStringExtra(FawryPluginAppClass.ERROR_MESSAGE_KEY));
                                }};
                                if (pendingResult != null) {
                                    pendingResult.success(result);
                                    pendingResult = null;
                                }
                                if (eventSink != null)
                                    eventSink.success(result);
                            } else if (requestResult == FawryPluginAppClass.FAILURE_CODE) {
                                String errorMessage = data.getStringExtra(FawryPluginAppClass.ERROR_MESSAGE_KEY);
                                if (pendingResult != null) {
                                    pendingResult.error(ERROR_INITIALIZE, errorMessage, "");
                                    pendingResult = null;
                                }
                                if (eventSink != null)
                                    eventSink.error(ERROR_INITIALIZE, errorMessage, "");
                            }
                        } else {
                            if (pendingResult != null) {
                                pendingResult.error(ERROR_INITIALIZE_CARD_TOKENIZER, "", "");
                                pendingResult = null;
                            }
                            if (eventSink != null)
                                eventSink.error(ERROR_INITIALIZE_CARD_TOKENIZER, "", "");
                        }
                    } else if (requestCode == CARD_TOKENIZER_REQUEST) {
                        if (resultCode == RESULT_OK) {
                            final FawryCardToken fawryCardToken = data.getParcelableExtra(FawryPluginAppClass.CARD_TOKEN_KEY);
                            final HashMap<String, Object> result = new HashMap<String, Object>() {{
                                put(FawryPluginAppClass.CARD_TOKEN_KEY, fawryCardToken.getToken());
                                put("card_creation_date", fawryCardToken.getCreationDate());
                                put("card_last_four_digits", fawryCardToken.getLastFourDigits());
                                if (data.getSerializableExtra(FawryPluginAppClass.CUSTOM_PARAMS) != null)
                                    put(FawryPluginAppClass.CUSTOM_PARAMS, data.getSerializableExtra(FawryPluginAppClass.CUSTOM_PARAMS));
                                if (data.getStringExtra(FawryPluginAppClass.ERROR_MESSAGE_KEY) != null)
                                    put(FawryPluginAppClass.ERROR_MESSAGE_KEY, data.getStringExtra(FawryPluginAppClass.ERROR_MESSAGE_KEY));
                            }};
                            if (pendingResult != null) {
                                pendingResult.success(result);
                                pendingResult = null;
                            }
                            if (eventSink != null)
                                eventSink.success(result);
                        } else {
                            if (pendingResult != null) {
                                pendingResult.error(ERROR_INITIALIZE_CARD_TOKENIZER, data.getStringExtra(FawryPluginAppClass.ERROR_MESSAGE_KEY), "");
                                pendingResult = null;
                            }
                            if (eventSink != null)
                                eventSink.error(ERROR_INITIALIZE_CARD_TOKENIZER, data.getStringExtra(FawryPluginAppClass.ERROR_MESSAGE_KEY), "");
                        }
                    }
                } catch (Exception ex) {
                    // Return an error.
                    if (pendingResult != null) {
                        pendingResult.error("0", ex.getMessage(), ex.getLocalizedMessage());
                        pendingResult = null;
                    }
                    if (eventSink != null)
                        eventSink.error("0", ex.getMessage(), ex.getLocalizedMessage());
                }
                return true;
            }
        });
//        activity.set
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        // This call will be followed by onReattachedToActivityForConfigChanges().
    }

    @Override
    public void onReattachedToActivityForConfigChanges(ActivityPluginBinding activityPluginBinding) { }

    @Override
    public void onDetachedFromActivity() { }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        switch (call.method) {
            case METHOD_INIT:
                try {
                    // Get the args from Flutter.
                    merchantID = call.argument("merchantID");
                    String styleString = call.argument("style");
                    boolean enableLogging = call.argument("enableLogging");
                    boolean enableMockups = call.argument("enableMockups");
                    boolean skipCustomerInput = call.argument("skipCustomerInput");
                    String username = call.argument("username");
                    String email = call.argument("email");
                    String languageString = call.argument("language");
                    String environment = call.argument("environment");

                    // Assert not null
                    assert styleString != null;
                    assert languageString != null;
                    assert environment != null;

                    // Set FawrySdk style
                    FawrySdk.Styles style = (styleString.equals("Style.STYLE1"))
                            ? FawrySdk.Styles.STYLE1 : FawrySdk.Styles.STYLE2;

                    endPointURL = (environment.equals("Environment.LIVE"))
                            ? "https://atfawry.com"
                            : "https://atfawry.fawrystaging.com";

                    // Set FawrySdk language
                    language = (languageString.equals("Language.EN"))
                            ? FawrySdk.Language.EN : FawrySdk.Language.AR;

                    // start FawryPay services
                    FawrySdk.init(style);

                    FawryPluginAppClass.enableLogging = enableLogging;
                    FawryPluginAppClass.enableMockups = enableMockups;
                    FawryPluginAppClass.skipCustomerInput = skipCustomerInput;
                    FawryPluginAppClass.username = username;
                    FawryPluginAppClass.email = email;

                    // Return a success.
                    result.success(true);
                } catch (Exception ex) {
                    // Return an error.
                    result.error(ERROR_INIT, ex.getMessage(), ex.getLocalizedMessage());
                }
                break;
            case METHOD_INITIALIZE:
                try {
                    // Get the args from Flutter.
                    String merchantRefNumber = (call.argument("merchantRefNumber") != null)
                            ? call.argument("merchantRefNumber").toString()
                            : randomAlphaNumeric(16);
                    List<HashMap<String, Object>> items = call.argument("items");
                    HashMap<String, Object> customParam = call.argument("customParam");

                    // Assert not null
                    assert merchantRefNumber != null;
                    assert items != null;

                    List<PayableItem> cartItems = new ArrayList<>();

                    for (HashMap<String, Object> item : items) {
                        Item cartItem = new Item();
                        cartItem.setSku(item.get("sku").toString());
                        cartItem.setDescription(item.get("description").toString());
                        cartItem.setQty(item.get("qty").toString());
                        cartItem.setPrice(item.get("price").toString());

                        if (item.get("originalPrice") != null)
                            cartItem.setOriginalPrice(item.get("originalPrice").toString());
                        if (item.get("height") != null)
                            cartItem.setHeight(item.get("height").toString());
                        if (item.get("length") != null)
                            cartItem.setLength(item.get("length").toString());
                        if (item.get("weight") != null)
                            cartItem.setWeight(item.get("weight").toString());
                        if (item.get("width") != null)
                            cartItem.setWidth(item.get("width").toString());
                        if (item.get("variantCode") != null)
                            cartItem.setVariantCode(item.get("variantCode").toString());
                        if (item.get("reservationCodes") != null)
                            cartItem.setReservationCodes((String[]) item.get("reservationCodes"));
                        if (item.get("earningRuleID") != null)
                            cartItem.setEarningRuleID(item.get("earningRuleID").toString());

                        cartItems.add(cartItem);
                    }

                    FawrySdk.initialize(activity, endPointURL, callback, merchantID, merchantRefNumber,
                            cartItems, language, PAYMENT_PLUGIN_REQUEST,
                            customParam, new UUID(1, 2));

                    // Return true for a success.
                    result.success(true);
                } catch (FawryException ex) {
                    UiUtils.showDialog(activity, ex, false);
                    ex.printStackTrace();
                    // Return an error.
                    result.error(ex.getStatusCode() + "", ex.getExceptionTitle(), ex.getExceptionMessage());
                } catch (Exception ex) {
                    // Return an error.
                    result.error(ERROR_INITIALIZE, ex.getMessage(), ex.getLocalizedMessage());
                }
                break;
            case METHOD_INITIALIZE_CARD_TOKENIZER:
                try {
                    // Get the args from Flutter.
                    String merchantRefNumber = (call.argument("merchantRefNumber") != null)
                            ? call.argument("merchantRefNumber").toString()
                            : randomAlphaNumeric(16);
                    String customerMobile = call.argument("customerMobile");
                    String customerEmail = call.argument("customerEmail");
                    HashMap<String, Object> customParam = call.argument("customParam");

                    // Assert not null
                    assert merchantID != null;
                    assert merchantRefNumber != null;

                    FawrySdk.initializeCardTokenizer(activity, endPointURL, callback, merchantID,
                            merchantRefNumber, customerMobile, customerEmail, language,
                            CARD_TOKENIZER_REQUEST, customParam, new UUID(1, 2));

                    // Return true for a success.
                    result.success(true);
                } catch (FawryException ex) {
                    UiUtils.showDialog(activity, ex, false);
                    ex.printStackTrace();
                    // Return an error.
                    result.error(ex.getStatusCode() + "", ex.getExceptionTitle(), ex.getExceptionMessage());
                } catch (Exception ex) {
                    // Return an error.
                    result.error(ERROR_INITIALIZE_CARD_TOKENIZER, ex.getMessage(), ex.getLocalizedMessage());
                }
                break;
            case METHOD_START_PAYMENT:
                try {
                    // Set pendingResult to result to use it in callbacks.
                    pendingResult = result;

                    // Start FawrySdk payment activity
                    FawrySdk.startPaymentActivity(activity);
                } catch (Exception ex) {
                    // Return an error.
                    result.error(ERROR_START_PAYMENT, ex.getMessage(), ex.getLocalizedMessage());
                }
                break;
            case METHOD_RESET:
                try {
                    // Reset FawrySdk payment
                    FawrySdk.resetFawrySDK();

                    // Return true for a success.
                    result.success(true);
                } catch (Exception ex) {
                    // Return an error.
                    result.error(ERROR_RESET, ex.getMessage(), ex.getLocalizedMessage());
                }
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }

    public static String randomAlphaNumeric(int count) {
        StringBuilder builder = new StringBuilder();
        while (count-- != 0) {
            int character = (int) (Math.random() * ALPHA_NUMERIC_STRING.length());
            builder.append(ALPHA_NUMERIC_STRING.charAt(character));
        }
        return builder.toString();
    }
}
