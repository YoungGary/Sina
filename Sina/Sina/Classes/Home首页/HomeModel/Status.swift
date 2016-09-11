//
//  Status.swift
//  Sina
//
//  Created by YOUNG on 16/9/11.
//  Copyright © 2016年 Young. All rights reserved.
//

import UIKit

class Status: NSObject {
    var create_at : String?//创建时间
    var source : String?//来源
    var text :String?//微博正文
    var mid : Int = 0//微博ID
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    init(dict: [String : AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
}
