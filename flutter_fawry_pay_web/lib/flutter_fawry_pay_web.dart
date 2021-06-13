/*
 * Copyright (c) 2021 Shady Boshra.
 * IN: https://LinkedIn.com/in/ShadyBoshra2012
 * GitHub: https://github.com/ShadyBoshra2012
 * Mostaql: https://mostaql.com/u/ShadyBoshra2012
 */

@JS()
library script.js;

import 'dart:async';
import 'dart:convert';
// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html show window;
import 'dart:html';
import 'dart:js_util';

import 'package:flutter/services.dart';
import 'package:flutter_fawry_pay_web/flutter_fawry_pay.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:js/js.dart';

@JS()
external dynamic checkout();

/// A web implementation of the FlutterFawryPay plugin.
class FlutterFawryPayWeb {
  /// The channel name which it's the bridge between Dart and JAVA or SWIFT.
  static const String _CHANNEL_NAME = "shadyboshra2012/flutterfawrypay";

  /// Methods name which detect which it called from Flutter.
  static const String _METHOD_INIT = "init";
  static const String _METHOD_INITIALIZE = "initialize";

  // static const String _METHOD_INITIALIZE_CARD_TOKENIZER = "initialize_card_tokenizer";
  static const String _METHOD_START_PAYMENT = "start_payment";
  static const String _METHOD_RESET = "reset";

  String? _username, _email, _customerName, _endPointURL;

  static void registerWith(Registrar registrar) {
    final MethodChannel channel = MethodChannel(
      _CHANNEL_NAME,
      const StandardMethodCodec(),
      registrar,
    );

    final pluginInstance = FlutterFawryPayWeb();
    channel.setMethodCallHandler(pluginInstance.handleMethodCall);
  }

