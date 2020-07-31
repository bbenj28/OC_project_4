//
//  SquareDisposition.swift
//  Instagrid
//
//  Created by Benjamin Breton on 31/07/2020.
//  Copyright © 2020 InstaApps. All rights reserved.
//

import Foundation
enum SquareDisposition: Float {
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
    case topAllWidth
    case bottomAllWidth
    case hidden
    
    func backgroundName() -> String {
        switch self {
        case .bottomAllWidth, .topAllWidth:
            return "Big"
        default:
            return "Little"
        }
    }
}
