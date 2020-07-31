//
//  PicSquareView.swift
//  Instagrid
//
//  Created by Benjamin Breton on 31/07/2020.
//  Copyright © 2020 InstaApps. All rights reserved.
//

import UIKit

class PicSquareView: UIButton {
    func setView(_ picSquare: PicSquare) {
        self.isHidden = picSquare.isHidden
        let background = UIImage(imageLiteralResourceName: "\(picSquare.disposition.backgroundName()) Square Background")
        self.setBackgroundImage(background, for: .normal)
        let image: UIImage
        if picSquare.pictureIsSelected {
            image = UIImage(imageLiteralResourceName: "Plus")
        } else {
            image = UIImage(imageLiteralResourceName: "Plus")
        }
        self.setImage(image, for: .normal)
    }
}
