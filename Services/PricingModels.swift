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

struct OfferCalculationInput {
    var box: BoxDimensions
    var structuralMaterial: MaterialPricingInput
    var coveringMaterial: MaterialPricingInput
    var laborMinutes: Double
    var quantity: Int
    var hourlyRate: Double
    var moldCost: Double
    var marginPercent: Double
}

struct OfferCalculationResult {
    var quantity: Int
    var materialCost: Double
    var laborCost: Double
    var moldCost: Double
    var subTotal: Double
    var total: Double
}
