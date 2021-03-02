/*
 * Copyright (c) 2021 Shady Boshra.
 * IN: https://LinkedIn.com/in/ShadyBoshra2012
 * GitHub: https://github.com/ShadyBoshra2012
 * Mostaql: https://mostaql.com/u/ShadyBoshra2012
 */

part of 'package:flutter_fawry_pay/flutter_fawry_pay.dart';

class FawryResponse {
  static const String _TRX_ID_KEY = "trx_id";
  static const String _EXPIRY_DATE_KEY = "expiry_date_key";
  static const String _CARD_TOKEN_KEY = "card_token";
  static const String _CARD_CREATION_DATE_KEY = "card_creation_date";
  static const String _CARD_LAST_FOUR_DIGITS_KEY = "card_last_four_digits";
  static const String _CUSTOM_PARAMS = "custom_param";
  static const String _ERROR_MESSAGE_KEY = "error_message";

  /// Parameters for payment process.
  String transactionID;
  DateTime expiryDate;

  /// Parameters for card tokenizer process.
  String cardToken;
  DateTime creationDate;
  String lastFourDigits;

  /// Common parameters for all process.
  Map<String, dynamic> customParam;
  String errorMessage;

  FawryResponse({
    this.transactionID,
    this.expiryDate,
    this.cardToken,
    this.creationDate,
    this.lastFourDigits,
    this.customParam,
    this.errorMessage,
  });

  factory FawryResponse.fromMap(Map<dynamic, dynamic> data) {
    return FawryResponse(
      transactionID: data[_TRX_ID_KEY],
      expiryDate: (data[_EXPIRY_DATE_KEY] != null) ? DateTime.fromMillisecondsSinceEpoch(data[_EXPIRY_DATE_KEY]) : null,
      cardToken: data[_CARD_TOKEN_KEY],
      creationDate:
          (data[_CARD_CREATION_DATE_KEY] != null) ? DateTime.fromMillisecondsSinceEpoch(data[_CARD_CREATION_DATE_KEY]) : null,
      lastFourDigits: data[_CARD_LAST_FOUR_DIGITS_KEY],
      customParam: data[_CUSTOM_PARAMS],
      errorMessage: data[_ERROR_MESSAGE_KEY],
    );
  }

  @override
  String toString() {
    return """    transactionID: ${this.transactionID},
    expiryDate:  ${this.expiryDate},
    cardToken:  ${this.cardToken},
    creationDate:  ${this.creationDate},
    lastFourDigits:  ${this.lastFourDigits},
    customParam:  ${this.customParam},
    errorMessage:  ${this.errorMessage}""";
  }
}
