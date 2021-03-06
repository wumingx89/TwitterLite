//
//  MenuViewController.swift
//  TwitterLite
//
//  Created by wuming on 10/3/17.
//  Copyright © 2017 Wuming Xie. All rights reserved.
//

import Foundation
import UIKit

protocol HamburgerViewControllerDelegate: class {
    func hamburgerViewController(_ hamburgerVC: HamburgerViewController, didPan sender: UIPanGestureRecognizer)
    func hamburgerViewController(_ hamburgerVC: HamburgerViewController, didAnimateMenu isOpening: Bool)
}

class HamburgerViewController: UIViewController {
    
    @IBOutlet weak var grayView: UIView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentLeadConstraint: NSLayoutConstraint!
    @IBOutlet weak var grayLeadingConstraint: NSLayoutConstraint!
    
    var lastTranslation: CGFloat!
    var originalLeadMargin: CGFloat!
    var menuViewController: UIViewController! {
        didSet {
            view.layoutIfNeeded()
            menuView.addSubview(menuViewController.view)
        }
    }
    
    var contentViewController: UIViewController! {
        didSet(oldContentViewController) {
            animateMenu(isOpening: false)
            reset(uiview: contentView, oldVC: oldContentViewController, newVC: contentViewController)
            
            if let navigationVC = contentViewController as? UINavigationController {
                if let topVC = navigationVC.topViewController as? HamburgerViewControllerDelegate {
                    delegate = topVC
                }
            }
        }
    }
    
    weak var delegate: HamburgerViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        grayView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(onGrayViewTap))
        )
        grayView.addGestureRecognizer(
            UIPanGestureRecognizer(target: self, action: #selector(onPanGesture))
        )
        grayView.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(openMenu), name: Constants.EventId.openMenu, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Constants.EventId.openMenu, object: nil)
    }
    
    @IBAction func onPanGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        
        switch sender.state {
        case.began:
            lastTranslation = translation.x
            originalLeadMargin = contentLeadConstraint.constant
            grayView.isHidden = false
        case .changed:
            contentLeadConstraint.constant = originalLeadMargin + translation.x
            grayLeadingConstraint.constant = originalLeadMargin + translation.x
            
            let delta = translation.x - lastTranslation
            grayView.alpha += 0.4 * delta / view.bounds.size.width
            grayView.alpha = min(0.4, max(0.0, grayView.alpha))
            lastTranslation = translation.x
        case .ended:
            animateMenu(isOpening: velocity.x > 0)
        default:
            break
        }
        
        delegate?.hamburgerViewController(self, didPan: sender)
    }
    
    func onGrayViewTap(_ sender: UITapGestureRecognizer) {
        animateMenu(isOpening: false)
    }
    
    func openMenu() {
        animateMenu(isOpening: true)
    }
    
    private func animateMenu(isOpening: Bool) {
        UIView.animate(
            withDuration: 0.5,
            delay: 0.0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 0.0,
            animations: {
                self.grayView.isHidden = !isOpening
                self.grayView.alpha = isOpening ? 0.4 : 0.0
                self.contentLeadConstraint.constant = isOpening ? self.view.frame.size.width * 0.7 : 0.0
                self.grayLeadingConstraint.constant = isOpening ? self.view.frame.size.width * 0.7 : 0.0
                self.delegate?.hamburgerViewController(self, didAnimateMenu: isOpening)
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
