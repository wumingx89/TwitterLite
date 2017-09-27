//
//  User.swift
//  TwitterLite
//
//  Created by Wuming Xie on 9/26/17.
//  Copyright © 2017 Wuming Xie. All rights reserved.
//

import UIKit
import SwiftyJSON

class User: NSObject {
    static let userDidLogoutKey = "UserDidLogOut"
    
    var userJSON: JSON!
    var name: String?
    var screenName: String?
    var profileUrl: URL?
    var tagline: String?
    
    private static var _currentUser: User?
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                if let jsonString = UserDefaults.standard.string(forKey: "currentUser") {
                    print(jsonString)
                    _currentUser = User(json: JSON(parseJSON: jsonString))
                } else {
                    print("somethings messed up")
                }
            }
            return _currentUser
        }
        set(user) {
            let defaults = UserDefaults.standard
            var stringToSet: String? = nil
            if let jsonString = user?.userJSON.rawString() {
                stringToSet = jsonString
            }
            defaults.set(stringToSet, forKey: "currentUser")
            defaults.synchronize()
            _currentUser = user
        }
    }
    
    init(json: JSON) {
        userJSON = json
        name = json["name"].string
        screenName = json["screen_name"].string
        tagline = json["description"].string
        
        if let profilePicUrl = json["profile_image_url_https"].string {
            profileUrl = URL(string: profilePicUrl)
        }
    }
}
