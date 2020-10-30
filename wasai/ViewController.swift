//
//  ViewController.swift
//  wasai
//
//  Created by 李政辉 on 2020/8/1.
//  Copyright © 2020 李政辉. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UITabBarController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initInterface()
    }
    
    func initInterface () {
        let homeViewController = HomeViewController()
        homeViewController.tabBarItem.title = "主页"
        
        let mineViewController = MineViewController()
        mineViewController.tabBarItem.title = "我的"
        
        tabBar.isTranslucent = false
        
        addChild(homeViewController)
        addChild(mineViewController)
    }
    
}


