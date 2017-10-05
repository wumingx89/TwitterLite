//
//  MenuViewController.swift
//  TwitterLite
//
//  Created by wuming on 10/3/17.
//  Copyright © 2017 Wuming Xie. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var hamburgerVC: HamburgerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 40
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorColor = UIColor.white
        tableView.tableFooterView = UIView()
        
        hamburgerVC.contentViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TweetsNavigationController")
    }
}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath)
        
        return cell
    }
}
