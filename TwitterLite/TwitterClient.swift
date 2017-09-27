//
//  TwitterClient.swift
//  TwitterLite
//
//  Created by Wuming Xie on 9/26/17.
//  Copyright © 2017 Wuming Xie. All rights reserved.
//

import UIKit
import BDBOAuth1Manager
import SwiftyJSON

class TwitterClient: BDBOAuth1SessionManager {
    
    static let shared: TwitterClient = TwitterClient(
        baseURL: URL(string: "https://api.twitter.com")!,
        consumerKey: Constants.OAuth.consumerKey,
        consumerSecret: Constants.OAuth.consumerSecret
    )
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error?) -> ())?
    
    func login(success: @escaping () -> (), failure: @escaping (Error?) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        deauthorize()
        fetchRequestToken(
            withPath: Constants.OAuth.requestTokenURL,
            method: "GET",
            callbackURL: URL(string: "twitterlite://oauth")!,
            scope: nil, success: { (credential) in
                let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(credential!.token!)")
                UIApplication.shared.open(url!)
        }, failure: { (error) in
            print("Error")
            self.loginFailure?(error)
        })
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NotificationCenter.default.post(
            name: NSNotification.Name(rawValue: User.userDidLogoutKey),
            object: nil
        )
    }
    
    func handleOpenUrl(url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(
            withPath: Constants.OAuth.accessTokenURL,
            method: "POST",
            requestToken: requestToken,
            success: { (accessToken) in
                self.currentAccount(success: { (user) in
                    User.currentUser = user
                }, failure: { (error) in
                    print(error.localizedDescription)
                    self.loginFailure?(error)
                })
                self.loginSuccess?()
        }, failure: { (error) in
            self.loginFailure?(error)
        })
    }
    
    func homeTimeLine(success: (([Tweet]) -> ())?, failure: ((Error) -> ())?) {
        get("1.1/statuses/home_timeline.json",
            parameters: nil,
            progress: nil,
            success: { (dataTask, response) in
                if let json = JSON(response as Any).array {
                    let tweets = Tweet.tweets(from: json)
                    success?(tweets)
                }
        }) { (dataTask, error) in
            failure?(error)
        }
    }
    
    func currentAccount(success: @escaping (User) -> (), failure: ((Error) -> ())?) {
        get("1.1/account/verify_credentials.json",
            parameters: nil,
            progress: nil,
            success: { (task, response) in
                let user = User(json: JSON(response as Any))
                success(user)
                
                print(user.name ?? "No name")
                print(user.tagline ?? "No tagline")
        }, failure: { (task, error) in
            failure?(error)
        })
    }
}
