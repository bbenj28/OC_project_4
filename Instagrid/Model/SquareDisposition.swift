//
//  SquareDisposition.swift
//  Instagrid
//
//  Created by Benjamin Breton on 31/07/2020.
//  Copyright © 2020 InstaApps. All rights reserved.
//

import Foundation
/// Disposition's possibilities for a PicSquare.
enum SquareDisposition: Float {
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
    case topAllWidth
    case bottomAllWidth
    case hidden
    
    /// Return first word of the background's filename of a picSquare regarding its disposition.
    /// - returns: Background's filename's first word.
    func backgroundName() -> String {
        switch self {
        case .bottomAllWidth, .topAllWidth:
            return "Big"
        default:
            return "Little"
        }
    }
    
    /// Return muliplier of the ratio of a picSquare regarding its disposition.
    /// - returns: Ratio's multiplier.
    func ratio() -> Float {
        switch self {
        case .bottomAllWidth, .topAllWidth:
            return 2.0
        default:
            return 1.0
        }
    }
}
