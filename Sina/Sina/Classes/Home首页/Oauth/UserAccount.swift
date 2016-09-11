//
//  UserAccount.swift
//  Sina
//
//  Created by YOUNG on 16/9/9.
//  Copyright © 2016年 Young. All rights reserved.
//

import UIKit

class UserAccount: NSObject ,NSCoding{
    /*
     Optional({
     "access_token" = "2.00GZJwAC02ssSI4a6a49308d0mhq4O";
     "expires_in" = 157679999;
     "remind_in" = 157679999;
     uid = 1846125460;
     })
     */
   
    //--token信息------------------------
    var access_token : String?
    var expires_in : NSTimeInterval =  0.0{//过期时间
        didSet{
          expires_date = NSDate(timeIntervalSinceNow: expires_in)
        }
    }
    var uid : String?
    
    var expires_date : NSDate?//把interval 编程nsdate类型
    //----------------增加的存储属性
    var screen_name : String?  // 昵称
    
    var avatar_large : String?//头像地址
    
    //--------------------end
    
    init(dict :[String : AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    override var description: String{
        return dictionaryWithValuesForKeys(["access_token","expires_date","uid","screen_name","avatar_large"]).description
    }
    
    //归档方法
     func encodeWithCoder(aCoder: NSCoder){
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeObject(uid, forKey: "uid")
        aCoder.encodeObject(expires_date, forKey: "expires_date")
        aCoder.encodeObject(screen_name, forKey: "screen_name")
        aCoder.encodeObject(avatar_large, forKey: "avatar_large")
    }
    //接档
     required init?(coder aDecoder: NSCoder){
        access_token = aDecoder.decodeObjectForKey("access_token") as? String
        uid = aDecoder.decodeObjectForKey("uid") as? String
        expires_date =  aDecoder.decodeObjectForKey("expires_date") as? NSDate
        screen_name =  aDecoder.decodeObjectForKey("screen_name")as? String
        avatar_large = aDecoder.decodeObjectForKey("avatar_large")as? String
    }
    
    
    
    
    
    
    
}
