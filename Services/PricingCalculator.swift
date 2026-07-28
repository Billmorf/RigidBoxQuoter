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
    
    nonisolated static func piecesPerSheet(piece: (width: Double, length: Double), sheet: (width: Double, length: Double)) -> Int {
        let pieceWidthwithSheetWidth = floor(sheet.width / piece.width)
        let pieceLengthwithSheetLength = floor(sheet.length / piece.length)
        let piecesPerSheet = pieceWidthwithSheetWidth * pieceLengthwithSheetLength
        
        let pieceWidthWithSheetLength = floor(sheet.length / piece.width)
        let pieceLengthWithSheetWidth = floor(sheet.width / piece.length)
        let piecesPerSheet2 = pieceWidthWithSheetLength * pieceLengthWithSheetWidth
        
        let bestPiecesPerSheet = Int(max(piecesPerSheet, piecesPerSheet2))
        
        return bestPiecesPerSheet
        
    }
    
    nonisolated static func sheetsNeeded(quantity: Int, piecesPerSheet: Int) -> Int {
        let result = Int(ceil(Double(quantity) / Double(piecesPerSheet)))
        return result
    }
}
