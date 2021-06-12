//
//  Fawry.swift
//  MyFawryPlugin
//
//  Created by Hussein Gamal Mohammed on 10/1/17.
//  Copyright © 2017 Hussein Gamal Mohammed. All rights reserved.
//

import UIKit



public class Fawry: NSObject {
    
//    public static var sharedInstance : Fawry? = Fawry()
    struct Static { static var instance: Fawry? }
    public class var sharedInstance: Fawry?
    {
        if Static.instance == nil { Static.instance = Fawry() }
        return Static.instance!
    }
    private var serverURL: String?
    private var merchantID: String?
    private var merchantRefNum: String?
    private var themeStyle: ThemeStyle!
    private var language: String!
    private var customParameters: AnyObject?
    private var GUID: String!
    private var currancy: Currancy?
    private var sdkFinishedBlock: ((_ transactionID: AnyObject?, _ FawryStatusCode: FawryStatusCode ) -> Void)?
    private var sdkSucessCompletionBlock: ((_ transactionID: AnyObject?, _ FawryStatusCode: FawryStatusCode ) -> Void)?
    private var sdkFailedCompletionBlock: ((_ transactionID: AnyObject?, _ FawryStatusCode: FawryStatusCode ) -> Void)?
    public var customerMobileNumber: String?
    public var customerEmailAddress: String?
    public var customerCIF: String?
    public var customerName: String?
    public var customerTypeCode: String?
    public var customerBirthDate: String?
    public var customerId: String?
    public var otherShippingAddressesList: NSArray?
    private var customerProfileId: String?
    public var skipCustomerInput : Bool? = false
    private var paymentMethodType: PaymentMethodType!
    private var sdkPaymentTypesCompletionBlock: ((_ SupportedPaymentMethods: [PaymentMethodType]) -> Void)?
    private var secureKey: String?
    private var signature: String?
    private var expiryHours: Int?
    
    var sdkTarget: SDKTarget?


    private override init() { }
    public func dispose() {
        
        FinancialTrxManager.sharedInstance.dispose()
        CustomerDataManager.sharedInstance.dispose()
        ShippingManager.sharedInstance.dispose()
        MerchantManager.sharedInstance.dispose()
        CardTokenizerManager.sharedInstance.dispose()
        
        self.merchantID = nil
        self.merchantRefNum = nil
        self.customerMobileNumber = nil
        self.customerEmailAddress = nil
        self.customerProfileId = nil
        Fawry.Static.instance = nil
        //Fawry.sharedInstance = nil
        
        self.customerMobileNumber = nil
        self.customerEmailAddress = nil
        self.customerCIF = nil
        self.customerName = nil
        self.customerBirthDate = nil
        self.skipCustomerInput = false
    }

    public func initialize(
        serverURL: String,
        styleParam: ThemeStyle?,
        merchantIDParam: String,
        merchantRefNum: String?,
        languageParam: String,
        GUIDParam: String,
        customeParameterParam: AnyObject?,
        currancyParam: Currancy,
        items: [Item]) {
        self.sdkTarget = SDKTarget.fawryPayment

        if serverURL.isEmpty {
            print(Constants.serverURLCannotBeEmpty)
            return
        }
        
        if (!self.canOpenURL(string: serverURL))
        {
            print(Constants.invalidServerURL)
            return
        }
        
        if merchantIDParam.isEmpty {
            print(Constants.merchantIDCannotBeEmpty)
            return
        }
        
        if languageParam.isEmpty {
            print(Constants.LanguageCannotBeEmpty)
            return
        }
        
        if GUIDParam.isEmpty {
            print(Constants.GUIDCannotBeEmpty)
            return
        }
        
        if items.count == 0 {
            print(Constants.ItemsCannotBeEmpty)
//            completionBlock(nil, .EmptyItemsList)
            return
        }
        
//        if !self.isItemsContentValid(items: items) {
//            print(Constants.ItemsCannotContainInvalidData)
//            return
//        }
        
        if(self.skipCustomerInput == true){
            if(isValidParameters()){
                self.handleSkipIntroParameters()
            }else{
                return
            }
        }
        
        
        
        self.sdkTarget = SDKTarget.fawryPayment
        self.serverURL = serverURL
        self.merchantID = merchantIDParam
        self.merchantRefNum = merchantRefNum
        self.language = languageParam
        self.GUID = GUIDParam
        self.themeStyle = styleParam
        self.customParameters = customeParameterParam
        self.currancy = currancyParam
        CustomerDataManager.sharedInstance.items = items

        UserDefaults.standard.set(1, forKey: ModelRequestObjectsJsonKeys.currentStep)
    
    }
    
