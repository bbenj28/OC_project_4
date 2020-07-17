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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var gridView: GridView!
    @IBOutlet var picSquares: [PicSquaresViews]!
    @IBOutlet var layoutsButtons: [UIImageView]!
    @IBOutlet var layoutsSelectedViews: [UIImageView]!
    
        // MARK: Viewdidload
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLayoutAndSquares(nil)
        swipesCreation()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reduceSquaresBeforeAppearance()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        resizeSquaresWithAnimation()
    }
    private func reduceSquaresBeforeAppearance() {
        for i in 0...3 {
            picSquares[i].transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        }
    }
    private func resizeSquaresWithAnimation() {
        UIView.animate(withDuration: 0.9, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            for i in 0...3 {
                self.picSquares[i].transform = .identity
            }
        }, completion: nil)
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
    /// - Parameter index: Index of the choosen layout (0...2). *nil* to update squares without changing layout
    private func updateLayoutAndSquares(_ index: Int?) {
        if let indexOk = index {
            grid.changeSelectedLayout(indexOk)
            updateLayouts()
        }
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
        unHideAllSquares()
        setLayouts()
        settedLayoutsAnimation()
        hideSquaresIfNeeded()
    }
    private func unHideAllSquares() {
        for i in 0...3 {
            picSquares[i].isHidden = false
        }
    }
    private func setLayouts() {
        for i in 0...3 {
            picSquares[i].setLayout(grid.picSquares[i])
        }
    }
    private func hideSquaresIfNeeded() {
        for i in 0...3 {
            picSquares[i].isHidden = grid.picSquares[i].isHidden
        }
    }
    private func settedLayoutsAnimation() {
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.gridView.layoutIfNeeded()
            for i in 0...3 {
                self.picSquares[i].layoutIfNeeded()
                self.picSquares[i].setPicture(self.grid.picSquares[i])
            }
        }, completion: nil)
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
            activityIndicator.startAnimating()
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
        imagePicker.isModalInPopover = true
        imagePicker.modalPresentationStyle = .fullScreen
        present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // an image is selected, dismiss picker and display it in the selected PicSquare
        self.dismiss(animated: true, completion: {
            let image = info[UIImagePickerController.InfoKey.originalImage]
            let picSquare = self.grid.picSquares[self.grid.selectedSquare!]
            picSquare.pictureIsSelected = true
            self.picSquares[self.grid.selectedSquare!].changePicture(image as! UIImage)
            self.activityIndicator.stopAnimating()
        })
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: {
            self.activityIndicator.stopAnimating()
        })
    }
    
}


// MARK: Swipe and share
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
            activityIndicator.startAnimating()
            checkIfGridIsReadyToShare()
        }
    }
    /// Check if all squares received a picture, and launch share process.
    private func checkIfGridIsReadyToShare() {
        if grid.isReadyToShare {
            makeGridDisappearAndShareIt()
        } else {
            activityIndicator.stopAnimating()
            displayingAlert(title: "Choose pictures", text: "All squares have to be full in the choosen layout. Please, choose pictures.")
        }
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
    private func makeGridDisappearAndShareIt() {
        UIView.animate(withDuration: 0.3, animations: {
            self.gridView.transform = self.gridDisappearance()
        }, completion: { (finished: Bool) in
            if finished {
                self.generateAndSharePicture()
            }
        })
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
            self.activityIndicator.stopAnimating()
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
