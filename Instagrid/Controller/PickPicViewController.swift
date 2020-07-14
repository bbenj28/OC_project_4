//
//  PickPicViewController.swift
//  Instagrid
//
//  Created by Benjamin Breton on 14/07/2020.
//  Copyright © 2020 InstaApps. All rights reserved.
//

import UIKit

class PickPicViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    @IBOutlet weak var gridView: GridView!
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
    @IBAction func swipeGestureRecognized(_ sender: UISwipeGestureRecognizer) {
        
        if sender.state == .ended {
            moveGridAnimation()
            generateAndSharePicture()
        }

    }
    private func returnDeletedGridAnimation() {
        picDisposition.delete()
        changeDisposition(nil)
        returnGridAnimation()
    }
    private func returnGridAnimation() {
        gridAnimation(.identity)
    }
    private func gridAnimation(_ transform: CGAffineTransform) {
        UIView.animate(withDuration: 0.3, animations: {
            self.gridView.transform = transform
        })
    }
    
    private func generateAndSharePicture() {
        let image = generatePicture()
        let ac = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        ac.completionWithItemsHandler = { (activity, success, items, error) in
            if success {
                self.returnDeletedGridAnimation()
            } else {
                self.returnGridAnimation()
            }
             //print(success ? "SUCCESS!" : "FAILURE")
        }

        present(ac, animated: true)
    }
    private func generatePicture() -> UIImage {
        return gridView.asImage()
    }
    private func moveGridAnimation() {
        gridAnimation(moveGrid())
    }
    private func moveGrid() -> CGAffineTransform {
        var translationX: CGFloat
        var translationY: CGFloat
        if UIDevice.current.orientation.isPortrait {
            let height = UIScreen.main.bounds.height
            translationY = -height
            translationX = 0
        } else {
            let width = UIScreen.main.bounds.width
            translationX = -width
            translationY = 0
        }
        let translation = CGAffineTransform(translationX: translationX, y: translationY)
        return translation
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
