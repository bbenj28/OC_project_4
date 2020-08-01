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
    static let picSquares: [PicSquare] = [PicSquare(), PicSquare(), PicSquare(), PicSquare()]
    
    /// Layout which is actually displayed
    static var selectedLayout: Int = 0
    
    /// PicSquare's index which is selected for a picture to add.
    static var selectedSquare: Int?
    
    /// Returns picSquares dispositions regarding selected layout.
    static private var picSquaresHiddenDisposition: [Bool] {
        switch selectedLayout {
        case 0:
            return [false, true, false, false]
        case 1:
            return [false, false, false, true]
        default:
            return [false, false, false, false]
        }
    }
    
    /// Check if pictures have been selected for all displayed picSquares in grid. Returns *true* if they have, *false* otherwise.
    static var isReadyToShare: Bool {
        for i in 0...3 {
            if picSquaresHiddenDisposition[i] == false && picSquares[i].pictureUrl == nil {
                return false
            }
        }
        return true
    }
    
    // MARK: - Methods
    
    /// Change selected layout in grid properties, and change picSquares disposition.
    /// - Parameter index: Index of the choosen layout (0...2).
    static func changeSelectedLayout(_ index: Int) {
        selectedLayout = index
        selectedSquare = nil
        for i in 0...3 {
            picSquares[i].isHidden = picSquaresHiddenDisposition[i]
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