    public func initialize(
        serverURL: String,
        styleParam: ThemeStyle?,
        merchantIDParam: String,
        merchantRefNum: String?,
        languageParam: String,
        GUIDParam: String,
        customeParameterParam: AnyObject?,
        currancyParam: Currancy,
        items: [Item],
        orderExpiryInHours: Int?,
        secureKey: String?,
        signature: String?) {
        self.sdkTarget = SDKTarget.fawryPayment

        if serverURL.isEmpty {
            print(Constants.serverURLCannotBeEmpty)
            return
        }
        
        if (!self.canOpenURL(string: serverURL))
        {
            print(Constants.invalidServerURL)
            return
        }
        
        if merchantIDParam.isEmpty {
            print(Constants.merchantIDCannotBeEmpty)
            return
        }
        
        if languageParam.isEmpty {
            print(Constants.LanguageCannotBeEmpty)
            return
        }
        
        if GUIDParam.isEmpty {
            print(Constants.GUIDCannotBeEmpty)
            return
        }
        
        if items.count == 0 {
            print(Constants.ItemsCannotBeEmpty)
//            completionBlock(nil, .EmptyItemsList)
            return
        }
        
        if secureKey == nil && signature == nil {
            print(Constants.secureKeyCannotBeEmpty)
            return
        }
        
//        if !self.isItemsContentValid(items: items) {
//            print(Constants.ItemsCannotContainInvalidData)
//            return
//        }
        
        if(self.skipCustomerInput == true){
            if(isValidParameters()){
                self.handleSkipIntroParameters()
            }else{
                return
            }
        }
        
        
        
        self.sdkTarget = SDKTarget.fawryPayment
        self.serverURL = serverURL
        self.merchantID = merchantIDParam
        self.merchantRefNum = merchantRefNum
        self.language = languageParam
        self.GUID = GUIDParam
        self.themeStyle = styleParam
        self.customParameters = customeParameterParam
        self.currancy = currancyParam
        CustomerDataManager.sharedInstance.items = items
        self.secureKey = secureKey
        self.expiryHours = orderExpiryInHours
        self.signature = signature
        UserDefaults.standard.set(1, forKey: ModelRequestObjectsJsonKeys.currentStep)
    
    }
    
    public func initialize(
            serverURL: String,
            styleParam: ThemeStyle?,
            merchantIDParam: String,
            merchantRefNum: String?,
            languageParam: String,
            GUIDParam: String,
            customeParameterParam: AnyObject?,
            currancyParam: Currancy,
            items: [Item],
            paymentMethodType : PaymentMethodType) {
        
            self.sdkTarget = SDKTarget.fawryPayment

            if serverURL.isEmpty {
                print(Constants.serverURLCannotBeEmpty)
                return
            }
            
            if (!self.canOpenURL(string: serverURL))
            {
                print(Constants.invalidServerURL)
                return
            }
            
            if merchantIDParam.isEmpty {
                print(Constants.merchantIDCannotBeEmpty)
                return
            }
            
            if languageParam.isEmpty {
                print(Constants.LanguageCannotBeEmpty)
                return
            }
            
            if GUIDParam.isEmpty {
                print(Constants.GUIDCannotBeEmpty)
                return
            }
            
            if items.count == 0 {
                print(Constants.ItemsCannotBeEmpty)
                return
            }
            
            
            if(self.skipCustomerInput == true){
                if(isValidParameters()){
                    self.handleSkipIntroParameters()
                }else{
                    return
                }
            }
            

            self.sdkTarget = SDKTarget.fawryPayment
            self.serverURL = serverURL
            self.merchantID = merchantIDParam
            self.merchantRefNum = merchantRefNum
            self.language = languageParam
            self.GUID = GUIDParam
            self.themeStyle = styleParam
            self.customParameters = customeParameterParam
            self.currancy = currancyParam
            CustomerDataManager.sharedInstance.items = items
            self.paymentMethodType = paymentMethodType
            CustomerDataManager.sharedInstance.themeStyle = styleParam

            UserDefaults.standard.set(1, forKey: ModelRequestObjectsJsonKeys.currentStep)
        
        }
    
