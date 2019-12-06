//
//  AppDelegate.swift
//  Issues
//
//  Created by HoangVanDuc on 12/4/19.
//  Copyright © 2019 HoangVanDuc. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    static let share = AppDelegate()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let cahing = Caching.share
        cahing.saveMenuItemIndex(index: 2)
        
        if #available(iOS 13, *) {
            
        } else {
            let token = Caching.share.getToken()
            
            if token.isEmpty || token.count <= 0 {
                self.startLogin()
            } else {
                self.startMain()
            }
        }
        return true
    }
    
    func startMain() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let nav1 = UINavigationController()
         let mainVC = IssuesViewController.init(nibName: "IssuesViewController", bundle: nil)
//        let mainVC = ReportIssuesViewController.init(nibName: "ReportIssuesViewController", bundle: nil)
        let mainView = mainVC
        nav1.viewControllers = [mainView]
        self.window!.rootViewController = nav1
    }
    
    func startLogin() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let nav1 = UINavigationController()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        let mainView = loginVC
        nav1.viewControllers = [mainView]
        self.window!.rootViewController = nav1
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

