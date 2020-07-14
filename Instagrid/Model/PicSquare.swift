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
    var width: Float {
        switch disposition {
        case .topLeft, .topRight, .bottomLeft, .bottomRight:
            return 127.5
        case .topAllWidth, .bottomAllWidth:
            return 270
        }
    }
    let height: Float = 127.5
    var disposition: SquareDisposition
    init(isHidden: Bool, disposition: SquareDisposition) {
        self.isHidden = isHidden
        self.disposition = disposition
    }
}
class TopLeftPicSquare: PicSquare {
    init() {
        super.init(isHidden: false, disposition: .topLeft)
    }
}
class TopRightPicSquare: PicSquare {
    init() {
        super.init(isHidden: false, disposition: .topRight)
    }
}
class BottomLeftPicSquare: PicSquare {
    init() {
        super.init(isHidden: false, disposition: .bottomAllWidth)
    }
}
class BottomRightPicSquare: PicSquare {
    init() {
        super.init(isHidden: true, disposition: .bottomRight)
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
