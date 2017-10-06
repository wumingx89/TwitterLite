//
//  MenuViewController.swift
//  TwitterLite
//
//  Created by wuming on 10/3/17.
//  Copyright © 2017 Wuming Xie. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var menuItems: [TableViewCompatible] = { () -> [TableViewCompatible] in
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let menuItems = [
            MenuItem(image: #imageLiteral(resourceName: "home"), title: "Home", viewController: storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController")),
            MenuItem(image: #imageLiteral(resourceName: "mention"), title: "Mentions", viewController: storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController")),
            MenuItem(image: #imageLiteral(resourceName: "profile"), title: "Profile", viewController: storyboard.instantiateViewController(withIdentifier: "ProfileViewController"))
        ]
        return menuItems
    }()
    
    var hamburgerVC: HamburgerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupProfile()
        
        hamburgerVC.contentViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TweetsNavigationController")
        
        NotificationCenter.default.addObserver(self, selector: #selector(setupProfile), name: NSNotification.Name(rawValue: "UserChanged"), object: nil)
    }
    
    private func setupTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 40
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorColor = UIColor.white
        tableView.tableFooterView = UIView()
    }
    
    @objc private func setupProfile() {
        profileImageView.layer.cornerRadius = profileImageView.bounds.size.width / 2.0
        profileImageView.clipsToBounds = true
        
        if let currentUser = User.currentUser {
            Helper.loadImage(withUrl: currentUser.profileUrl!, forView: profileImageView)
            nameLabel.text = currentUser.name
            handleLabel.text = "@\(currentUser.screenName ?? "")"
            followingCountLabel.text = currentUser.followingCount
            followersCountLabel.text = currentUser.followersCount
            followersLabel.text = currentUser.followersCount == "1" ? "Follower" : "Followers"
        }
    }
}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return menuItems[indexPath.row].cellForTableView(tableView, for: indexPath)
    }
}
