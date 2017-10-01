//
//  Tweet.swift
//  TwitterLite
//
//  Created by Wuming Xie on 9/26/17.
//  Copyright © 2017 Wuming Xie. All rights reserved.
//

import SwiftyJSON

class Tweet: NSObject {
    var user: User?
    var originalTweeter: User?
    var text: String?
    var timeStamp: Date?
    var id: String?
    var retweeted = false
    var retweetCount = 0
    var favorited = false
    var favoritesCount = 0
    
    init(json: JSON) {
        text = json["text"].string
        id = json["id_str"].string
        
        retweeted = json["retweeted"].bool ?? false
        retweetCount = json["retweet_count"].int ?? 0
        favorited = json["favorited"].bool ?? false
        favoritesCount = json["favourites_count"].int ?? 0
        
        if let timeStampString = json["created_at"].string {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            
            timeStamp = dateFormatter.date(from: timeStampString)
        }
        
        user = User(json: json["user"])
        if let retweetStatus = json["retweeted_status"].dictionary {
            originalTweeter = User(json: retweetStatus["user"]!)
            text = retweetStatus["text"]?.string
        }
        
        
        print(json)
    }
    
    func isRetweet() -> Bool {
        return originalTweeter != nil
    }
    
    func changeRTStatus() {
        let changeCount = retweeted ? -1 : 1
        retweetCount = retweetCount + changeCount
        retweeted = !retweeted
    }
    
    func changeFavoriteStatus() {
        let changeCount = favorited ? -1 : 1
        favoritesCount = favoritesCount + changeCount
        favorited = !favorited
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
