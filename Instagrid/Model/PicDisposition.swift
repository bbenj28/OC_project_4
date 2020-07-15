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
    var selectedLayout: Int = 1
    var selectedSquare: Int?
    var picSquaresToFill: [Int] {
        switch selectedLayout {
        case 0:
            return [0, 2, 3]
        case 1:
            return [0, 1, 2]
        case 2:
            return [0, 1, 2, 3]
        default:
            return []
        }
    }
    var gridIsReadyToShare: Bool {
        if picSquaresToFill.count > 0 {
            for i in 0...picSquaresToFill.count - 1 {
                let index = picSquaresToFill[i]
                if picSquares[index].pictureIsSelected == false {
                    return false
                }
            }
            return true
        } else {
            return false
        }
    }
    init() {
        changeDisposition(0)
    }
    func changeDisposition(_ index: Int?) {
        if let indexOk = index {
            selectedLayout = indexOk
        }
        selectedSquare = nil
        switch selectedLayout {
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
    func delete() {
        for i in 0...3 {
            picSquares[i].pictureIsSelected = false
        }
    }
}
