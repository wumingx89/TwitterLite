//
//  Tweet.swift
//  TwitterLite
//
//  Created by Wuming Xie on 9/26/17.
//  Copyright © 2017 Wuming Xie. All rights reserved.
//

import UIKit
import SwiftyJSON

class Tweet: NSObject {
    var text: String?
    var timeStamp: Date?
    var retweetCount = 0
    var favoritesCount = 0
    
    init(json: JSON) {
        text = json["text"].string
        
        retweetCount = json["retweet_count"].int ?? 0
        favoritesCount = json["favourites_count"].int ?? 0
        
        if let timeStampString = json["created_at"].string {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            
            timeStamp = dateFormatter.date(from: timeStampString)
        }
        
        print(json)
    }
    
    class func tweets(from jsonArray: [JSON]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for json in jsonArray {
            let tweet = Tweet(json: json)
            tweets.append(tweet)
        }
        
        return tweets
    }
}
