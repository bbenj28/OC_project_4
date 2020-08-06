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
    
    var selectedSquareForPicture: Int?

    var swipeDirection: UISwipeGestureRecognizer.Direction {
        if UIDevice.current.orientation == .portrait || UIDevice.current.orientation == .portraitUpsideDown {
            return .up
        } else {
            return .left
        }
    }
    
    // MARK: - Outlets
    
    @IBOutlet var swipe: UISwipeGestureRecognizer!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet var picSquareButton: [PicSquareView]!
    
    @IBOutlet weak var gridView: UIView!
    
    @IBOutlet var layoutButton: [UIButton]!
    
    // MARK: - View appearance
    
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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        swipe.direction = swipeDirection
    }
 
 
 
}

// MARK: - Choose layout

extension PickPicViewController {
    
    // MARK: - Layouts buttons
    
    /// Action when a layout's button is hitten.
    /// - Parameter sender: The layout's button.
    @IBAction func layoutSelection(_ sender: UIButton) {
        for i in 0...2 {
            layoutButton[i].isSelected = false
            if sender == layoutButton[i] {
                sender.isSelected = true
                layoutIsSelected(i)
            }
        }
    }
    
    /// Update grid based on choosen layout.
    /// - Parameter index: Index of the choosen layout.
    private func layoutIsSelected(_ index: Int) {
        if grid.changeSelectedLayout(index) {
            animationWithSpring({
                self.updateSquaresButtons()
            }, next: nil)
            //updateSquaresButtons()
        }
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
        // if the photos album is available, ask to pick picture
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            selectedSquareForPicture = index
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
        if let index = selectedSquareForPicture {
            if self.picSquareButton[index].displayImage(image) == false {
                self.imageViewInPicSquareButtonError()
            } else {
                grid.picSquares[index].hasPicture = true
            }
        }
    }
    
}

// MARK: - Swipe and share

extension PickPicViewController {

    /// Action to do when a left or up swipe is recognized.
    @IBAction func swipeActionBis(_ sender: UISwipeGestureRecognizer) {
        activityIndicator.startAnimating()
        if grid.isReadyToShare {
            makeGridDisappearAndShareIt()
        } else {
            stopSharing()
        }
    }
        
    /// Grid is not ready to share : display alert and stop sharing.
    private func stopSharing() {
        activityIndicator.stopAnimating()
        displayingAlert(title: "Choose pictures", text: "All squares have to be full in the choosen layout. Please, choose pictures.")
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
