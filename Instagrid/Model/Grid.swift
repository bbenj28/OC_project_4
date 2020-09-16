//
//  PicDisposition.swift
//  Instagrid
//
//  Created by Benjamin Breton on 13/07/2020.
//  Copyright © 2020 InstaApps. All rights reserved.
//

import Foundation
/// Class of the grid, used to change its disposition when a layout is selected by user, to get its picSquare's informations,  and to know if the grid is ready to share.
class Grid {
    
    // MARK: - Properties
    
    /// Squares contained by the grid.
    let picSquares: [PicSquare] = [PicSquare(), PicSquare(), PicSquare(), PicSquare()]
    
    /// Layout which is actually displayed.
    var selectedLayout: Layout = .layout2
    
    /// All possible layouts.
    let layouts: [Layout] = [.layout0, .layout1, .layout2]
    
    /// Check if pictures have been selected for all displayed picSquares in grid. Returns *true* if they have, *false* otherwise.
    var isReadyToShare: Bool {
        for i in 0...3 {
            if selectedLayout.isHiddenSquare(i) == false && picSquares[i].hasPicture == false {
                return false
            }
        }
        return true
    }
    
    // MARK: - Methods
    
    /// Change selected layout in grid properties, and change picSquares disposition.
    /// - Parameter index: Index of the choosen layout (0...2).
    func changedSelectedLayout(to index: Int) {
        if selectedLayout != layouts[index] {
            selectedLayout = layouts[index]
            for i in 0...3 {
                picSquares[i].isHidden = selectedLayout.isHiddenSquare(i)
            }
            let notificationName = Notification.Name("newLayout")
            let notification = Notification(name: notificationName)
            NotificationCenter.default.post(notification)
        }
    }
    
    /// Delete pictures in all picSquares.
    func delete() {
        for i in 0...3 {
            picSquares[i].hasPicture = false
        }
    }
}
