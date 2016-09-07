//
//  HomeTransitionAnimation.swift
//  Sina
//
//  Created by YOUNG on 16/9/7.
//  Copyright © 2016年 Young. All rights reserved.
//

import UIKit

class HomeTransitionAnimation: NSObject,UIViewControllerAnimatedTransitioning,UIViewControllerTransitioningDelegate{
    
    var presentedFrame  : CGRect = CGRectZero
    var isPresented : Bool = false
    
    var callback : ((presented : Bool) -> ())?

    init(callback : (presented : Bool) -> ()) {
        self.callback = callback
    }
    
}

//MARK:自定义转场--
extension HomeTransitionAnimation{
    //设置弹出vc的frame
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        let presentation = PresentationController(presentedViewController: presented, presentingViewController: presenting)
        presentation.presentedViewFrame = presentedFrame        
        return presentation
    }
    //设置转场动画  弹出
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        return self
    }
    //设置转场动画  消失
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        return self
    }
}
//UIViewControllerAnimatedTransitioning 协议需要执行的方法
extension HomeTransitionAnimation{
    // synchronize with the main animation.
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval{
        return 0.5
    }
    // This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
    func animateTransition(transitionContext: UIViewControllerContextTransitioning){
        isPresented ? presentViewAnimation(transitionContext) : dismissViewAnimation(transitionContext)
        
    }
    //弹出动画
    func presentViewAnimation(transitionContext: UIViewControllerContextTransitioning){
        
        let presentedView = transitionContext.viewForKey(UITransitionContextToViewKey)
        transitionContext.containerView()?.addSubview(presentedView!)
        //执行动画
        presentedView?.transform = CGAffineTransformMakeScale(1.0, 0.0)
        presentedView?.layer.anchorPoint = CGPointMake(0.5, 0)
        
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
            presentedView?.transform = CGAffineTransformIdentity
        }) { (isFinish : Bool) in
            //要告诉转场上下文 你完成了 动画
            transitionContext.completeTransition(true)
        }
    }
    //消失动画
    func dismissViewAnimation(transitionContext: UIViewControllerContextTransitioning){
        let dismissView = transitionContext.viewForKey(UITransitionContextFromViewKey)
        transitionContext.containerView()?.addSubview(dismissView!)
        //执行动画
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
            dismissView?.transform = CGAffineTransformMakeScale(1.0, 0.001)
        }) { (_) in
            dismissView?.removeFromSuperview()
            //要告诉转场上下文 你完成了 动画
            transitionContext.completeTransition(true)
        }
    }
}