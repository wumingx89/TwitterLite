//
//  TweetCell.swift
//  TwitterLite
//
//  Created by Wuming Xie on 9/26/17.
//  Copyright © 2017 Wuming Xie. All rights reserved.
//

import UIKit
import AFNetworking

@objc protocol TweetCellDelegate {
    @objc optional func tweetCell(_ tweetCell: TweetCell, didTapReply tweet: Tweet)
}

class TweetCell: UITableViewCell {
    
    // MARK: Outlets
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
            tweetLabel.text = tweet.text
            nameLabel.text = tweet.user?.name
            handleLabel.text = "@\(tweet.user?.screenName ?? "")"
            
            dateLabel.text = nil
            if let tweetDate = tweet.timeStamp {
                dateLabel.text = TweetCell.formatter.string(from: tweetDate)
            }
            
            profileImage.image = nil
            if let profileUrl = tweet.user?.profileUrl {
                Helper.loadImage(withUrl: profileUrl, forView: profileImage)
            }
        }
    }
    
    weak var delegate: TweetCellDelegate?
    
    // MARK: - Static variables
    static let indentifier = "TweetCell"
    static let formatter = { () -> DateFormatter in
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM y"
        return formatter
    }()

    // MARK: - Lifecycle functions
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Customize cell elements
        selectionStyle = .none
        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = profileImage.bounds.width / 2.0
        
        // Add tap gesture recognizers to icons
        replyImageView.isUserInteractionEnabled = true
        replyImageView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(onReply))
        )
        
    }
    
    // MARK: - Tweet action functions
    func onReply() {
        delegate?.tweetCell?(self, didTapReply: tweet)
    }
}
