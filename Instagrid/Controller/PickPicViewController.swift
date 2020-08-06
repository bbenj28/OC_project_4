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

    let imagePicker = UIImagePickerController()
    
    let grid = Grid()

    // MARK: - Outlets

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet var picSquareButton: [PicSquareView]!
    
    @IBOutlet weak var gridView: UIView!
    
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
        reductionTransformation(picSquareButton, animation: false, completion: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // launch appearance animation
        identityTransformation(picSquareButton, animation: true, completion: nil)
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
                sender.isSelected = true
                layoutIsSelected(i)
            } else {
                sender.isSelected = false
            }
        }
    }

    /// Update grid based on choosen layout.
    /// - Parameter index: Index of the choosen layout.
    private func layoutIsSelected(_ index: Int) {
        if index != grid.selectedLayout {
            updateLayoutAndSquares(index)
        }
    }

    // MARK: - Change disposition
    
    /// Update grid based on choosen layout, and update squares based on choosen layout and pictures.
    /// - Parameter index: Index of the choosen layout (0...2). *nil* to update squares without changing layout
    private func updateLayoutAndSquares(_ index: Int?) {
        animationWithSpring({
            if let indexOk = index {
                self.grid.changeSelectedLayout(indexOk)
            }
            self.updateSquaresButtons()
        }, next: nil)
    }
    private func updateSquaresButtons() {
        for i in 0...3 {
            if picSquareButton[i].setView(grid.picSquares[i]) == false {
                imageViewInPicSquareButtonError()
            }
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
        grid.selectedSquare = index
        // if the photos album is available, ask to pick picture
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            activityIndicator.startAnimating()
            reductionTransformation(picSquareButton, animation: true, completion: { _ in
                self.imagePickerInit()
            })
        } else {
            picSquareButton[index].isSelected = false
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
    private func updatePicSquareWithSelection(_ image: UIImage?) {
        if let index = grid.pictureIsSelectedForPicSquare() {
            if self.picSquareButton[index].displayImage(image) == false {
                self.imageViewInPicSquareButtonError()
            }
        }
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
                if grid.isReadyToShare {
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
        gridDisappearance(gridView, completion: { (finished: Bool) in
            if finished {
                self.sharePicture(self.gridView.image)
            }
        })
    }

    // MARK: - Grid reappearance

    /// Delete grid's pictures and make it come back.
    private func returnDeletedGridAnimation() {
        grid.delete()
        updateLayoutAndSquares(nil)
        identityTransformation([gridView], animation: true, completion: nil)
    }
    /// Make grid come back.
    private func returnGridAnimation() {
        identityTransformation([gridView], animation: true, completion: nil)
    }

    // MARK: - Grid animation

    /// Animate grid appearance and disappearance.
    private func gridAnimation(_ transform: CGAffineTransform) {
        UIView.animate(withDuration: 0.3, animations: {
            self.gridView.transform = transform
        })
    }

    // MARK: - Share

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
    private func displayingAlert(title:String, text:String){
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    private func imageViewInPicSquareButtonError() {
        displayingAlert(title: "ERROR", text: "One or several picSquares buttons imageView return nil.")
    }
    
}
