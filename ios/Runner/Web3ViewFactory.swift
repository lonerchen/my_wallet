//
//  BaiduFaceFactory.swift
//  Runner
//
//  Created by 陈健文 on 2020/3/19.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import Foundation
import Flutter

class Web3ViewFactory : NSObject, FlutterPlatformViewFactory{
    
//    let controller: UIViewController
//
//    init(controller: UIViewController) {
//        self.controller = controller
//    }
    
    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        
        return Web3View(frame: frame,viewId: viewId,args: (args as! [String:Any]))
    }
    
   func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
       return FlutterStandardMessageCodec.sharedInstance()
   }

    
    
}