  /// Handles method calls over the MethodChannel of this plugin.
  /// Note: Check the "federated" architecture for a new way of doing this:
  /// https://flutter.dev/go/federated-plugins
  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case _METHOD_INIT:
        return _init(call.arguments);
      case _METHOD_INITIALIZE:
        return _initialize(call.arguments);
      case _METHOD_START_PAYMENT:
        return await _startProcess();
      case _METHOD_RESET:
        return _reset();
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details:
              'flutter_fawry_pay for web doesn\'t implement \'${call.method}\'',
        );
    }
  }

  bool _init(dynamic arguments) {
    List<Node>? nodes = html.window.document.documentElement
        ?.getElementsByClassName("fawry-plugin-script");

    if (nodes?.length == 1) return true;

    _username = arguments["username"];
    _email = arguments["email"];
    _customerName = arguments["customerName"];
    if (arguments["environment"].contains("LIVE"))
      _endPointURL = "https://atfawry.com";
    else
      _endPointURL = "https://atfawry.fawrystaging.com";

    LinkElement fawryStyleSheet = LinkElement()
      ..attributes = {
        "class": "fawry-charges-stylesheet",
        "rel": "stylesheet",
        "href":
            "$_endPointURL/atfawry/plugin/assets/payments/css/fawrypay-payments.css",
      };

    ScriptElement fawryPluginScript = ScriptElement()
      ..attributes = {
        "class": "fawry-plugin-script",
        "type": "text/javascript",
        "src":
            "$_endPointURL/atfawry/plugin/assets/payments/js/fawrypay-payments.js",
      };

    html.window.document.documentElement?.append(fawryStyleSheet);
    html.window.document.documentElement?.append(fawryPluginScript);

    return true;
  }

  bool _initialize(dynamic arguments) {
    List<Node>? nodes = html.window.document.documentElement
        ?.getElementsByClassName("fawry-charges-script");

    String merchantID = arguments["merchantID"];
    String merchantRefNumber = (arguments["merchantRefNumber"] != null)
        ? arguments["merchantRefNumber"].toString()
        : FlutterFawryPay.instance.randomAlphaNumeric(16);
    List items = arguments["items"];
    String? customerProfileId = arguments["customerProfileId"];
    String language =
        arguments["language"].replaceAll("Language.", "").toLowerCase();
    String webDisplayMode =
        arguments["webDisplayMode"].replaceAll("DisplayMode.", "");
    int? paymentExpiry = arguments["paymentExpiry"];
    String? returnUrl = arguments["returnUrl"];
    bool? authCaptureModePayment = arguments["authCaptureModePayment"];

    String chargeItemsString = "[";
    for (Map item in items) {
      String itemString = """
      {
        itemId: '${item["sku"]}',
        description: '${item["description"]}',
        price: ${item["price"]},
        quantity: ${item["qty"]},
        ${(item["imageUrl"] != null) ? "imageUrl: '${item["imageUrl"]}'," : ""}
        },
      """;
      chargeItemsString += itemString;
    }
    chargeItemsString += "]";

    ScriptElement script = ScriptElement()
      ..text = """
      var resultData;
      
      async function checkout() {
        var configuration = {
            locale : "$language",  //default en
            mode: DISPLAY_MODE.$webDisplayMode,  //required, allowed values [POPUP, INSIDE_PAGE, SIDE_PAGE]
            onSuccess : successCallBack,  //optional and not supported in SEPARATED display mode
            onFailure : failureCallBack,  //optional and not supported in SEPARATED display mode
        }; 
        
        FawryPay.checkout(buildChargeRequest(), configuration);
        
        await checkResultDataNullity();
        
        return JSON.stringify(resultData);
      }
      
      async function checkResultDataNullity() {
        await new Promise(resolve => setTimeout(async () => {
            if (resultData == null) await checkResultDataNullity();
            resolve();
          }, 50));
        resetResultData();
      }
      
      function resetResultData() {
        new Promise(resolve => setTimeout(async () => {
          resultData = null;
          resolve();
        }, 1000));
      }
      
      function buildChargeRequest() {
        const chargeRequest = {
            merchantCode: '$merchantID',
            merchantRefNum: '$merchantRefNumber',
            ${(_username != null) ? "customerMobile: '$_username'," : ""}
            ${(_email != null) ? "customerEmail: '$_email'," : ""}
            ${(_customerName != null) ? "customerName: '$_customerName'," : ""}
            ${(customerProfileId != null) ? "customerProfileId: '$customerProfileId'," : ""}
            ${(paymentExpiry != null) ? "paymentExpiry: '$paymentExpiry'," : ""}
            ${(returnUrl != null) ? "returnUrl: '$returnUrl'," : ""}
            ${(authCaptureModePayment != null) ? "authCaptureModePayment: '$authCaptureModePayment'," : ""}
            chargeItems: $chargeItemsString,
            signature: "2ca4c078ab0d4c50ba90e31b3b0339d4d4ae5b32f97092dd9e9c07888c7eef36"
        };
        return chargeRequest;
      }
      
      function successCallBack(data) {
        // console.log('handle successful callback as desired, data', data);
        
        resultData = {
          "trx_id": data["referenceNumber"],
          "expiry_date_key": data["expirationTime"],
        };
        
        window.postMessage({
          "trx_id": data["referenceNumber"],
          "expiry_date_key": data["expirationTime"],
        }, "*");
      }
      
      function failureCallBack(data) {
        // console.log('handle failure callback as desired, data', data);
        
        resultData = {
          "error_message": data["statusDescription"]
        };
        
        window.postMessage({
          "error_message": data["statusDescription"]
        }, "*");
      }
    """
      ..setAttribute("class", "fawry-charges-script");

    if (nodes?.length == 0)
      html.window.document.documentElement?.append(script);
    else
      nodes?.last.replaceWith(script);

    return true;
  }

  Future<Map> _startProcess() async {
    var object = await promiseToFuture(checkout());
    return jsonDecode(object);
  }

  bool _reset() {
    List<Node>? nodes = html.window.document.documentElement
        ?.getElementsByClassName("fawry-charges-script");

    ScriptElement script = ScriptElement()
      ..text = """
        checkout = null;
      """
      ..setAttribute("class", "fawry-charges-script");

    if (nodes?.length == 1) nodes?.last.replaceWith(script);
    return true;
  }

  static Stream callbackResultStream() {
    return html.window.onMessage.map((event) => event.data);
  }
}
