//
//  ComposeViewController.swift
//  TwitterLite
//
//  Created by Wuming Xie on 9/29/17.
//  Copyright © 2017 Wuming Xie. All rights reserved.
//

import UIKit

// MARK:- ComposeViewController
class ComposeViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var placeHolderLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var tweetButton: UIButton!
    @IBOutlet weak var charCountLabel: UILabel!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var tweetCompletionHandler: ((Tweet?, Error?) -> ())!
    var replyToTweet: Tweet?
    
    // MARK: - View lifecycle functions
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        automaticallyAdjustsScrollViewInsets = false
        tweetTextView.delegate = self
        tweetTextView.text = ""
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(moveBottomView),
            name: Notification.Name.UIKeyboardWillShow,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(moveBottomView),
            name: Notification.Name.UIKeyboardWillHide,
            object: nil
        )
        
        bottomView.layer.borderColor = Constants.TwitterColor.darkGray.cgColor
        bottomView.layer.borderWidth = 0.3
        tweetButton.layer.cornerRadius = 17.0
        tweetButton.layer.masksToBounds = true
        
        if let replyToUser = replyToTweet?.user?.screenName {
            placeHolderLabel.isHidden = true
            let reply = "@\(replyToUser) "
            tweetTextView.text = reply
            updateCharactersLeft(140 - reply.characters.count)
            updateTweetButton(enabled: true)
        } else {
            updateCharactersLeft(140)
            updateTweetButton(enabled: false)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tweetTextView.becomeFirstResponder()
    }
    
    // Need to remove observers when this class is deinitialized
    deinit {
        print("===================ComposeVC deinitializing===================")
        NotificationCenter.default.removeObserver(
            self, name: Notification.Name.UIKeyboardWillHide, object: nil
        )
        NotificationCenter.default.removeObserver(
            self, name: Notification.Name.UIKeyboardWillHide, object: nil
        )
    }
    
    // MARK: - Action outlets
    @IBAction func onTweet(_ sender: UIButton) {
        TwitterClient.shared.tweet(
            tweetTextView.text,
            replyToId: nil,
            completion: tweetCompletionHandler
        )
        
        tweetTextView.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onCancel(_ sender: UIBarButtonItem) {
        if !tweetTextView.text.isEmpty {
            let alertController = UIAlertController(
                title: nil,
                message: "You have an unfinished tweet. Are you sure you want to leave?",
                preferredStyle: .actionSheet
            )
            
            alertController.addAction(UIAlertAction(title: "Discard draft", style: .destructive) { (action) in
                self.view.endEditing(true)
                self.dismiss(animated: true, completion: nil)
            })
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            present(alertController, animated: true, completion: nil)
        } else {
            view.endEditing(true)
            dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Keyboard/Typing functions
    func moveBottomView(_ notification: Notification) {
        if notification.name == Notification.Name.UIKeyboardWillShow {
            let value = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue
            bottomConstraint.constant = value.cgRectValue.size.height
        } else {
            bottomConstraint.constant = 0.0
        }
    }
    
    func updateCharactersLeft(_ count: Int) {
        charCountLabel.text = "\(count)"
        charCountLabel.textColor = count > Constants.tweetWarningLimit ? Constants.TwitterColor.darkGray : UIColor.red
    }
    
    func updateTweetButton(enabled: Bool) {
        tweetButton.isEnabled = enabled
        UIView.animate(withDuration: 0.25) { 
            self.tweetButton.alpha = enabled ? 1.0 : 0.3
        }
    }
}

// MARK:- Text view delegate methods
extension ComposeViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if !placeHolderLabel.isHidden && !textView.text.isEmpty {
            placeHolderLabel.isHidden = true
        } else if textView.text.isEmpty {
            placeHolderLabel.isHidden = false
        }
        
        let count = tweetTextView.text.characters.count
        updateCharactersLeft(140 - count)
        updateTweetButton(enabled: count > 0 && count <= 140)
    }
}
