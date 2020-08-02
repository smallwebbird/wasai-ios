//
//  AppDelegate.swift
//  wasai
//
//  Created by 李政辉 on 2020/8/1.
//  Copyright © 2020 李政辉. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let Preferences = PreferenceManager.shared
    var initalViewController: UIViewController?
    let appVersion = SystemInfo.appVersion
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // 如果是ios13以上，那么直接返回
        if #available(iOS 13, *) {
            return true
        }
        window = UIWindow(frame: UIScreen.main.bounds)
        let homeStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let homeViewController: UIViewController = homeStoryBoard.instantiateViewController(withIdentifier: "ViewController") as UIViewController
        let guideStoryBoard: UIStoryboard = UIStoryboard(name: "Guide", bundle: nil)
        let guideViewController: UIViewController = guideStoryBoard.instantiateViewController(withIdentifier: "GuideViewController") as UIViewController
        let isFirstOpenApp = Preferences[.isFirstOpenApp]
        let cacheAppVersion = Preferences[.appVersion]
        // 如果是一次那么就进入引导页，否则进入首页
        print(isFirstOpenApp)
        if isFirstOpenApp {
            // 第一次进入之后设置为false
            Preferences[.isFirstOpenApp] = false
            initalViewController = guideViewController
        } else {
            // 如果不是第一次使用app，看看是不是因为升级
            if appVersion != cacheAppVersion {
                // 不等于说明更新了
                Preferences[.appVersion] = appVersion
                initalViewController = guideViewController
            } else {
                initalViewController = homeViewController
            }
        }
        window?.rootViewController = initalViewController
        window?.makeKeyAndVisible()
        print("hello world")
        return true
        
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    // 在ios以上以下都能执行
    func applicationWillTerminate(_ application: UIApplication) {
        print("app退出了")
    }
    // ios 13以下才能够触发appDelegate中的生命周期的方法，ios13以上
    // ui生命周期函数是在SceneDelegate中
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("app在ios13以下进入后台了")
    }
}

