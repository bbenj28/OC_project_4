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
    var isHidden: Bool {
        return disposition == .hidden
    }
    var disposition: SquareDisposition
    let id: Int
    var pictureUrl: URL?
    init(disposition: SquareDisposition, id: Int) {
        self.disposition = disposition
        self.id = id
    }
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
