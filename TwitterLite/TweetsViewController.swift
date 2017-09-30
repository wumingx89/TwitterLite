//
//  TweetsViewController.swift
//  TwitterLite
//
//  Created by Wuming Xie on 9/26/17.
//  Copyright © 2017 Wuming Xie. All rights reserved.
//

import UIKit

// MARK:- Main view controller
class TweetsViewController: UIViewController {

    @IBOutlet weak var tweetsTableView: UITableView!
    
    fileprivate let twitterClient = TwitterClient.shared
    fileprivate var tweets: [Tweet]!
    
    // MARK: - Lifecycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        addRefreshControl()
        setupNavBar()

        fetchTimeline(animation: nil)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        print("Segue: \(segue.identifier ?? "No identifier")")
        switch segue.identifier ?? "" {
        case Constants.SegueIds.replyTweet:
            fallthrough
        case Constants.SegueIds.compose:
            let navigationVC = segue.destination as! UINavigationController
            let destination = navigationVC.topViewController as! ComposeViewController
            destination.tweetCompletionHandler = { (tweet, error) in
                if let tweet = tweet {
                    self.tweets.insert(tweet, at: 0)
                    self.tweetsTableView.reloadData()
                } else {
                    // TODO: Show error
                    print(error.debugDescription)
                }
            }
        default:
            break
        }
    }
    
    func onLogout() {
        TwitterClient.shared.logout()
    }
    
    func onCompose() {
        performSegue(withIdentifier: "composeTweetSegue", sender: self)
    }
    
    func fetchTimeline(animation: (() -> ())?) {
        //TODO: Show network error on network error
        twitterClient.homeTimeLine { (tweets, error) in
            self.tweets = tweets ?? []
            animation?()
            self.tweetsTableView.reloadData()
            
            if error != nil {
                print(error!.localizedDescription)
            }
        }
    }
    
    fileprivate func setupNavBar() {
        let logoutImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        logoutImageView.image = #imageLiteral(resourceName: "logout")
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: logoutImageView)
        logoutImageView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(onLogout))
        )
        
        // Set up compose bar item
        let composeImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        composeImageView.image = #imageLiteral(resourceName: "compose")
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: composeImageView)
        composeImageView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(onCompose))
        )
    }
}

// MARK:- Table view data source/delegate extension
extension TweetsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets == nil ? 0 : tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tweetsTableView.dequeueReusableCell(withIdentifier: TweetCell.indentifier, for: indexPath) as! TweetCell
        
        cell.tweet = tweets[indexPath.row]
        
        return cell
    }
    
    fileprivate func setupTableView() {
        tweetsTableView.rowHeight = UITableViewAutomaticDimension
        tweetsTableView.estimatedRowHeight = 200
        tweetsTableView.delegate = self
        tweetsTableView.dataSource = self
    }
}

// MARK:- Pull to refresh
extension TweetsViewController {
    fileprivate func addRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tweetsTableView.insertSubview(refreshControl, at: 0)
    }
    
    func refresh(_ refreshControl: UIRefreshControl) {
        refreshControl.beginRefreshing()
        
        fetchTimeline { 
            refreshControl.endRefreshing()
        }
    }
}

