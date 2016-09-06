//
//  HomeViewController.swift
//  Sina
//
//  Created by YOUNG on 16/9/4.
//  Copyright © 2016年 Young. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {

    private lazy var titleButton : TitleButton = TitleButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        visitorView.addRotateAnimation()
        if !isLogin {
            return;
        }
        setupNavigationBar()
        setupTitleButton()
    }
}
//MARK:首页navigationUI相关
extension HomeViewController{
    //左右navigationBarItem
    private func setupNavigationBar(){
        let button :UIButton = UIButton()
        button.setImage(UIImage(named: "navigationbar_friendattention"), forState: .Normal)
        button.setImage(UIImage(named: "navigationbar_friendattention_highlighted"), forState: .Highlighted)
        button.sizeToFit()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop")
        
    }
    //中间的titleButton
    private func setupTitleButton(){
        titleButton.setTitle("coderwhy", forState: .Normal)
        navigationItem.titleView = titleButton
        
        titleButton.addTarget(self, action: #selector(HomeViewController.didClickTitleButton), forControlEvents: .TouchUpInside)
    }
    
}

//MARK:监听点击
extension HomeViewController{
   @objc private func didClickTitleButton(){
        titleButton.selected = !titleButton.selected;
        //创建控制器
        let propover = PopoverViewController()
        //设置modal类型
        propover.modalPresentationStyle = .Custom
        presentViewController(propover, animated: true, completion: nil)
    }
}


















