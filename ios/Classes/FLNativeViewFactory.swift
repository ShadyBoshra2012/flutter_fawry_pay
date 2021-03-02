//
//  FLNativeViewFactory.swift
//  flutter_fawry_pay
//
//  Created by Shady on 3/2/21.
//

import Flutter
import UIKit
//import MyFawryPlugin

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

    func createNativeView(view _view: UIView){
//        let FawryPlugin = Fawry.sharedInstance
        
        _view.backgroundColor = UIColor.blue
//        let fawryButton = UIButton()
//        FawryPlugin?.applyFawryButtonStyleToButton(button: fawryButton)
//        fawryButton.frame = CGRect(x: 0, y: 0, width: 180, height: 48.0)
//        _view.addSubview(fawryButton)
    }
}
