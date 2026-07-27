//
//  RawMaterial.swift
//  RigidBoxQuoter
//
//  Created by Bill Morfonidis on 25/7/26.
//

import Foundation
import SwiftData

@Model
class RawMaterial {
    var name: String
    var unit: MaterialUnit
    var pricePerUnit: Double
    var sheetWidth: Double?
    var sheetHeight: Double?
    var lastUpdated: Date
    
    init(name: String, unit: MaterialUnit, pricePerUnit: Double, sheetWidth: Double? = nil, sheetHeight: Double? = nil) {
        self.name = name
        self.unit = unit
        self.pricePerUnit = pricePerUnit
        self.sheetWidth = sheetWidth
        self.sheetHeight = sheetHeight
        self.lastUpdated = Date()
    }
    
}
