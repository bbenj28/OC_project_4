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
        
        if let _ = picSquare.pictureUrl {
            imageTransformation(true)
        } else {
            imageTransformation(false)
        }
    }

    
    /// Change picSquare's image regarding selected picture.
    func setImage(_ data: Data?) {
        if let verifiedData = data {
            if let verifiedImage = UIImage(data: verifiedData) {
                displayImage(verifiedImage)
            } else {
                imagePlus()
            }
        } else {
            imagePlus()
        }
        isSelected = false
    }
    private func displayImage(_ image: UIImage) {
        setImage(image, for: .normal)
        imageTransformation(true)
    }
    private func imagePlus() {
        let image = UIImage(imageLiteralResourceName: "Plus")
        setImage(image, for: .normal)
        imageTransformation(false)
    }
    private func imageTransformation(_ imageIsSelected: Bool) {
        if imageIsSelected {
            imageView?.contentMode = .scaleAspectFill
            let scale = CGAffineTransform(scaleX: 0.5, y: 0.5)
            imageView?.transform = scale
        } else {
            imageView?.transform = .identity
            imageView?.contentMode = .center
        }
    }
}
