//
//  MainTabbarController.swift
//  Sina
//
//  Created by YOUNG on 16/9/4.
//  Copyright © 2016年 Young. All rights reserved.
//

import UIKit

class MainTabbarController: UITabBarController {

    private lazy var imageName = ["tabbar_home_highlighted","tabbar_message_center_highlighted","","tabbar_discover_highlighted","tabbar_profile_highlighted"]
    
    private lazy var composeButton : UIButton = UIButton(imageName: "tabbar_compose_icon_add", bgImageName: "tabbar_compose_button")
    
    override func viewDidLoad() {
        super.viewDidLoad()
       addComposeButton()
        
    }
    
    //在view will appear中遍历tabbar 改变选中图片
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
       tabbarItems()
    }
}

extension MainTabbarController{
    //MARK: 加发布按钮
    private func addComposeButton(){
        tabBar.addSubview(composeButton)
        
        composeButton.sizeToFit()
        
        composeButton.center = CGPointMake(tabBar.center.x, tabBar.bounds.size.height*0.5)
        
        composeButton.addTarget(self, action: #selector(MainTabbarController.composeButtonClick), forControlEvents: .TouchUpInside)
    }
    //MARK:tabbar选中图片
    private func tabbarItems(){
        for i in 0..<tabBar.items!.count {
            let item = tabBar.items![i]
            
            if i == 2 {
                item.enabled = false
                continue
            }
            
            item.selectedImage = UIImage(named:imageName[i])
        }
    }
}
//MARK: 点击事件的监听
extension MainTabbarController{
    func composeButtonClick() {
        let composeVC = ComposeViewController()
        let composeNavi = UINavigationController(rootViewController: composeVC)
        presentViewController(composeNavi, animated: true, completion: nil)
    }
}



