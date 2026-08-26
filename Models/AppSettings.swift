//
//  AppSettings.swift
//  RigidBoxQuoter
//
//  Created by Bill Morfonidis on 30/7/26.
//

import Foundation
import SwiftData

@Model
class AppSettings {
    var hourlyRate: Double
    var lastUpdated: Date
    
    init(hourlyRate: Double) {
        self.hourlyRate = hourlyRate
        self.lastUpdated = Date()
    }
}
