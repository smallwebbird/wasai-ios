//
//  MineHomeViewController.swift
//  wasai
//
//  Created by 李政辉 on 2020/10/30.
//  Copyright © 2020 李政辉. All rights reserved.
//

import Foundation
import UIKit

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        let webviewViewController = UINavigationController(rootViewController: WebViewViewController())
        
        webviewViewController.modalPresentationStyle = .fullScreen
        
        present(webviewViewController, animated: true)
    }

}

