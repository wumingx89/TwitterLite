//
//  HashTag.swift
//  TwitterLite
//
//  Created by wuming on 9/28/17.
//  Copyright © 2017 Wuming Xie. All rights reserved.
//

import SwiftyJSON

class HashTag: NSObject {

    let start: Int?
    let end: Int?
    let text: String?
    
    init(json: JSON) {
        if let indexArray = json["indices"].array {
            start = indexArray[0].int
            end = indexArray[1].int
        }
        text = json["text"].string
    }
    
    class func hashTags(from jsonArray: [JSON]) {
        var hashTags = [HashTag]()
        for json in jsonArray {
            hashTags.append(HashTag(json: json))
        }
        return hashTags
    }
}
