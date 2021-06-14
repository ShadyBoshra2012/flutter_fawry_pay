/*
 * Copyright (c) 2021 Shady Boshra.
 * IN: https://LinkedIn.com/in/ShadyBoshra2012
 * GitHub: https://github.com/ShadyBoshra2012
 * Mostaql: https://mostaql.com/u/ShadyBoshra2012
 */

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_fawry_pay_web/flutter_fawry_pay.dart';
import 'package:flutter_fawry_pay_web_example/keys.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isFawryPayInit = false;
  bool _isInitPayment = false;
  bool _isInitCardToken = false;
  bool _reset = false;
  String _text = "";

  late StreamSubscription _fawryCallbackResultStream;

  @override
  void initState() {
    super.initState();
    initFawryPay();
  }

  @override
  void dispose() {
    super.dispose();
    _fawryCallbackResultStream.cancel();
  }

  Future<void> initFawryPay() async {
    try {
      _isFawryPayInit = await FlutterFawryPay.instance.init(
        merchantID: Keys.merchantID, // Set the merchant ID here for one time only.
        style: Style.STYLE1,
        skipCustomerInput: true, // If set to true, you must set username and email.
        username: "01234567890", // Must be phone number.
        email: "abc@test.com",
        webDisplayMode: DisplayMode.SIDE_PAGE, // For web how you show the Fawry screen.
        environment: Environment.TEST, // You should set environment here.
      );

      _fawryCallbackResultStream = FlutterFawryPay.instance.callbackResultStream().listen((event) {
        Map<dynamic, dynamic> data = event;
        FawryResponse response = FawryResponse.fromMap(data);
        setState(() => _text = response.toString());
      });

      setState(() {});
    } catch (ex) {
      print(ex);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
              child: Text('FawryPay Init? $_isFawryPayInit'),
            ),
            Center(
              child: Text('Init Payment? $_isInitPayment'),
            ),
            Center(
              child: Text('Init Card Token? $_isInitCardToken'),
            ),
            Center(
              child: Text('$_text'),
            ),
            ElevatedButton(
              onPressed: () async {
                _isInitPayment = await FlutterFawryPay.instance.initialize(
                  returnUrl: "test.com", // For Web use only.
                  items: [
                    FawryItem(sku: "1", description: "Item 1", qty: 1, price: 20.0),
                  ],
                  customParam: {
                    "order_id": "123213",
                    "price": 231.0,
                  },
                );
                setState(() {
                  if (_isInitPayment) {
                    _isInitCardToken = false;
                  }
                });
              },
              child: Text("Init for Payment"),
            ),
            ElevatedButton(
              onPressed: () async {
                _isInitCardToken = await FlutterFawryPay.instance.initializeCardTokenizer(
                  customerMobile: "01234567890",
                  customerEmail: "abc@test.com",
                  customParam: {
                    "order_id": "123213",
                    "price": 231.0,
                  },
                );
                setState(() {
                  if (_isInitCardToken) {
                    _isInitPayment = false;
                  }
                });
              },
              child: Text("Init for Card Token"),
            ),
            ElevatedButton(
              onPressed: () async {
                FawryResponse response = await FlutterFawryPay.instance.startProcess();
                setState(() {
                  _text = "Your result: $response";
                });
              },
              child: Text("Start Payment"),
            ),
            ElevatedButton(
              onPressed: () async {
                _reset = await FlutterFawryPay.instance.reset();
                setState(() {
                  if (_reset) {
                    _isInitPayment = false;
                    _isInitCardToken = false;
                  }
                });
              },
              child: Text("Reset Payment"),
            ),
            FawryButton(),
          ],
        ),
      ),
    );
  }
}
