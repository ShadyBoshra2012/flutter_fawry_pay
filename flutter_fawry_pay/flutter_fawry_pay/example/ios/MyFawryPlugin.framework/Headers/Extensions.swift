//
//  Extensions.swift
//  MyFawryPlugin
//
//  Created by Hussein Gamal Mohammed on 9/26/17.
//  Copyright © 2017 Hussein Gamal Mohammed. All rights reserved.
//

import Foundation
import UIKit
extension UILabel{
    
    func applyThemeToPlaceholder() {

        self.attributedText = NSAttributedString(string: self.text!, attributes: [NSAttributedStringKey.foregroundColor : UIColor.darkGray])
    }
    
}

extension UITextField{
  
    func applyThemeToPlaceholder() {
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder!, attributes: [NSAttributedStringKey.foregroundColor : UIColor.darkGray])

    }
    func makeTextFieldTouchableWithSelector(selector: Selector, target: Any){
      
        self.isUserInteractionEnabled = false
        let button = UIButton(frame: self.frame)
        button.addTarget(target, action: selector, for: .touchUpInside)
        self.superview!.addSubview(button)
    }
    
}

extension UIImageView{
    
    func animateWrongInput(textField: UITextField, message: String){
        CATransaction.begin()

        textField.layer.borderWidth = 1.0;
        textField.layer.borderColor = UIColor.blue.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 4
        textField.clipsToBounds = true

        CATransaction.commit()

    }
    
}
extension UIImage {
    struct RotationOptions: OptionSet {
        let rawValue: Int
        
        static let flipOnVerticalAxis = RotationOptions(rawValue: 1)
        static let flipOnHorizontalAxis = RotationOptions(rawValue: 2)
    }
    
    func rotated(by rotationAngle: Measurement<UnitAngle>, options: RotationOptions = []) -> UIImage? {
        guard let cgImage = self.cgImage else { return nil }
        
        let rotationInRadians = CGFloat(rotationAngle.converted(to: .radians).value)
        let transform = CGAffineTransform(rotationAngle: rotationInRadians)
        var rect = CGRect(origin: .zero, size: self.size).applying(transform)
        rect.origin = .zero
        
        let renderer = UIGraphicsImageRenderer(size: rect.size)
        return renderer.image { renderContext in
            renderContext.cgContext.translateBy(x: rect.midX, y: rect.midY)
            renderContext.cgContext.rotate(by: rotationInRadians)
            
            let x = options.contains(.flipOnVerticalAxis) ? -1.0 : 1.0
            let y = options.contains(.flipOnHorizontalAxis) ? 1.0 : -1.0
            renderContext.cgContext.scaleBy(x: CGFloat(x), y: CGFloat(y))
            
            let drawRect = CGRect(origin: CGPoint(x: -self.size.width/2, y: -self.size.height/2), size: self.size)
            renderContext.cgContext.draw(cgImage, in: drawRect)
        }
    }
}

extension UIImageView{
    func configureImageRelatedToNumberOfStepsFromBundle (bundle: Bundle) {
        var numberOfSteps = 4
        if MerchantManager.sharedInstance.merchantInfoObject.shippingStatus == ShippingStatus.NoShipping {
            numberOfSteps = numberOfSteps - 1
            
        }
        let selectedStep = UserDefaults.standard.integer(forKey: ModelRequestObjectsJsonKeys.currentStep)
        switch numberOfSteps {
        case 2:
            
            self.image = UIImage(named: "2_steps_\(selectedStep)_selected", in: bundle, compatibleWith: nil)
            
            break
        case 3:
            self.image = UIImage(named: "3-steps_\(selectedStep)_selected", in: bundle, compatibleWith: nil)
            
            break
        case 4:
            self.image = UIImage(named: "4-steps_\(selectedStep)_selected", in: bundle, compatibleWith: nil)
            
            break
        default:
            break
        }
        self.contentMode = .scaleAspectFit
        
    }
}
extension UILabel {
    
    var substituteFontName : String {
        get { return self.font.fontName }
        set { self.font = UIFont(name: newValue, size: self.font.pointSize) }
    }
    
}

extension UIView {
    
    func dropShadow() {
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 1
    }
}
extension String {
    func chunkFormatted(withChunkSize chunkSize: Int = 4,
                        withSeparator separator: Character = " ") -> String {
        return characters.filter { $0 != separator }.chunk(n: chunkSize)
            .map{ String($0) }.joined(separator: String(separator))
    }
}
extension Collection {
    public func chunk(n: IndexDistance) -> [SubSequence] {
        var res: [SubSequence] = []
        var i = startIndex
        var j: Index
        while i != endIndex {
            j = index(i, offsetBy: n, limitedBy: endIndex) ?? endIndex
            res.append(self[i..<j])
            i = j
        }
        return res
    }
}
