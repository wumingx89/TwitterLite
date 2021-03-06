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
    @IBOutlet var rtConstraints: [NSLayoutConstraint]!
    
    var profileHandler: ((User) -> ())?
    var originalUser: User!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = profileImage.bounds.size.width / 2.0
        
        profileImage.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(onProfile))
        )
    }
    
    func updateCell(withTweet tweet: Tweet) {
        if tweet.isRetweet() {
            topRTView.isHidden = false
            originalUser = tweet.originalTweeter
            retweetNameLabel.text = "\(User.isCurrentUser(tweet.user) ? "You" : tweet.user?.name ?? "") Retweeted"
            for constraint in rtConstraints {
                constraint.constant = 4.0
            }
        } else {
            originalUser = tweet.user
            for constraint in rtConstraints {
                constraint.constant = 0.0
            }
            topRTView.isHidden = true
        }
        
        tweetLabel.text = tweet.text
        nameLabel.text = originalUser.name
        handleLabel.text = "@\(originalUser.screenName ?? "")"
        
        timeLabel.text = nil
        if let tweetDate = tweet.timeStamp {
            timeLabel.text = DateFormatter.localizedString(from: tweetDate, dateStyle: .short, timeStyle: .short)
        }
        
        profileImage.image = nil
        if let profileUrl = originalUser?.profileUrl {
            Helper.loadImage(withUrl: profileUrl, forView: profileImage)
        }
    }
    
    func onProfile() {
        profileHandler?(originalUser)
    }
}
