//
//  BrowerTransitionAnimation.swift
//  Sina
//
//  Created by YOUNG on 16/9/24.
//  Copyright © 2016年 Young. All rights reserved.
//

import UIKit

//定义协议 弹出
protocol AnimationPresentedDelegate : NSObjectProtocol{
    
    func startRect(indexPath : NSIndexPath) -> CGRect
    func endRect(indexPath : NSIndexPath) -> CGRect
    func imageView(indexPath : NSIndexPath) -> UIImageView
}
//定义dismiss的协议
protocol AnimationDismissDelegate : NSObjectProtocol {
    func indexPathForDimissView() -> NSIndexPath
    func imageViewForDimissView() -> UIImageView
}


class BrowerTransitionAnimation: NSObject {
    var isPresented :Bool = false
    //定义代理属性
    var presentedDelegate : AnimationPresentedDelegate?
    var dismissDelegate : AnimationDismissDelegate?
    var indexPath : NSIndexPath?
    
}

extension BrowerTransitionAnimation : UIViewControllerTransitioningDelegate{
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        return self
    }
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        return self
    }
}

extension BrowerTransitionAnimation : UIViewControllerAnimatedTransitioning{
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        if isPresented == true {//model
            //nil 检验
            guard let presentedDelegate = presentedDelegate, indexPath = indexPath else {
                return
            }
            // UITransitionContextFromViewKey, and UITransitionContextToViewKey
            let presentedView = transitionContext.viewForKey(UITransitionContextToViewKey)!
            
            transitionContext.containerView()?.addSubview(presentedView)
            
            // 获取执行动画的imageView
            let startRect = presentedDelegate.startRect(indexPath)
            let imageView = presentedDelegate.imageView(indexPath)
            transitionContext.containerView()?.addSubview(imageView)
            imageView.frame = startRect
            
            //执行动画
            presentedView.alpha = 0.0
            transitionContext.containerView()?.backgroundColor = UIColor.blackColor()
            UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
                
               imageView.frame = presentedDelegate.endRect(indexPath)
                
                }, completion: { (_) in
                    imageView.removeFromSuperview()
                    presentedView.alpha = 1.0
                    transitionContext.containerView()?.backgroundColor = UIColor.clearColor()
                    transitionContext.completeTransition(true)
            })
            
        }else{//dismiss
            
            // nil值校验
            guard let dismissDelegate = dismissDelegate, presentedDelegate = presentedDelegate else {
                return
            }
            
            // 1.取出消失的View
            let dismissView = transitionContext.viewForKey(UITransitionContextFromViewKey)
            dismissView?.removeFromSuperview()
            
            // 2.获取执行动画的ImageView
            let imageView = dismissDelegate.imageViewForDimissView()
            transitionContext.containerView()?.addSubview(imageView)
            let indexPath = dismissDelegate.indexPathForDimissView()
            
            // 3.执行动画
            UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
                imageView.frame = presentedDelegate.startRect(indexPath)
            }) { (_) -> Void in
                transitionContext.completeTransition(true)
            }
        }
    }
}













