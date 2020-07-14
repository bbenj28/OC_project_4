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
            viewResize(picSquare)
            squarePicture(picSquare)
        }
    }
    private func viewResize(_ picSquare: PicSquare) {
        let width = CGFloat(picSquare.width)
        let height = CGFloat(picSquare.height)
        frame.size = CGSize(width: width, height: height)
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
        picture.frame = CGRect(origin: .zero, size: frame.size)
    }

}