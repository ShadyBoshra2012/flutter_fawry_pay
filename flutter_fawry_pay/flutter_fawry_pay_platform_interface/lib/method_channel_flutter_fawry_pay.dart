import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_fawry_pay/enums/environment.dart';
import 'package:flutter_fawry_pay/models/fawry_response.dart';

import 'enums/display_mode.dart';
import 'enums/language.dart';
import 'enums/style.dart';
import 'flutter_fawry_pay_platform_interface.dart';
import 'models/fawry_item.dart';

/// An implementation of [FlutterFawryPayPlatform] that uses method channels.
class MethodChannelFlutterFawryPay extends FlutterFawryPayPlatform {
  /// The channel name which it's the bridge between Dart and JAVA or SWIFT.
  static const String _CHANNEL_NAME = "shadyboshra2012/flutterfawrypay";

  /// Methods name which detect which it called from Flutter.
  static const String _METHOD_INIT = "init";
  static const String _METHOD_INITIALIZE = "initialize";
  static const String _METHOD_INITIALIZE_CARD_TOKENIZER = "initialize_card_tokenizer";
  static const String _METHOD_START_PAYMENT = "start_payment";
  static const String _METHOD_RESET = "reset";

  static const MethodChannel _channel = MethodChannel(_CHANNEL_NAME);

  /// Init FawryPay SDK services.
  ///
  /// This initialize the SDK for one time only and
  /// also can change at anytime.
  /// Set here some parameters to configure the SDK.
  /// Returns `true` if it initialized fine.
  /// Throws exception if not.
  ///
  /// [style] sets the style of SDK.
  /// [enableLogging] sets whether enable logs from SDK or not.
  /// [skipCustomerInput] sets whether you let user enter username and email,
  /// or there's a default username and email. If you set it to true, then you
  /// are required to set default username and email.
  /// [username] sets the default username if you set `skipCustomerInput = true`,
  /// it should be a phone number.
  /// [email] sets the default email if you set `skipCustomerInput = true`.
  /// [customerName] optional sets customer name (Only Web).
  /// [environment] sets the environment.
  @override
  Future<bool?> init({
    Style style = Style.STYLE1,
    bool enableLogging = false,
    bool enableMockups = false,
    bool skipCustomerInput = false,
    String? username,
    String? email,
    String? webCustomerName,
    Environment environment = Environment.TEST,
  }) {
    return _channel.invokeMethod(_METHOD_INIT, <String, dynamic>{
      'style': style.toString(),
      'enableLogging': enableLogging,
      'enableMockups': enableMockups,
      'skipCustomerInput': skipCustomerInput,
      'username': username,
      'email': email,
      'webCustomerName': webCustomerName,
      'environment': environment.toString(),
    }).then((value) => value ?? false);
  }

  /// Initialize FawryPay payment charge.
  ///
  /// Initialize the payment charge by adding some parameters.
  /// Returns `true` if it initialized fine.
  /// Throws exception if not.
  ///
  /// [merchantID] sets the merchantID that you have received from Fawry.
  /// [items] sets the list of items that the user will pay for.
  /// [merchantRefNumber] sets an optional number consists of 16 random characters and numbers.
  /// [customerProfileId] sets an optional profile id (Only Web).
  /// [language] sets the language of payment, whether English or Arabic, default English.
  /// [environment] sets the environment of payment, whether Test or Live, default Test.
  /// [webDisplayMode] sets display mode (Only Web).
  /// [paymentExpiry] sets the time in which it will expire this payment (Only Web).
  /// [returnUrl] sets return url which will go back after payment completed (Only Web & Must include if using Cards).
  /// [authCaptureModePayment] sets auth capture mode payment (Only Web).
  /// [customParam] sets a map of custom data you want to receive back with result data after payment.
  @override
  Future<bool?> initialize({
    required String merchantID,
    required List<FawryItem> items,
    String? merchantRefNumber,
    String? customerProfileId,
    Language language = Language.EN,
    Environment environment = Environment.TEST,
    DisplayMode webDisplayMode = DisplayMode.POPUP,
    int? paymentExpiry,
    String? returnUrl,
    bool? authCaptureModePayment,
    Map<String, dynamic>? customParam,
  }) {
    return _channel.invokeMethod(_METHOD_INITIALIZE, <String, dynamic>{
      'merchantID': merchantID,
      'items': items.map((e) => e.toJSON()).toList(),
      'merchantRefNumber': merchantRefNumber,
      'customerProfileId': customerProfileId,
      'language': language.toString(),
      'environment': environment.toString(),
      'webDisplayMode': webDisplayMode.toString(),
      'paymentExpiry': paymentExpiry,
      'returnUrl': returnUrl,
      'authCaptureModePayment': authCaptureModePayment,
      'customParam': customParam,
    }).then((value) => value ?? false);
  }

  /// Initialize Card Tokenizer.
  ///
  /// Initialize the adding new card.
  /// Returns `true` if it initialized fine.
  /// Throws exception if not.
  ///
  /// [merchantID] sets the merchantID that you have received from Fawry.
  /// [customerMobile] sets the user phone number.
  /// [customerEmail] sets the user email.
  /// [customerProfileId] sets an optional profile id (Only iOS).
  /// [merchantRefNumber] sets an optional number consists of 16 random characters and numbers (only Android).
  /// [language] sets the language of payment, whether English or Arabic, default English.
  /// [environment] sets the environment of payment, whether Test or Live, default Test.
  /// [customParam] sets a map of custom data you want to receive back with result data after payment.
  Future<bool?> initializeCardTokenizer({
    required String merchantID,
    required String customerMobile,
    required String customerEmail,
    String? customerProfileId,
    String? merchantRefNumber,
    Language language = Language.EN,
    Environment environment = Environment.TEST,
    Map<String, dynamic>? customParam,
  }) {
    return _channel.invokeMethod(_METHOD_INITIALIZE_CARD_TOKENIZER, <String, dynamic>{
      'merchantID': merchantID,
      'customerMobile': customerMobile,
      'customerEmail': customerEmail,
      'customerProfileId': customerProfileId,
      'merchantRefNumber': merchantRefNumber,
      'language': language.toString(),
      'environment': environment.toString(),
      'customParam': customParam,
    }).then((value) => value ?? false);
  }

  /// Start FawryPay SDK process.
  ///
  /// Start FawryPay SDK process, whether it was initialized for payment,
  /// or initialized for card tokenizer.
  /// Returns a `FawryResponse` type of the resulted data.
  /// Throws exception if not completed well.
  @override
  Future<FawryResponse> startProcess() async {
    Map<dynamic, dynamic> data = await (_channel.invokeMethod(_METHOD_START_PAYMENT));
    return FawryResponse.fromMap(data);
  }

  /// Reset FawryPay SDK Payment.
  ///
  /// Returns `true` if it was rest well.
  /// Throws exception if not.
  @override
  Future<bool?> reset() {
    return _channel.invokeMethod(_METHOD_RESET).then((value) => value ?? false);
  }
}
