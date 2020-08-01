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
    var pictureUrl: URL?
    init(disposition: SquareDisposition) {
        self.disposition = disposition
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
