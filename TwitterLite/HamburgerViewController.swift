//
//  MenuViewController.swift
//  TwitterLite
//
//  Created by wuming on 10/3/17.
//  Copyright © 2017 Wuming Xie. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController {
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentLeadConstraint: NSLayoutConstraint!
    
    var originalLeadMargin: CGFloat!
    var menuViewController: UIViewController! {
        didSet {
            view.layoutIfNeeded()
            menuView.addSubview(menuViewController.view)
        }
    }
    
    var contentViewController: UIViewController! {
        didSet(oldContentViewController) {
            let oldVC = oldContentViewController == nil ? nil : oldContentViewController
            reset(uiview: contentView, oldVC: oldVC, newVC: contentViewController)
            
            animateMenu(isOpening: false)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onPanGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        
        switch sender.state {
        case.began:
            originalLeadMargin = contentLeadConstraint.constant
        case .changed:
            contentLeadConstraint.constant = originalLeadMargin + translation.x
        case .ended:
            animateMenu(isOpening: velocity.x > 0)
        default:
            break
        }
    }
    
    private func animateMenu(isOpening: Bool) {
        UIView.animate(
            withDuration: 0.5,
            delay: 0.0,
            usingSpringWithDamping: isOpening ? 1.0 : 0.4,
            initialSpringVelocity: 0.0,
            animations: {
                self.contentLeadConstraint.constant = isOpening ? self.view.frame.size.width * 0.8 : 0.0
                self.view.layoutIfNeeded()
        }) { (finished) in }
    }
    
    private func reset(uiview: UIView, oldVC: UIViewController?, newVC: UIViewController) {
        view.layoutIfNeeded()
        
        if let oldVC = oldVC {
            oldVC.willMove(toParentViewController: nil)
            oldVC.view.removeFromSuperview()
            oldVC.didMove(toParentViewController: nil)
        }
        
        newVC.willMove(toParentViewController: self)
        uiview.addSubview(newVC.view)
        newVC.didMove(toParentViewController: self)
    }
}
