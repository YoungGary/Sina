//
//  WelcomeViewController.swift
//  Sina
//
//  Created by YOUNG on 16/9/11.
//  Copyright © 2016年 Young. All rights reserved.
//

import UIKit
import SDWebImage

class WelcomeViewController: UIViewController {

    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var distance2bottom: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //头像设置
        let iconString = UserAccountViewModel.sharedInstance.account?.avatar_large
        let url = NSURL(string: iconString ?? "")
        
        icon.sd_setImageWithURL(url, placeholderImage: UIImage(named: "avatar_default_big" ))
        
        //animation
        distance2bottom.constant = UIScreen.mainScreen().bounds.height-200
        UIView.animateWithDuration(5.0, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 5.0, options: .CurveEaseInOut, animations: {
            self.view.layoutIfNeeded()
            }) { (finished) in
            UIApplication.sharedApplication().keyWindow?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        }
        
    }

    

    

}
