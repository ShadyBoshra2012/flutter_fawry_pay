import Flutter
import UIKit
//import MyFawryPlugin

public class SwiftFlutterFawryPayPlugin: NSObject, FlutterPlugin {
    /// The channel name which it's the bridge between Dart and SWIFT
    private static var CHANNEL_NAME : String = "shadyboshra2012/flutterfawrypay"

    /// Methods name which detect which it called from Flutter.
    private var METHOD_INIT : String = "init"
    private var METHOD_INITIALIZE : String = "initialize"
    private var METHOD_INITIALIZE_CARD_TOKENIZER : String = "initialize_card_tokenizer"
    private var METHOD_START_PAYMENT : String = "start_payment"
    private var METHOD_RESET : String = "reset"

    /// Error codes returned to Flutter if there's an error.
    private var INIT_ERROR : String = "1"
    private var ERROR_INITIALIZE : String = "2"
    private var ERROR_INITIALIZE_CARD_TOKENIZER : String = "3"
    private var ERROR_START_PAYMENT : String = "4"
    private var ERROR_RESET : String = "5"
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: CHANNEL_NAME, binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterFawryPayPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    
//    let factory = FLNativeViewFactory(messenger: registrar.messenger())
//    registrar.register(factory, withId: "FawryButton")
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
//    let FawryPlugin = Fawry.sharedInstance
    
//    if call.method == METHOD_INIT {
//
//        // Get the args from Flutter.
//        guard let args = call.arguments as? [String: Any] else {
//            return
//        }

//        let key : String = args["key"] as! String
//        let environmentString : String = args["environment"] as! String
        
//        FawryPlugin.initialize(
//           serverURL: "https://atfawry.fawrystaging.com",
//           styleParam: .style1,
//           merchantIDParam: "1tSa6uxz2nQd7XkmPnhODw==",
//           merchantRefNum: "AB123456789",
//           languageParam: "en",
//           GUIDParam: "#@DDFFEEER",
//           customeParameterParam: nil,
//           currancyParam: .EGP,
//           items: T[Item]
//        )

        // Return true if success.
//        result(true)
//    }
//    else if call.method == METHOD_INITIALIZE {
//
//        // Get the args from Flutter.
//        let args = call.arguments as? [String: Any]
//
//        let cardNumber : String = args!["number"] as! String
//    }
//    else if call.method == METHOD_INITIALIZE_CARD_TOKENIZER {
//
//    }
//    else {
        result(FlutterMethodNotImplemented)
//    }
  }
}
