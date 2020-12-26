//
//  Web3ViewPlugin.swift
//  Runner
//
//  Created by zi zhi on 2020/10/19.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//
import Foundation

class Web3ViewPlugin {
    static func registerWithRegistrar(registar: FlutterPluginRegistrar, controller: UIViewController){
        registar.register(Web3ViewFactory(controller: controller), withId: "banner");
    }
}
