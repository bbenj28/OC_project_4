//
//  PickPicViewController.swift
//  Instagrid
//
//  Created by Benjamin Breton on 14/07/2020.
//  Copyright © 2020 InstaApps. All rights reserved.
//

import UIKit
// MARK: Init
class PickPicViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
        // MARK: Properties
    var imagePicker = UIImagePickerController()
    let grid = Grid()
    
        // MARK: Outlets
    @IBOutlet weak var swipeInstructionsLabel: UILabel!
    @IBOutlet weak var gridView: GridView!
    @IBOutlet var picSquares: [PicSquaresViews]!
    @IBOutlet var layoutsButtons: [UIImageView]!
    @IBOutlet var layoutsSelectedViews: [UIImageView]!
    
        // MARK: Viewdidload
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLayoutAndSquares(0)
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        swipeInstructionsLabel.text = swipeInstructionsText()
    }
}

extension PickPicViewController {
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        swipeInstructionsLabel.text = swipeInstructionsText()
    }
    func swipeInstructionsText() -> String {
        switch UIDevice.current.orientation {
        case .portrait, .portraitUpsideDown:
            return "Swipe up to share"
        case .landscapeLeft, .landscapeRight :
            return "Swipe left to share"
        default:
            return ""
        }
    }
}

// MARK: Choose layout
extension PickPicViewController {
    
    
        // MARK: Layouts buttons
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
        if index != grid.selectedLayout {
            updateLayoutAndSquares(index)
        }
    }
    
        // MARK: Change disposition
    private func updateLayoutAndSquares(_ index: Int?) {
        grid.changeDisposition(index)
        for i in 0...2 {
            if grid.selectedLayout == i {
                layoutsSelectedViews[i].isHidden = false
            } else {
                layoutsSelectedViews[i].isHidden = true
            }
        }
        for i in 0...3 {
            picSquares[i].setView(grid.picSquares[i])
        }
        
    }
}

// MARK: Choose pictures
extension PickPicViewController {
    
    
        // MARK: Squares buttons
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
        grid.selectedSquare = index
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            imagePickerInit()
        } else {
            displayingAlert(title: "Photos album not available", text: "The photos album is not available. The application can not add pictures.")
        }
        
    }
    
        // MARK: Image picker
    func imagePickerInit() {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        self.dismiss(animated: true, completion: {
            let image = info[UIImagePickerController.InfoKey.originalImage]
            let picSquare = self.grid.picSquares[self.grid.selectedSquare!]
            picSquare.pictureIsSelected = true
            self.picSquares[self.grid.selectedSquare!].changePicture(image as! UIImage)
        })
    }
}


// MARK: Swipe to share
extension PickPicViewController {
    
    
        // MARK: Swipes
    @IBAction func swipeUpGestureRecognized(_ sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            if UIDevice.current.orientation.isPortrait {
                swipeActions()
            }
        }
    }
    private func swipeActions() {
        if grid.gridIsReadyToShare {
            moveGridAnimation()
            generateAndSharePicture()
        } else {
            displayingAlert(title: "Choose pictures", text: "All squares have to be full in the choosen layout. Please, choose pictures.")
        }
    }
    
        // MARK: Grid Animations
    private func moveGridAnimation() {
        gridAnimation(gridDisparition())
    }
    private func gridDisparition() -> CGAffineTransform {
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
    private func returnDeletedGridAnimation() {
        grid.delete()
        updateLayoutAndSquares(nil)
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
    
        // MARK: Generate and share
    private func generateAndSharePicture() {
        let image = generatePicture()
        sharePicture(image)
    }
    private func generatePicture() -> UIImage {
        return gridView.asImage()
    }
    private func sharePicture(_ image: UIImage) {
        let ac = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        ac.completionWithItemsHandler = { (activity, success, items, error) in
            if success {
                self.returnDeletedGridAnimation()
            } else {
                self.returnGridAnimation()
            }
        }
        present(ac, animated: true)
    }
}

// MARK: Alert
extension PickPicViewController {
    func displayingAlert(title:String, text:String){
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}
