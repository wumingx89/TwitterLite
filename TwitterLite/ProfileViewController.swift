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
    @IBOutlet weak var profileImageView: UIImageView!
    
    var headerImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsetsMake(headerView.frame.height, 0, 0, 0)
        tableView.clipsToBounds = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TweetCell", bundle: nil), forCellReuseIdentifier: "TweetCell")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        profileImageView.layer.cornerRadius = profileImageView.bounds.size.width / 2.0
        profileImageView.clipsToBounds = true
        
        headerImageView = UIImageView(frame: headerView.bounds)
        headerImageView.image = #imageLiteral(resourceName: "default_bg")
        headerImageView.contentMode = .scaleAspectFill
        headerImageView.isHidden = false
        headerView.insertSubview(headerImageView, belowSubview: headerLabel)
        
        headerView.clipsToBounds = true
    }

//    override func viewDidLayoutSubviews() {
//        <#code#>
//    }
    

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
