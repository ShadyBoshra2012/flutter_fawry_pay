/*
 * Copyright (c) 2021 Shady Boshra.
 * IN: https://LinkedIn.com/in/ShadyBoshra2012
 * GitHub: https://github.com/ShadyBoshra2012
 * Mostaql: https://mostaql.com/u/ShadyBoshra2012
 */

part of 'package:flutter_fawry_pay/flutter_fawry_pay.dart';

class FawryItem {
  String sku;
  String description;
  int qty;
  double price;
  double? originalPrice;
  int? height;
  int? length;
  double? weight;
  int? width;
  String? variantCode;
  List<String>? reservationCodes;
  String? earningRuleID;

  /// FawryItem constructor.
  ///
  /// [sku] sets the item id.
  /// [description] sets the item description.
  /// [qty] sets the quantity of the item.
  /// [price] sets the price for one item.
  FawryItem({
    required this.sku,
    required this.description,
    required this.qty,
    required this.price,
    this.originalPrice,
    this.height,
    this.length,
    this.weight,
    this.width,
    this.variantCode,
    this.reservationCodes,
    this.earningRuleID,
  });

  Map<String, dynamic> toJSON() {
    return {
      'sku': this.sku,
      'description': this.description,
      'qty': this.qty,
      'price': this.price,
      'originalPrice': this.originalPrice,
      'height': this.height,
      'length': this.length,
      'weight': this.weight,
      'width': this.width,
      'variantCode': this.variantCode,
      'reservationCodes': this.reservationCodes,
      'earningRuleID': this.earningRuleID,
    };
  }
}
