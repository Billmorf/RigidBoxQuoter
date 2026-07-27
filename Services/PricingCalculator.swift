//
//  PricingCalculator.swift
//  RigidBoxQuoter
//
//  Created by Bill Morfonidis on 27/7/26.
//

import Foundation

enum PricingCalculator {
    nonisolated static func pieceDimensions(for box: BoxDimensions) -> (boardBase: (width: Double, length: Double), boardLid: (width: Double, length: Double), coveringBase: (width: Double, length: Double), coveringLid: (width: Double, length: Double)) {
        let boardBase = (width: box.baseWidth + 2 * box.baseHeight, length: box.baseLength + 2 * box.baseHeight)
        let lidDimensions = (lidLength: box.baseLength + 0.5, lidWidth: box.baseWidth + 0.5)
        let boardLid = (width: lidDimensions.lidWidth + 2*box.lidHeight, length: lidDimensions.lidLength + 2 * box.lidHeight)
        let coveringBase = (width: boardBase.width + 3.5, length: boardBase.length + 3.5)
        let coveringLid = (width: boardLid.width + 3.5, length: boardLid.length + 3.5)
        
        return (boardBase, boardLid, coveringBase, coveringLid)
    }
}
