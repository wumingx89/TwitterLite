//
//  TweetCountCell.swift
//  TwitterLite
//
//  Created by Wuming Xie on 10/1/17.
//  Copyright © 2017 Wuming Xie. All rights reserved.
//

import UIKit

class TweetCountCell: UITableViewCell {

    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var retweetNameLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var favoriteNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    func setCell(withTweet tweet: Tweet) {
        retweetCountLabel.text = "\(tweet.retweetCount)"
        retweetNameLabel.text = tweet.retweetCount == 1 ? "Retweet" : "Retweets"
        
        favoriteCountLabel.text = "\(tweet.favoritesCount)"
        favoriteNameLabel.text = tweet.favoritesCount == 1 ? "Favorite" : "Favorites"
    }
}
