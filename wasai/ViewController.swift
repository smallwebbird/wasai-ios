//
//  ViewController.swift
//  wasai
//
//  Created by 李政辉 on 2020/8/1.
//  Copyright © 2020 李政辉. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        
        // 初始化页面
        initInterface()
    }
    
    func initInterface () {
        let button = UIButton(frame: CGRect(x: 0, y: 200, width: view.frame.width, height: 50))
        button.setTitle("跳转到webview", for: .normal)
        button.backgroundColor = UIColor.red
        button.addTarget(self, action: #selector(jumpToWebview), for: .touchUpInside)
        view.addSubview(button)
    }
    
    @objc func jumpToWebview () {
        let webviewViewController = WebViewViewController()
        navigationController?.pushViewController(webviewViewController, animated: true)
    }
    
}


