//
//  TweetsViewController.swift
//  TwitterLite
//
//  Created by Wuming Xie on 9/26/17.
//  Copyright © 2017 Wuming Xie. All rights reserved.
//

import UIKit
import MBProgressHUD

// MARK:- Main view controller
class TweetsViewController: UIViewController {

    @IBOutlet weak var tweetsTableView: UITableView!
    
    fileprivate var loadingMoreView: InfiniteScrollActivityView!
    fileprivate var isMoreDataLoading = false
    fileprivate let twitterClient = TwitterClient.shared
    fileprivate var tweets: [Tweet]!
    
    // MARK: - Lifecycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupRefreshControl()
        setupNavBar()
        setupInfiniteScroll()

        MBProgressHUD.showAdded(to: self.view, animated: true)
        fetchTimeline {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        print("Segue: \(segue.identifier ?? "No identifier")")
        switch segue.identifier ?? "" {
        case Constants.SegueIds.replyTweet:
            let navigationVC = segue.destination as! UINavigationController
            let destination = navigationVC.topViewController as! ComposeViewController
            destination.replyToTweet = sender as? Tweet
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
    
    fileprivate func fetchTimeline(animation: (() -> ())?) {
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
    
    fileprivate func loadMoreTweets() {
        twitterClient.homeTimeLine { (tweets, error) in
            if let tweets = tweets {
                self.tweets.append(contentsOf: tweets)
                self.tweetsTableView.reloadData()
                self.loadingMoreView.stopAnimating()
            } else {
                // TODO: Show network error
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
    
    private func setupInfiniteScroll() {
        loadingMoreView = InfiniteScrollActivityView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: tweetsTableView.bounds.size.width,
                height: InfiniteScrollActivityView.defaultHeight
            )
        )
        loadingMoreView.isHidden = true
        tweetsTableView.addSubview(loadingMoreView)
        
        var insets = tweetsTableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        tweetsTableView.contentInset = insets
    }
}

// MARK:- Table view data source/delegate extension
extension TweetsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets == nil ? 0 : tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tweetsTableView.dequeueReusableCell(withIdentifier: TweetCell.indentifier, for: indexPath) as! TweetCell
        
        cell.delegate = self
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
    fileprivate func setupRefreshControl() {
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

// MARK:- Scroll view delegata
extension TweetsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !isMoreDataLoading {
        let scrollViewContentHeight = tweetsTableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tweetsTableView.bounds.size.height
            
            if scrollView.contentOffset.y > scrollOffsetThreshold && tweetsTableView.isDragging {
                isMoreDataLoading = true
                
                loadingMoreView.frame = CGRect(
                    x: 0,
                    y: tweetsTableView.contentSize.height,
                    width: tweetsTableView.bounds.size.width,
                    height: InfiniteScrollActivityView.defaultHeight
                )
                loadingMoreView.isHidden = true
                loadingMoreView.startAnimating()
                loadMoreTweets()
            }
        }
    }
}

// MARK:- Tweet cell delegate
extension TweetsViewController: TweetCellDelegate {
    func tweetCell(_ tweetCell: TweetCell, didTapReply tweet: Tweet) {
        self.performSegue(withIdentifier: Constants.SegueIds.replyTweet, sender: tweet)
    }
}
