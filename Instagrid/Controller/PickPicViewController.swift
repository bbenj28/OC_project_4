//
//  PickPicViewController.swift
//  Instagrid
//
//  Created by Benjamin Breton on 14/07/2020.
//  Copyright © 2020 InstaApps. All rights reserved.
//

import UIKit

// MARK: - Init
class PickPicViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    // MARK: - Properties

    var imagePicker = UIImagePickerController()

    // MARK: - Outlets

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet var picSquareButton: [PicSquareView]!
    
    @IBOutlet weak var gridView: GridView!
    
    @IBOutlet var layoutButton: [UIButton]!

    // MARK: - View appearance

    override func viewDidLoad() {
        super.viewDidLoad()
        // select first layout's button and change layout
        updateLayoutAndSquares(0)
        // create swipes to share
        swipesCreation()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // prepare appearance animation
        prepareAppearance()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // launch appearance animation
        appearanceAnimation()
    }
    
    /// For each button, change its size with a 0.2 scale.
    private func prepareAppearance() {
        for i in 0...3 {
            picSquareButton[i].transform = transformForAppearance()
        }
        for i in 0...2 {
            layoutButton[i].transform = transformForAppearance()
        }
    }
    private func transformForAppearance() -> CGAffineTransform {
        return CGAffineTransform(scaleX: 0.2, y: 0.2)
    }
    
    /// Animate buttons appearance from a 0.2 scale to identity.
    private func appearanceAnimation() {
        UIView.animate(withDuration: 0.9, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.picSquaresAppearance()
            self.layoutsButtonsAppearance()
        }, completion: nil)
    }
    private func picSquaresAppearance() {
        for i in 0...3 {
            picSquareButton[i].transform = .identity
        }
    }
    private func layoutsButtonsAppearance() {
        for i in 0...2 {
            self.layoutButton[i].transform = .identity
        }
    }

}

// MARK: - Choose layout

extension PickPicViewController {

    // MARK: - Layouts buttons

    /// Action when a layout's button is hitten.
    /// - Parameter sender: The layout's button.
    @IBAction func layoutSelection(_ sender: UIButton) {
        for i in 0...2 {
            if sender == layoutButton[i] {
                layoutIsSelected(i)
            }
        }
    }

    /// Update grid based on choosen layout.
    /// - Parameter index: Index of the choosen layout.
    private func layoutIsSelected(_ index: Int) {
        if index != Grid.selectedLayout {
            updateLayoutAndSquares(index)
        }
    }

    // MARK: - Change disposition
    
    /// Update grid based on choosen layout, and update squares based on choosen layout and pictures.
    /// - Parameter index: Index of the choosen layout (0...2). *nil* to update squares without changing layout
    private func updateLayoutAndSquares(_ index: Int?) {
        if let indexOk = index {
            Grid.changeSelectedLayout(indexOk)
            updateLayoutsButtons()
        }
        updateSquaresButtons()
    }
    private func updateLayoutsButtons() {
        for i in 0...2 {
            // hide or show the check mark
            if Grid.selectedLayout == i {
                layoutButton[i].isSelected = true
            } else {
                layoutButton[i].isSelected = false
            }
        }
    }
    private func updateSquaresButtons() {
        for i in 0...3 {
            picSquareButton[i].setView(Grid.picSquares[i])
        }
    }
}

// MARK: - Choose pictures

extension PickPicViewController {

    // MARK: - Squares buttons
    
    /// Action when a picSquare's Button is hitten.
    /// - Parameter sender: The picSquare's Button.
    @IBAction func picSquareSelection(_ sender: PicSquareView) {
        sender.isSelected = true
        for i in 0...3 {
            if picSquareButton[i] == sender {
                askForChangePictureInPicSquares(i)
            }
        }
    }
    private func askForChangePictureInPicSquares(_ index: Int) {
        Grid.selectedSquare = index
        // if the photos album is available, ask to pick picture
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            activityIndicator.startAnimating()
            imagePickerInit()
        } else {
            displayingAlert(title: "Photos album not available", text: "The photos album is not available. The application can not add pictures.")
        }
    }
    
    // MARK: - Image picker

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
            if let link = info[UIImagePickerController.InfoKey.imageURL] as? URL {
                if let index = Grid.pictureIsSelectedForPicSquare(link) {
                    self.picSquareButton[index].setView(Grid.picSquares[index])
                }
            }
            self.activityIndicator.stopAnimating()
        })
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: {
            if let index = Grid.pictureIsSelectedForPicSquare(nil) {
                self.picSquareButton[index].setView(Grid.picSquares[index])
            }
            self.activityIndicator.stopAnimating()
        })
    }
    
}

// MARK: - Swipe and share

extension PickPicViewController {

    // MARK: - Swipes

    /// Create an up swipe for portrait oriented device, and a left swipe for landscape oriented device.
    private func swipesCreation() {
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(_:)))
        upSwipe.direction = .up
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(_:)))
        leftSwipe.direction = .left
        view.addGestureRecognizer(upSwipe)
        view.addGestureRecognizer(leftSwipe)
    }
    /// Action to do when a left or up swipe is recognized.
    @objc func swipeAction(_ sender: UISwipeGestureRecognizer) {
        if let swipeDirectionNeeded = swipeDirectionNeeded() {
            if sender.direction == swipeDirectionNeeded {
                activityIndicator.startAnimating()
                if Grid.isReadyToShare {
                    makeGridDisappearAndShareIt()
                } else {
                    stopSharing()
                }
            }
        }
    }
    /// Grid is not ready to share : display alert and stop sharing.
    private func stopSharing() {
        activityIndicator.stopAnimating()
        displayingAlert(title: "Choose pictures", text: "All squares have to be full in the choosen layout. Please, choose pictures.")
    }

    // MARK: - Device's orientation

    /// Returns the swipe direction based on device's orientation.
    /// - Returns: *.up* for a portrait oriented device, *.left* for a landscape oriented device, *nil* otherwise.
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

    // MARK: - Grid disappearance

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

    // MARK: - Grid reappearance

    /// Delete grid's pictures and make it come back.
    private func returnDeletedGridAnimation() {
        Grid.delete()
        updateLayoutAndSquares(nil)
        returnGridAnimation()
    }
    /// Make grid come back.
    private func returnGridAnimation() {
        gridAnimation(.identity)
    }

    // MARK: - Grid animation

    /// Animate grid appearance and disappearance.
    private func gridAnimation(_ transform: CGAffineTransform) {
        UIView.animate(withDuration: 0.3, animations: {
            self.gridView.transform = transform
        })
    }

    // MARK: - Generate and share

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
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityController.completionWithItemsHandler = { (activity, success, items, error) in
            if success {
                self.returnDeletedGridAnimation()
            } else {
                self.returnGridAnimation()
            }
            self.activityIndicator.stopAnimating()
        }
        present(activityController, animated: true)
    }
}

// MARK: - Alert

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
