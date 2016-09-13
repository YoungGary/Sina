//
//  NSDate+Extension.swift
//  处理weibo时间
//
//  Created by YOUNG on 16/9/12.
//  Copyright © 2016年 Young. All rights reserved.
//

import Foundation

extension NSDate{
    class func dealWithDateWithString(create : String) -> String{
        
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "EEE MM dd HH:mm:ss Z yyyy"
        dateFormat.locale = NSLocale(localeIdentifier: "en")
        
        guard let createDate = dateFormat.dateFromString(create) else{
            return ""
        }
        
        //print(createDate)
        let now = NSDate()
        
        let interval = Int(now.timeIntervalSinceDate(createDate))
        
        // print(interval)
        
        /*
         1分钟内:刚刚
         1小时内:15分钟前
         1天内:3小时前
         昨天: 昨天 03:24
         一年内: 02-23 03:24
         一年后: 2015-2-23 03:23*/
        //刚刚
        if interval < 60{
            
            return "刚刚"
        }
        //1小时内
        if interval < (60 * 60) {
            
            return "\(interval/60)分钟前"
        }
        //一天内
        if interval < (60 * 60 * 24) {
            
            return "\(interval/(60*60))小时前"
        }
        //昨天
        let canlenda = NSCalendar.currentCalendar()
        if canlenda.isDateInYesterday(createDate) {
            dateFormat.dateFormat = "昨天 HH:mm"
            let result = dateFormat.stringFromDate(createDate)
            
            return result
        }
        //一年内
        let com =  canlenda.components(.Year, fromDate: createDate, toDate: now, options: [])
        if com.year<1{
            dateFormat.dateFormat = "MM-dd HH:mm"
            let result = dateFormat.stringFromDate(createDate)
            
            return result
        }
        //一年外
        dateFormat.dateFormat = "yyyy-MM-dd HH:mm"
        let result = dateFormat.stringFromDate(createDate)
        
        return result
        
        
       
    }
}
