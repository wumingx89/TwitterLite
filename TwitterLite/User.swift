//
//  User.swift
//  TwitterLite
//
//  Created by Wuming Xie on 9/26/17.
//  Copyright © 2017 Wuming Xie. All rights reserved.
//

import SwiftyJSON

class User: NSObject {
    static let userDidLogoutKey = "UserDidLogOut"
    
    var userJSON: JSON!
    var name: String?
    var id: String?
    var screenName: String?
    var profileUrl: URL?
    var tagline: String?
    var tweetCount: String!
    var followingCount: String!
    var followersCount: String!
    
    private static var _currentUser: User?
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                if let jsonString = UserDefaults.standard.string(forKey: "currentUser") {
                    _currentUser = User(json: JSON(parseJSON: jsonString))
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
        id = json["id_str"].string
        screenName = json["screen_name"].string
        tagline = json["description"].string
        tweetCount = Helper.formatCount(json["statuses_count"].int)
        followingCount = Helper.formatCount(json["friends_count"].int)
        followersCount = Helper.formatCount(json["followers_count"].int)
        
        if let profilePicUrl = json["profile_image_url_https"].string {
            profileUrl = URL(string: profilePicUrl)
        }
    }
    
    class func isCurrentUser(_ user: User?) -> Bool {
        return user != nil && user!.id == User._currentUser?.id
    }
}
