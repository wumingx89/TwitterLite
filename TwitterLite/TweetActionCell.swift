//
//  TweetActionCell.swift
//  TwitterLite
//
//  Created by Wuming Xie on 10/1/17.
//  Copyright © 2017 Wuming Xie. All rights reserved.
//

import UIKit

@objc protocol TweetActionCellDelegate {
    @objc optional func tweetActionCell(
        _ tweetActionCell: TweetActionCell,
        didTapReply completion: (() -> ())?
    )
    
    @objc optional func tweetActionCell(
        _ tweetActionCell: TweetActionCell,
        didTapRetweet completion: (() -> ())?
    )
    
    @objc optional func tweetActionCell(
        _ tweetActionCell: TweetActionCell,
        didTapFavorite completion: (() -> ())?
    )
}

class TweetActionCell: UITableViewCell {

    @IBOutlet weak var replyImageView: UIImageView!
    @IBOutlet weak var retweetImageView: UIImageView!
    @IBOutlet weak var favoriteImageView: UIImageView!
    
    weak var delegate: TweetActionCellDelegate?
    var tweet: Tweet! {
        didSet {
            updateRTImageColor()
            updateFavoriteImageColor()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Set images properly
        replyImageView.image = replyImageView.image!.withRenderingMode(.alwaysTemplate)
        replyImageView.tintColor = Constants.TwitterColor.darkGray
        favoriteImageView.image = favoriteImageView.image!.withRenderingMode(.alwaysTemplate)
        retweetImageView.image = retweetImageView.image!.withRenderingMode(.alwaysTemplate)
        
        // Add tap gesture recognizers to images
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
    }

    func onReply() {
        delegate?.tweetActionCell?(self, didTapReply: nil)
    }
    
    func onRetweet() {
        delegate?.tweetActionCell?(self, didTapRetweet: {
            self.animateImage(self.retweetImageView, colorChange: self.updateRTImageColor)
        })
    }

    func onFavorite() {
        delegate?.tweetActionCell?(self, didTapFavorite: {
            self.animateImage(self.favoriteImageView, colorChange: self.updateFavoriteImageColor)
        })
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
