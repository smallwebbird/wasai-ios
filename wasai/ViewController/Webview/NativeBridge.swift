//
//  NativeBridge.swift
//  wasai
//
//  Created by 李政辉 on 2020/10/29.
//  Copyright © 2020 李政辉. All rights reserved.
//

import Foundation

protocol CallFinished {
    func callNativeFunctionFinished(params: [String: Any]) -> Void
}

class NativeBridge: CallFinished {
    let params: [String: Any]
    let nativeBridge: CallFinished
    init(params: [String: Any], nativeBridge: CallFinished) {
        self.params = params
        self.nativeBridge = nativeBridge
        dispatchFunction()
    }
    
    func dispatchFunction () {
        callNativeFunctionFinished(params: params)
    }
    
    func callNativeFunctionFinished(params: [String : Any]) {
        nativeBridge.callNativeFunctionFinished(params: params)
    }
}
