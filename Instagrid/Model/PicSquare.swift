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

    var isHidden: Bool {
        return disposition == .hidden
    }

    var disposition: SquareDisposition

    var pictureUrl: URL?

    // MARK: - Init

    init(disposition: SquareDisposition) {
        self.disposition = disposition
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

// MARK: - Inheritance

class TopLeftPicSquare: PicSquare {
    init() {
        super.init(disposition: .topAllWidth)
    }
}
class TopRightPicSquare: PicSquare {
    init() {
        super.init(disposition: .hidden)
    }
}
class BottomLeftPicSquare: PicSquare {
    init() {
        super.init(disposition: .bottomLeft)
    }
}
class BottomRightPicSquare: PicSquare {
    init() {
        super.init(disposition: .bottomRight)
    }
}
