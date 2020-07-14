//
//  PickPicViewController.swift
//  Instagrid
//
//  Created by Benjamin Breton on 14/07/2020.
//  Copyright © 2020 InstaApps. All rights reserved.
//

import UIKit

class PickPicViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    @IBOutlet var picSquares: [PicSquaresViews]!
    @IBOutlet var layoutsButtons: [UIImageView]!
    @IBOutlet var layoutsSelectedViews: [UIImageView]!
    
    var imagePicker = UIImagePickerController()
    let picDisposition = PicDisposition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeDisposition(0)
        // Do any additional setup after loading the view.
    }
    
    private func changeDisposition(_ index: Int?) {
        picDisposition.changeDisposition(index)
        for i in 0...2 {
            if picDisposition.selectedLayout == i {
                layoutsSelectedViews[i].isHidden = false
            } else {
                layoutsSelectedViews[i].isHidden = true
            }
        }
        for i in 0...3 {
            picSquares[i].setView(picDisposition.picSquares[i])
        }
        
    }

    @IBAction func layout1IsSelected(_ sender: Any) {
        layoutIsSelected(0)
    }
    
    @IBAction func layout2IsSelected(_ sender: Any) {
        layoutIsSelected(1)
    }
    @IBAction func layout3IsSelected(_ sender: Any) {
        layoutIsSelected(2)
    }
    private func layoutIsSelected(_ index: Int) {
        if index != picDisposition.selectedLayout {
            changeDisposition(index)
        }
    }
    
    
    
    
    @IBAction func askForChangePictureInPicSquare0(_ sender: Any) {
        askForChangePictureInPicSquares(0)
    }
    
    @IBAction func askForChangePictureInPicSquare1(_ sender: Any) {
        askForChangePictureInPicSquares(1)
    }
    
    @IBAction func askForChangePictureInPicSquare2(_ sender: Any) {
        askForChangePictureInPicSquares(2)
    }
    
    @IBAction func askForChangePictureInPicSquare3(_ sender: Any) {
        askForChangePictureInPicSquares(3)
    }
    
    private func askForChangePictureInPicSquares(_ index: Int) {
        picDisposition.selectedSquare = index
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            print(imagePicker.mediaTypes)
            
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            

            present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        self.dismiss(animated: true, completion: {
            let image = info[UIImagePickerController.InfoKey.originalImage]
            let picSquare = self.picDisposition.picSquares[self.picDisposition.selectedSquare!]
            picSquare.pictureIsSelected = true
            self.picSquares[self.picDisposition.selectedSquare!].changePicture(image as! UIImage)
        })

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
