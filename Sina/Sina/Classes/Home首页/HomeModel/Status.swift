//
//  Status.swift
//  Sina
//
//  Created by YOUNG on 16/9/11.
//  Copyright © 2016年 Young. All rights reserved.
//

import UIKit

class Status: NSObject {
    //json中的键---
    var create_at : String?//创建时间
    var source : String?//来源
    var created_at : String?
    var text :String?//微博正文
    var mid : Int = 0//微博ID
    var user :User?
    var pic_urls : [[String : String]]?
    var retweeted_status : Status?//转发  
  //----------------------------------
   
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    init(dict: [String : AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
        if let userDict = dict["user"] as? [String : AnyObject] {
           user = User(dict: userDict)
        }
        if let retweeted = dict["retweeted_status"] as? [String : AnyObject] {
            retweeted_status = Status(dict: retweeted)
        }
    }
    
}













