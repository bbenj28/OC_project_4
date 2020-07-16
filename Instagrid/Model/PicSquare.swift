//
//  PicSquare.swift
//  Instagrid
//
//  Created by Benjamin Breton on 13/07/2020.
//  Copyright © 2020 InstaApps. All rights reserved.
//

import Foundation
class PicSquare {
    var pictureIsSelected: Bool = false
    var isHidden: Bool
    var disposition: SquareDisposition
    let id: Int
    init(isHidden: Bool, disposition: SquareDisposition, id: Int) {
        self.isHidden = isHidden
        self.disposition = disposition
        self.id = id
    }
}
class TopLeftPicSquare: PicSquare {
    init() {
        super.init(isHidden: false, disposition: .topLeft, id: 0)
    }
}
class TopRightPicSquare: PicSquare {
    init() {
        super.init(isHidden: false, disposition: .topRight, id: 1)
    }
}
class BottomLeftPicSquare: PicSquare {
    init() {
        super.init(isHidden: false, disposition: .bottomAllWidth, id: 2)
    }
}
class BottomRightPicSquare: PicSquare {
    init() {
        super.init(isHidden: true, disposition: .bottomRight, id: 3)
    }
}

enum SquareDisposition {
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
    case topAllWidth
    case bottomAllWidth
}
