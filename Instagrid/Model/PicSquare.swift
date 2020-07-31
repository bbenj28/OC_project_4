//
//  PicSquare.swift
//  Instagrid
//
//  Created by Benjamin Breton on 13/07/2020.
//  Copyright © 2020 InstaApps. All rights reserved.
//

import Foundation
/// Class of squares which will contain a picture.
class PicSquare {
    var pictureIsSelected: Bool = false
    var isHidden: Bool {
        if disposition == .hidden {
            return true
        } else {
            return false
        }
    }
    var disposition: SquareDisposition
    let id: Int
    init(disposition: SquareDisposition, id: Int) {
        self.disposition = disposition
        self.id = id
    }
}
class TopLeftPicSquare: PicSquare {
    init() {
        super.init(disposition: .topAllWidth, id: 0)
    }
}
class TopRightPicSquare: PicSquare {
    init() {
        super.init(disposition: .hidden, id: 1)
    }
}
class BottomLeftPicSquare: PicSquare {
    init() {
        super.init(disposition: .bottomLeft, id: 2)
    }
}
class BottomRightPicSquare: PicSquare {
    init() {
        super.init(disposition: .bottomRight, id: 3)
    }
}
