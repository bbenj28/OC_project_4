//
//  PicSquare.swift
//  Instagrid
//
//  Created by Benjamin Breton on 13/07/2020.
//  Copyright © 2020 InstaApps. All rights reserved.
//

import Foundation

// MARK: - Mother class

/// Class of squares which will contain a picture.
class PicSquare {
    
    // MARK: - Properties
    
    var isHidden: Bool
    
    var pictureUrl: URL?
    
    // MARK: - Init
    
    init() {
        self.isHidden = false
    }
    
    // MARK: - Picture's data
    
    /// Ask for button's image's data.
    /// - returns: Button's image's data if a picture is selected, *nil* otherwise.
    func imageButton() -> Data? {
        if let verifiedUrl = pictureUrl {
            if let data = NSData(contentsOf: verifiedUrl) as Data? {
                return data
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}
