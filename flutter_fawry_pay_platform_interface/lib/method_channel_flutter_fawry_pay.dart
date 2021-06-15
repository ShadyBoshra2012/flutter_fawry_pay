/*
 * Copyright (c) 2021 Shady Boshra.
 * IN: https://LinkedIn.com/in/ShadyBoshra2012
 * GitHub: https://github.com/ShadyBoshra2012
 * Mostaql: https://mostaql.com/u/ShadyBoshra2012
 */

import 'dart:async';

import 'package:flutter/services.dart';

import 'flutter_fawry_pay_platform_interface.dart';
import 'models/fawry_item.dart';
import 'models/fawry_response.dart';

/// An implementation of [FlutterFawryPayPlatform] that uses method channels.
class MethodChannelFlutterFawryPay extends FlutterFawryPayPlatform {
  /// The channel name which it's the bridge between Dart and different platforms.
  static const String _CHANNEL_NAME = "shadyboshra2012/flutterfawrypay";

  /// Methods name which detect which it called from Flutter.
  static const String _METHOD_INIT = "init";
  static const String _METHOD_INITIALIZE = "initialize";
  static const String _METHOD_INITIALIZE_CARD_TOKENIZER =
      "initialize_card_tokenizer";
  static const String _METHOD_START_PAYMENT = "start_payment";
  static const String _METHOD_RESET = "reset";

  /// Error codes returned to Flutter if there's an error.
  static const String _ERROR_INIT = "1";
  static const String _ERROR_INITIALIZE = "2";
  static const String _ERROR_INITIALIZE_CARD_TOKENIZER = "3";
  static const String _ERROR_START_PAYMENT = "4";
  static const String _ERROR_RESET = "5";

  static const MethodChannel _channel = MethodChannel(_CHANNEL_NAME);

  /// Init FawryPay SDK services.
  ///
  /// This initialize the SDK for one time only and
  /// also can change at anytime.
  /// Set here some parameters to configure the SDK.
  /// Returns `true` if it initialized fine.
  /// Throws exception if not.
  ///
  /// [merchantID] sets the merchantID that you have received from Fawry.
  /// [style] sets the style of SDK.
  /// [enableLogging] sets whether enable logs from SDK or not.
  /// [skipCustomerInput] sets whether you let user enter username and email,
  /// or there's a default username and email. If you set it to true, then you
  /// are required to set default username and email.
  /// [username] sets the default username if you set `skipCustomerInput = true`,
  /// it should be a phone number.
  /// [email] sets the default email if you set `skipCustomerInput = true`.
  /// [webCustomerName] optional sets customer name (Only Web).
  /// [language] sets the language of payment, whether English or Arabic, default English.
  /// [environment] sets the environment of payment, whether Test or Live, default Test.
  /// [webDisplayMode] sets display mode (Only Web).
  @override
  Future<bool> init({
    required String merchantID,
    Style style = Style.STYLE1,
    bool enableLogging = false,
    bool enableMockups = false,
    bool skipCustomerInput = false,
    String? username,
    String? email,
    String? webCustomerName,
    Language language = Language.EN,
    Environment environment = Environment.TEST,
    DisplayMode webDisplayMode = DisplayMode.POPUP,
  }) async {
    // Check if skipCustomerInput is true, but username or email is equals null.
    assert(
        !skipCustomerInput ||
            (skipCustomerInput && username != null && email != null),
        "If skipCustomerInput is true, then you should set username and email.");

    try {
      return await _channel.invokeMethod(_METHOD_INIT, <String, dynamic>{
        'merchantID': merchantID,
        'style': style.toString(),
        'enableLogging': enableLogging,
        'enableMockups': enableMockups,
        'skipCustomerInput': skipCustomerInput,
        'username': username,
        'email': email,
        'webCustomerName': webCustomerName,
        'language': language.toString(),
        'environment': environment.toString(),
        'webDisplayMode': webDisplayMode.toString(),
      });
    } on PlatformException catch (e) {
      if (e.code == _ERROR_INIT)
        throw "Error Occurred: Code: $_ERROR_INIT. Message: ${e.message}. Details: SDK Init Error";
      throw "Error Occurred: Code: ${e.code}. Message: ${e.message}. Details: ${e.details}";
    } catch (e) {
      throw "Error Occurred: Message: $e";
    }
  }

