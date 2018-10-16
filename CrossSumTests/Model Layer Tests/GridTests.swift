//
//  GridTests.swift
//  CrossSumTests
//
//  Created by Joseph Wardell on 10/15/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import XCTest
@testable import CrossSum

class GridTests: XCTestCase {

    func testCreateGridFromString() {
        
        let str = "1+3-5+7÷9"
        let specifications = GridSpecification(size: 3, range: 0...3, operators: [], solutionRange: 0...3, allowsFractionalSolutions: false)
        let grid = try! Grid(str, specifications)
        XCTAssertNotNil(grid)
        
        XCTAssertEqual(grid.symbols,
                       [
                        ["1","+","3"],
                        ["-","5","+"],
                        ["7","÷","9"]
            ]
                       )
    }
    
    func testCannotCreateGridFromMalformedString() {
        
        let specifications = GridSpecification(size: 3, range: 0...3, operators: [], solutionRange: 0...3, allowsFractionalSolutions: false)
        
        XCTAssertThrowsError(_ = try Grid("1+3-5*7÷9", specifications))
        XCTAssertThrowsError(_ = try Grid("1+3-5-7÷9-", specifications))
        XCTAssertThrowsError(_ = try Grid("1+3-5-7÷+9", specifications))
        XCTAssertThrowsError(_ = try Grid("1+3-5-", specifications))
    }

    func testGridMatchesSpecifications() {
        // TODO: this
    }
    
    func testGridSolutions() {
        // TODO: this
    }
    
    func testGridUsesClientToWinowSolutions() {
        // TODO: this
    }
    
    func testGridDoesNotOffer2CharacterSolutionsToRound() {
        // TODO: this
        
        // given:
        let r = Round(gridFactory: SimpleGridFactory())
        // grid with round as its client
        
        // test:
        // grid's solutions do not include the possibility to just just "-" followed by the number
        // e.g. if there's a solution "-5", then there's a statement like "-4-2" in the grid, not just a "-5"
        // and you can't just select "-5+"
    }
    
}
