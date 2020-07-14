//
//  PicDisposition.swift
//  Instagrid
//
//  Created by Benjamin Breton on 13/07/2020.
//  Copyright © 2020 InstaApps. All rights reserved.
//

import Foundation
class PicDisposition {
    let picSquares: [PicSquare] = [TopLeftPicSquare(), TopRightPicSquare(), BottomLeftPicSquare(), BottomRightPicSquare()]
    let selectedLayout: SelectedLayout
    init(layoutsPosition: [[String:Float]]) {
        selectedLayout = SelectedLayout(layoutsPosition: layoutsPosition)
        changeDisposition(1)
    }
    func changeDisposition(_ index: Int) {
        selectedLayout.index = index
        switch index {
        case 0:
            firstDisposition()
        case 1:
            secondDisposition()
        case 2:
            thirdDisposition()
        default:
            break
        }
    }
    private func firstDisposition() {
        picSquares[0].disposition = .topAllWidth
        picSquares[1].isHidden = true
        picSquares[2].disposition = .bottomLeft
        picSquares[3].isHidden = false
    }
    private func secondDisposition() {
        picSquares[0].disposition = .topLeft
        picSquares[1].isHidden = false
        picSquares[2].disposition = .bottomAllWidth
        picSquares[3].isHidden = true
    }
    private func thirdDisposition() {
        picSquares[0].disposition = .topLeft
        picSquares[1].isHidden = false
        picSquares[2].disposition = .bottomLeft
        picSquares[3].isHidden = false
    }
}
