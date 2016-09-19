//
//  TitleView.swift
//  Sina
//
//  Created by YOUNG on 16/9/19.
//  Copyright © 2016年 Young. All rights reserved.
//

import UIKit
import SnapKit

class TitleView: UIView {
    
    lazy var titleLabel : UILabel = UILabel()
    lazy var screenNameLabel : UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TitleView{
    private func setupView(){
        //add subView
        addSubview(titleLabel)
        addSubview(screenNameLabel)
        //constrains
        titleLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.bottom.equalTo(self)
        }
        screenNameLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(self)
        }
        // 3.设置空间的属性
        titleLabel.font = UIFont.systemFontOfSize(16)
        screenNameLabel.font = UIFont.systemFontOfSize(14)
        screenNameLabel.textColor = UIColor.lightGrayColor()
        
        // 4.设置文字内容
        titleLabel.text = "发微博"
        screenNameLabel.text = UserAccountViewModel.sharedInstance.account?.screen_name
        
    }
}














