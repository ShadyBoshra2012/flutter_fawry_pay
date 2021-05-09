/*
 * Copyright (c) 2021 Shady Boshra.
 * IN: https://LinkedIn.com/in/ShadyBoshra2012
 * GitHub: https://github.com/ShadyBoshra2012
 * Mostaql: https://mostaql.com/u/ShadyBoshra2012
 */

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

part 'fawry_button.dart';
part 'package:flutter_fawry_pay/enums/environment.dart';
part 'package:flutter_fawry_pay/enums/language.dart';
part 'package:flutter_fawry_pay/enums/style.dart';
part 'package:flutter_fawry_pay/models/fawry_item.dart';
part 'package:flutter_fawry_pay/models/fawry_response.dart';

class FlutterFawryPay {
  /// Singleton constructor.
  FlutterFawryPay._();

  /// Instance of FlutterFawryPay singleton.
  static FlutterFawryPay instance = FlutterFawryPay._();

  /// The channel name which it's the bridge between Dart and JAVA or SWIFT.
  static const String _CHANNEL_NAME = "shadyboshra2012/flutterfawrypay";

  /// Methods name which detect which it called from Flutter.
  static const String _METHOD_INIT = "init";
  static const String _METHOD_INITIALIZE = "initialize";
  static const String _METHOD_INITIALIZE_CARD_TOKENIZER = "initialize_card_tokenizer";
  static const String _METHOD_START_PAYMENT = "start_payment";
  static const String _METHOD_RESET = "reset";

  /// Event Channel for stream sending data from Native side.
  EventChannel _eventChannelCallbackResult = EventChannel("flutterfawrypay/callback_result_stream");

  /// Error codes returned to Flutter if there's an error.
  static const String _ERROR_INIT = "1";
  static const String _ERROR_INITIALIZE = "2";
  static const String _ERROR_INITIALIZE_CARD_TOKENIZER = "3";
  static const String _ERROR_START_PAYMENT = "4";
  static const String _ERROR_RESET = "5";

  /// Initialize the channel
  MethodChannel _channel = const MethodChannel(_CHANNEL_NAME);

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
  Future<bool?> init({
    style = Style.STYLE1,
    enableLogging = false,
    enableMockups = false,
    skipCustomerInput = false,
    String? username,
    String? email,
  }) async {
    // Check if skipCustomerInput is true, but username or email is equals null.
    assert(!skipCustomerInput || (skipCustomerInput && username != null && email != null),
        "If skipCustomerInput is true, then you should set username and email.");

    try {
      return await _channel.invokeMethod(_METHOD_INIT, <String, dynamic>{
        'style': style.toString(),
        'enableLogging': enableLogging,
        'enableMockups': enableMockups,
        'skipCustomerInput': skipCustomerInput,
        'username': username,
        'email': email,
      });
    } on PlatformException catch (e) {
      if (e.code == _ERROR_INIT) throw "Error Occurred: Code: $_ERROR_INIT. Message: ${e.message}. Details: SDK Init Error";
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
  /// [merchantID] sets the merchantID that you have received from Fawry.
  /// [items] sets the list of items that the user will pay for.
  /// [merchantRefNumber] sets an optional number consists of 16 random characters and numbers.
  /// [language] sets the language of payment, whether English or Arabic, default English.
  /// [environment] sets the environment of payment, whether Test or Live, default Test.
  /// [customParam] sets a map of custom data you want to receive back with result data after payment.
  Future<bool?> initialize({
    required String merchantID,
    required List<FawryItem> items,
    String? merchantRefNumber,
    Language language = Language.EN,
    Environment environment = Environment.TEST,
    Map<String, dynamic>? customParam,
  }) async {
    try {
      return await _channel.invokeMethod(_METHOD_INITIALIZE, <String, dynamic>{
        'merchantID': merchantID,
        'items': items.map((e) => e.toJSON()).toList(),
        'merchantRefNumber': merchantRefNumber,
        'language': language.toString(),
        'environment': environment.toString(),
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
  }) async {
    try {
      return await _channel.invokeMethod(_METHOD_INITIALIZE_CARD_TOKENIZER, <String, dynamic>{
        'merchantID': merchantID,
        'customerMobile': customerMobile,
        'customerEmail': customerEmail,
        'customerProfileId': customerProfileId,
        'merchantRefNumber': merchantRefNumber,
        'language': language.toString(),
        'environment': environment.toString(),
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
  Future<FawryResponse> startProcess() async {
    try {
      Map<dynamic, dynamic> data = await (_channel.invokeMethod(_METHOD_START_PAYMENT) as FutureOr<Map<dynamic, dynamic>>);
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
  Future<bool?> reset() async {
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

  /// Stream to return resulted data.
  Stream callbackResultStream() {
    return _eventChannelCallbackResult.receiveBroadcastStream();
  }
}