  /// Initialize FawryPay payment charge.
  ///
  /// Initialize the payment charge by adding some parameters.
  /// Returns `true` if it initialized fine.
  /// Throws exception if not.
  ///
  /// [items] sets the list of items that the user will pay for.
  /// [merchantRefNumber] sets an optional number consists of 16 random characters and numbers.
  /// [customerProfileId] sets an optional profile id (Only Web).
  /// [paymentExpiry] sets the time in which it will expire this payment (Only Web).
  /// [returnUrl] sets return url which will go back after payment completed (Only Web & Must include if using Cards).
  /// [authCaptureModePayment] sets auth capture mode payment (Only Web).
  /// [customParam] sets a map of custom data you want to receive back with result data after payment.
  @override
  Future<bool> initialize({
    required List<FawryItem> items,
    String? merchantRefNumber,
    String? customerProfileId,
    int? paymentExpiry,
    String? returnUrl,
    bool? authCaptureModePayment,
    Map<String, dynamic>? customParam,
  }) async {
    try {
      return await _channel.invokeMethod(_METHOD_INITIALIZE, <String, dynamic>{
        'items': items.map((e) => e.toJSON()).toList(),
        'merchantRefNumber': merchantRefNumber,
        'customerProfileId': customerProfileId,
        'paymentExpiry': paymentExpiry,
        'returnUrl': returnUrl,
        'authCaptureModePayment': authCaptureModePayment,
        'customParam': customParam,
      });
    } on PlatformException catch (e) {
      if (e.code == _ERROR_INITIALIZE)
        throw "Error Occurred: Code: $_ERROR_INITIALIZE. Message: ${e.message}. Details: SDK Initialization Error";
      throw "Error Occurred: Code: ${e.code}. Message: ${e.message}. Details: ${e.details}";
    } catch (e) {
      throw "Error Occurred: $e";
    }
  }

  /// Initialize Card Tokenizer.
  ///
  /// Initialize the adding new card.
  /// Returns `true` if it initialized fine.
  /// Throws exception if not.
  ///
  /// [customerMobile] sets the user phone number.
  /// [customerEmail] sets the user email.
  /// [customerProfileId] sets an optional profile id (Only iOS).
  /// [merchantRefNumber] sets an optional number consists of 16 random characters and numbers (only Android).
  /// [customParam] sets a map of custom data you want to receive back with result data after payment.
  Future<bool> initializeCardTokenizer({
    required String customerMobile,
    required String customerEmail,
    String? customerProfileId,
    String? merchantRefNumber,
    Map<String, dynamic>? customParam,
  }) async {
    try {
      return await _channel
          .invokeMethod(_METHOD_INITIALIZE_CARD_TOKENIZER, <String, dynamic>{
        'customerMobile': customerMobile,
        'customerEmail': customerEmail,
        'customerProfileId': customerProfileId,
        'merchantRefNumber': merchantRefNumber,
        'customParam': customParam,
      });
    } on PlatformException catch (e) {
      if (e.code == _ERROR_INITIALIZE_CARD_TOKENIZER)
        throw "Error Occurred: Code: $_ERROR_INITIALIZE_CARD_TOKENIZER. Message: ${e.message}. Details: SDK Initialize Card Tokenizer Error";
      throw "Error Occurred: Code: ${e.code}. Message: ${e.message}. Details: ${e.details}";
    } catch (e) {
      throw "Error Occurred: $e";
    }
  }

  /// Start FawryPay SDK process.
  ///
  /// Start FawryPay SDK process, whether it was initialized for payment,
  /// or initialized for card tokenizer.
  /// Returns a `FawryResponse` type of the resulted data.
  /// Throws exception if not completed well.
  @override
  Future<FawryResponse> startProcess() async {
    try {
      Map<dynamic, dynamic> data =
          await (_channel.invokeMethod(_METHOD_START_PAYMENT));
      return FawryResponse.fromMap(data);
    } on PlatformException catch (e) {
      if (e.code == _ERROR_START_PAYMENT)
        throw "Error Occurred: Code: $_ERROR_START_PAYMENT. Message: ${e.message}. Details: SDK start process error";
      throw "Error Occurred: Code: ${e.code}. Message: ${e.message}. Details: ${e.details}";
    } catch (e) {
      throw "Error Occurred: $e";
    }
  }

  /// Reset FawryPay SDK Payment.
  ///
  /// Returns `true` if it was rest well.
  /// Throws exception if not.
  @override
  Future<bool> reset() async {
    try {
      return await _channel.invokeMethod(_METHOD_RESET);
    } on PlatformException catch (e) {
      if (e.code == _ERROR_RESET)
        throw "Error Occurred: Code: $_ERROR_RESET. Message: ${e.message}. Details: SDK Reset SDK Error";
      throw "Error Occurred: Code: ${e.code}. Message: ${e.message}. Details: ${e.details}";
    } catch (e) {
      throw "Error Occurred: $e";
    }
  }
}
