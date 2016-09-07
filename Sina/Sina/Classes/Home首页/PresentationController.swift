//
//  PresentationController.swift
//  Sina
//
//  Created by YOUNG on 16/9/7.
//  Copyright © 2016年 Young. All rights reserved.
//

import UIKit

class PresentationController: UIPresentationController {
    
    var presentedViewFrame :CGRect = CGRectZero
    
    lazy var coverView = UIView()
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        //let x = UIScreen.mainScreen().bounds
        
        presentedView()?.frame = presentedViewFrame
        //设置蒙版view
        setupCoverView()
    }
}

//MARK:蒙版设置
extension PresentationController{
    func setupCoverView() {
        coverView.frame = containerView!.bounds
        containerView?.insertSubview(coverView, atIndex: 0)
        coverView.backgroundColor = UIColor(white: 0.8, alpha: 0.2)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(PresentationController.didClickCoverView))
        coverView.addGestureRecognizer(tap)
        
    }
}
//MARK:tap手势
extension PresentationController{
    @objc private func didClickCoverView(){
        
            presentedViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}











