//
//  UserAccountViewModel.swift
//  Sina
//
//  Created by YOUNG on 16/9/10.
//  Copyright © 2016年 Young. All rights reserved.
//

import UIKit

class UserAccountViewModel {
    
    static let sharedInstance : UserAccountViewModel = UserAccountViewModel()
    var account : UserAccount?
    
    var islogin :Bool {
        if account == nil {
            return false
        }
        guard let expire_date = account?.expires_date else{
            return false
        }
        return  expire_date.compare(NSDate()) == NSComparisonResult.OrderedDescending
    }
    //获取路径
    var documentPath : String{
        let document = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
        let path = (document as NSString).stringByAppendingPathComponent("account.plist")
        return path
    }
    
    // MARK:- 重写init()函数
    init () {
        // 1.从沙盒中读取中归档的信息
        account = NSKeyedUnarchiver.unarchiveObjectWithFile(documentPath) as? UserAccount
    }
}
