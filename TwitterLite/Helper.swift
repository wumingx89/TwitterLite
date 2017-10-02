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
                
                if response != nil {
                    // Fade in image if it's from network
                    view.alpha = 0.0
                    UIView.animate(withDuration: 0.5, animations: {
                        view.alpha = 1.0
                    })
                }
        }) { (request, response, error) in
            print(error.localizedDescription)
        }
    }
}
