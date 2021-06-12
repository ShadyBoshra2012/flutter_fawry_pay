#import "FlutterFawryPayPlugin.h"
#if __has_include(<flutter_fawry_pay/flutter_fawry_pay-Swift.h>)
#import <flutter_fawry_pay/flutter_fawry_pay-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_fawry_pay-Swift.h"
#endif

@implementation FlutterFawryPayPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterFawryPayPlugin registerWithRegistrar:registrar];
}
@end
