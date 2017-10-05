//
//  AppDelegate.swift
//  TwitterLite
//
//  Created by Wuming Xie on 9/25/17.
//  Copyright © 2017 Wuming Xie. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        if User.currentUser != nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let hamburgerVC = storyboard.instantiateViewController(withIdentifier: "HamburgerViewController") as! HamburgerViewController
            let menuVC = storyboard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
            
            menuVC.hamburgerVC = hamburgerVC
            hamburgerVC.menuViewController = menuVC
            window?.rootViewController = hamburgerVC
        }
        
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name(rawValue: User.userDidLogoutKey),
            object: nil,
            queue: OperationQueue.main) { (notification) in
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateInitialViewController()
                self.window?.rootViewController = vc
        }
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        TwitterClient.shared.handleOpenUrl(url: url)
        return true
    }
}
