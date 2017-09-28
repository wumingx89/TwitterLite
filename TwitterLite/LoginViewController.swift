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
    
    // MARK: Lifecycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Action outlets
    @IBAction func onLogin(_ sender: UIButton) {
        let twitterClient = TwitterClient.shared
        twitterClient.login(success: { 
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        }) { (error) in
            print(error!.localizedDescription)
        }
    }
}
