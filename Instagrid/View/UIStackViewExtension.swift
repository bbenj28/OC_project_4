//
//  UIStackViewExtension.swift
//  Instagrid
//
//  Created by Benjamin Breton on 30/07/2020.
//  Copyright © 2020 InstaApps. All rights reserved.
//

import UIKit

extension UIStackView {
    func addBackgroundColor(_ color: UIColor) {
        let subview = UIView(frame: bounds)
        subview.backgroundColor = color
        subview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subview, at: 0)
    }
}
