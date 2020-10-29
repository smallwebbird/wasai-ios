//
//  GlideOne.swift
//  wasai
//
//  Created by 李政辉 on 2020/10/28.
//  Copyright © 2020 李政辉. All rights reserved.
//

import UIKit
import Foundation

class GuideOneViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.red
        
        initInterface();
    }
    
    func initInterface() {
        let label = UILabel(frame: CGRect(x: 0,y: 0,width: 100,height: 100))
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.text = "one"
        label.textColor = UIColor.yellow
        view.addSubview(label)
    }
}

