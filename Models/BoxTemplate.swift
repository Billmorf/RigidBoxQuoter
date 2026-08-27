//
//  BoxTemplate.swift
//  RigidBoxQuoter
//
//  Created by Bill Morfonidis on 30/7/26.
//

import Foundation
import SwiftData

@Model
class BoxTemplate {
    var name: String
    var baseLength: Double
    var baseWidth: Double
    var baseHeight: Double
    var lidHeight: Double
    var laborMinutes: Double
    var structuralMaterial: RawMaterial
    var coveringMaterial: RawMaterial
    
    init(name: String, baseLength: Double, baseWidth: Double, baseHeight: Double, lidHeight: Double, laborMinutes: Double, structuralMaterial: RawMaterial, coveringMaterial: RawMaterial) {
        self.name = name
        self.baseLength = baseLength
        self.baseWidth = baseWidth
        self.baseHeight = baseHeight
        self.lidHeight = lidHeight
        self.laborMinutes = laborMinutes
        self.structuralMaterial = structuralMaterial
        self.coveringMaterial = coveringMaterial
    }
}
