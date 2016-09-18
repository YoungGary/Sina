//
//  StatusViewModel.swift
//  Sina
//
//  Created by YOUNG on 16/9/12.
//  Copyright © 2016年 Young. All rights reserved.
//

import UIKit

class StatusViewModel: NSObject {
    var status : Status?
    //weibo 处理后来源
    var sourceText : String?
    //weibo  处理后的时间
    var createText : String?
    //处理认证
    var verifiedImage : UIImage?
    //处理会员等级
    var vipImage : UIImage?
    //处理weibo配图的url
    var picUrls : [NSURL] = [NSURL]()
    
    init(status :Status){
        self.status = status
        //处理来源
        guard let source = status.source where source != "" else{
            return
        }
        let startIndex = (source as NSString).rangeOfString(">").location + 1
        let length = (source as NSString).rangeOfString("</").location - startIndex
        
        sourceText = (source as NSString).substringWithRange(NSRange(location: startIndex, length: length))
        //处理时间
        guard let created_at = status.created_at else{
            return
        }
        createText = NSDate.dealWithDateWithString(created_at)
        // 处理用户的认证类型
        switch status.user?.verified_type ?? -1 {
        case 0:
            verifiedImage = UIImage(named: "avatar_vip")
        case 2, 3, 5:
            verifiedImage = UIImage(named: "avatar_enterprise_vip")
        case 220:
            verifiedImage = UIImage(named: "avatar_grassroot")
        default:
            verifiedImage = nil
        }
         // 处理用户的会员等级
        let mbrank = status.user?.mbrank ?? 0
        
        if mbrank > 0 && mbrank <= 6 {
            vipImage = UIImage(named: "common_icon_membership_level\(mbrank)")
        }
        //处理weibo配图
        let pic_dict = status.pic_urls!.count != 0 ? status.pic_urls : status.retweeted_status?.pic_urls
        if let pic_urlDicts = pic_dict{
            for picDict in pic_urlDicts {
                guard let urlString = picDict["thumbnail_pic"] else{
                    continue
                }
                picUrls.append(NSURL(string: urlString)!)
                
            }
        }
        
    }
    
}












