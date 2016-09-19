//
//  ComposeTextView.swift
//  Sina
//
//  Created by YOUNG on 16/9/19.
//  Copyright © 2016年 Young. All rights reserved.
//

import UIKit
import SnapKit

class ComposeTextView: UITextView {
    
    
    lazy var placeHolderLabel : UILabel = UILabel()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

}

extension ComposeTextView{
    private func setupView(){
        
        addSubview(placeHolderLabel)
        
        placeHolderLabel.snp_makeConstraints { (make) in
            make.top.equalTo(7)
            make.left.equalTo(7)
        }
        //property
        placeHolderLabel.text = "分享新鲜事..."
        placeHolderLabel.font = font
        placeHolderLabel.textColor = UIColor.lightGrayColor()
    }
}













