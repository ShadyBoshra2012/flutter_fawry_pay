/*
 * Copyright (c) 2021 Shady Boshra.
 * IN: https://LinkedIn.com/in/ShadyBoshra2012
 * GitHub: https://github.com/ShadyBoshra2012
 * Mostaql: https://mostaql.com/u/ShadyBoshra2012
 */

part of 'package:flutter_fawry_pay_web/flutter_fawry_pay.dart';

/// The Fawry Button available to use.
class FawryButton extends fawry_button_parent.FawryButton {
  final double height;
  final double width;

  const FawryButton({
    Key? key,
    this.height = 36.0,
    this.width = 200.0,
  }) : super(
          key: key,
          height: height,
          width: width,
        );

  @override
  Widget nativeWidget() {
    ui.platformViewRegistry.registerViewFactory(
      fawry_button_parent.FawryButton.VIEW_TYPE,
      (int viewId) => InputElement()
        ..attributes = {
          "type": "image",
          "onClick": "parent.checkout();",
          "height": "100%",
          "width": "100%"
        }
        ..src = "https://www.atfawry.com/assets/img/FawryPayLogo.jpg"
        ..alt = "pay-using-fawry"
        ..id = "fawry-payment-btn",
    );
    return HtmlElementView(viewType: fawry_button_parent.FawryButton.VIEW_TYPE);
  }
}
