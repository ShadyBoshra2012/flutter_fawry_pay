//
//  FLNativeViewFactory.swift
//  flutter_fawry_pay
//
//  Created by Shady on 3/2/21.
//

import Flutter
import UIKit
import MyFawryPlugin

class FLNativeViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return FLNativeView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger)
    }
}

class FLNativeView: NSObject, FlutterPlatformView {
    private var _view: UIView
    
    private var fawry: Fawry!

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?
    ) {
        _view = UIView()
        super.init()
        // iOS views can be created here
        createNativeView(view: _view)
    }

    func view() -> UIView {
        return _view
    }

    let fawryButton = UIButton()
    
    func createNativeView(view _view: UIView){
        // Get instance of Fawry plugin.
        fawry = Fawry.sharedInstance
        
        // Wrap FawryButton inside the view.
        ///Adding `fawryButton` to the superview.
        _view.addSubview(fawryButton)
        
        /// Seting up `fawryButton` constraints
        fawryButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            fawryButton.leadingAnchor.constraint(equalTo: _view.leadingAnchor),
            fawryButton.trailingAnchor.constraint(equalTo: _view.trailingAnchor),
            fawryButton.bottomAnchor.constraint(equalTo: _view.bottomAnchor),
            fawryButton.topAnchor.constraint(equalTo: _view.topAnchor)
        ])
        fawry?.applyFawryButtonStyleToButton(button: fawryButton)
        
        fawryButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    @objc
    private func didTapButton() {
        // Call show Fawry SDK function.
        SwiftFlutterFawryPayPlugin.showFawrySDK()
    }
    
}
