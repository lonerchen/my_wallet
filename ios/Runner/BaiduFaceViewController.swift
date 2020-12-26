//
//  BaiduFaceViewController.swift
//  Runner
//
//  Created by 陈健文 on 2020/3/19.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import UIKit

class BaiduFaceViewController: UIViewController {
    var topView = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white//设置整个界面背景为白色

        topView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: view.frame.height)
        topView.backgroundColor = UIColor.white


        let title = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height:view.frame.height))
        title.text = "这是一个原生的ios页面"//设置UILabel的文字


        title.textAlignment = NSTextAlignment.center//UILabel里的文字水平居中


        title.textColor = UIColor.black
        topView.addSubview(title)
        self.view.addSubview(topView)
    }
    
    
    
}
