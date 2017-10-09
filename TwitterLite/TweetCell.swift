//
//  TweetCell.swift
//  TwitterLite
//
//  Created by Wuming Xie on 9/26/17.
//  Copyright © 2017 Wuming Xie. All rights reserved.
//

import UIKit
import SwiftDate

enum TweetCellStyle {
    case normal, small
}

class TweetCell: UITableViewCell {
    
    // MARK: Outlets
    @IBOutlet weak var topRTView: UIView!
    @IBOutlet weak var retweetNameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var replyImageView: UIImageView!
    @IBOutlet weak var retweetImageView: UIImageView!
    @IBOutlet weak var favoriteImageView: UIImageView!
    @IBOutlet var rtConstraints: [NSLayoutConstraint]!
    
    // MARK: - Properties
    var style = TweetCellStyle.normal {
        didSet(oldStyle) {
            if style != oldStyle {
                switch style {
                case .normal:
                    nameLabel.font = UIFont(name: nameLabel.font.fontName, size: nameLabel.font.pointSize + 5.0)
                    tweetLabel.font = UIFont(name: tweetLabel.font.fontName, size: tweetLabel.font.pointSize + 5.0)
                    replyImageView.isHidden = false
                    retweetImageView.isHidden = false
                    favoriteImageView.isHidden = false
                case .small:
                    nameLabel.font = UIFont(name: nameLabel.font.fontName, size: nameLabel.font.pointSize - 5.0)
                    tweetLabel.font = UIFont(name: tweetLabel.font.fontName, size: tweetLabel.font.pointSize - 5.0)
                    replyImageView.isHidden = true
                    retweetImageView.isHidden = true
                    favoriteImageView.isHidden = true
                }
            }
        }
    }
    
    var tweet: Tweet! {
        didSet {
            var originalUser: User?
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
            nameLabel.text = originalUser?.name
            handleLabel.text = "@\(originalUser?.screenName ?? "")"
            
            dateLabel.text = nil
            if let tweetDate = tweet.timeStamp {
                dateLabel.text = timeSince(tweetDate)
            }
            
            profileImage.image = nil
            if let profileUrl = originalUser?.profileUrl {
                Helper.loadImage(withUrl: profileUrl, forView: profileImage)
            }
            
            updateRTImageColor()
            updateFavoriteImageColor()
        }
    }
    
    var replyHandler: ((Tweet) -> ())?
    var retweetHandler: ((Tweet, @escaping () -> ()) -> ())?
    var favoriteHandler: ((Tweet, @escaping () -> ()) -> ())?
    var profileHandler: ((User) -> ())?

    // MARK: - Lifecycle functions
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Customize cell elements
        selectionStyle = .none
        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = profileImage.bounds.width / 2.0
        
        // Font color
        dateLabel.textColor = Constants.TwitterColor.lightGray
        handleLabel.textColor = Constants.TwitterColor.lightGray
        
        // Add tap gesture recognizers to icons
        replyImageView.isUserInteractionEnabled = true
        replyImageView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(onReply))
        )
        
        retweetImageView.isUserInteractionEnabled = true
        retweetImageView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(onRetweet))
        )
        
        favoriteImageView.isUserInteractionEnabled = true
        favoriteImageView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(onFavorite))
        )
        
        // Add tap gesture recognizer to profile image
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(onProfile))
        )
        
        // Set images properly
        replyImageView.image = replyImageView.image!.withRenderingMode(.alwaysTemplate)
        replyImageView.tintColor = Constants.TwitterColor.darkGray
        favoriteImageView.image = favoriteImageView.image!.withRenderingMode(.alwaysTemplate)
        retweetImageView.image = retweetImageView.image!.withRenderingMode(.alwaysTemplate)
    }
    
    // MARK: - Tweet cell action functions
    func onProfile() {
        if let originalUser = tweet.originalTweeter {
            profileHandler?(originalUser)
        } else if let user = tweet.user {
            profileHandler?(user)
        }
    }
    
    func onReply() {
        replyHandler?(tweet)
    }
    
    func onRetweet() {
        retweetHandler?(tweet) {
            self.animateImage(self.retweetImageView, colorChange: self.updateRTImageColor)
        }
    }
    
    func onFavorite() {
        favoriteHandler?(tweet) {
            self.animateImage(self.favoriteImageView, colorChange: self.updateFavoriteImageColor)
        }
    }
    
    func updateRTImageColor() {
        retweetImageView.tintColor = tweet.retweeted ? UIColor.green : Constants.TwitterColor.darkGray
    }
    
    func updateFavoriteImageColor() {
        favoriteImageView.tintColor = tweet.favorited ? UIColor.red : Constants.TwitterColor.darkGray
    }
    
    func animateImage(_ imageView: UIImageView, colorChange: @escaping () -> ()) {
        UIView.animate(withDuration: 0.1, animations: {
            imageView.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
            colorChange()
        }) { (finished) in
            UIView.animate(withDuration: 0.1, animations: {
                imageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            })
        }
    }
    
    // MARK: - Time since tweet posted
    func timeSince(_ time: Date) -> String {
        let components: [Calendar.Component] = [.day, .hour, .minute, .second]
        let mapping: [Calendar.Component: String] = [.day: "d", .hour: "h", .minute: "m", .second: "s"]
        let times = time.timeIntervalSinceNow.in(components)
        
        for component in components {
            if let elapsedTime = times[component] {
                if abs(elapsedTime) > 0 {
                    return "\(abs(elapsedTime))\(mapping[component]!)"
                }
            }
        }
        
        return ""
    }
}
