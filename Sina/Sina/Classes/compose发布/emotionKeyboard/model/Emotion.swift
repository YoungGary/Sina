//
//  Emotion.swift
//  Sina
//
//  Created by YOUNG on 16/9/21.
//  Copyright © 2016年 Young. All rights reserved.
//

import UIKit

class Emotion: NSObject {
    // emoji的code
    var code : String? {     // emoji的code
        didSet {
            guard let code = code else {
                return
            }
            
            // 1.创建扫描器
            let scanner = NSScanner(string: code)
            
            // 2.调用方法,扫描出code中的值
            var value : UInt32 = 0
            scanner.scanHexInt(&value)
            
            // 3.将value转成字符
            let c = Character(UnicodeScalar(value))
            
            // 4.将字符转成字符串
            emojiCode = String(c)
        }
    }
    
    // 普通表情对应的图片名称
    var png : String?{
        didSet{
            guard let png = png else{
                return
            }
             pngPath = NSBundle.mainBundle().bundlePath + "/Emoticons.bundle/" + png
        }
    }
     // 普通表情对应的文字
    var chs : String?
    
    //处理pngPath
    var pngPath  : String?
    //emoji code
     var emojiCode : String?
    //shanchu 
     var isRemove : Bool = false
    //empty
    var isEmpty : Bool = false
    
    init(dict : [String : String]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    init (isRemove : Bool) {
        self.isRemove = isRemove
    }
    init (isEmpty : Bool) {
        self.isEmpty = isEmpty
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}





