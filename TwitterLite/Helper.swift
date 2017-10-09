//
//  Helper.swift
//  TwitterLite
//
//  Created by wuming on 9/28/17.
//  Copyright © 2017 Wuming Xie. All rights reserved.
//

import AFNetworking

class Helper {
    class func loadImage(withUrl url: URL, forView view: UIImageView, placeholder: UIImage? = nil) {
        view.setImageWith(
            URLRequest(url: url),
            placeholderImage: placeholder,
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
    
    class func formatCount(_ count: Int?) -> String {
        guard let count = count else {
            return "0"
        }
        
        let number = Double(count)
        let millions = number / 1000000.0
        if millions > 1.0 {
            return "\(round(millions * 10) / 10)M"
        }
        
        let thousands = number / 1000.0
        if thousands > 1.0 {
            return "\(round(thousands * 10) / 10)K"
        }
        
        return "\(count)"
    }
}
