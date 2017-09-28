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
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    // MARK: Properties
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
    
    // MARK: Static variables
    static let indentifier = "TweetCell"
    static let formatter = { () -> DateFormatter in
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM y"
        return formatter
    }()

    // MARK: Lifecycle functions
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Customize cell elements
        selectionStyle = .none
        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = profileImage.bounds.width / 2.0
    }
}
