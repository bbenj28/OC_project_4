//
//  Layout.swift
//  Instagrid
//
//  Created by Benjamin Breton on 06/08/2020.
//  Copyright © 2020 InstaApps. All rights reserved.
//

import Foundation
enum Layout {
    case layout0
    case layout1
    case layout2
    
    func isHiddenSquare(_ index: Int) -> Bool {
        switch self {
        case .layout0:
            return index == 1
        case .layout1:
            return index == 3
        case .layout2:
            return false
        }
    }
}
