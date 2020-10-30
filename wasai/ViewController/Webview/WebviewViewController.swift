//
//  ViewController.swift
//  wasai
//
//  Created by 李政辉 on 2020/8/1.
//  Copyright © 2020 李政辉. All rights reserved.
//

import UIKit
import WebKit

class WebViewViewController: UIViewController, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler,
    CallFinished{
    
    
    var webview: WKWebView?
    
    var navBack = UINavigationItem()
    var navForward = UINavigationItem()
    
    var progressView = UIProgressView()
    
    var barH:CGFloat = 0.0
    var statusH:CGFloat = 0.0
    
    var backItem: UIBarButtonItem?
    
    var closeItem: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        
        barH = (navigationController?.navigationBar.frame.height)!
        
        statusH = UIApplication.shared.statusBarFrame.height
        
        navigationItem.hidesBackButton = true
       
        initWebView()
        
        initNavigationBar()
        
        initProgressBar()
    }
    
    func initNavigationBar () {
        self.navigationItem.title = "加载中..."
        
    }
    
    func initProgressBar () {
        progressView = UIProgressView(frame: CGRect(x: 0, y: statusH + barH, width: view.frame.width, height: 30))
        progressView.trackTintColor = UIColor.white
        progressView.progressTintColor = UIColor.red
        // 通过变形改变 progress 高度
        progressView.transform = CGAffineTransform.init(scaleX: 1, y: 2)
        //设置初始值，防止网页加载过慢时没有进度
        progressView.progress = 0.01
        //设定两端弧度
        progressView.layer.cornerRadius = 1.0
        view.addSubview(progressView)
        
    }
    
    
    func initWebView () {
        // 好像默认x 和 y 就是从bar下面开始的，所以这里面不需要 导航栏的高度和状态栏的高度
        //创建wkwebview
        webview = WKWebView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        // 监听webview加载进度
        webview?.configuration.userContentController.add(WeakScriptMessageDelegate.init(self), name: "bridge")
        webview!.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        // 监听webview url变化
        webview!.addObserver(self, forKeyPath: "title", options: .new, context: nil)
        // 监听 cangoback 变化
        webview!.addObserver(self, forKeyPath: "canGoBack", options: .new, context: nil)
        webview!.uiDelegate = self
        webview!.navigationDelegate = self
            //创建网址
        let url = NSURL(string: "http://192.168.1.102:8080?1")
            //创建请求
        let request = NSURLRequest(url: url! as URL)
            //加载请求
        webview!.load(request as URLRequest)
            //添加wkwebview
        self.view.addSubview(webview!)
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        let jsonStr = message.body
        let jsonData = (jsonStr as AnyObject).data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false) ?? Data()
        guard let json = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) else {
             return
        }
        dispatchNativeBridge(json: json as! [String : Any])
    }
    
    func callNativeFunctionFinished(params: [String : Any]) {
        let msg: [String: Any] = ["callbackId":
                                    params["callbackId"], "responseData": ["data": ["abc": 1223333], "type": "success"]]
        let data = try? JSONSerialization.data(withJSONObject: msg, options: [])
        var jsonStr = String(data: data!, encoding: String.Encoding.utf8)
        webview?.evaluateJavaScript("window.JSBridge.receiveMessage(" + jsonStr! + ")") {(response,     error) in
                print(error)
        }
    }
    
    
    func dispatchNativeBridge(json: [String: Any]) {
        NativeBridge.init(params: json, nativeBridge: self)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress"{
            progressView.alpha = 1.0
            progressView.setProgress(Float(webview!.estimatedProgress), animated: true)
                 //进度条的值最大为1.0
             if(webview!.estimatedProgress >= 1.0) {
                UIView.animate(withDuration: 0.3, delay: 0.1, options: UIView.AnimationOptions.curveEaseInOut, animations: { () -> Void in
                    self.progressView.alpha = 0.0
                }, completion: { (finished:Bool) -> Void in
                    self.progressView.progress = 0
                })
              }
        } else if keyPath == "title" {
            self.navigationItem.title = webview?.title
        } else if (keyPath == "canGoBack") {
            updateNavigationItem()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        webview!.removeObserver(self, forKeyPath: "estimatedProgress")
        webview!.removeObserver(self, forKeyPath: "title")
        webview!.removeObserver(self, forKeyPath: "canGoBack")
        webview!.navigationDelegate = nil
        webview!.uiDelegate = nil
    }

    
    //页面开始加载时调用
    @available(iOS 8.0, *)
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    }

    // 页面加载失败时调用
    @available(iOS 8.0, *)
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        updateNavigationItem()
    }

    // 当内容开始返回时调用
    @available(iOS 8.0, *)
    public func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {

    }

    // 页面加载完成之后调用
    @available(iOS 8.0, *)
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.navigationItem.title = self.webview?.title
        updateNavigationItem()
        // 执行js文件
        runJS()
    }
    
    func runJS () {
        webview?.evaluateJavaScript(WebviewJavascript, completionHandler: nil)
    }
    
     //处理拨打电话、发短信、发邮件以及Url跳转等等
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {
        if navigationAction.request.url?.scheme == "tel" {
//            DispatchQueue.main.async {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open( navigationAction.request.url!,options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(navigationAction.request.url!);
            };
                decisionHandler(WKNavigationActionPolicy.cancel)
//            }
        }
        else if navigationAction.request.url?.scheme == "sms"{
            if #available(iOS 10.0, *) {
                UIApplication.shared.open( navigationAction.request.url!,options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(navigationAction.request.url!);
            };

            decisionHandler(WKNavigationActionPolicy.cancel)
        }
        else if navigationAction.request.url?.scheme == "mailto"{
            //邮件的处理
            if #available(iOS 10.0, *) {
                print("one")
                UIApplication.shared.open( navigationAction.request.url!,options: [:], completionHandler: nil)
            } else {
                print("two")
                // Fallback on earlier versions
                UIApplication.shared.openURL(navigationAction.request.url!);
            };
            decisionHandler(WKNavigationActionPolicy.cancel)
        }
        else{
            decisionHandler(WKNavigationActionPolicy.allow)
        }
    }
    
    // 警告框
        // 在JS端调用alert函数时，会触发此代理方法。
        // JS端调用alert时所传的数据可以通过message拿到
        // 在原生得到结果后，需要回调JS，是通过completionHandler回调
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void){
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) -> Void in
            completionHandler()
            }))
           self.present(alert, animated: true, completion: nil)
    }
    
    // 是否显示左边的
    func updateNavigationItem(){
        navigationController?.interactivePopGestureRecognizer?.isEnabled = !webview!.canGoBack
        if (backItem == nil) {
            let goBackBtn = UIButton.init()
   //        goBackBtn.setImage(UIImage.init(named: "navi_go_back"), for: UIControl.State.normal)
           goBackBtn.setTitle(" 返回", for: UIControl.State.normal)
            goBackBtn.setTitleColor(.red, for: .normal)
           goBackBtn.addTarget(self, action: #selector(goback), for: .touchUpInside)
           goBackBtn.sizeToFit()
           goBackBtn.contentEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 8)
           
           backItem = UIBarButtonItem.init(customView: goBackBtn)
        }
        if (closeItem == nil) {
            let closeBtn = UIButton.init()
            closeBtn.setTitle("关闭", for: UIControl.State.normal)
            closeBtn.setTitleColor(.red, for: .normal)
            closeBtn.addTarget(self, action: #selector(popViewController), for: .touchUpInside)
            closeBtn.sizeToFit()
            closeItem = UIBarButtonItem.init(customView: closeBtn)
        }
        let items:[UIBarButtonItem] = webview!.canGoBack ? [backItem!, closeItem!] : [backItem!]
        self.navigationItem.leftBarButtonItems = items
    }
    
    @objc func goback () {
        if (webview!.canGoBack) {
            webview!.goBack()
        } else {
            popViewController()
        }
    }
    
    @objc func popViewController(){
         
        dismiss(animated: true, completion: nil)
    }
    
    deinit {
        webview!.configuration.userContentController.removeScriptMessageHandler(forName: "bridge")
        print("WKWebViewController is deinit")
    }
}



