//
//  PicSquareView.swift
//  Instagrid
//
//  Created by Benjamin Breton on 31/07/2020.
//  Copyright © 2020 InstaApps. All rights reserved.
//

import UIKit

class PicSquareView: UIButton {
    
    /// Change view regarding layout's and picture's selections.
    /// - parameter picSquare: The target grid's square.
    /// - returns: *true* if the button's imageView exists (when unwrapping it), *false* otherwise.
    func setView(_ picSquare: PicSquare) -> Bool {
        isHidden = picSquare.isHidden
        let bool: Bool
        if picSquare.hasPicture {
            bool = imageTransformation(true)
        } else {
            bool = imagePlus()
        }
        isSelected = false
        return bool
    }

    
    /// Change picSquare's image regarding selected picture.
    /// - parameter image: The picSquare's picture.
    /// - returns: *true* if the button's imageView exists (when unwrapping it), *false*
    func displayImage(_ image: UIImage?) -> Bool {
        let bool: Bool
        if let verifiedImage = image {
            setImage(verifiedImage, for: .normal)
            bool = imageTransformation(true)
        } else {
            bool = true
        }
        isSelected = false
        return bool
    }
    
    /// Change empty picSquare's image with a plus.
    /// - returns: *true* if the button's imageView exists (when unwrapping it), *false*
    private func imagePlus() -> Bool {
        let image = UIImage(imageLiteralResourceName: "Plus")
        setImage(image, for: .normal)
        let bool = imageTransformation(false)
        isSelected = false
        return bool
    }
    
    /// Change picSquare's imageView properties regarding if a picture has been selected or not.
    /// - returns: *true* if the button's imageView exists (when unwrapping it), *false*
    private func imageTransformation(_ imageIsSelected: Bool) -> Bool {
        guard let picView = imageView else {
            return false
        }
        if imageIsSelected {
            picView.contentMode = .scaleAspectFill
            let scale = CGAffineTransform(scaleX: 0.5, y: 0.5)
            picView.transform = scale
        } else {
            picView.transform = .identity
            picView.contentMode = .center
        }
        return true
    }
}
