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

///https://api.weibo.com/2/statuses/home_timeline.json?access_token=2.00GZJwAC02ssSI4a6a49308d0mhq4O

import UIKit

class HomeViewController: BaseViewController{

    lazy var statusViewModels : [StatusViewModel] = [StatusViewModel]()
    
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
        //加载首页数据
        loadData()
        //估算tableView的rowheight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
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
        //设置转场代理
        propover.transitioningDelegate = transintonAnimaiton
    
        presentViewController(propover, animated: true, completion: nil)
    }
}
//MARK:网络获取数据
extension HomeViewController{
    private func loadData(){
        let urlstring = "https://api.weibo.com/2/statuses/home_timeline.json"
        let params = ["access_token":(UserAccountViewModel.sharedInstance.account?.access_token)!]
        NetWorkTools.shareInstance.request(.GET, url: urlstring, parameters: params) { (result, error) in
            if error != nil{
                print(error)
                return
            }
            
            guard let results = result as? [String : AnyObject]else{
                print("1")
                return
            }
            
            guard let resultDict = results["statuses"] as? [[String : AnyObject]] else{
                print("2")
                return
            }
            
            for dict in resultDict{
                let status =  Status(dict: dict)
                let viewModels = StatusViewModel(status: status)
                self.statusViewModels.append(viewModels)
            }
            //reload
            self.tableView.reloadData()
            
        }
    }
}

//MARK:date source
extension HomeViewController{
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statusViewModels.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("homeCell") as! HomeTableViewCell
        let model = statusViewModels[indexPath.row]
        cell.model = model
        return cell
        
    }
}























