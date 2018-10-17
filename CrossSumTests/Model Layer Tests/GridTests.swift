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

    func testCreaetGridFromFancierString() {
        
        let specifications = GridSpecification(size: 5, range: 0...3, operators: [], solutionRange: 0...3, allowsFractionalSolutions: false)
        let sut = """
            3 + 2 + 3
            + 3 + 2 +
            2 + 4 + 3
            + 3 + 2 +
            2 + 4 + 3
            """
        XCTAssertNotNil(_ = try Grid(sut, specifications))
    }
    
    func testGridMatchesSpecifications() {
        // TODO: this
    }

    func testGridWithNoSolutions() {
        // a trivial grid that has no solutions
        let specifications = GridSpecification(size: 2, range: 0...3, operators: [.plus], solutionRange: 0...3, allowsFractionalSolutions: false)
        let sut = """
            2 +
            4 +
            """
        let empty = try! Grid(sut, specifications)
        XCTAssertEqual(empty.solutions, Set())
 
        // now a robust grid that should have solutions, but with a solution range that precludes any valid solutions
        let specifications2 = specifications.mutatedCopy(size:5, solutionRange: 0...0 )
        let sut2 = """
            3 + 2 + 3
            + 3 + 2 +
            2 + 4 + 3
            + 3 + 2 +
            2 + 4 + 3
            """
        let empty2 = try! Grid(sut2, specifications2)
        XCTAssertEqual(empty2.solutions, Set())
    }
    
    func testGridSolutionsFor5x5AllAdd() {

        let specifications = GridSpecification(size: 5, range: 0...30, operators: [.plus], solutionRange: 0...30, allowsFractionalSolutions: false)
        let sut = """
            3 + 2 + 3
            + 3 + 2 +
            2 + 4 + 3
            + 3 + 2 +
            2 + 4 + 3
"""
        let grid = try! Grid(sut, specifications)
        XCTAssertEqual(grid.solutions, Set(arrayLiteral: 7,10,5,9,8,6,4))

    }
    
    func testGridSolutionsFor5x5AddSubtract() {
        
        let specifications = GridSpecification(size: 5, range: 0...30, operators: [.plus], solutionRange: -30...30, allowsFractionalSolutions: false)
        let sut = """
            1 - 3 + 2
            + 3 + 4 +
            2 + 4 - 4
            - 1 + 4 +
            2 - 3 + 2
"""
        let grid = try! Grid(sut, specifications)
        XCTAssertEqual(grid.solutions, Set(arrayLiteral: -1,-2,-3,-4,4,10,0,7,8,1,6,3,2,5))
        
        // -3 appears in this grid 3 times, but every time it is a two-space expression (ie just "-3")
        // this is allowable in the default implementation but not in the real game
        let negativethree = sort(grid.solutionsToExpressionLocations.value[-3]!)
        XCTAssertEqual(negativethree.count, 3)
        XCTAssertEqual(TGC(coordinate: negativethree[0].0), TGC(coordinate: (0,1)))
        XCTAssertEqual(TGC(coordinate: negativethree[0].1), TGC(coordinate: (0,2)))
        XCTAssertEqual(TGC(coordinate: negativethree[1].0), TGC(coordinate: (0,1)))
        XCTAssertEqual(TGC(coordinate: negativethree[1].1), TGC(coordinate: (1,1)))
        XCTAssertEqual(TGC(coordinate: negativethree[2].0), TGC(coordinate: (4,1)))
        XCTAssertEqual(TGC(coordinate: negativethree[2].1), TGC(coordinate: (4,2)))
   }

    func testGridUsesClientToWinowSolutions() {
        // TODO: this
    }
    
    func testGridDoesNotOffer2CharacterSolutionsToRound() {
        // TODO: this
        
        // given:
        let r = Round(gridFactory: SimpleGridFactory())
        // grid with round as its client
        let specifications = GridSpecification(size: 5, range: 0...30, operators: [.plus], solutionRange: -30...30, allowsFractionalSolutions: false)
        let sut = """
            1 - 3 + 2
            + 3 + 4 +
            2 + 4 - 4
            - 1 + 4 +
            2 - 3 + 2
"""
        let grid = try! Grid(sut, specifications)
        grid.solutionClient = r
        
        // since -3 only has 2-step solutions (ie "-3"), r should not have allowed them to be found
        // so there should be no -3 solution
        XCTAssertEqual(grid.solutions, Set(arrayLiteral: -1,-2,-4,4,10,0,7,8,1,6,3,2,5))
        let negativethree = sort(grid.solutionsToExpressionLocations.value[-3]!)
        XCTAssertEqual(negativethree.count, 0)

        
        
        // test:
        // grid's solutions do not include the possibility to just just "-" followed by the number
        // e.g. if there's a solution "-5", then there's a statement like "-4-2" in the grid, not just a "-5"
        // and you can't just select "-5+"
    }
    
}


struct TGC {    // "TeastableGridCoordinate", shortened for readability
    let coordinate : Grid.Coordinate
}

extension TGC : Equatable {}
func ==(lhs: TGC, rhs: TGC) -> Bool {
    return lhs.coordinate == rhs.coordinate
}

func sort(_ solutions:[(Grid.Coordinate, Grid.Coordinate)]) -> [(Grid.Coordinate, Grid.Coordinate)] {
    return solutions.sorted() { lhs, rhs in
        if lhs.0.0 < rhs.0.0 {
            return true
        }
        else if lhs.0.0 == rhs.0.0 && lhs.0.1 < rhs.0.1 {
            return true
        }
        else if lhs.0.1 == rhs.0.1 && lhs.1.0 < rhs.1.0 {
            return true
        }
        else if lhs.1.0 == rhs.1.0 && lhs.1.1 < rhs.1.1 {
            return true
        }
        else {
            return false
        }
    }
}
