//
//  UIBarButtonItem+Extension.swift
//  Sina
//
//  Created by YOUNG on 16/9/6.
//  Copyright © 2016年 Young. All rights reserved.
//

import UIKit

extension UIBarButtonItem{
    convenience init(imageName : String) {
        let button :UIButton = UIButton()
        button.setImage(UIImage(named: imageName), forState: .Normal)
        button.setImage(UIImage(named: imageName + "_highlighted"), forState: .Highlighted)
        button.sizeToFit()
        self.init(customView :button)
    }
}
