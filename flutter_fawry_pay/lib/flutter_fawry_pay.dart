/*
 * Copyright (c) 2021 Shady Boshra.
 * IN: https://LinkedIn.com/in/ShadyBoshra2012
 * GitHub: https://github.com/ShadyBoshra2012
 * Mostaql: https://mostaql.com/u/ShadyBoshra2012
 */

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fawry_pay/flutter_fawry_pay.dart';
import 'package:flutter_fawry_pay_platform_interface/fawry_button.dart'
    as fawry_button_parent;
import 'package:flutter_fawry_pay_platform_interface/flutter_fawry_pay_platform_interface.dart';
import 'package:flutter_fawry_pay_platform_interface/models/fawry_item.dart';
import 'package:flutter_fawry_pay_platform_interface/models/fawry_response.dart';

export 'package:flutter_fawry_pay_platform_interface/flutter_fawry_pay_platform_interface.dart';
export 'package:flutter_fawry_pay_platform_interface/models/fawry_item.dart';
export 'package:flutter_fawry_pay_platform_interface/models/fawry_response.dart';

part 'package:flutter_fawry_pay/fawry_button.dart';

class FlutterFawryPay extends FlutterFawryPayPlatform {
  /// Singleton constructor.
  FlutterFawryPay._();

  /// Instance of FlutterFawryPay singleton.
  static FlutterFawryPay instance = FlutterFawryPay._();

  /// Event Channel for stream sending data from Native side.
  EventChannel _eventChannelCallbackResult =
      EventChannel("flutterfawrypay/callback_result_stream");

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
    return await FlutterFawryPayPlatform.instance.init(
      merchantID: merchantID,
      style: style,
      enableLogging: enableLogging,
      enableMockups: enableMockups,
      skipCustomerInput: skipCustomerInput,
      username: username,
      email: email,
      webCustomerName: webCustomerName,
      language: language,
      environment: environment,
      webDisplayMode: webDisplayMode,
    );
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
    return await FlutterFawryPayPlatform.instance.initialize(
      items: items,
      merchantRefNumber: merchantRefNumber,
      customerProfileId: customerProfileId,
      paymentExpiry: paymentExpiry,
      returnUrl: returnUrl,
      authCaptureModePayment: authCaptureModePayment,
      customParam: customParam,
    );
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
  @override
  Future<bool> initializeCardTokenizer({
    required String customerMobile,
    required String customerEmail,
    String? customerProfileId,
    String? merchantRefNumber,
    Map<String, dynamic>? customParam,
  }) async {
    return await FlutterFawryPayPlatform.instance.initializeCardTokenizer(
      customerMobile: customerMobile,
      customerEmail: customerEmail,
      customerProfileId: customerProfileId,
      merchantRefNumber: merchantRefNumber,
      customParam: customParam,
    );
  }

  /// Start FawryPay SDK process.
  ///
  /// Start FawryPay SDK process, whether it was initialized for payment,
  /// or initialized for card tokenizer.
  /// Returns a `FawryResponse` type of the resulted data.
  /// Throws exception if not completed well.
  @override
  Future<FawryResponse> startProcess() async {
    return await FlutterFawryPayPlatform.instance.startProcess();
  }

  /// Reset FawryPay SDK Payment.
  ///
  /// Returns `true` if it was rest well.
  /// Throws exception if not.
  @override
  Future<bool> reset() async {
    return await FlutterFawryPayPlatform.instance.reset();
  }

  /// Stream to return resulted data.
  Stream callbackResultStream() {
    return _eventChannelCallbackResult.receiveBroadcastStream();
  }
}