    public func initialize(
            serverURL: String,
            styleParam: ThemeStyle?,
            merchantIDParam: String,
            merchantRefNum: String?,
            languageParam: String,
            GUIDParam: String,
            customeParameterParam: AnyObject?,
            currancyParam: Currancy,
            items: [Item],
            paymentMethodType : PaymentMethodType,
            orderExpiryInHours: Int?,
            secureKey: String?,
            signature: String?) {
        
            self.sdkTarget = SDKTarget.fawryPayment

            if serverURL.isEmpty {
                print(Constants.serverURLCannotBeEmpty)
                return
            }
            
            if (!self.canOpenURL(string: serverURL))
            {
                print(Constants.invalidServerURL)
                return
            }
            
            if merchantIDParam.isEmpty {
                print(Constants.merchantIDCannotBeEmpty)
                return
            }
            
            if languageParam.isEmpty {
                print(Constants.LanguageCannotBeEmpty)
                return
            }
            
            if GUIDParam.isEmpty {
                print(Constants.GUIDCannotBeEmpty)
                return
            }
            
            if items.count == 0 {
                print(Constants.ItemsCannotBeEmpty)
                return
            }
            
            if secureKey == nil && signature == nil {
                print(Constants.secureKeyCannotBeEmpty)
                return
            }
        
            if(self.skipCustomerInput == true){
                if(isValidParameters()){
                    self.handleSkipIntroParameters()
                }else{
                    return
                }
            }
            

            self.sdkTarget = SDKTarget.fawryPayment
            self.serverURL = serverURL
            self.merchantID = merchantIDParam
            self.merchantRefNum = merchantRefNum
            self.language = languageParam
            self.GUID = GUIDParam
            self.themeStyle = styleParam
            self.customParameters = customeParameterParam
            self.currancy = currancyParam
            CustomerDataManager.sharedInstance.items = items
            self.paymentMethodType = paymentMethodType
            CustomerDataManager.sharedInstance.themeStyle = styleParam
            self.secureKey = secureKey
            self.expiryHours = orderExpiryInHours
            self.signature = signature
            UserDefaults.standard.set(1, forKey: ModelRequestObjectsJsonKeys.currentStep)
        
        }
    
