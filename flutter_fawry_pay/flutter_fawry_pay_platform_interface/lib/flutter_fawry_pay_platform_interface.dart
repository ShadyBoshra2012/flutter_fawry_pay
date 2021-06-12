/*
 * Copyright (c) 2021 Shady Boshra.
 * IN: https://LinkedIn.com/in/ShadyBoshra2012
 * GitHub: https://github.com/ShadyBoshra2012
 * Mostaql: https://mostaql.com/u/ShadyBoshra2012
 */

import 'dart:async';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'enums/display_mode.dart';
import 'enums/environment.dart';
import 'enums/language.dart';
import 'enums/style.dart';
import 'method_channel_flutter_fawry_pay.dart';
import 'models/fawry_item.dart';
import 'models/fawry_response.dart';

/// The interface that implementations of flutter_fawry_pay must implement.
///
/// Platform implementations should extend this class rather than implement it as `flutter_fawry_pay`
/// does not consider newly added methods to be breaking changes. Extending this class
/// (using `extends`) ensures that the subclass will get the default implementation, while
/// platform implementations that `implements` this interface will be broken by newly added
/// [FlutterFawryPayPlatform] methods.
abstract class FlutterFawryPayPlatform extends PlatformInterface {
  /// Constructs a FlutterFawryPayPlatform.
  FlutterFawryPayPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterFawryPayPlatform _instance = MethodChannelFlutterFawryPay();

  /// The default instance of [FlutterFawryPayPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterFawryPay].
  static FlutterFawryPayPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [FlutterFawryPayPlatform] when they register themselves.
  static set instance(FlutterFawryPayPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

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
  /// [webCustomerName] optional sets customer name (Only Web).
  /// [environment] sets the environment.
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
    throw UnimplementedError('init() has not been implemented.');
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
    throw UnimplementedError('initialize() has not been implemented.');
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
    throw UnimplementedError('initializeCardTokenizer() has not been implemented.');
  }

  /// Start FawryPay SDK process.
  ///
  /// Start FawryPay SDK process, whether it was initialized for payment,
  /// or initialized for card tokenizer.
  /// Returns a `FawryResponse` type of the resulted data.
  /// Throws exception if not completed well.
  Future<FawryResponse> startProcess() {
    throw UnimplementedError('startProcess() has not been implemented.');
  }

  /// Reset FawryPay SDK Payment.
  ///
  /// Returns `true` if it was rest well.
  /// Throws exception if not.
  Future<bool?> reset() async {
    throw UnimplementedError('reset() has not been implemented.');
  }

  /// Stream to return resulted data.
  Stream callbackResultStream() {
    throw UnimplementedError('callbackResultStream() has not been implemented.');
  }
}
