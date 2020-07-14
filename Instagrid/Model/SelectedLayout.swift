//
//  SelectedLayout.swift
//  Instagrid
//
//  Created by Benjamin Breton on 14/07/2020.
//  Copyright © 2020 InstaApps. All rights reserved.
//

import Foundation
class SelectedLayout {
    var index: Int?
    var positionX: Float {
        if let indexOk = index {
            return layoutsPosition[indexOk]["x"]!
        } else {
            return 0
        }
    }
    var positionY: Float {
        if let indexOk = index {
            return layoutsPosition[indexOk]["y"]!
        } else {
            return 0
        }
    }
    var layoutsPosition: [[String:Float]]
    init(layoutsPosition: [[String:Float]]) {
        self.layoutsPosition = layoutsPosition
    }
}
