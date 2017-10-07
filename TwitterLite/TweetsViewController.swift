//
//  TweetsViewController.swift
//  TwitterLite
//
//  Created by Wuming Xie on 9/26/17.
//  Copyright © 2017 Wuming Xie. All rights reserved.
//

import UIKit
import MBProgressHUD

enum TimelineType {
    case home, mentions
}

// MARK:- Main view controller
class TweetsViewController: UIViewController {

    @IBOutlet weak var tweetsTableView: UITableView!
    
    var timelineType = TimelineType.home
    
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
        
        print("View did load for tweets timeline of type \(timelineType == .home ? "home" : "mentions")")
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
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
        case Constants.SegueIds.openTweet:
            let navigationVC = segue.destination as! UINavigationController
            let destination = navigationVC.topViewController as! DetailsViewController
            let cell = sender as! TweetCell
            destination.tweet = cell.tweet
            destination.completionHandler = { (replyTweet) in
                var reloadablePaths = [self.tweetsTableView.indexPathForRow(at: cell.center)!]
                if let replyTweet = replyTweet {
                    self.tweets.insert(replyTweet, at: 0)
                    reloadablePaths.insert(IndexPath(row: 0, section: 0), at: 0)
                }
                self.tweetsTableView.reloadRows(at: reloadablePaths, with: .none)
            }
            destination.retweetHandler = retweetHandler
            destination.favoriteHandler = favoriteHandler
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
    
    
    // MARK:- Helper functions
    fileprivate func fetchTimeline(animation: (() -> ())?) {
        //TODO: Show network error on network error
        twitterClient.timeline(type: timelineType) { (tweets, error) in
            self.tweets = tweets ?? []
            animation?()
            self.tweetsTableView.reloadData()
            
            if error != nil {
                print(error!.localizedDescription)
            }
        }
    }
    
    fileprivate func loadMoreTweets() {
        twitterClient.timeline(type: timelineType, maxId: tweets[tweets.count - 1].id) { (tweets, error) in
            self.isMoreDataLoading = false
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
        let cell = tweetsTableView.dequeueReusableCell(withIdentifier: Constants.CellTypes.tweetCell, for: indexPath) as! TweetCell

        cell.tweet = tweets[indexPath.row]
        cell.replyHandler = replyHandler
        cell.retweetHandler = retweetHandler
        cell.favoriteHandler = favoriteHandler
        
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

// MARK:- Tweet engagement handlers
extension TweetsViewController {
    func replyHandler(_ tweet: Tweet) {
        performSegue(withIdentifier: Constants.SegueIds.replyTweet, sender: tweet)
    }
    
    func retweetHandler(_ tweet: Tweet, _ completion: @escaping () -> ()) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if !tweet.retweeted {
            alertController.addAction(
                UIAlertAction(title: "Retweet", style: .default) { (action) in
                    self.twitterClient.retweet(tweet.id!) { (error) in
                        if error == nil {
                            tweet.changeRTStatus()
                            completion()
                        }
                    }
            })
        } else {
            alertController.addAction(
                UIAlertAction(title: "Undo Retweet", style: .destructive) { (action) in
                    self.twitterClient.unretweet(tweet.id) { (error) in
                        if error == nil {
                            tweet.changeRTStatus()
                            completion()
                        }
                    }
            })
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if var topVC = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedVC = topVC.presentedViewController {
                topVC = presentedVC
            }
            topVC.present(alertController, animated: true, completion: nil)
        }
    }
    
    func favoriteHandler(_ tweet: Tweet, _ completion: @escaping () -> ()) {
        if !tweet.favorited {
            self.twitterClient.favorite(tweet.id) { (error) in
                if error == nil {
                    tweet.changeFavoriteStatus()
                    completion()
                }
            }
        } else {
            self.twitterClient.unfavorite(tweet.id) { (error) in
                if error == nil {
                    tweet.changeFavoriteStatus()
                    completion()
                }
            }
        }
    }
}
