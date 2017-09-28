//
//  Helper.swift
//  TwitterLite
//
//  Created by wuming on 9/28/17.
//  Copyright © 2017 Wuming Xie. All rights reserved.
//

import AFNetworking

class Helper {
    class func loadImage(withUrl url: URL, forView view: UIImageView) {
        view.setImageWith(
            URLRequest(url: url),
            placeholderImage: nil,
            success: { (request, response, image) in
                view.image = image
                view.alpha = 0.0
                // Fade in image
                UIView.animate(withDuration: 0.5, animations: { 
                    view.alpha = 1.0
                })
        }) { (request, response, error) in
            print(error.localizedDescription)
        }
    }
}
