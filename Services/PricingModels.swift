//
//  PricingModels.swift
//  RigidBoxQuoter
//
//  Created by Bill Morfonidis on 27/7/26.
//

import Foundation

struct MaterialPricingInput {
    var pricePerUnit: Double
    var sheetWidth: Double
    var sheetHeight: Double
}

struct BoxDimensions {
    var baseLength: Double
    var baseWidth: Double
    var baseHeight: Double
    var lidHeight: Double
}
