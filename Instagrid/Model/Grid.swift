//
//  PicDisposition.swift
//  Instagrid
//
//  Created by Benjamin Breton on 13/07/2020.
//  Copyright © 2020 InstaApps. All rights reserved.
//

import Foundation
/// Class of the grid, used to change its disposition when a layout is selected by user, to know which square is choosen for a picture selection, and to know if the grid is ready to share.
class Grid {
    let picSquares: [PicSquare] = [TopLeftPicSquare(), TopRightPicSquare(), BottomLeftPicSquare(), BottomRightPicSquare()]
    var selectedLayout: Int = 0
    var selectedSquare: Int?
    private var displayedPicSquaresInGrid: [Int] {
        switch selectedLayout {
        case 0:
            return [0, 2, 3]
        case 1:
            return [0, 1, 2]
        case 2:
            return [0, 1, 2, 3]
        default:
            return []
        }
    }
    var isReadyToShare: Bool {
        if displayedPicSquaresInGrid.count > 0 {
            for i in 0...displayedPicSquaresInGrid.count - 1 {
                let index = displayedPicSquaresInGrid[i]
                if picSquares[index].pictureIsSelected == false {
                    return false
                }
            }
            return true
        } else {
            return false
        }
    }
    /// Change selected layout in grid properties, and change picSquares disposition.
    /// - Parameter index: Index of the choosen layout (0...2).
    func changeSelectedLayout(_ index: Int) {
        selectedLayout = index
        selectedSquare = nil
        switch selectedLayout {
        case 0:
            firstDisposition()
        case 1:
            secondDisposition()
        case 2:
            thirdDisposition()
        default:
            break
        }
    }
    private func firstDisposition() {
        picSquares[0].disposition = .topAllWidth
        picSquares[1].disposition = .hidden
        picSquares[2].disposition = .bottomLeft
        picSquares[3].disposition = .bottomRight
    }
    private func secondDisposition() {
        picSquares[0].disposition = .topLeft
        picSquares[1].disposition = .topRight
        picSquares[2].disposition = .bottomAllWidth
        picSquares[3].disposition = .hidden
    }
    private func thirdDisposition() {
        picSquares[0].disposition = .topLeft
        picSquares[1].disposition = .topRight
        picSquares[2].disposition = .bottomLeft
        picSquares[3].disposition = .bottomRight
    }
    /// Delete pictures in all picSquares.
    func delete() {
        for i in 0...3 {
            picSquares[i].pictureIsSelected = false
        }
    }
    func pictureIsSelectedForPicSquare() -> Int {
        let picSquare = picSquares[selectedSquare!]
        picSquare.pictureIsSelected = true
        return selectedSquare!
    }
}
