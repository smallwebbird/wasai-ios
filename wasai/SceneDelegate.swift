//
//  SceneDelegate.swift
//  wasai
//
//  Created by 李政辉 on 2020/8/1.
//  Copyright © 2020 李政辉. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let Preferences = PreferenceManager.shared
    var initalViewController: UIViewController?
    let appVersion = SystemInfo.appVersion


    @available(iOS 13.0, *)
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        if let windowSence = scene as? UIWindowScene  {
           self.window = UIWindow(windowScene: windowSence)
            var homeViewController: UIViewController = ViewController()
            homeViewController = UINavigationController(rootViewController: homeViewController)
            let guideViewController: UIViewController = GuideViewController()
            let isFirstOpenApp = Preferences[.isFirstOpenApp]
            let cacheAppVersion = Preferences[.appVersion]
            // 如果是一次那么就进入引导页，否则进入首页
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
            self.window?.rootViewController = initalViewController
            self.window?.makeKeyAndVisible()        }
    }
    @available(iOS 13.0, *)
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    @available(iOS 13.0, *)
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    @available(iOS 13.0, *)
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    @available(iOS 13.0, *)
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    @available(iOS 13.0, *)
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        print("在ios13中进入后台时触发")
    }
}