    public func initializeCardTokenizer(
        serverURL: String,
        styleParam: ThemeStyle?,
        merchantIDParam: String,
        languageParam: String,
        GUIDParam: String,
        customerMobileNumber: String,
        customerEmailAddress: String,
        customerProfileId: String,
        currancyParam: Currancy) throws{
        
        self.sdkTarget = SDKTarget.cardTokenizer

        if serverURL.isEmpty {
            print(Constants.serverURLCannotBeEmpty)
            throw ValidationError(message: Constants.serverURLCannotBeEmpty, view: nil)
            
        }
        if (!self.canOpenURL(string: serverURL))
        {
            print(Constants.invalidServerURL)
            throw ValidationError(message: Constants.invalidServerURL, view: nil)
        }

        if merchantIDParam.isEmpty {
            print(Constants.merchantIDCannotBeEmpty)
            throw ValidationError(message: Constants.merchantIDCannotBeEmpty, view: nil)

        }
        
        if languageParam.isEmpty {
            print(Constants.LanguageCannotBeEmpty)
            throw ValidationError(message: Constants.LanguageCannotBeEmpty, view: nil)
        }
        
        if GUIDParam.isEmpty {
            print(Constants.GUIDCannotBeEmpty)
            throw ValidationError(message: Constants.GUIDCannotBeEmpty, view: nil)
        }
        
       if customerEmailAddress.isEmpty {
            print(Constants.CustomerEmailCannotBeEmpty)
            throw ValidationError(message: Constants.CustomerEmailCannotBeEmpty, view: nil)
        }
        
        if customerMobileNumber.isEmpty {
            print(Constants.CustomerMobileCannotBeEmpty)
            throw ValidationError(message: Constants.CustomerMobileCannotBeEmpty, view: nil)
        }
        
        if !MWalletValidationManager.sharedInstance().isProperEgyptianNumber(customerMobileNumber){
            print(Constants.InvalidCustomerMobileNumber)
            throw ValidationError(message: Constants.InvalidCustomerMobileNumber, view: nil)
        }
        
        if customerProfileId.isEmpty {
            print(Constants.CustomerProfileIDCannotBeEmpty)
            throw ValidationError(message: Constants.CustomerProfileIDCannotBeEmpty, view: nil)
        }
        
        self.sdkTarget = SDKTarget.cardTokenizer
        self.serverURL = serverURL
        self.customerMobileNumber = customerMobileNumber
        self.customerEmailAddress = customerEmailAddress
        self.customerProfileId = customerProfileId
        
        self.merchantID = merchantIDParam
        self.language = languageParam
        self.GUID = GUIDParam
        self.themeStyle = styleParam
        self.currancy = currancyParam
        
//        UserDefaults.standard.set(1, forKey: ModelRequestObjectsJsonKeys.currentStep)
        
    }
    
