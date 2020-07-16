//
//  PicSquaresViews.swift
//  Instagrid
//
//  Created by Benjamin Breton on 14/07/2020.
//  Copyright © 2020 InstaApps. All rights reserved.
//

import UIKit

class PicSquaresViews: UIView {
    @IBOutlet private var plus: UIImageView!
    @IBOutlet private var picture: UIImageView!
    func setView(_ picSquare: PicSquare) {
        isHidden = picSquare.isHidden
        if picSquare.isHidden == false {
            setAutoLayout(picSquare)
            squarePicture(picSquare)
        }
    }
    private func squarePicture(_ picSquare: PicSquare) {
        if picSquare.pictureIsSelected {
            plus.isHidden = true
            checkPictureSize()
            picture.isHidden = false
        } else {
            picture.isHidden = true
            plusPosition()
        }
    }
    private func plusPosition() {
        plus.transform = .identity
        let positionX = frame.width / 2 - 20
        let positionY = frame.height / 2 - 20
        let translationX = positionX - plus.frame.minX
        let translationY = positionY - plus.frame.minY
        let translation = CGAffineTransform(translationX: translationX, y: translationY)
        plus.transform = translation
        plus.isHidden = false
    }
    func changePicture(_ image: UIImage) {
        
        plus.isHidden = true
        picture.image = image
        picture.isHidden = false
        checkPictureSize()
    }
    private func checkPictureSize() {
        // adjust picture size to frame size and to avoid white margins : change origin point to (-1, -1) and add 1 point on each picture's side 
        let origin = CGPoint(x: -1, y: -1)
        let size = CGSize(width: frame.size.width + 2, height: frame.size.height + 2)
        picture.frame = CGRect(origin: origin, size: size)
    }
    
    private func setAutoLayout(_ picSquare: PicSquare) {
        searchAndReplaceRatioLayout(picSquare)
        searchAndReplaceHorizontalCenterLayout(picSquare)
        superview!.layoutIfNeeded()
        layoutIfNeeded()
    }
    private func searchAndReplaceRatioLayout(_ picSquare: PicSquare) {
        for constraint in constraints {
            if let identifier = constraint.identifier {
                if identifier == "Ratio\(picSquare.id)" {
                    let multiplier = getNewAspectRatioMultiplier(picSquare)
                    let newConstraint = getNewConstraint(constraint: constraint, multiplier: multiplier, identifier: "Ratio\(picSquare.id)")
                    replaceRatioLayout(oldConstraint: constraint, newConstraint: newConstraint)
                    break
                }
            }
        }
    }
    private func searchAndReplaceHorizontalCenterLayout(_ picSquare: PicSquare) {
        
        for constraint in superview!.constraints {
            if let identifier = constraint.identifier {
                if identifier == "Hcenter\(picSquare.id)" {
                    let multiplier = getNewHorizontalCenterMultiplier(picSquare)
                    let newConstraint = getNewConstraint(constraint: constraint, multiplier: multiplier, identifier: "Hcenter\(picSquare.id)")
                    replaceHorizontalCenterLayout(oldConstraint: constraint, newConstraint: newConstraint)
                    break
                }
            }
        }
    }
    private func getNewAspectRatioMultiplier(_ picSquare: PicSquare) -> CGFloat {
        switch picSquare.disposition {
        case .bottomAllWidth, .topAllWidth:
            return 2.118
        default:
            return 1
        }
    }
    private func getNewHorizontalCenterMultiplier(_ picSquare: PicSquare) -> CGFloat {
        switch picSquare.disposition {
        case .bottomAllWidth, .topAllWidth:
            return 1
        case .bottomLeft, .topLeft:
            return 0.525
        case .bottomRight, .topRight:
            return 1.475
        }
    }
    private func getNewConstraint(constraint: NSLayoutConstraint, multiplier: CGFloat, identifier: String) -> NSLayoutConstraint {
        let newConstraint = NSLayoutConstraint(item: constraint.firstItem!, attribute: constraint.firstAttribute, relatedBy: constraint.relation, toItem: constraint.secondItem, attribute: constraint.secondAttribute, multiplier: multiplier, constant: constraint.constant)
        newConstraint.identifier = identifier
        return newConstraint
    }
    private func replaceHorizontalCenterLayout(oldConstraint: NSLayoutConstraint, newConstraint: NSLayoutConstraint) {
        superview!.removeConstraint(oldConstraint)
        superview!.addConstraint(newConstraint)
    }
    private func replaceRatioLayout(oldConstraint: NSLayoutConstraint, newConstraint: NSLayoutConstraint) {
        removeConstraint(oldConstraint)
        addConstraint(newConstraint)
    }

}
