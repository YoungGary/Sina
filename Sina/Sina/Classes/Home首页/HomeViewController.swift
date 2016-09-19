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
import SDWebImage
import MJRefresh

class HomeViewController: BaseViewController{

    lazy var statusViewModels : [StatusViewModel] = [StatusViewModel]()
    
    private lazy var titleButton : TitleButton = TitleButton()
    
    private lazy var transintonAnimaiton : HomeTransitionAnimation = HomeTransitionAnimation { [weak self] (presented) -> () in
        self?.titleButton.selected = presented
    }
    
    lazy var tipLabel : UILabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        visitorView.addRotateAnimation()
        
        if !isLogin {
            return;
        }
        
        setupNavigationBar()
        setupTitleButton()
        setupTipLabel()
        
        //refresh
        setupRefreshHeader()
        setupRefreshFooter()
        
        //估算tableView的rowheight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 400
        
        
        
    }
}
//MARK:首页UI相关
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
        let title = UserAccountViewModel.sharedInstance.account?.screen_name
        titleButton.setTitle(title, forState: .Normal)
        navigationItem.titleView = titleButton
        titleButton.addTarget(self, action: #selector(HomeViewController.didClickTitleButton), forControlEvents: .TouchUpInside)
    }
    
    //refresh header
    private func setupRefreshHeader(){
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(HomeViewController.loadNewData))
        tableView.mj_header = header
        header.setTitle("下拉刷新", forState: .Idle)
        header.setTitle("释放刷新", forState: .Pulling)
        header.setTitle("刷新中", forState: .Refreshing)
        tableView.mj_header.beginRefreshing()//开始刷新状态
    }
    //refresh footer
    private func setupRefreshFooter(){
        tableView.mj_footer = MJRefreshAutoFooter(refreshingTarget: self, refreshingAction: #selector(HomeViewController.loadMoreData))
        
    }
    //tip label
    private func setupTipLabel(){
        let screenWidth = UIScreen.mainScreen().bounds.width
        tipLabel.frame = CGRect(x: 0, y: 10, width: screenWidth, height: 44)
        self.navigationController?.navigationBar.insertSubview(tipLabel, atIndex: 0)
        tipLabel.backgroundColor = UIColor.orangeColor()
        //property
        tipLabel.textColor = UIColor.whiteColor()
        tipLabel.font = UIFont.systemFontOfSize(14)
        tipLabel.textAlignment = .Center
        tipLabel.hidden = true
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
    
    @objc  private func loadNewData(){
        loadData(true)
    }
    @objc private func loadMoreData(){
        loadData(false)
    }
    
    private func loadData(isNew : Bool){
        //获取since_id
        var since_id = 0
        var max_id = 0
        if isNew {
            since_id = statusViewModels.first?.status?.mid ?? 0
        }else{
            max_id = statusViewModels.last?.status?.mid ?? 0
            max_id = max_id == 0 ?  0 : max_id - 1
        }
        
        
        let urlstring = "https://api.weibo.com/2/statuses/home_timeline.json"
        let params = ["access_token":(UserAccountViewModel.sharedInstance.account?.access_token)!,"since_id" : "\(since_id)","max_id" : "\(max_id)"]
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
            //temp array
            var tempArray = [StatusViewModel]()
            
            for dict in resultDict{
                let status =  Status(dict: dict)
                let viewModels = StatusViewModel(status: status)
                tempArray.append(viewModels)
            }
            if isNew{
                //把临时数组append到最前面
                self.statusViewModels = tempArray  + self.statusViewModels
            }else{
                //把临时数组append到最后面
                self.statusViewModels += tempArray
            }
            
            
            //cache picture
            self.cachePictureWithModels(tempArray)
            
            
        }
    }
    //MARK: 缓存单张配图
    private func cachePictureWithModels(viewModels : [StatusViewModel]){
        let group = dispatch_group_create()
        for viewModel in viewModels {
            for imgUrl in viewModel.picUrls{
                dispatch_group_enter(group)
                SDWebImageManager.sharedManager().downloadImageWithURL(imgUrl, options: [], progress: nil, completed: { (_, _, _, _, _) in
                    
                    dispatch_group_leave(group)
                })
            }
        }
        dispatch_group_notify(group, dispatch_get_main_queue()) {
            //刷新表格
            self.tableView.reloadData()
            //end refresh
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            //显示label
            self.showTipLabel(viewModels.count)
        }
    }
    //MARK:tiplabel animaiton
    private func showTipLabel(count : Int){
        UIView.animateWithDuration(1.0, animations: {
            self.tipLabel.hidden = false
            self.tipLabel.frame.origin.y = 44
           self.tipLabel.text = count == 0 ?  "没有新数据" :  "\(count)条新微博"
            }) { (_) in
                UIView.animateWithDuration(1.0, delay: 1.5, options: [], animations: { 
                    self.tipLabel.frame.origin.y = 10
                    }, completion: { (_) in
                      self.tipLabel.hidden = true
                })
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























