//
//  BaiduFaceView.swift
//  Runner
//
//  Created by 陈健文 on 2020/3/19.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import Foundation
import Flutter

class BaiduFaceView: NSObject,FlutterPlatformView {
    
    func view() -> UIView {
        return BaiduFaceViewController().view
    }
    
}
