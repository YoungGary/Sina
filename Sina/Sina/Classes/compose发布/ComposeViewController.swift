//
//  ComposeViewController.swift
//  Sina
//
//  Created by YOUNG on 16/9/19.
//  Copyright © 2016年 Young. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {
    
    lazy var titleView : TitleView = TitleView()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNaviBar()
    }
}

//MARK:UI相关
extension ComposeViewController{
    private func setupNaviBar(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .Plain, target: self, action: #selector(ComposeViewController.didClickCancelButton))
         navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: .Plain, target: self, action: #selector(ComposeViewController.didClickComposeButton))
        navigationItem.titleView = titleView
        
    }
}
//MARK:监听点击事件
extension ComposeViewController{
    @objc private func  didClickCancelButton(){
        dismissViewControllerAnimated(true, completion: nil)
    }
    @objc private func  didClickComposeButton(){
        
    }
}