//
//  FindEmoticon.swift
//  10-表情的显示
//
//  Created by xiaomage on 16/4/13.
//  Copyright © 2016年 小码哥. All rights reserved.
//

import UIKit

class FindEmoticon: NSObject {
    // MARK:- 设计单例对象
    static let shareIntance : FindEmoticon = FindEmoticon()
    
    // MARK:- 表情属性
    private lazy var manager : EmoticonManager = EmoticonManager()
    
    // 查找属性字符串的方法
    func findAttrString(statusText : String?, font : UIFont) -> NSMutableAttributedString? {
        // 1.创建匹配规则
        guard let statusText = statusText else{
            return nil
        }
        
        let pattern = "\\[.*?\\]" // 匹配表情
        
        // 2.创建正则表达式对象
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            return nil
        }
        
        // 3.开始匹配
        let results = regex.matchesInString(statusText, options: [], range: NSRange(location: 0, length: statusText.characters.count))
        
        // 4.获取结果
        let attrMStr = NSMutableAttributedString(string: statusText)
        for var i = results.count - 1; i >= 0; i-=1 {
            // 4.0.获取结果
            let result = results[i]
            
            // 4.1.获取chs
            let chs = (statusText as NSString).substringWithRange(result.range)
            
            // 4.2.根据chs,获取图片的路径
            guard let pngPath = findPngPath(chs) else {
                return nil
            }
            
            // 4.3.创建属性字符串
            let attachment = NSTextAttachment()
            attachment.image = UIImage(contentsOfFile: pngPath)
            attachment.bounds = CGRect(x: 0, y: -4, width: font.lineHeight, height: font.lineHeight)
            let attrImageStr = NSAttributedString(attachment: attachment)
            
            // 4.4.将属性字符串替换到来源的文字位置
            attrMStr.replaceCharactersInRange(result.range, withAttributedString: attrImageStr)
        }
        
            //-------表情匹配成功,接下来匹配@人名--------------------------------------------------
        let patternAt = "@.*?:" // 匹配@
        
        guard let regex2 = try? NSRegularExpression(pattern: patternAt, options: []) else {
            return nil
        }
        
        let atResults = regex2.matchesInString(statusText, options: [], range: NSRange(location: 0, length: statusText.characters.count))
        
        for var j = atResults.count - 1; j >= 0; j-=1 {
            
            let result2 = atResults[j]
            
            let atStr = (statusText as NSString).substringWithRange(result2.range)
            
            let atAttrString = NSAttributedString(string: atStr, attributes: [NSForegroundColorAttributeName : UIColor.blueColor()])
            
            attrMStr.replaceCharactersInRange(result2.range, withAttributedString: atAttrString)
        }
        
     //-------@匹配成功,接下来匹配#话题#--------------------------------------------------
        let patternTopic = "#.*?#" // 匹配##
        
        guard let regex3 = try? NSRegularExpression(pattern: patternTopic, options: []) else {
            return nil
        }
        
        let topicResults = regex3.matchesInString(statusText, options: [], range: NSRange(location: 0, length: statusText.characters.count))
        
        for var k = topicResults.count - 1; k >= 0; k -= 1 {
            
            let result3 = topicResults[k]
            
            let topicStr = (statusText as NSString).substringWithRange(result3.range)
            
            let topicAttrString = NSAttributedString(string: topicStr, attributes: [NSForegroundColorAttributeName : UIColor.blueColor()])
            
            attrMStr.replaceCharactersInRange(result3.range, withAttributedString: topicAttrString)
        }
        //-------#话题#匹配成功,接下来匹配url--------------------------------------------------
//        let patternUrl = "http(s)?://([\\w-]+\\.)+[\\w-]+(/[\\w- ./?%&=]*)?" // 匹配url
//        
//        guard let regex4 = try? NSRegularExpression(pattern: patternUrl, options: []) else {
//            return nil
//        }
//        
//        let urlResults = regex4.matchesInString(statusText, options: [], range: NSRange(location: 0, length: statusText.characters.count))
//        
//        for var l = urlResults.count - 1; l >= 0; l -= 1 {
//            
//            let result2 = urlResults[l]
//            
//            let urlStr = (statusText as NSString).substringWithRange(result2.range)
//            
//            let urlAttrString = NSAttributedString(string: urlStr, attributes: [NSForegroundColorAttributeName : UIColor.blueColor()])
//            
//            attrMStr.replaceCharactersInRange(result2.range, withAttributedString: urlAttrString)
//        }
        // 返回结果
        return attrMStr
    }
    
    private func findPngPath(chs : String) -> String? {
        for package in manager.packages {
            for emoticon in package.emotions {
                if emoticon.chs == chs {
                    return emoticon.pngPath
                }
            }
        }
        
        return nil
    }
}
