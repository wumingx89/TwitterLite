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
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func onLogin(_ sender: UIButton) {
        let twitterClient = BDBOAuth1SessionManager(
            baseURL: URL(string: "https://api.twitter.com")!,
            consumerKey: Constants.OAuth.consumerKey,
            consumerSecret: Constants.OAuth.consumerSecret
        )
        
        twitterClient?.deauthorize()
        twitterClient?.fetchRequestToken(
            withPath: Constants.OAuth.requestTokenURL,
            method: "GET",
            callbackURL: URL(string: "twitterlite://oauth")!,
            scope: nil, success: { (credential) in
                print(credential?.token ?? "No token")
                let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(credential!.token!)")
                if url == nil {
                    print("NIL")
                }
                UIApplication.shared.open(url!)
        }, failure: { (error) in
            print("Error")
        })
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
