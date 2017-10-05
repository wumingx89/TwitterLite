//
//  LoginViewController.swift
//  TwitterLite
//
//  Created by Wuming Xie on 9/25/17.
//  Copyright © 2017 Wuming Xie. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {
    
    // MARK: Action outlets
    @IBAction func onLogin(_ sender: UIButton) {
        let twitterClient = TwitterClient.shared
        twitterClient.login(success: { 
            //self.performSegue(withIdentifier: "loginSegue", sender: nil)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let hamburgerVC = storyboard.instantiateViewController(withIdentifier: "HamburgerViewController") as! HamburgerViewController
            let menuVC = storyboard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
            
            menuVC.hamburgerVC = hamburgerVC
            hamburgerVC.menuViewController = menuVC
            
            self.present(hamburgerVC, animated: true, completion: nil)
        }) { (error) in
            print(error!.localizedDescription)
        }
    }
}
