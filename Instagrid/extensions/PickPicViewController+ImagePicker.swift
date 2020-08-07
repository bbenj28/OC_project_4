//
//  PickPicViewController+ImagePicker.swift
//  Instagrid
//
//  Created by Benjamin Breton on 07/08/2020.
//  Copyright © 2020 InstaApps. All rights reserved.
//

import UIKit

extension PickPicViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    // MARK: - Image picker
    
    func launchImagePicker() {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        imagePicker.isModalInPopover = true
        imagePicker.modalPresentationStyle = .fullScreen
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // an image is selected, dismiss picker and display it in the selected PicSquare
        self.dismiss(animated: true, completion: {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                self.updatePicSquareWithSelection(image)
            } else {
                self.updatePicSquareWithSelection(nil)
            }
            self.activityIndicator.stopAnimating()
        })
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: {
            self.updatePicSquareWithSelection(nil)
            self.activityIndicator.stopAnimating()
        })
    }
}
