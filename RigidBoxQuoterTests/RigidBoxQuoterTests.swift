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

}
