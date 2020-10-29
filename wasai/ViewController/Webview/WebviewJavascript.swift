//
//  WebviewJavascript.swift
//  wasai
//
//  Created by 李政辉 on 2020/10/29.
//  Copyright © 2020 李政辉. All rights reserved.
//

import Foundation

let WebviewJavascript = """
(function () {
    if (window.JSBridge) {
        return;
    }
   let uniqueId = 0,
       sucCallbacks = {},
       failCallbacks = {},
       registerFuncs = {};

   const voidFn = function () {};
   window.JSBridge = {
       // 调用 Native
       invoke: function({ bridgeName, data, success, fail } = params) {
           // 判断环境，获取不同的 nativeBridge
           // 获取唯一 id
           var callbackId = 'cb_' + uniqueId++ + '_' + Date.now();
           // 存储 Callback
           sucCallbacks[callbackId] = success || voidFn;
           failCallbacks[callbackId] = fail || voidFn;
           var params = {
               bridgeName: bridgeName,
               data: data || {},
               // 传到 Native 端
               callbackId: callbackId
           };
           try {
               window.webkit.messageHandlers.bridge.postMessage(JSON.stringify(params));
           } catch(e) {
               console.error(e);
           }
       },
       receiveMessage: function(msg) {
           msg = JSON.stringify(msg);
           msg = JSON.parse(msg);
           var bridgeName = msg.bridgeName,
               data = msg.responseData || {},
               // Native 将 callbackId 原封不动传回
               callbackId = msg.callbackId,
               responseId = msg.responseId;
           // 具体逻辑
           // bridgeName 和 callbackId 不会同时存在
           if (callbackId) {
               if (data.type === "success") {
                   sucCallbacks[callbackId](data.data || {});
               } else {
                   failCallbacks[callbackId](data.data || {});
               }
           } else if (bridgeName) {
           // 通过 bridgeName 找到句柄
               if (registerFuncs[bridgeName]) {
                   var ret = {},
                       flag = false;
                   registerFuncs[bridgeName].forEach(function(callback) {
                       callback(data, function(r) {
                           flag = true;
                           ret = Object.assign(ret, r);
                       });
                   });
                   if (flag) {
                   // 回调 Native
                       try {
                           window.webkit.messageHandlers.bridge.postMessage(JSON.stringify({
                               responseId: responseId,
                               ret: ret
                           }));
                       } catch (e) {
                           console.error(e);
                       }
                   }
               }
           }
       },
       register: function(bridgeName, callback) {
           if (!registerFuncs[bridgeName])  {
               registerFuncs[bridgeName] = [];
           }
           // 存储回调
           registerFuncs[bridgeName].push(callback);
       }
   };
})();
"""
