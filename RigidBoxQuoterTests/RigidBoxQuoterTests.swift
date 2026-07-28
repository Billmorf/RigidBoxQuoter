//
//  RigidBoxQuoterTests.swift
//  RigidBoxQuoterTests
//
//  Created by Bill Morfonidis on 27/7/26.
//

import Testing
@testable import RigidBoxQuoter

struct RigidBoxQuoterTests {

    @Test func testPieceDimensionsForStandardBox() async throws {
        let box = BoxDimensions(baseLength: 12, baseWidth: 10, baseHeight: 5, lidHeight: 2.5)
        let result = PricingCalculator.pieceDimensions(for: box)
        
        #expect(result.boardBase.width == 20)
        #expect(result.boardBase.length == 22)
        #expect(result.boardLid.width == 15.5)
    }
    
    @Test func testResultsForPiecesPerSheet () async throws {
        let piece = (width: 20.0, length: 22.0)
        let sheet = (width: 75.0, length: 105.0)
        let result = PricingCalculator.piecesPerSheet(piece: piece, sheet: sheet)
        
        #expect(result == 15)
    }
    
    @Test func testSheetsNeeded () async throws {
        let quantity = 100
        let piecesPerSheet = 15
        
        let result = PricingCalculator.sheetsNeeded(quantity: quantity, piecesPerSheet: piecesPerSheet)
        
        #expect(result == 7)
    }
    
    @Test func testMaterialCost () async throws {
        let piece = (width: 20.0, length: 22.0)
        let material = MaterialPricingInput(pricePerUnit: 0.75, sheetWidth: 75, sheetHeight: 105)
        let quantity = 100
        
        let result = PricingCalculator.materialCost(piece: piece, material: material, quantity: quantity)
        
        #expect(result == 5.25)
    }

}
