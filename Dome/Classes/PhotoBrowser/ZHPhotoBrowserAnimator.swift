//
//  ZHPhotoBrowserAnimator.swift
//  03-PhotoBrowser(界面布局)
//
//  Created by 李智恒 on 16/4/28.
//  Copyright © 2016年 Zhli. All rights reserved.
//

import UIKit

// MARK:- 定义协议
protocol PresentDelegate : class {
    func homeRect(indexPath : NSIndexPath) -> CGRect
    func photoBrowserRect(indexPath : NSIndexPath) -> CGRect
    func imageView(indexPath : NSIndexPath) -> UIImageView
}

protocol DismissDelegate : class {
    func currentIndexPath() -> NSIndexPath
    func imageView() -> UIImageView
}

class ZHPhotoBrowserAnimator: NSObject  {

    //定义属性
    var isPresented : Bool = false
    
    weak var presentDelegate : PresentDelegate?
    weak var dismissDelegate : DismissDelegate?
    var indexPath : NSIndexPath?
    
}
//实现转场代理中的方法
extension ZHPhotoBrowserAnimator :UIViewControllerTransitioningDelegate
{
    //弹出动画交给谁管理
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        return self
    }
    //消失动画交给谁管理
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresented = false
        return self
    }
    
}
//实现转场代理中的方法
extension  ZHPhotoBrowserAnimator : UIViewControllerAnimatedTransitioning
{
    // 1.返回动画执行的时间
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 1.0
    }
    
    // 2.可以获取转场的上下文:可以通过上下文获取到执行动画的View
    // UITransitionContextFromViewKey : 取出是消失的View,是在做消失动画时会使用
    // UITransitionContextToViewKey : 取出是弹出的View,是在做弹出动画时会使用
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        isPresented ? animateForPresentView(transitionContext) : animateForDismessView(transitionContext)
    }
    
    
    func animateForPresentView(transitionContext: UIViewControllerContextTransitioning)
    {
        // 1.取出弹出的View(控制器的View)
        let presentView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        
        // 2.将弹出的View自己加到containerView中
        transitionContext.containerView()?.addSubview(presentView)
        
        // 3.执行动画
        // 3.1.获取执行的imageView
        guard let presentDelegate = presentDelegate else {
            return
        }
        guard let indexPath = indexPath else {
            return
        }
        let imageView = presentDelegate.imageView(indexPath)
        
        // 3.2.将imageView添加到父控件
        transitionContext.containerView()?.addSubview(imageView)
        
        // 3.3.设置imageView的起始位置
        imageView.frame = presentDelegate.homeRect(indexPath)
        
        // 3.4.执行动画
        presentView.alpha = 0
        transitionContext.containerView()?.backgroundColor = UIColor.blackColor()
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
            imageView.frame = presentDelegate.photoBrowserRect(indexPath)
            }) { (_) -> Void in
                presentView.alpha = 1.0
                imageView.removeFromSuperview()
                transitionContext.containerView()?.backgroundColor = UIColor.clearColor()
                transitionContext.completeTransition(true)
        }
        
        
    }
    
    
    
    func animateForDismessView(transitionContext: UIViewControllerContextTransitioning)
    {
      // 1.取出消失的View
       let dismessView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        dismessView.removeFromSuperview()
        
        // 2.执行动画
        // 2.1.获取执行动画的imageView
        guard let dismissDelegate = dismissDelegate else {
            return
        }
        guard let presentDelegate = presentDelegate else {
            return
        }
        let imageView = dismissDelegate.imageView()
        transitionContext.containerView()?.addSubview(imageView)
        
        // 2.2.获取当前正在显示的indexPath
        let indexPath = dismissDelegate.currentIndexPath()
        
        // 2.3.设置起始位置
        imageView.frame = presentDelegate.photoBrowserRect(indexPath)
        
        // 2.4.执行动画
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
            imageView.frame = presentDelegate.homeRect(indexPath)
            }) { (_) -> Void in
                transitionContext.completeTransition(true)
        }
    }

}