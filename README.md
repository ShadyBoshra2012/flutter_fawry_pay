# Flutter FawryPay  

[![pub.dev](https://img.shields.io/pub/v/flutter_fawry_pay.svg)](https://pub.dev/packages/flutter_fawry_pay)  [![Donate Paypal](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://paypal.me/ShadyBoshra2012) [![GitHub Follow](https://img.shields.io/github/followers/ShadyBoshra2012.svg?style=social&label=Follow)](https://github.com/ShadyBoshra2012)

## Explain

This plugin is for [FawryPay](https://developer.fawrystaging.com/docs-home). It's implemented the native SDKs to work on Flutter environment.

> It works for Android fine. iOS works fine on **Real Device** only (FawryPay Requirements).

Contribution: [Eng. Ahmed Mahmoud](https://github.com/AhmedAbouelkher)

![](https://developer.fawrystaging.com/fawrypay/img/docs/fawry-pay-english.png)


## Getting Started

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_fawry_pay: ^0.0.3
```


### Android

You have to edit `AndroidManifest.xml` file with following.

```manifest
<manifest ...
    xmlns:tools="http://schemas.android.com/tools" 
    ... />
    ...
    <application
        ...
        tools:replace="android:theme,android:label,android:name" 
        ... >
    ...
    </appliaction>
</manifest>
```

And download this [file](https://github.com/ShadyBoshra2012/flutter_fawry_pay/blob/master/example/android/app/libs/fawryplugin-release.aar), and put it in `app/libs` folder (If not exist, create it).


### iOS

No actions needed, just work on Real Device only. Need xCode 12.x and SWIFT 5.3.x. 


## Usage

You just have to import the package with

```dart
import 'package:flutter_fawry_pay/flutter_fawry_pay.dart';
```

Then, you need to initialize the SDK.

```dart
FlutterFawryPay.instance.init(
  style: Style.STYLE1,
  skipCustomerInput: true, // If set to true, you must set username and email.
  username: "01234567890", // Must be phone number.
  email: "abc@test.com",
);
```

Now, you can stream the result data that from SDK.

```dart
FlutterFawryPay.instance.callbackResultStream().listen((event) {
  FawryResponse response = FawryResponse.fromMap(data);
  print(response);
});
```

Let's now make our first payment initialize, you must set your merchantID that token from FawryPay system, and set your FawryItems that the user will pay for.

> Note that: there's error in native FawryPay SDK for android to retrieve again customParam.

```dart
FlutterFawryPay.instance.initialize(
  merchantID: Keys.merchantID,
  items: [
    FawryItem(sku: "1", description: "Item 1", qty: 1, price: 20.0),
  ],
);
```

You can set some parameters like: `merchantRefNumber, language, environment, customParam`.

And when you are ready for production you have to set the environment to Live.

```dart
FlutterFawryPay.instance.initialize(
  environment: Environment.LIVE,
  merchantID: Keys.merchantID,
  items: [
    FawryItem(sku: "1", description: "Item 1", qty: 1, price: 20.0),
  ],
);
```

So, it was initialized well, how to start payment? You have TWO ways.

### First way: Native Fawry Button

You can use the native button for FawryPay SDK. through this only widget.

```dart
FawryButton()
```

### Second way: Your custom widget

You can use your own widget with a function to call with `FlutterFawryPay.instance.startProcess()`.

```dart
RaisedButton(
  onPressed: () async {
  FawryResponse response = await FlutterFawryPay.instance.startProcess();
  },
  child: Text("Start Payment"),
)
```

There's a function in FawryPay is CardTokenizer, you can use it like this way:

> Note that: there's error in native FawryPay SDK for android to retrieve again customParam.

```dart
FlutterFawryPay.instance.initializeCardTokenizer(
  merchantID: Keys.merchantID,
  customerMobile: "01234567890",
  customerEmail: "abc@test.com",
  customParam: {
    "order_id": "123213",
    "price": 231.0,
  },
);
```

Last function you can use is reset the initialization (Android only), doing that:

```dart
FlutterFawryPay.instance.reset();
```

## Objects

```dart
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
}

class FawryResponse {
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
}
```


## Enums

```dart
/// Enums for Environment configuration.
///
/// [TEST] for test stage atfawry.fawrystaging endpoint.
/// [LIVE] for production stage atfawry endpoint.
enum Environment { TEST, LIVE }

/// Enums for Environment configuration.
///
/// [EN] for English language.
/// [AR] for Arabic language.
enum Language { EN, AR }

/// Enums for Environment configuration.
///
/// [STYLE1] for first styling.
/// [STYLE2] for second styling.
enum Style { STYLE1, STYLE2 }
```


## Links

FawryPay Android SDK: https://developer.fawrystaging.com/docs/sdks/android-sdk

FawryPay iOS SDK: https://developer.fawrystaging.com/docs/sdks/ios-sdk


## Supported By ❤

[Eng. Ahmed Mahmoud](https://github.com/AhmedAbouelkher) (Works on iOS development)
[Eng. Ahmed Hamouda](https://github.com/ahmadali17)
[Eng. Mohamed Ghoneim](https://www.facebook.com/mohamed.Ghoneim.97/)



## Issues or Contributions

This is a beta version of plugin, so I am very appreciated for any issues or contribution you can help me with.


## Find me on Stackoverflow

<a href="https://stackoverflow.com/users/2076880/shady-boshra"><img src="https://stackoverflow.com/users/flair/2076880.png" width="208" height="58" alt="profile for Shady Boshra at Stack Overflow, Q&amp;A for professional and enthusiast programmers" title="profile for Shady Boshra at Stack Overflow, Q&amp;A for professional and enthusiast programmers"></a>


## License

MIT: [https://mit-license.org](http://mit-license.org). 

Copyright (c) 2021 Shady Boshra. All rights reserved.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.