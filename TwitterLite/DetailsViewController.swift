//
//  DetailsViewController.swift
//  TwitterLite
//
//  Created by wuming on 9/27/17.
//  Copyright © 2017 Wuming Xie. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var tweet: Tweet!
    var replyTweet: Tweet?
    var completionHandler: ((Tweet?) -> ())?
    var retweetHandler: ((Tweet, @escaping () -> ()) -> ())?
    var favoriteHandler: ((Tweet, @escaping () -> ()) -> ())?
    let tableStructure = [
        Constants.CellTypes.tweetDetailCell,
        Constants.CellTypes.tweetCountCell,
        Constants.CellTypes.tweetActionCell
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupNavBar()
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationVC = segue.destination as! UINavigationController
        let destination = navigationVC.topViewController as! ComposeViewController
        destination.replyToTweet = tweet
        destination.tweetCompletionHandler = { (tweet, error) in
            if let tweet = tweet {
                self.replyTweet = tweet
            } else {
                // TODO: Show error
                print(error.debugDescription)
            }
        }
    }
    
    private func setupTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupNavBar() {
        navigationItem.backBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back"), style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.tintColor = Constants.TwitterColor.black
    }
}

extension DetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableStructure.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableStructure[indexPath.row], for: indexPath)
        
        switch indexPath.row {
        case 0:
            let detailCell = cell as! TweetDetailCell
            detailCell.updateCell(withTweet: tweet)
        case 1:
            let countCell = cell as! TweetCountCell
            countCell.setCell(withTweet: tweet)
        case 2:
            let actionCell = cell as! TweetActionCell
            actionCell.tweet = tweet
            actionCell.delegate = self
        default:
            break
        }
        
        return cell
    }
}

extension DetailsViewController: TweetActionCellDelegate {
    func tweetActionCell(_ tweetActionCell: TweetActionCell, didTapReply completion: (() -> ())?) {
        performSegue(withIdentifier: Constants.SegueIds.tweetDetailReply, sender: self)
    }
    
    func tweetActionCell(_ tweetActionCell: TweetActionCell, didTapRetweet completion: (() -> ())?) {
        retweetHandler?(tweet) {
            completion?()
            let indexPath = self.tableView.indexPath(for: tweetActionCell)!
            self.tableView.reloadRows(at: [IndexPath(row: indexPath.row - 1, section: indexPath.section)], with: .none)
        }
    }
    
    func tweetActionCell(_ tweetActionCell: TweetActionCell, didTapFavorite completion: (() -> ())?) {
        favoriteHandler?(tweet) {
            completion?()
            let indexPath = self.tableView.indexPath(for: tweetActionCell)!
            self.tableView.reloadRows(at: [IndexPath(row: indexPath.row - 1, section: indexPath.section)], with: .none)
        }
    }
}
