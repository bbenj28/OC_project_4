//
//  UIViewController+animations.swift
//  Instagrid
//
//  Created by Benjamin Breton on 06/08/2020.
//  Copyright © 2020 InstaApps. All rights reserved.
//

import UIKit
extension UIViewController {
    /// The height translation the grid have to do when sharing it.
    var heightTranslation: CGFloat {
        if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight {
            return 0
        } else {
            return -UIScreen.main.bounds.height
        }
    }
    
    /// The width translation the grid have to do when sharing it
    var widthTranslation: CGFloat {
        if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight {
            return -UIScreen.main.bounds.width
        } else {
            return 0
        }
    }
    
    /// Transform UIViews back to their identity with or without animations.
    /// - parameter views: Views to transform.
    /// - parameter animation: Is an animation wanted for this transformation.
    /// - parameter completion: Action to do after the transformation.
    func identityTransformation(_ views: [UIView], animation: Bool, completion handler: ((Bool) -> Void)?) {
        for view in views {
            transformation(view, transform: .identity, animation: animation, completion: handler)
        }
    }
    
    /// Reduce UIViews with or without animations.
    /// - parameter views: Views to transform.
    /// - parameter animation: Is an animation wanted for this transformation.
    /// - parameter completion: Action to do after the transformation.
    func reductionTransformation(_ views: [UIView], animation: Bool, completion handler: ((Bool) -> Void)?) {
        for view in views {
            transformation(view, transform: CGAffineTransform(scaleX: 0.2, y: 0.2), animation: animation, completion: handler)
        }
    }
    
    /// Make grid disappear.
    /// - parameter views: Views to transform.
    /// - parameter completion: Action to do after the transformation.
    func gridDisappearance(_ view: UIView, completion handler: ((Bool) -> Void)?) {
        let translation = CGAffineTransform(translationX: widthTranslation, y: heightTranslation)
        transformation(view, transform: translation, animation: true, completion: handler)
    }
    
    /// Transform views.
    /// - parameter views: Views to transform.
    /// - parameter transform: Transformations to do.
    /// - parameter animation: Is an animation wanted for this transformation.
    /// - parameter completion: Action to do after the transformation.
    func transformation(_ view: UIView, transform: CGAffineTransform, animation: Bool, completion handler: ((Bool) -> Void)?) {
        if animation {
            animationWithSpring({
                view.transform = transform
            }, next: handler)
        } else {
            view.transform = transform
        }
    }
    
    /// Animate wanted transformations.
    /// - parameter transform: Transformations to do.
    /// - parameter next: Action to do after the animation.
    func animationWithSpring(_ transform: @escaping () -> Void, next handler: ((Bool) -> Void)?) {
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.5,
            options: [],
            animations: transform,
            completion: { (finished: Bool) in
                if let next = handler {
                    next(finished)
                }
        })
        
    }
    
}
