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
    let tableStructure = ["TweetDetailCell", "TweetCountCell", "TweetActionCell"]
    
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
    
    func onBack() {
        dismiss(animated: true) {
            self.completionHandler?(self.replyTweet)
        }
    }
    
    private func setupTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupNavBar() {
        let backImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        backImageView.image = #imageLiteral(resourceName: "back")
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backImageView)
        backImageView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(onBack))
        )
    }
}

extension DetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableStructure.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = tableStructure[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellType, for: indexPath)
        
        switch cellType {
        case "TweetDetailCell":
            let detailCell = cell as! TweetDetailCell
            detailCell.updateCell(withTweet: tweet)
        case "TweetCountCell":
            let countCell = cell as! TweetCountCell
            countCell.setCell(withTweet: tweet)
        case "TweetActionCell":
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
