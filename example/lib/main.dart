/*
 * Copyright (c) 2021 Shady Boshra.
 * IN: https://LinkedIn.com/in/ShadyBoshra2012
 * GitHub: https://github.com/ShadyBoshra2012
 * Mostaql: https://mostaql.com/u/ShadyBoshra2012
 */

import 'package:flutter/material.dart';
import 'package:flutter_fawry_pay/flutter_fawry_pay.dart';
import 'package:flutter_fawry_pay_example/keys.dart';

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

  @override
  void initState() {
    super.initState();
    initFawryPay();
  }

  Future<void> initFawryPay() async {
    try {
      _isFawryPayInit = await FlutterFawryPay.instance.init(
        style: Style.STYLE1,
        skipCustomerInput: true, // If set to true, you must set username and email.
        username: "01234567890", // Must be phone number.
        email: "abc@test.com",
      );

      FlutterFawryPay.instance.callbackResultStream().listen((event) {
        Map<dynamic, dynamic> data = event;
        print(data);
        FawryResponse response = FawryResponse.fromMap(data);
        print(response);
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
                  merchantID: Keys.merchantID,
                  items: [
                    FawryItem(sku: "1", description: "Item 1", qty: 1, price: 20.0),
                  ],
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
                  merchantID: Keys.merchantID,
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
