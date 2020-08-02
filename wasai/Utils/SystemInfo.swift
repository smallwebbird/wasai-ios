//
//  SystemInfo.swift
//  wasai
//
//  Created by 李政辉 on 2020/8/2.
//  Copyright © 2020 李政辉. All rights reserved.
//

import Foundation

// 用来存储一些系统信息
struct SystemInfo {
    static let infoDictionary = Bundle.main.infoDictionary!
    static let appName = infoDictionary["CFBundleName"]
    static let majorVersion = infoDictionary["CFBundleShortVersionString"]
    static let minorVersion =  infoDictionary["CFBundleVersion"]
    static let appVersion = majorVersion as! String

}
