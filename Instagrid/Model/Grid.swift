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

    // MARK: - Properties

    /// PicSquares contained by the grid.
    static let picSquares: [PicSquare] = [TopLeftPicSquare(), TopRightPicSquare(), BottomLeftPicSquare(), BottomRightPicSquare()]

    /// Layout which is actually displayed
    static var selectedLayout: Int = 0

    /// PicSquare's index which is selected for a picture to add.
    static var selectedSquare: Int?

    /// Returns picSquares dispositions regarding selected layout.
    static private var picSquaresDisposition: [SquareDisposition] {
        switch selectedLayout {
        case 0:
            return [.topAllWidth, .hidden, .bottomLeft, .bottomRight]
        case 1:
            return [.topLeft, .topRight, .bottomAllWidth, .hidden]
        case 2:
            return [.topLeft, .topRight, .bottomLeft, .bottomRight]
        default:
            return []
        }
    }

    /// Check if pictures have been selected for all displayed picSquares in grid. Returns *true* if they have, *false* otherwise.
    static var isReadyToShare: Bool {
        if picSquaresDisposition.count > 0 {
            for i in 0...3 {
                if picSquaresDisposition[i] != .hidden && picSquares[i].pictureUrl == nil {
                    return false
                }
            }
            return true
        } else {
            return false
        }
    }

    // MARK: - Methods

    /// Change selected layout in grid properties, and change picSquares disposition.
    /// - Parameter index: Index of the choosen layout (0...2).
    static func changeSelectedLayout(_ index: Int) {
        selectedLayout = index
        selectedSquare = nil
        for i in 0...3 {
            picSquares[i].disposition = picSquaresDisposition[i]
        }
    }

    /// Delete pictures in all picSquares.
    static func delete() {
        for i in 0...3 {
            picSquares[i].pictureUrl = nil
        }
    }
    
    /// Add selected picture's link in the selected picSquare's property, and return its index.
    /// - returns: Selected picSquare's index, *nil* if there's no selected picSquare.
    static func pictureIsSelectedForPicSquare(_ link: URL?) -> Int? {
        if let index = selectedSquare {
            if let verifiedLink = link {
                picSquares[index].pictureUrl = verifiedLink
            }
            return index
        } else {
            return nil
        }
    }
}
