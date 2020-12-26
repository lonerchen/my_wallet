//
//  Web3View.swift
//  Runner
//
//  Created by zi zhi on 2020/10/17.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import Foundation
import WebKit

class Web3View : NSObject,FlutterPlatformView{
    
    var walletAddress : String;
    var rpcServerUrl:String;
    var chainId :Int;
    var url :String;
    var scriptConfig : WKUserScriptConfig;
//    var privateKey :String;
    
    init(frame: CGRect, viewId: Int64, args:[String:Any]) {
        walletAddress = args["walletAddress"] as! String
        rpcServerUrl = args["rpcServerUrl"] as! String
        chainId = args["chainId"] as! Int
        url = args["url"] as! String
        scriptConfig = WKUserScriptConfig(
                address: walletAddress,
                chainId: chainId,
                rpcUrl: rpcServerUrl,
                privacyMode: false
            )
//        privateKey = args["privateKey"] as! String
    }
    
    func view() -> UIView {
//        let dappView = DAppWebViewController();
//        dappView.address = walletAddress;
//        dappView.chainId = chainId;
//        dappView.rpcUrl = rpcServerUrl;
//        dappView.homepage = url;
//        dappView.scriptConfig = WKUserScriptConfig(
//            address: walletAddress,
//            chainId: chainId,
//            rpcUrl: rpcServerUrl,
//            privacyMode: false
//        );
//        dappView.setupSubviews();
//        dappView.navigate(to: url)
        return webview;
//        return (DAppWebViewController(coder: NSCoder,homepage: url, address: walletAddress, rpcUrl: rpcServerUrl, chainId: chainId)?.view)!
    }
    
    lazy var webview: WKWebView = {
        let config = WKWebViewConfiguration()

        let controller = WKUserContentController()
        controller.addUserScript(scriptConfig.providerScript)
        controller.addUserScript(scriptConfig.injectedScript)
//        for name in DAppMethod.allCases {
//            controller.add(self, name: name.rawValue)
//        }

        config.userContentController = controller

        let webview = WKWebView(frame: CGRect(x: 0, y: 0, width: 300, height: 600), configuration: config)
        webview.translatesAutoresizingMaskIntoConstraints = false
//        webview.uiDelegate = self
        webview.load(URLRequest(url:URL(string: "www.baidu.com")!))
        return webview
    }()
    
}
