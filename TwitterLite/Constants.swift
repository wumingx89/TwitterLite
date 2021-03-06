//
//  Constants.swift
//  TwitterLite
//
//  Created by Wuming Xie on 9/25/17.
//  Copyright © 2017 Wuming Xie. All rights reserved.
//

import UIKit

struct Constants {
    
    static let tweetWarningLimit = 20
    static let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    struct OAuth {
        static let consumerKey = "KYOA9SGcQM4SWdIUny2E7Gc3P"
        static let consumerSecret = "1eXvtK5MRzzkMuQDcvHuyMJiMZmVji3i2dgTyzNcFG5yHwmDhB"
        static let requestTokenURL = "oauth/request_token"
        static let authorizeURL = "oauth/authorize"
        static let accessTokenURL = "oauth/access_token"
    }
    
    struct SegueIds {
        static let compose = "composeTweetSegue"
        static let replyTweet = "replyTweetSegue"
        static let openTweet = "openTweetSegue"
        static let tweetDetailReply = "tweetDetailReplySegue"
    }
    
    struct TwitterColor {
        static let primaryBlue = Constants.colorHelper(r: 29, g: 161, b: 242, a: 1)
        static let black = Constants.colorHelper(r: 20, g: 23, b: 26, a: 1)
        static let darkGray = Constants.colorHelper(r: 101, g: 119, b: 134, a: 1)
        static let lightGray = Constants.colorHelper(r: 170, g: 184, b: 194, a: 1)
    }
    
    struct EventId {
        static let newTweet = "TwitterLite_NewTweet"
        static let openMenu = Notification.Name("OpenHamburgerMenu")
    }
    
    struct CellTypes {
        static let tweetCell = "TweetCell"
        static let tweetDetailCell = "TweetDetailCell"
        static let tweetCountCell = "TweetCountCell"
        static let tweetActionCell = "TweetActionCell"
    }
    
    static func colorHelper(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> UIColor {
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    }
}
