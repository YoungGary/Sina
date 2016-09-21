//
//  EmoticonPackage.swift
//  Sina
//
//  Created by YOUNG on 16/9/21.
//  Copyright © 2016年 Young. All rights reserved.
//

import UIKit

class EmoticonPackage: NSObject {
    var emotions : [Emotion] = [Emotion]()
    init(id : String){
        super.init()
        if id == "" {
            addEmptyEmoticon(true)
            return
        }
        // 2.根据id拼接info.plist的路径
        let plistPath = NSBundle.mainBundle().pathForResource("\(id)/info.plist", ofType: nil, inDirectory: "Emoticons.bundle")!
        
        // 3.根据plist文件的路径读取数据 [[String : String]]
        let array = NSArray(contentsOfFile: plistPath)! as! [[String : String]]
        
        // 4.遍历数组
        var index = 0
        for var dict in array {
            if let png = dict["png"] {
                dict["png"] = id + "/" + png
            }
            
            emotions.append(Emotion(dict: dict))
            index += 1
            if index == 20 {
                // 添加删除表情
                emotions.append(Emotion(isRemove: true))
                
                index = 0
            }
        }
        // 5.添加空白表情
        addEmptyEmoticon(false)
    }
    
    private func addEmptyEmoticon(isRecently : Bool) {
        let count = emotions.count % 21
        if count == 0 && !isRecently {
            return
        }
        
        for _ in count..<20 {
            emotions.append(Emotion(isEmpty: true))
        }
        
        emotions.append(Emotion(isRemove: true))
    }

}



