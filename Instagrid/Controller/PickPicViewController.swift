//
//  PickPicViewController.swift
//  Instagrid
//
//  Created by Benjamin Breton on 14/07/2020.
//  Copyright © 2020 InstaApps. All rights reserved.
//

import UIKit

final class PickPicViewController: UIViewController {
    
    // MARK: - Properties
    
    private let imagePicker = UIImagePickerController()
    private let grid = Grid()
    private var selectedSquareForPicture: Int?
    private var swipeDirection: UISwipeGestureRecognizer.Direction {
        if UIDevice.current.orientation == .portrait || UIDevice.current.orientation == .portraitUpsideDown {
            return .up
        } else {
            return .left
        }
    }
    
    // MARK: - Outlets
    
    @IBOutlet private var swipe: UISwipeGestureRecognizer!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var picSquareButton: [PicSquareView]!
    @IBOutlet private weak var gridView: UIView!
    @IBOutlet private var layoutButton: [UIButton]!
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // select first layout's button and change layout
        layoutSelection(layoutButton[0])
        // change swipe direction regarding UIScreen's bounds
        if UIScreen.main.bounds.width > UIScreen.main.bounds.height {
            swipe.direction = .left
        } else {
            swipe.direction = .up
        }
        // add observers for share notifications
        NotificationCenter.default.addObserver(self, selector: #selector(returnDeletedGridAnimation), name: Notification.Name(rawValue: "DeleteGrid"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(returnGridAnimation), name: Notification.Name(rawValue: "KeepGrid"), object: nil)
        // prepare appearance animation
        reductionTransformation(picSquareButton, animation: false, completion: nil)
    }
    
    // MARK: - viewDidAppear
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // launch appearance animation
        identityTransformation(picSquareButton, animation: true, completion: nil)
    }
    
    // MARK: - swipe transition
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        swipe.direction = swipeDirection
    }
    
    // MARK: - Choose layout
    
    /// Action when a layout's button is hitten.
    /// - Parameter sender: The layout's button.
    @IBAction func layoutSelection(_ sender: UIButton) {
        for i in 0...2 {
            layoutButton[i].isSelected = false
            // check which layout has been selected
            if sender == layoutButton[i] {
                sender.isSelected = true
                layoutIsSelected(i)
            }
        }
    }
    
    /// Update grid based on choosen layout.
    /// - Parameter index: Index of the choosen layout.
    private func layoutIsSelected(_ index: Int) {
        // check if grid changed selected layout to eventually update squares buttons
        if grid.changedSelectedLayout(to: index) {
            animationWithSpring({
                self.updateSquaresButtons()
            }, next: nil)
        }
    }
    
    /// Layout has been changed, so buttons have to change too.
    private func updateSquaresButtons() {
        for i in 0...3 {
            if picSquareButton[i].setView(grid.picSquares[i]) == false {
                imageViewInPicSquareButtonError()
            }
        }
    }
    
    // MARK: - Choose Picture
    
    /// Action when a picSquare's Button is hitten.
    /// - Parameter sender: The picSquare's Button.
    @IBAction func picSquareSelection(_ sender: PicSquareView) {
        sender.isSelected = true
        // check which button has been hitten and ask for change picture in this button.
        for i in 0...3 {
            if picSquareButton[i] == sender {
                askForChangePictureInPicSquares(i)
                break
            }
        }
    }
    
    /// Ask user to choose an image in the imagePicker.
    /// - parameter index: Index of the hitten button.
    private func askForChangePictureInPicSquares(_ index: Int) {
        // if the photos album is available, ask to pick picture
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            // save the button's index
            selectedSquareForPicture = index
            // launch activity indicator
            activityIndicator.startAnimating()
            // animate the view and launch image picker
            reductionTransformation(picSquareButton, animation: true, completion: { _ in
                self.launchImagePicker()
            })
        } else {
            picSquareButton[index].isSelected = false
            displayingAlert(title: "Photos album not available", text: "The photos album is not available. The application can not add pictures.")
        }
    }
    
    /// Handle return from imagePicker.
    /// - parameter image: Image which has been selected by the user. If no image has been selected, returns *nil*.
    private func updatePicSquareWithSelection(_ image: UIImage?) {
        // get selected button's index
        if let index = selectedSquareForPicture {
            // check if an image has been selected
            if let verifiedImage = image {
                // check if the button's imageView exists and change button's image.
                if self.picSquareButton[index].displayImage(verifiedImage) == false {
                    self.imageViewInPicSquareButtonError()
                } else {
                    // tell grid that an image has been selected for this button
                    grid.picSquares[index].hasPicture = true
                }
            } else {
                picSquareButton[index].isSelected = false
            }
        }
    }
    
    // MARK: - Swipe and share
    
    /// Action to do when a left or up swipe is recognized.
    /// - parameter sender: The swipe gesture.
    @IBAction func swipeAction(_ sender: UISwipeGestureRecognizer) {
        // check if all pictures have been selected.
        if grid.isReadyToShare {
            activityIndicator.startAnimating()
            // grid disappears and launch activity controller
            gridDisappearance(gridView, completion: { (finished: Bool) in
                if finished {
                    self.sharePicture(self.gridView.image)
                }
            })
        } else {
            displayingAlert(title: "Choose pictures", text: "All squares have to be full in the choosen layout. Please, choose pictures.")
        }
    }
    
    /// Delete grid's pictures and make it come back.
    @objc private func returnDeletedGridAnimation() {
        grid.delete()
        updateSquaresButtons()
        returnGridAnimation()
    }
    
    /// Make grid come back.
    @objc private func returnGridAnimation() {
        activityIndicator.stopAnimating()
        identityTransformation([gridView], animation: true, completion: nil)
    }
}

extension PickPicViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    /// ImagePicker's parameters modification, and present it.
    private func launchImagePicker() {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        imagePicker.isModalInPopover = true
        imagePicker.modalPresentationStyle = .fullScreen
        present(imagePicker, animated: true, completion: nil)
    }
    
    /// Actions to do when a picture is selected.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // an image is selected, dismiss picker and display it in the selected PicSquare
        dismiss(animated: true, completion: {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                self.updatePicSquareWithSelection(image)
            } else {
                self.updatePicSquareWithSelection(nil)
            }
            self.activityIndicator.stopAnimating()
        })
    }
    
    /// Actions to do when user did hit the cancel button.
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: {
            self.updatePicSquareWithSelection(nil)
            self.activityIndicator.stopAnimating()
        })
    }
}
