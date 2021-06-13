/*
 * Copyright (c) 2021 Shady Boshra.
 * IN: https://LinkedIn.com/in/ShadyBoshra2012
 * GitHub: https://github.com/ShadyBoshra2012
 * Mostaql: https://mostaql.com/u/ShadyBoshra2012
 */

part of 'package:flutter_fawry_pay/flutter_fawry_pay.dart';

class FawryButton extends fawry_button_parent.FawryButton {
  final double height;
  final double width;

  const FawryButton({
    Key? key,
    this.height = 50.0,
    this.width = 200.0,
  }) : super(
          key: key,
          height: height,
          width: width,
        );

  @override
  Widget nativeWidget() {
    // Pass parameters to the platform side.
    final Map<String, dynamic> creationParams = <String, dynamic>{};

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        // return widget on Android.
        return Container(
          height: this.height,
          width: this.width,
          child: androidView(creationParams),
        );
      case TargetPlatform.iOS:
        // return widget on iOS.
        return Container(
          height: this.height,
          width: this.width,
          child: iOSView(creationParams),
        );
      default:
        throw UnsupportedError("Unsupported platform view");
    }
  }

  Widget androidView(Map<String, dynamic> creationParams) {
    return PlatformViewLink(
      viewType: fawry_button_parent.FawryButton.VIEW_TYPE,
      surfaceFactory:
          (BuildContext context, PlatformViewController controller) {
        return AndroidViewSurface(
          controller: controller as AndroidViewController,
          gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
          hitTestBehavior: PlatformViewHitTestBehavior.opaque,
        );
      },
      onCreatePlatformView: (PlatformViewCreationParams params) {
        return PlatformViewsService.initSurfaceAndroidView(
          id: params.id,
          viewType: fawry_button_parent.FawryButton.VIEW_TYPE,
          layoutDirection: TextDirection.ltr,
          creationParams: creationParams,
          creationParamsCodec: StandardMessageCodec(),
        )
          ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
          ..create();
      },
    );
  }

  Widget iOSView(Map<String, dynamic> creationParams) {
    return UiKitView(
      viewType: fawry_button_parent.FawryButton.VIEW_TYPE,
      layoutDirection: TextDirection.ltr,
      creationParams: creationParams,
      creationParamsCodec: const StandardMessageCodec(),
    );
  }
}
