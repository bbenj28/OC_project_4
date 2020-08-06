//
//  UIViewController+animations.swift
//  Instagrid
//
//  Created by Benjamin Breton on 06/08/2020.
//  Copyright © 2020 InstaApps. All rights reserved.
//

import UIKit
extension UIViewController {
    var heightTranslation: CGFloat {
        if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight {
            return 0
        } else {
            return -UIScreen.main.bounds.height
        }
    }
    var widthTranslation: CGFloat {
        if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight {
            return -UIScreen.main.bounds.width
        } else {
            return 0
        }
    }
    func identityTransformation(_ views: [UIView], animation: Bool, completion handler: ((Bool) -> Void)?) {
        for view in views {
            transformation(view, transform: .identity, animation: animation, completion: handler)
        }
    }
    func reductionTransformation(_ views: [UIView], animation: Bool, completion handler: ((Bool) -> Void)?) {
        for view in views {
            transformation(view, transform: CGAffineTransform(scaleX: 0.2, y: 0.2), animation: animation, completion: handler)
        }
    }
    func gridDisappearance(_ view: UIView, completion handler: ((Bool) -> Void)?) {
        let translation = CGAffineTransform(translationX: widthTranslation, y: heightTranslation)
        transformation(view, transform: translation, animation: true, completion: handler)
    }
    func transformation(_ view: UIView, transform: CGAffineTransform, animation: Bool, completion handler: ((Bool) -> Void)?) {
        if animation {
            animationWithSpring({
                view.transform = transform
            }, next: handler)
        } else {
            view.transform = transform
        }
    }
    
    /// Animate buttons for picture selection and picSquares appearance.
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
