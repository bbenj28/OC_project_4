//
//  UIViewController+alert.swift
//  Instagrid
//
//  Created by Benjamin Breton on 06/08/2020.
//  Copyright © 2020 InstaApps. All rights reserved.
//

import UIKit
extension UIViewController {
    /// Display an alert.
    /// - parameter title : Alert's title.
    /// - parameter text: Alert's text.
    func displayingAlert(title:String, text:String){
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    /// Display an alert to ask user if he wants to keep or delete the grid when it comes back after sharing.
    func deleteGridAlert() {
        let alert = UIAlertController(title: "Deleting Grid", message: "Do you want the grid to be deleted before its come back ?", preferredStyle: .actionSheet)
        let actionYes = UIAlertAction(title: "Yes", style: .default, handler: { _ in
            self.yesAnswer()
        })
        let actionNo = UIAlertAction(title: "No", style: .default, handler: { _ in
            self.noAnswer()
        })
        alert.addAction(actionYes)
        alert.addAction(actionNo)
        self.present(alert, animated: true)
    }
    private func yesAnswer() {
        let name = Notification.Name("DeleteGrid")
        let notification = Notification(name: name)
        NotificationCenter.default.post(notification)
    }
    private func noAnswer() {
        let name = Notification.Name("KeepGrid")
        let notification = Notification(name: name)
        NotificationCenter.default.post(notification)
    }
    
    /// Display an alert if a button's imageView returned *nil*.
    func imageViewInPicSquareButtonError() {
        displayingAlert(title: "ERROR", text: "One or several picSquares buttons imageView return nil.")
    }
}
