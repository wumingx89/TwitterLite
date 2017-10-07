//
//  SettingModel.swift
//  TwitterLite
//
//  Created by Wuming Xie on 10/5/17.
//  Copyright © 2017 Wuming Xie. All rights reserved.
//

import UIKit

enum MenuItemType {
    case viewController
}

class MenuItem: TableViewCompatible {
    var reuseIdentifier = "MenuCell"
    var title: String!
    var image: UIImage!
    var viewController: UIViewController?
    var timelineType: TimelineType?
    
    init(image: UIImage, title: String, viewController: UIViewController? = nil, timelineType: TimelineType? = nil) {
        self.title = title
        self.image = image
        self.viewController = viewController
        self.timelineType = timelineType
    }
    
    func cellForTableView(_ tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MenuCell
        
        cell.configure(withModel: self)
        
        return cell
    }
}
