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
        if picSquare.hasPicture {
            imageTransformation(true)
        } else {
            imagePlus()
        }
        isSelected = false
    }

    
    /// Change picSquare's image regarding selected picture.
    func displayImage(_ image: UIImage?) {
        if let verifiedImage = image {
            setImage(verifiedImage, for: .normal)
            imageTransformation(true)
        }
        isSelected = false
    }
    
    private func imagePlus() {
        let image = UIImage(imageLiteralResourceName: "Plus")
        setImage(image, for: .normal)
        imageTransformation(false)
        isSelected = false
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
