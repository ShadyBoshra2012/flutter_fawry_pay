import Flutter
import UIKit
import MyFawryPlugin

public class SwiftFlutterFawryPayPlugin: NSObject, FlutterPlugin {
    /// The channel name which it's the bridge between Dart and SWIFT
    private static var CHANNEL_NAME : String = "shadyboshra2012/flutterfawrypay"
    
    /// Methods name which detect which it called from Flutter.
    private var METHOD_INIT : String = "init"
    private var METHOD_INITIALIZE : String = "initialize"
    private var METHOD_INITIALIZE_CARD_TOKENIZER : String = "initialize_card_tokenizer"
    private var METHOD_START_PAYMENT : String = "start_payment"
    private var METHOD_RESET : String = "reset"
    
    private static var EVENT_CHANNEL_CALLBACK_RESULT : String = "flutterfawrypay/callback_result_stream";
    
    /// Error codes returned to Flutter if there's an error.
    private var INIT_ERROR : String = "1"
    private static var ERROR_INITIALIZE : String = "2"
    private var ERROR_INITIALIZE_CARD_TOKENIZER : String = "3"
    private var ERROR_START_PAYMENT : String = "4"
    private var ERROR_RESET : String = "5"
    
    /// Variable to hold the result object when it need to be coded inside callbacks.
    private static var pendingResult : FlutterResult!
    
    /// Variable to send the result object when it need to be coded inside callbacks
    public static var eventSink : FlutterEventSink!
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: CHANNEL_NAME, binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterFawryPayPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        let factory = FLNativeViewFactory(messenger: registrar.messenger())
        registrar.register(factory, withId: "FawryButton")
        
        let eventChannel = FlutterEventChannel(name: EVENT_CHANNEL_CALLBACK_RESULT, binaryMessenger: registrar.messenger())
        eventChannel.setStreamHandler(FawryStreamHandler())
        
        
        // Get fawry instance
        guard let fawry = Fawry.sharedInstance else { return }
        
        // Get ViewController from UIApplication.window
        guard let viewController = UIApplication.shared.delegate?.window??.rootViewController else { return }
        
        // Handle successful payments.
        fawry.paymentOperationSuccess(onViewController: viewController) { (response, statusCode) in
            if response != nil {
                print("Transaction ID = \(response!)")
                let result: [String: Any?] = [
                    "trx_id": response,
                    "expiry_date_key": nil,
                    "custom_param": nil,
                ]
                if pendingResult != nil {
                    pendingResult(result)
                    pendingResult = nil
                }
                if eventSink != nil {
                    eventSink(result)
                }
            }
        }
        
        // Handle errors payments.
        fawry.paymentOperationFailure(onViewController: viewController) { (transactionID, statusCode) in
            print("payment Operation Failure")
            if pendingResult != nil {
                pendingResult(FlutterError(code: ERROR_INITIALIZE, message: "", details: ""));
            }
            if eventSink != nil {
                pendingResult(FlutterError(code: ERROR_INITIALIZE, message: "", details: ""));
            }
        }
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        guard let fawry = Fawry.sharedInstance else { return }
        
