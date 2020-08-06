//
//  UIViewController+alert.swift
//  Instagrid
//
//  Created by Benjamin Breton on 06/08/2020.
//  Copyright © 2020 InstaApps. All rights reserved.
//

import UIKit
extension UIViewController {
    func displayingAlert(title:String, text:String){
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    func imageViewInPicSquareButtonError() {
        displayingAlert(title: "ERROR", text: "One or several picSquares buttons imageView return nil.")
    }
}
