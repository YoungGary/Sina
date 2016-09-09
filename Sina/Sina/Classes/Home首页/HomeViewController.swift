//
//  HomeViewController.swift
//  Sina
//
//  Created by YOUNG on 16/9/4.
//  Copyright © 2016年 Young. All rights reserved.
//
//App key：122711537
//App secret：adf5c65bbeb223b613997c8b1df75918
///https://api.weibo.com/oauth2/authorize?client_id=122711537&redirect_uri=www.baidu.com

import UIKit

class HomeViewController: BaseViewController{

    private lazy var titleButton : TitleButton = TitleButton()
    
    private lazy var transintonAnimaiton : HomeTransitionAnimation = HomeTransitionAnimation { [weak self] (presented) -> () in
        self?.titleButton.selected = presented
    }
    
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
        //titleButton.selected = !titleButton.selected;
        //创建控制器
        let propover = PopoverViewController()
        
        //设置modal类型
        propover.modalPresentationStyle = .Custom
        let x =  UIScreen.mainScreen().bounds.size.width/2
        transintonAnimaiton.presentedFrame = CGRect(x: x-90, y: 60, width: 180, height:260)
        //设置代理
        propover.transitioningDelegate = transintonAnimaiton
    
        presentViewController(propover, animated: true, completion: nil)
    }
}
















