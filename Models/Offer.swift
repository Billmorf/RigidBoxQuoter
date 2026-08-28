//
//  Offer.swift
//  RigidBoxQuoter
//
//  Created by Bill Morfonidis on 28/8/26.
//

import Foundation
import SwiftData

@Model
class Offer {
    var clientName: String
    var boxTemplateName: String
    var quantity: Int
    var date: Date
    var materialCost: Double
    var laborCost: Double
    var moldCost: Double
    var subTotal: Double
    var total: Double
    var marginPercent: Double
    
    init(clientName: String, boxTemplateName: String, quantity: Int, materialCost: Double, laborCost: Double, moldCost: Double, subTotal: Double, total: Double, marginPercent: Double) {
        self.clientName = clientName
        self.boxTemplateName = boxTemplateName
        self.quantity = quantity
        self.date = Date()
        self.materialCost = materialCost
        self.laborCost = laborCost
        self.moldCost = moldCost
        self.subTotal = subTotal
        self.total = total
        self.marginPercent = marginPercent
    }
}

extension Offer {
    var profitAmount: Double {
        self.total - self.subTotal
    }
    var costPerUnit: Double {
        self.total / Double(self.quantity)
    }
}
