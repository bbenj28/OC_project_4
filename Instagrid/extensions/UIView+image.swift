//
//  UIView+image.swift
//  Instagrid
//
//  Created by Benjamin Breton on 05/08/2020.
//  Copyright © 2020 InstaApps. All rights reserved.
//

import UIKit
extension UIView {
    var image: UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
