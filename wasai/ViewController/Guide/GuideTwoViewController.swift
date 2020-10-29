//
//  GlideOne.swift
//  wasai
//
//  Created by 李政辉 on 2020/10/28.
//  Copyright © 2020 李政辉. All rights reserved.
//

import UIKit
import Foundation

class GuideTwoViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blue
        initInterface();
    }
    
    func initInterface() {
        // label
        let label = UILabel(frame: CGRect(x: 0,y: 0,width: 100,height: 100))
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.text = "two"
        label.textColor = UIColor.yellow
        view.addSubview(label)
        
        // button
        let button = UIButton(frame: CGRect(x: 0, y: 200, width: 200, height: 200))
        button.setTitle("下一步", for: UIControl.State.normal)
        button.backgroundColor = UIColor.darkGray
        
        button.addTarget(self, action: #selector(click), for: .touchUpInside)
        view.addSubview(button)
    }
    
    @objc func click () {
        var homeViewController: UIViewController = ViewController()
        homeViewController = UINavigationController(rootViewController: homeViewController)
        // ios13 改变了present 的样式
        /*https://zonneveld.dev/ios-13-viewcontroller-presentation-style-modalpresentationstyle/
        */
        homeViewController.modalPresentationStyle = .fullScreen
        present(homeViewController, animated: true)
    }
}


