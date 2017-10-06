//
//  File.swift
//  TwitterLite
//
//  Created by Wuming Xie on 10/5/17.
//  Copyright © 2017 Wuming Xie. All rights reserved.
//

import Foundation
import UIKit

protocol TableViewCompatible {
    var reuseIdentifier: String { get }
    func cellForTableView(_ tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell
}

protocol Configurable {
    associatedtype T
    var model: T! { get set }
    func configure(withModel model: T)
}
