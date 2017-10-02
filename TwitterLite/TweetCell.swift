//
//  TweetCell.swift
//  TwitterLite
//
//  Created by Wuming Xie on 9/26/17.
//  Copyright © 2017 Wuming Xie. All rights reserved.
//

import UIKit
import AFNetworking

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
    
    // MARK: - Properties
    var tweet: Tweet! {
        didSet {
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
            
            dateLabel.text = nil
            if let tweetDate = tweet.timeStamp {
                dateLabel.text = DateFormatter.localizedString(from: tweetDate, dateStyle: .short, timeStyle: .short)
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
    
    // MARK: - Static variables
    static let indentifier = "TweetCell"

    // MARK: - Lifecycle functions
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Customize cell elements
        selectionStyle = .none
        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = profileImage.bounds.width / 2.0
        profileImage.layer.borderColor = Constants.TwitterColor.darkGray.cgColor
        profileImage.layer.borderWidth = 0.5
        
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
        
        // Set images properly
        replyImageView.image = replyImageView.image!.withRenderingMode(.alwaysTemplate)
        replyImageView.tintColor = Constants.TwitterColor.darkGray
        favoriteImageView.image = favoriteImageView.image!.withRenderingMode(.alwaysTemplate)
        retweetImageView.image = retweetImageView.image!.withRenderingMode(.alwaysTemplate)
    }
    
    // MARK: - Tweet action functions
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
}
