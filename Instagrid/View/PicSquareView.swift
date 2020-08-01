//
//  PicSquareView.swift
//  Instagrid
//
//  Created by Benjamin Breton on 31/07/2020.
//  Copyright © 2020 InstaApps. All rights reserved.
//

import UIKit

class PicSquareView: UIButton {
    /// Change picSquare regarding selected layout and picture.
    func setView(_ picSquare: PicSquare) {
        isHidden = picSquare.isHidden
        let backgroundNormal = UIImage(imageLiteralResourceName: "\(picSquare.disposition.backgroundName()) Square Background")
        let backgroundSelected = UIImage(imageLiteralResourceName: "\(picSquare.disposition.backgroundName()) Square Background Selected")
        setBackgroundImage(backgroundNormal, for: .normal)
        setBackgroundImage(backgroundSelected, for: .selected )
        changeRatio(CGFloat(picSquare.disposition.ratio()))
        imageButton(picSquare.imageButton())
        isSelected = false
    }
    
    /// Change picSquare's image regarding selected picture.
    private func imageButton(_ data: Data?) {
        if let verifiedData = data {
            if let verifiedImage = UIImage(data: verifiedData) {
                imageView?.contentMode = .scaleAspectFill
                setImage(verifiedImage, for: .normal)
            } else {
                imagePlus()
            }
        } else {
            imagePlus()
        }
    }
    private func imagePlus() {
        //self.contentVerticalAlignment = .center
        //self.contentHorizontalAlignment = .center
        imageView?.contentMode = .center
        let image = UIImage(imageLiteralResourceName: "Plus")
        let imageSelected = UIImage(imageLiteralResourceName: "Plus Selected")
        setImage(image, for: .normal)
        setImage(imageSelected, for: .selected)
    }
    
    /// Change picSquare's ratio regarding selected layout.
    private func changeRatio(_ multiplier: CGFloat) {
        for constraint in constraints {
            if constraint.identifier == "PicSquareRatio" {
                if let firstItem = constraint.firstItem {
                    let newConstraint = NSLayoutConstraint(item: firstItem, attribute: constraint.firstAttribute, relatedBy: constraint.relation, toItem: constraint.secondItem, attribute: constraint.secondAttribute, multiplier: multiplier, constant: constraint.constant)
                    newConstraint.identifier = "PicSquareRatio"
                    removeConstraint(constraint)
                    addConstraint(newConstraint)
                }
            }
        }
        
        layoutIfNeeded()
        imageView?.layoutIfNeeded()
    }
}
