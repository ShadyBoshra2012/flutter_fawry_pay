/*
 * Copyright (c) 2021 Shady Boshra.
 * IN: https://LinkedIn.com/in/ShadyBoshra2012
 * GitHub: https://github.com/ShadyBoshra2012
 * Mostaql: https://mostaql.com/u/ShadyBoshra2012
 */

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// The Fawry Button available to use.
class FawryButton extends StatelessWidget {
  static const String VIEW_TYPE = "FawryButton";

  final double height;
  final double width;

  const FawryButton({
    Key? key,
    this.height = 50.0,
    this.width = 200.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: this.height,
      width: this.width,
      child: this.nativeWidget(),
    );
  }

  Widget nativeWidget() {
    throw UnimplementedError('nativeWidget() Unsupported platform view.');
  }
}
