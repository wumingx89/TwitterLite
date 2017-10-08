//
//  ProfileViewController.swift
//  TwitterLite
//
//  Created by Wuming Xie on 10/6/17.
//  Copyright © 2017 Wuming Xie. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var taglineView: UIView!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var linkView: UIView!
    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var bottomStackView: UIStackView!
    @IBOutlet weak var tweetCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    
    var headerImageView: UIImageView!
    var user: User!
    
    
    // MARK:- View lifecycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsetsMake(headerView.frame.height, 0, 0, 0)
        tableView.clipsToBounds = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TweetCell", bundle: nil), forCellReuseIdentifier: "TweetCell")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nameLabel.text = user.name
        usernameLabel.text = "@\(user.screenName ?? "")"
        
        if let tagline = user.tagline {
            taglineView.isHidden = false
            taglineLabel.text = tagline
        } else {
            taglineView.isHidden = true
        }
        
        if let location = user.location {
            locationView.isHidden = false
            locationLabel.text = location
        } else {
            locationView.isHidden = true
        }
        
        if let expandedUrl = user.expandedUrl {
            linkView.isHidden = false
            linkLabel.text = expandedUrl
        } else {
            linkView.isHidden = true
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
        headerView.insertSubview(headerImageView, belowSubview: headerLabel)
        headerView.clipsToBounds = true
        if let bannerUrl = user.bannerUrl {
            Helper.loadImage(withUrl: bannerUrl, forView: headerImageView)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        cell.style = .small
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("hi")
    }
}

// MARK:- Scroll view delegate
extension ProfileViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let headerHeight = headerView.bounds.height
        let offset = scrollView.contentOffset.y + headerHeight
        
        var profileImageTransform = CATransform3DIdentity
        var headerTransform = CATransform3DIdentity
        
        if offset < 0 {
            // Pulling down
            print("Pulling down")
            headerLabel.isHidden = true
        } else {
            headerTransform = CATransform3DTranslate(headerTransform, 0, max(-50, -offset), 0)
            
            headerLabel.isHidden = true
            headerView.layer.transform = headerTransform
        }
    }
}
