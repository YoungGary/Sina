//
//  User.swift
//  Sina
//
//  Created by YOUNG on 16/9/12.
//  Copyright © 2016年 Young. All rights reserved.
//

import UIKit

class User: NSObject {
    var profile_image_url : String?
    var screen_name : String?
    var verified_type : Int = -1           // 用户的认证类型
    var mbrank : Int = 0                 // 用户的会员等级
 
    init(dict : [String : AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}
