//
//  BaseViewController.swift
//  Sina
//
//  Created by YOUNG on 16/9/5.
//  Copyright © 2016年 Young. All rights reserved.
//

import UIKit

class BaseViewController: UITableViewController {
    
     var isLogin : Bool = false
    
    lazy var  visitorView :VisitorView = VisitorView.visitorView()
    
    override func loadView() {
        isLogin ? super.loadView() : setupVisitorView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNaviBar()
        
    }
}


//MARK:ui相关
extension BaseViewController{
    //添加访客试图
    func  setupVisitorView(){
        view = visitorView;
        visitorView.loginButton.addTarget(self, action: #selector(BaseViewController.loginButtonClick), forControlEvents: .TouchUpInside)
        visitorView.rigisterButton.addTarget(self, action: #selector(BaseViewController.registerButtonClick), forControlEvents: .TouchUpInside)
    }
   @objc private func setupNaviBar(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: .Plain, target: self, action: #selector(BaseViewController.registerButtonClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: .Plain, target: self, action: #selector(BaseViewController.loginButtonClick))
    }
    
}

//MARK:事件的监听
extension BaseViewController{
   @objc private func registerButtonClick(){
        print("register")
    }
   @objc private func loginButtonClick(){
        //弹出登录页面
        let oauth = OauthViewController()
        let navi = UINavigationController(rootViewController: oauth)
        presentViewController(navi, animated: true, completion: nil)
        
    }
}














