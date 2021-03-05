/*
 * Copyright (c) 2021 Shady Boshra.
 * IN: https://LinkedIn.com/in/ShadyBoshra2012
 * GitHub: https://github.com/ShadyBoshra2012
 * Mostaql: https://mostaql.com/u/ShadyBoshra2012
 */

part of 'flutter_fawry_pay.dart';

class FawryButton extends StatelessWidget {
  final double height;
  final double width;

  const FawryButton({Key? key, this.height = 50.0, this.width = 200.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // This is used in the platform side to register the view.
    final String viewType = 'FawryButton';

    // Pass parameters to the platform side.
    final Map<String, dynamic> creationParams = <String, dynamic>{};

    return Container(
      height: this.height,
      width: this.width,
      child: (Platform.isAndroid)
          ? PlatformViewLink(
              viewType: viewType,
              surfaceFactory:
                  (BuildContext context, PlatformViewController controller) {
                return AndroidViewSurface(
                  controller: controller as AndroidViewController,
                  gestureRecognizers: const <
                      Factory<OneSequenceGestureRecognizer>>{},
                  hitTestBehavior: PlatformViewHitTestBehavior.opaque,
                );
              },
              onCreatePlatformView: (PlatformViewCreationParams params) {
                return PlatformViewsService.initSurfaceAndroidView(
                  id: params.id,
                  viewType: viewType,
                  layoutDirection: TextDirection.ltr,
                  creationParams: creationParams,
                  creationParamsCodec: StandardMessageCodec(),
                )
                  ..addOnPlatformViewCreatedListener(
                      params.onPlatformViewCreated)
                  ..create();
              },
            )
          : Container() /*UiKitView(
              viewType: viewType,
              layoutDirection: TextDirection.ltr,
              creationParams: creationParams,
              creationParamsCodec: const StandardMessageCodec(),
            )*/
      ,
    );
  }
}
