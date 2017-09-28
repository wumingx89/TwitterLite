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
    
    // MARK: Lifecycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        addRefreshControl()

        fetchTimeline(animation: nil)
    }
    
    // MARK: Action outlets
    @IBAction func onLogout(_ sender: Any) {
        TwitterClient.shared.logout()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
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

