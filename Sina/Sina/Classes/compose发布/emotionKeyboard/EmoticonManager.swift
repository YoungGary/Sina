//
//  EmoticonManager.swift
//  Sina
//
//  Created by YOUNG on 16/9/21.
//  Copyright © 2016年 Young. All rights reserved.
//

import UIKit
//manager -> packages -> emotions
class EmoticonManager{
    var packages : [EmoticonPackage] = [EmoticonPackage]()
    
    init(){
        // 1.添加最近表情的包
        packages.append(EmoticonPackage(id: ""))
        
        // 2.添加默认表情的包
        packages.append(EmoticonPackage(id: "com.sina.default"))
        
        // 3.添加emoji表情的包
        packages.append(EmoticonPackage(id: "com.apple.emoji"))
        
        // 4.添加浪小花表情的包
        packages.append(EmoticonPackage(id: "com.sina.lxh"))
    }
}
