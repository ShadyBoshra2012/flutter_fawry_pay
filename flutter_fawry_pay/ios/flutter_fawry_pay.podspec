#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_fawry_pay.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_fawry_pay'
  s.version          = '0.0.3'
  s.summary          = 'This plugin is for FawryPay. It\'s implemented the native SDKs to work on Flutter environment.'
  s.description      = <<-DESC
  This plugin is for FawryPay. It's implemented the native SDKs to work on Flutter environment.
                       DESC
  s.homepage         = 'https://pub.dev/packages/flutter_fawry_pay'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Shady Boshra' => 'shadyboshra2011@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '8.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
  
  # Prevent local Framework to be removed
  s.preserve_paths = 'Frameworks/MyFawryPlugin.framework'
  s.vendored_frameworks = 'Frameworks/MyFawryPlugin.framework'
end
