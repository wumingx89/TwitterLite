//
//  MenuCell.swift
//  TwitterLite
//
//  Created by wuming on 10/3/17.
//  Copyright © 2017 Wuming Xie. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell, Configurable {

    @IBOutlet weak var settingImage: UIImageView!
    @IBOutlet weak var settingNameLabel: UILabel!
    
    var viewController: UIViewController?
    var model: MenuItem! {
        didSet {
            settingImage.image = model.image.withRenderingMode(.alwaysTemplate)
            settingImage.tintColor = Constants.TwitterColor.darkGray
            settingNameLabel.text = model.title
            viewController = model.viewController
            
            if let timelineType = model.timelineType {
                if let navigationVC = viewController as? UINavigationController {
                    if let tweetsVC = navigationVC.topViewController as? TweetsViewController {
                        tweetsVC.timelineType = timelineType
                    }
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    func configure(withModel model: MenuItem) {
        self.model = model
    }
}
