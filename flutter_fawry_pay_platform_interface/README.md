# flutter_fawry_pay_platform_interface

A common platform interface for the [`flutter_fawry_pay`][1] plugin.

This interface allows platform-specific implementations of the `flutter_fawry_pay`
plugin, as well as the plugin itself, to ensure they are supporting the
same interface.

# Usage

To implement a new platform-specific implementation of `flutter_fawry_pay`, extend
[`FlutterFawryPayPlatform`][2] with an implementation that performs the
platform-specific behavior, and when you register your plugin, set the default
`FlutterFawryPayPlatform` by calling
`FlutterFawryPayPlatform.instance = MyPlatformFlutterFawryPay()`.

# Note on breaking changes

Strongly prefer non-breaking changes (such as adding a method to the interface)
over breaking changes for this package.

See https://flutter.dev/go/platform-interface-breaking-changes for a discussion
on why a less-clean interface is preferable to a breaking change.

[1]: ../flutter_fawry_pay
[2]: lib/flutter_fawry_pay_platform_interface.dart
