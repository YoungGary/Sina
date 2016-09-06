//
//  TitleButton.swift
//  Sina
//
//  Created by YOUNG on 16/9/6.
//  Copyright © 2016年 Young. All rights reserved.
//

import UIKit

class TitleButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setImage(UIImage(named: "navigationbar_arrow_down"), forState: .Normal)
        setImage(UIImage(named: "navigationbar_arrow_up"), forState: .Selected)
        sizeToFit()
        setTitleColor(UIColor.blackColor(), forState: .Normal)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel!.frame.origin.x = 0
        imageView!.frame.origin.x = titleLabel!.frame.size.width + 8
    }
}