    public func showSDK(
        onViewController: UIViewController ,
        completionBlock: @escaping (_ transactionID: AnyObject?, _ FawryStatusCode: FawryStatusCode) -> Void){

            NotificationCenter.default.addObserver(self, selector: #selector(executeCompletionBlock), name: NSNotification.Name(rawValue: Constants.transactionObserverMethod), object: nil)
            
        let bundle = Bundle.init(for: self.classForCoder)
        guard let serverURL = self.serverURL else { return }
        
        guard let currancy = self.currancy else { return }
        CustomerDataManager.sharedInstance.currancy = currancy.rawValue
        CustomerDataManager.sharedInstance.lang = self.language
        CustomerDataManager.sharedInstance.paymentMethodType = self.paymentMethodType
        MerchantManager.sharedInstance.secureKey = self.secureKey
        MerchantManager.sharedInstance.billExpiryHours = self.expiryHours
        MerchantManager.sharedInstance.signature = self.signature

            
        self.sdkFinishedBlock = completionBlock
        
        if(self.sdkTarget == SDKTarget.fawryPayment)
        {
            guard let merchantID = self.merchantID else { return }
            ModelRequestObjectsJsonKeys.domainURL = serverURL

            LoadingAnimation.sharedInstance.showActivityIndicatory(uiView: onViewController.view, title: NSLocalizedString(languageKeys.ExtraLanguageKeys.IntializngPlugin, tableName: languageKeys.ExtraLanguageKeys.fileName, bundle: bundle, value: "", comment: ""))
            
            MerchantManager.sharedInstance.getMerchantInfo(accountNumber: merchantID) { (merchant, message) in
                LoadingAnimation.sharedInstance.removeActivityIndicator(uiView: onViewController.view)
                
                if (merchant != nil) {
                   MerchantManager.sharedInstance.merchantRefNum = self.merchantRefNum
                    FinancialTrxManager.sharedInstance.addToReceipt(item: ReceiptItem(amount: (CustomerDataManager.sharedInstance.calculateTotalAmountForCustomerItems()), key: Constants.OrderAmount, value: "", reciptItemType: ReciptItemType.OrderAmount))
                    
                        self.pushToNotificationViewControllerWithBaseViewController(baseViewController: onViewController)

                }else{
                    self.presnetErrorMessage(message: message!, Title: ValidationErrorTitle.connectionError.rawValue, onViewController: onViewController)
                }
            }
        }else if(self.sdkTarget == SDKTarget.cardTokenizer){
            

            guard let merchantID = self.merchantID else { return }
            guard let customerProfileId = self.customerProfileId else { return }
            guard let customerMobileNumber = self.customerMobileNumber else { return }
            guard let customerEmailAddress = self.customerEmailAddress else { return }
            
            ModelRequestObjectsJsonKeys.CardTokenizer.domainURL = serverURL

            let model = CardTokenizerRequestParams(
                merchantCode: merchantID,
                customerProfileId: customerProfileId,
                customerMobile: customerMobileNumber,
                customerEmail: customerEmailAddress,
                cardNumberParam: "",
                expiryDateYearParam: "",
                expiryDateMonthParam: "",
                cvvParam: "")
            
            self.pushToCardTokenizerViewControllerWithBaseViewController(baseViewController: onViewController, model: model)
        }

    }

    public func getSupportedPaymentMethods(
        onViewController: UIViewController ,
        serverURL: String,
        merchantIDParam: String,
        languageParam: String,
        completionBlock: @escaping (_ SupportedPaymentMethods: [PaymentMethodType]) -> Void){
        
        if serverURL.isEmpty {
            print(Constants.serverURLCannotBeEmpty)
            return
        }
        
        if (!self.canOpenURL(string: serverURL))
        {
            print(Constants.invalidServerURL)
            return
        }
        
        if merchantIDParam.isEmpty {
            print(Constants.merchantIDCannotBeEmpty)
            return
        }
        
        if languageParam.isEmpty {
            print(Constants.LanguageCannotBeEmpty)
            return
        }
        
        CustomerDataManager.sharedInstance.lang = languageParam
        self.sdkPaymentTypesCompletionBlock = completionBlock
        
        
        ModelRequestObjectsJsonKeys.domainURL = serverURL
        
        MerchantManager.sharedInstance.getMerchantInfo(accountNumber: merchantIDParam) { (merchant, message) in
            
            if (merchant?.paymentMethods != nil) {
                
                var supportedArray : [PaymentMethodType] = [PaymentMethodType]()
                if let paymentMethods = merchant?.paymentMethods{
                    
                    for paymentMethod in paymentMethods{
                        
                        switch paymentMethod.code {
                        case PaymentMethodCode.Fawry.rawValue:
                            supportedArray.append(PaymentMethodType.FAWRY_KIOSK)
                            break
                            
                        case PaymentMethodCode.CreditCard.rawValue:
                            supportedArray.append(PaymentMethodType.CREDIT_CARD)
                            break
                            
                        default:
                            break
                        }
                    }
                }
                self.sdkPaymentTypesCompletionBlock!(supportedArray)
                
            }else{
                self.presnetErrorMessage(message: message!, Title: ValidationErrorTitle.connectionError.rawValue, onViewController: onViewController)
            }
        }
        

    }
    
    public func paymentOperationSuccess(
        onViewController: UIViewController ,
        completionBlock: @escaping (_ transactionID: AnyObject?, _ FawryStatusCode: FawryStatusCode) -> Void){
        
        self.sdkSucessCompletionBlock = completionBlock

        NotificationCenter.default.addObserver(self, selector: #selector(executeSuccessCompletionBlock), name: NSNotification.Name(rawValue: Constants.transactionSuccessObserverMethod), object: nil)
 
    }
    
    public func paymentOperationFailure(
        onViewController: UIViewController ,
        completionBlock: @escaping (_ transactionID: AnyObject?, _ FawryStatusCode: FawryStatusCode) -> Void){
        
        self.sdkFailedCompletionBlock = completionBlock
        
        NotificationCenter.default.addObserver(self, selector: #selector(executeFailedCompletionBlock), name: NSNotification.Name(rawValue: Constants.transactionFailedObserverMethod), object: nil)
        
    }
    
    public func applyFawryButtonStyleToButton(button: UIButton) {
        button.setBackgroundImage(UIImage(named: "@fawry", in: Bundle(for: MyFawryPlugin_RecepitViewController.self), compatibleWith: nil), for: .normal)
        button.setTitle("", for: .normal)
    }
    public func applyFawryButtonStyleToButton(button: UIButton,buttonImage: UIImage) {
        button.setBackgroundImage(buttonImage, for: .normal)
        button.setTitle("", for: .normal)
    }
    public func applyFawryButtonStyleToCreditCardButton(button: UIButton) {
        button.setBackgroundImage(UIImage(named: "creditCard", in: Bundle(for: MyFawryPlugin_RecepitViewController.self), compatibleWith: nil), for: .normal)
        
        button.setTitle("", for: .normal)
    }
    public func applyFawryButtonStyleToCreditCardButton(button: UIButton,buttonImage: UIImage) {
        button.setBackgroundImage(buttonImage, for: .normal)
        button.setTitle("", for: .normal)
    }
    func updatePluginCompletionBlockParams(blockParams: (String, FawryStatusCode)) {
      

            UserDefaults.standard.removeObject(forKey: Constants.PluginCompletionBlockTransactionIDParam)
            UserDefaults.standard.removeObject(forKey: Constants.PluginCompletionBlockStatusCodeParam)
        
            UserDefaults.standard.set(blockParams.0 , forKey: Constants.PluginCompletionBlockTransactionIDParam)
            UserDefaults.standard.set(blockParams.1.rawValue , forKey: Constants.PluginCompletionBlockStatusCodeParam)
            UserDefaults.standard.synchronize()


    
    }
    func loadPluginCompletionBlock() -> (String, Int) {
        
        var pair = ("",0)
        if let transactionID = UserDefaults.standard.value(forKey: Constants.PluginCompletionBlockTransactionIDParam) {
            pair.0 = transactionID as! String
        }
        if let statusCodeIncoming = UserDefaults.standard.value(forKey: Constants.PluginCompletionBlockStatusCodeParam) {
            pair.1 = statusCodeIncoming as! Int
            
        }
        return pair
    }

    @objc private func executeCompletionBlock(notification: Notification){

        let pairFromDefaults = loadPluginCompletionBlock()
        if (sdkTarget == SDKTarget.fawryPayment){
            
            sdkFinishedBlock!((pairFromDefaults.0 as AnyObject), FawryStatusCode(rawValue: pairFromDefaults.1)!)
        
        }else if(sdkTarget == SDKTarget.cardTokenizer){
            
            let jsonData = JSON.parse(pairFromDefaults.0)
            let cardTokenizerInfo = CardTokenizerInfo(json: jsonData)
            
            sdkFinishedBlock!(cardTokenizerInfo, FawryStatusCode(rawValue: pairFromDefaults.1)!)
        }
        

        
    }
    @objc private func executeSuccessCompletionBlock(notification: Notification){
        
        let pairFromDefaults = loadPluginCompletionBlock()
        
        if (sdkTarget == SDKTarget.fawryPayment){
            sdkSucessCompletionBlock!((pairFromDefaults.0 as AnyObject), FawryStatusCode(rawValue: pairFromDefaults.1)!)
        }
        
    }
    @objc private func executeFailedCompletionBlock(notification: Notification){
        
        let pairFromDefaults = loadPluginCompletionBlock()
        
        if (sdkTarget == SDKTarget.fawryPayment){
            sdkFailedCompletionBlock!((pairFromDefaults.0 as AnyObject), FawryStatusCode(rawValue: pairFromDefaults.1)!)
        }
        
    }
    private func pushToNotificationViewControllerWithBaseViewController(baseViewController: UIViewController){
        let s = UIStoryboard (name: "MyFawryPlugin_Notification", bundle: Bundle(for: MyFawryNavigationViewController_Notification.self))
        
        let vc = s.instantiateViewController(withIdentifier: "MyFawryNavigationViewController_Notification") as! MyFawryNavigationViewController_Notification
        
        OperationQueue.main.addOperation({
            vc.modalPresentationStyle = .fullScreen
            baseViewController.present(vc, animated: true, completion: nil)
        })
        
    }
    private func pushToCardTokenizerViewControllerWithBaseViewController(
        baseViewController: UIViewController, model: CardTokenizerRequestParams){
        let s = UIStoryboard (
            name: "MyFawryPlugin_CardTokenizer",
            bundle: Bundle(for: MyFawryNavigationViewController_CardTokenizer.self))
        
        let vc = s.instantiateViewController(withIdentifier: "MyFawryNavigationViewController_CardTokenizer") as! MyFawryNavigationViewController_CardTokenizer
        
        
        OperationQueue.main.addOperation({
            vc.modalPresentationStyle = .fullScreen
            baseViewController.present(vc, animated: true, completion: nil)
            (vc.viewControllers[0] as! MyFawryPlugin_CardTokenizerViewController).model = model
        })
        
    }

    private func presnetErrorMessage(message: String, Title: String,onViewController: UIViewController) {
        let alertControl = UIAlertController.init(title: Title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction.init(title: "Ok", style: .cancel, handler: nil)
        alertControl.addAction(okAction)
        
        onViewController.present(alertControl, animated: true, completion: nil)
    }
    
    func isItemsContentValid(items: [Item]) -> Bool {
        for item in items {
            if item.price <= 0 || item.quantity <= 0 {
                return false
            }
        }
        return true
    }
    
    func canOpenURL(string: String?) -> Bool {
        guard let urlString = string else { return false }
        guard let url = NSURL(string: urlString) else { return false }
        if !UIApplication.shared.canOpenURL(url as URL) { return false }
        return true
//        let regEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
//        let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[regEx])
//        return predicate.evaluate(with: string)
    }
    
    private func handleSkipIntroParameters()
    {

        if CustomerDataManager.sharedInstance.customerData == nil  {
            CustomerDataManager.sharedInstance.customerData = CustomerData()
        }
        CustomerDataManager.sharedInstance.customerData.email = self.customerEmailAddress
        CustomerDataManager.sharedInstance.customerData.mobileNumber = self.customerMobileNumber
        CustomerDataManager.sharedInstance.customerData.customerCIF = self.customerCIF
        CustomerDataManager.sharedInstance.customerData.otherShippingAddressesList = self.otherShippingAddressesList as? Array<String>
        CustomerDataManager.sharedInstance.customerData.customerId = self.customerId
        CustomerDataManager.sharedInstance.customerData.customerBirthDate = self.customerBirthDate
        CustomerDataManager.sharedInstance.customerData.customerBirthDate = self.customerBirthDate
        CustomerDataManager.sharedInstance.customerData.customerName = self.customerName
        CustomerDataManager.sharedInstance.customerData.customerTypeCode = self.customerTypeCode

    }
    
    private func isValidParameters() -> Bool {
        if !(isValidEmailAddress() && isValidMobileNumber()){
            if !isValidCIF() {
                return false
            }
        }
        return true
    }
    private func isValidEmailAddress() -> Bool {
        if self.customerEmailAddress == nil || self.customerEmailAddress?.count == 0 {
            print(Constants.CustomerEmailCannotBeEmpty)
            return false
        }else {
            if (MWalletValidationManager.sharedInstance().isEmailAddressValid(self.customerEmailAddress) != true) {
                print(languageKeys.Notification.ErrorInvalidEmail)
                return false
            }
        }
        return true
    }
    
    private func isValidMobileNumber() -> Bool {
        if self.customerMobileNumber == nil || self.customerMobileNumber?.count == 0 {
            print(Constants.CustomerMobileCannotBeEmpty)
            return false
        }else{
            if !MWalletValidationManager.sharedInstance().isProperEgyptianNumber(self.customerMobileNumber){
                print(languageKeys.Notification.ErrorInvalidMobileNumber)
                return false
            }
        }
        return true
    }
    
    private func isValidCIF() -> Bool {
        if self.customerCIF == nil || self.customerCIF?.count == 0 {
            print(Constants.CustomerCIFCannotBeEmpty)
            return false
        }
        return true
    }
    

    class public func randomAlphaNumeric(count: Int) -> String {
        let letters : NSString = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        var randomString = ""
        for _ in 0 ..< count {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        return randomString
    }
}
