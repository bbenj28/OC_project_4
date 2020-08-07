//
//  UIViewController+activityController.swift
//  Instagrid
//
//  Created by Benjamin Breton on 07/08/2020.
//  Copyright © 2020 InstaApps. All rights reserved.
//

import UIKit
extension UIViewController {
    // MARK: - Share
    
    /// Launch UIActivityController to share picture.
    /// - Parameter image: The generated UIImage to share.
    func sharePicture(_ image: UIImage) {
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityController.completionWithItemsHandler = { (activity, success, items, error) in
            let name: Notification.Name
            if success {
                name = Notification.Name("ShareTrue")
                
            } else {
                name = Notification.Name("ShareFalse")
            }
            let notification = Notification(name: name)
            NotificationCenter.default.post(notification)
        }
        present(activityController, animated: true)
    }
}
