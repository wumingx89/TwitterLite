//
//  TweetDetailCell.swift
//  TwitterLite
//
//  Created by Wuming Xie on 10/1/17.
//  Copyright © 2017 Wuming Xie. All rights reserved.
//

import UIKit

class TweetDetailCell: UITableViewCell {

    @IBOutlet weak var topRTView: UIView!
    @IBOutlet weak var retweetNameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = profileImage.bounds.size.width / 2.0
    }
    
    func updateCell(withTweet tweet: Tweet) {
        var originalUser: User?
        if tweet.isRetweet() {
            topRTView.isHidden = false
            originalUser = tweet.originalTweeter
            retweetNameLabel.text = "\(User.isCurrentUser(tweet.user) ? "You" : tweet.user?.name ?? "") Retweeted"
        } else {
            originalUser = tweet.user
            topRTView.isHidden = true
        }
        
        tweetLabel.text = tweet.text
        nameLabel.text = originalUser?.name
        handleLabel.text = "@\(originalUser?.screenName ?? "")"
        
        timeLabel.text = nil
        if let tweetDate = tweet.timeStamp {
            timeLabel.text = DateFormatter.localizedString(from: tweetDate, dateStyle: .short, timeStyle: .short)
        }
        
        profileImage.image = nil
        if let profileUrl = originalUser?.profileUrl {
            Helper.loadImage(withUrl: profileUrl, forView: profileImage)
        }
    }
}
