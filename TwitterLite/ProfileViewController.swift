//
//  ProfileViewController.swift
//  TwitterLite
//
//  Created by Wuming Xie on 10/6/17.
//  Copyright © 2017 Wuming Xie. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var linkView: UIView!
    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var bottomStackView: UIStackView!
    @IBOutlet weak var tweetCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet var locationConstraints: [NSLayoutConstraint]!
    @IBOutlet var linkConstraints: [NSLayoutConstraint]!
    
    var headerImageView: UIImageView!
    var blurEffectView: UIVisualEffectView!
    var user: User!
    var timelineType = TimelineType.user
    var tweets = [Tweet]()
    
    
    // MARK:- View lifecycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if navigationController != nil && navigationController!.viewControllers.count > 1 {
            backImage.isHidden = false
            backImage.isUserInteractionEnabled = true
            backImage.image = #imageLiteral(resourceName: "profile_back").withRenderingMode(.alwaysTemplate)
            backImage.tintColor = UIColor.white
            backImage.backgroundColor = Constants.TwitterColor.lightGray
            backImage.alpha = 0.66
            backImage.layer.cornerRadius = backImage.bounds.size.width / 2.0
            backImage.clipsToBounds = true
            backImage.addGestureRecognizer(
                UITapGestureRecognizer(target: self, action: #selector(onBack))
            )
        } else {
            backImage.isHidden = true
        }
        
        tableView.contentInset = UIEdgeInsetsMake(headerView.frame.height, 0, 0, 0)
        tableView.clipsToBounds = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TweetCell", bundle: nil), forCellReuseIdentifier: "TweetCell")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        tableView.tableFooterView = UIView()
        
        navigationController?.navigationBar.isHidden = true
        
        blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        blurEffectView.frame = headerView.bounds
        blurEffectView.alpha = 0.0
        headerView.insertSubview(blurEffectView, belowSubview: headerLabel)
        
        if user == nil {
            user = User.currentUser!
        }
        TwitterClient.shared.timeline(type: timelineType, userId: user.id) { (tweets, error) in
            if let tweets = tweets {
                self.tweets = tweets
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nameLabel.text = user.name
        headerLabel.text = user.name
        usernameLabel.text = "@\(user.screenName ?? "")"
        
        if let tagline = user.tagline {
            taglineLabel.isHidden = false
            taglineLabel.text = tagline
        } else {
            taglineLabel.isHidden = true
        }
        
        if let location = user.location, !location.isEmpty {
            locationView.isHidden = false
            locationLabel.text = location
        } else {
            locationView.isHidden = true
        }
        locationConstraints.forEach { (constraint) in
            constraint.isActive = !self.locationView.isHidden
        }
        
        
        if let expandedUrl = user.expandedUrl, !expandedUrl.isEmpty {
            linkView.isHidden = false
            linkLabel.text = expandedUrl
        } else {
            linkView.isHidden = true
        }
        linkConstraints.forEach { (constraint) in
            constraint.isActive = !self.linkView.isHidden
        }
        
        bottomStackView.isHidden = locationView.isHidden && linkView.isHidden
        
        tweetCountLabel.text = user.tweetCount
        followingCountLabel.text = user.followingCount
        followersCountLabel.text = user.followersCount
        
        view.layoutIfNeeded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        profileImageView.layer.cornerRadius = profileImageView.bounds.size.width / 2.0
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.layer.borderWidth = 2.0
        Helper.loadImage(withUrl: user.profileUrl!, forView: profileImageView)
        
        headerImageView = UIImageView(frame: headerView.bounds)
        headerImageView.contentMode = .scaleAspectFill
        headerImageView.isHidden = false
        headerView.insertSubview(headerImageView, belowSubview: blurEffectView)
        headerView.clipsToBounds = true
        if let bannerUrl = user.bannerUrl {
            Helper.loadImage(withUrl: bannerUrl, forView: headerImageView, placeholder: #imageLiteral(resourceName: "default_bg"))
        } else {
            headerImageView.image = #imageLiteral(resourceName: "default_bg")
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let profileSize = profileView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        if profileSize.height != profileView.frame.size.height {
            profileView.frame.size.height = profileSize.height
            tableView.tableHeaderView = profileView
            tableView.layoutIfNeeded()
        }
    }
    
    func onBack() {
        navigationController?.popViewController(animated: true)
    }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        cell.style = .small
        cell.tweet = tweets[indexPath.row]
        return cell
    }
}

// MARK:- Scroll view delegate
extension ProfileViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let headerHeight = headerView.bounds.height
        let offset = scrollView.contentOffset.y + headerHeight
        let headerStop = CGFloat(50.0)
        
        var profileImageTransform = CATransform3DIdentity
        var headerTransform = CATransform3DIdentity
        
        if offset < 0 {
            let headerScaleFactor = -1 * offset / headerHeight
            let headerSizeVariation = (headerHeight * (1.0 + headerScaleFactor) - headerHeight) / 2.0
            headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizeVariation, 0)
            headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0)
            
            headerView.layer.zPosition = 0
            headerLabel.isHidden = true
        } else {
            headerTransform = CATransform3DTranslate(headerTransform, 0, max(-headerStop, -offset), 0)
            
            headerLabel.isHidden = false
            let alignToHeaderLabel = -offset + nameLabel.frame.origin.y + headerHeight + headerStop
            headerLabel.frame.origin = CGPoint(x: headerLabel.frame.origin.x, y: max(alignToHeaderLabel, headerStop + 40.0))
            
            blurEffectView.alpha = min(1.0, (offset - alignToHeaderLabel) / 40.0)
            
            let profileImageHeight = profileImageView.bounds.height
            let profileImageScale = min(headerStop, offset) / profileImageHeight / 1.4
            let profileSizeVariation = (profileImageHeight * (1.0 + profileImageScale) - profileImageHeight) / 2.0
            
            profileImageTransform = CATransform3DTranslate(profileImageTransform, 0, profileSizeVariation, 0)
            profileImageTransform = CATransform3DScale(profileImageTransform, 1.0 - profileImageScale, 1.0 - profileImageScale, 0)
            
            if offset <= headerStop {
                if profileImageView.layer.zPosition < headerView.layer.zPosition {
                    headerView.layer.zPosition = 0
                    backImage.layer.zPosition = headerView.layer.zPosition + 1.0
                }
            } else if profileImageView.layer.zPosition >= headerView.layer.zPosition {
                headerView.layer.zPosition = 2.0
                backImage.layer.zPosition = headerView.layer.zPosition + 1.0
            }
        }
        
        headerView.layer.transform = headerTransform
        profileImageView.layer.transform = profileImageTransform
    }
}
