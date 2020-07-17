//
//  PickPicViewController.swift
//  Instagrid
//
//  Created by Benjamin Breton on 14/07/2020.
//  Copyright © 2020 InstaApps. All rights reserved.
//

import UIKit
// CONTROLLER used to choose layouts, picture and share grid
// MARK: Init
class PickPicViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
        // MARK: Properties
    var imagePicker = UIImagePickerController()
    let grid = Grid()
    
        // MARK: Outlets
    @IBOutlet weak var gridView: GridView!
    @IBOutlet var picSquares: [PicSquaresViews]!
    @IBOutlet var layoutsButtons: [UIImageView]!
    @IBOutlet var layoutsSelectedViews: [UIImageView]!
    
        // MARK: Viewdidload
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLayoutAndSquares(0)
        swipesCreation()
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
    /// Update grid based on choosen layout.
    /// - Parameter index: Index of the choosen layout.
    private func layoutIsSelected(_ index: Int) {
        if index != grid.selectedLayout {
            updateLayoutAndSquares(index)
        }
    }
    
        // MARK: Change disposition
    /// Update grid based on choosen layout, and update squares based on choosen layout and pictures.
    /// - Parameter index: Index of the choosen layout. *nil* to update squares without changing layout
    private func updateLayoutAndSquares(_ index: Int?) {
        grid.changeSelectedLayout(index)
        updateLayouts()
        updateSquares()
    }
    private func updateLayouts() {
        for i in 0...2 {
            // hide or show the check mark
            if grid.selectedLayout == i {
                layoutsSelectedViews[i].isHidden = false
            } else {
                layoutsSelectedViews[i].isHidden = true
            }
        }
    }
    private func updateSquares() {
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
        // if the photos album is available, ask to pick picture
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            imagePickerInit()
        } else {
            displayingAlert(title: "Photos album not available", text: "The photos album is not available. The application can not add pictures.")
        }
    }
    
        // MARK: Image picker
    private func imagePickerInit() {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // an image is selected, dismiss picker and display it in the selected PicSquare
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
    /// Create an up swipe for portrait oriented device, and a left swipe for landscape oriented device.
    private func swipesCreation() {
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(_:)))
        upSwipe.direction = .up
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(_:)))
        leftSwipe.direction = .left
        view.addGestureRecognizer(upSwipe)
        view.addGestureRecognizer(leftSwipe)
    }
    @objc func swipeAction(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == swipeDirectionNeeded() {
            checkIfGridIsReadyToShare()
        }
    }
    /// Check if all squares received a picture, and launch share process.
    private func checkIfGridIsReadyToShare() {
        if grid.isReadyToShare {
            prepareToShare()
        } else {
            displayingAlert(title: "Choose pictures", text: "All squares have to be full in the choosen layout. Please, choose pictures.")
        }
    }
    private func prepareToShare() {
        makeGridDisappear()
        generateAndSharePicture()
    }
    
        // MARK: Device's orientation
    /// Returns the swipe direction based on device's orientation.
    /// - Returns: *.up* for a portrait oriented device, *.left* for a landscape oriented device.
    private func swipeDirectionNeeded() -> UISwipeGestureRecognizer.Direction? {
        if deviceOrientation(.portraitUpsideDown) || deviceOrientation(.portrait) {
            return .up
        }
        if deviceOrientation(.landscapeLeft) || deviceOrientation(.landscapeRight) {
            return .left
        }
        return nil
    }
    /// Check if the needed orientation is the actual device's orientation.
    /// - Parameter orientation: The needed orientation.
    /// - Returns: *true* if the needed orientation is the actual device's orientation, *false* otherwise.
    private func deviceOrientation(_ orientation: UIDeviceOrientation) -> Bool {
        return UIDevice.current.orientation == orientation
    }
    
        // MARK: Grid Animations
                // Grid disappearance
    /// Make grid disappear if ready to share.
    private func makeGridDisappear() {
        gridAnimation(gridDisappearance())
    }
    private func gridDisappearance() -> CGAffineTransform {
        let translations = getTranslationsXYBasedOnDeviceOrientation()
        let translation = CGAffineTransform(translationX: translations[0], y: translations[1])
        return translation
    }
    private func getTranslationsXYBasedOnDeviceOrientation() -> [CGFloat] {
        if deviceOrientation(.portrait) || deviceOrientation(.portraitUpsideDown) {
            let height = UIScreen.main.bounds.height
            return [0, -height]
        } else {
            let width = UIScreen.main.bounds.width
            return [-width, 0]
        }
    }
                // Grid is back
    /// Delete grid's pictures and make it come back.
    private func returnDeletedGridAnimation() {
        grid.delete()
        updateLayoutAndSquares(nil)
        returnGridAnimation()
    }
    /// Make grid come back.
    private func returnGridAnimation() {
        gridAnimation(.identity)
    }
                // Animation
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
    /// Ask the grid view to generate a single picture.
    /// - Returns: The UIImage generated.
    private func generatePicture() -> UIImage {
        return gridView.asImage()
    }
    /// Launch UIActivityController to share picture.
    /// - Parameter image: The generated UIImage to share.
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
    /// Display an alert with an unique answer: *OK*.
    /// - Parameter title: Title of the alert.
    /// - Parameter text : Message to display in the alert's box.
    func displayingAlert(title:String, text:String){
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}