        if call.method == METHOD_INIT {
            
            let args = call.arguments as! [String:Any?]
            
            // Get the args from Flutter.
            guard let _ = args["style"] as? String,
                  let _ = args["enableLogging"] as? Bool,
                  let _ = args["enableMockups"] as? Bool,
                  let skipCustomerInput = args["skipCustomerInput"] as? Bool,
                  let username = args["username"] as? String,
                  let email = args["email"] as? String
            else {
                return
            }
            
            fawry.skipCustomerInput = skipCustomerInput
            fawry.customerMobileNumber = username
            fawry.customerEmailAddress = email
            
            // Return true if success.
            result(true)
        }
        else if call.method == METHOD_INITIALIZE {
            
            let args = call.arguments as! [String:Any?]
            
            // Get the args from Flutter.
            guard let merchantID = args["merchantID"] as? String,
                  let environment = args["environment"] as? String,
                  let items = args["items"] as? [[String:AnyObject?]],
                  let languageString = args["language"] as? String
            else {
                return
            }
            
            let _ = args["customParam"] as? [String:Any?]
            
            var merchantRefNumber: String {
                guard let refNum = args["merchantRefNumber"] as? String else {
                    return randomAlphaNumeric()
                }
                return refNum
            }
            
            
            let serverUrl = (environment == "Environment.LIVE")
                ? "https://atfawry.com"
                : "https://atfawry.fawrystaging.com";
            
            // Set FawrySdk language
            let language = (languageString == "Language.EN") ? "en" : "ar";
            
            
            let cartItems = items.compactMap({
                return Item(
                    productSKUParam: $0["sku"] as! String,
                    productDescriptionParam: $0["description"] as! String,
                    priceParam: $0["price"] as! Double,
                    originalPriceParam: ($0["originalPrice"] as? Double) ?? 0.0,
                    quantityParam: $0["qty"] as! Int,
                    widthParam:  ($0["width"] as? Int) ?? 0,
                    heightParam: ($0["height"] as? Int) ?? 0,
                    lengthParam: ($0["length"] as? Int) ?? 0,
                    weightParam: ($0["weight"] as? Double) ?? 0.0,
                    variantCode: ($0["variantCode"] as? String) ?? "",
                    reservationCodes: ($0["reservationCodes"] as? [String]) ?? [],
                    earningRuleId: ($0["earningRuleID"] as? String) ?? ""
                )
            })
            
            fawry.initialize(
                serverURL: serverUrl,
                styleParam: ThemeStyle(
                    primaryColor: .red,
                    primaryDarkColor: .red,
                    secondaryColor: .red,
                    secondaryDarkColor: .red
                ),
                
                merchantIDParam: merchantID,
                merchantRefNum: merchantRefNumber,
                languageParam: language,
                GUIDParam: "#@DDFFEEER",
                customeParameterParam: nil, //TODO: After first beta.
                currancyParam: .EGP,
                items: cartItems
            )
            
            // Return true if success.
            result(true)
        }
        else if call.method == METHOD_INITIALIZE_CARD_TOKENIZER {
            
            let args = call.arguments as! [String:Any?]
            
            // Get the args from Flutter.
            guard let merchantID = args["merchantID"] as? String,
                  let environment = args["environment"] as? String,
                  let customerMobile = args["customerMobile"] as? String,
                  let customerEmail = args["customerEmail"] as? String,
                  let languageString = args["language"] as? String
            else {
                return
            }
            
            var customerProfileId: String {
                guard let id = args["customerProfileId"] as? String else {
                    return randomAlphaNumeric()
                }
                return id
            }
            
            
            let serverUrl = (environment == "Environment.LIVE")
                ? "https://atfawry.com"
                : "https://atfawry.fawrystaging.com";
            
            // Set FawrySdk language
            let language = (languageString == "Language.EN") ? "en" : "ar";
            
            do{
                try fawry.initializeCardTokenizer(
                    serverURL: serverUrl,
                    styleParam: ThemeStyle(
                        primaryColor: .red,
                        primaryDarkColor: .red,
                        secondaryColor: .red,
                        secondaryDarkColor: .red
                    ),
                    merchantIDParam: merchantID,
                    languageParam: language,
                    GUIDParam: "#@DDFFEEER",
                    customerMobileNumber: customerMobile,
                    customerEmailAddress: customerEmail,
                    customerProfileId: customerProfileId,
                    currancyParam: .EGP)
                
                result(true)
            } catch (let errorMsg){
                print("error \(errorMsg.localizedDescription)")
                result(FlutterError(code: ERROR_INITIALIZE_CARD_TOKENIZER, message: errorMsg.localizedDescription, details: nil))
            }
        }
        else if call.method == METHOD_START_PAYMENT {
            // Set pendingResult to result to use it in callbacks.
            SwiftFlutterFawryPayPlugin.pendingResult = result;
            
            // Call show Fawry SDK function.
            SwiftFlutterFawryPayPlugin.showFawrySDK()
        }
        else {
            result(FlutterMethodNotImplemented)
        }
    }
    
    func randomAlphaNumeric(_ length: Int = 16) -> String {
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    class FawryStreamHandler: NSObject, FlutterStreamHandler {
        public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
            eventSink = events
            return nil
        }
        
        public func onCancel(withArguments arguments: Any?) -> FlutterError? {
            eventSink = nil
            return nil
        }
    }
    
    public static func showFawrySDK() {
        guard let fawry = Fawry.sharedInstance else { return }
        
        guard let viewController = UIApplication.shared.delegate?.window??.rootViewController else { return }
        // Start FawrySdk payment scene
        fawry.showSDK(onViewController: viewController) { (response, statusCode) in
            if response != nil {
                if response is String {
                    print("Transaction ID = \(response!)")
                    let result = [
                        "trx_id": response,
                        "expiry_date_key": nil,
                        "custom_param": nil,
                    ]
                    if SwiftFlutterFawryPayPlugin.pendingResult != nil {
                        SwiftFlutterFawryPayPlugin.pendingResult(result)
                        SwiftFlutterFawryPayPlugin.pendingResult = nil
                    }
                    if SwiftFlutterFawryPayPlugin.eventSink != nil {
                        SwiftFlutterFawryPayPlugin.eventSink(result)
                    }
                } else {
                    let cardTokenizerItem = response as? CardTokenizerInfo
                    if cardTokenizerItem != nil {
                        print( "token : \(cardTokenizerItem?.card?.token ?? "")")
                        let result: [String:Any?] = [
                            "card_token": cardTokenizerItem?.card?.token,
                            "card_creation_date": cardTokenizerItem?.card?.creationDate,
                            "card_last_four_digits": cardTokenizerItem?.card?.lastFourDigits,
                            "card_brand": cardTokenizerItem?.card?.brand,
                            "custom_param": nil,
                        ]
                        
                        if SwiftFlutterFawryPayPlugin.pendingResult != nil {
                            SwiftFlutterFawryPayPlugin.pendingResult(result)
                            SwiftFlutterFawryPayPlugin.pendingResult = nil
                        }
                        if SwiftFlutterFawryPayPlugin.eventSink != nil {
                            SwiftFlutterFawryPayPlugin.eventSink(result)
                        }
                    }
                }
            }
        }
    }
}
