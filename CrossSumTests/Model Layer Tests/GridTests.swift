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
        let specifications = Grid.Specification(size: 3, range: 0...3, operators: [], solutionRange: 0...3, allowsFractionalSolutions: false)
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
        
        let specifications = Grid.Specification(size: 3, range: 0...3, operators: [], solutionRange: 0...3, allowsFractionalSolutions: false)
        
        XCTAssertThrowsError(_ = try Grid("1+3-5*7÷9", specifications))
        XCTAssertThrowsError(_ = try Grid("1+3-5-7÷9-", specifications))
        XCTAssertThrowsError(_ = try Grid("1+3-5-7÷+9", specifications))
        XCTAssertThrowsError(_ = try Grid("1+3-5-", specifications))
    }

    func testCreaetGridFromFancierString() {
        
        let specifications = Grid.Specification(size: 5, range: 0...3, operators: [], solutionRange: 0...3, allowsFractionalSolutions: false)
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
        let specifications = Grid.Specification(size: 2, range: 0...3, operators: [.plus], solutionRange: 0...3, allowsFractionalSolutions: false)
        let sut = """
            2 +
            4 +
            """
        let empty = try! Grid(sut, specifications)
        XCTAssert(GridSolver(grid: empty, solutionFilter: GridSolver.NoFilter).findSolutions().isEmpty)
//        XCTAssertEqual(empty.solutions, Set())
 
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
        XCTAssert(GridSolver(grid: empty2, solutionFilter: GridSolver.NoFilter).findSolutions().isEmpty)
    }
    
    func testGridSolutionsFor5x5AllAdd() {

        let specifications = Grid.Specification(size: 5, range: 0...30, operators: [.plus], solutionRange: 0...30, allowsFractionalSolutions: false)
        let sut = """
            3 + 2 + 3
            + 3 + 2 +
            2 + 4 + 3
            + 3 + 2 +
            2 + 4 + 3
"""
        let grid = try! Grid(sut, specifications)
        let solutions = GridSolver(grid: grid, solutionFilter: GridSolver.NoFilter).findSolutions()
        XCTAssertEqual(solutions.solutions, Set(arrayLiteral: 7,10,5,9,8,6,4))

    }
    
    func testGridSolutionsFor5x5AddSubtract() {
        
        let specifications = Grid.Specification(size: 5, range: 0...30, operators: [.plus], solutionRange: -30...30, allowsFractionalSolutions: false)
        let sut = """
            1 - 3 + 2
            + 3 + 4 +
            2 + 4 - 4
            - 1 + 4 +
            2 - 3 + 2
"""
        let grid = try! Grid(sut, specifications)
        let solutions = GridSolver(grid: grid, solutionFilter: GridSolver.NoFilter).findSolutions()
        XCTAssertEqual(solutions.solutions, Set(arrayLiteral: -1,-2,-3,-4,4,10,0,7,8,1,6,3,2,5))
        
        // -3 appears in this grid 3 times, but every time it is a two-space expression (ie just "-3")
        // this is allowable in the default implementation of the GridSolver but not in the real game
        // TODO: bring this back, though it should be simpler to express
        let ways = solutions.waysToGet(solution: -3)
        XCTAssertEqual(ways.count, 3)
        let negativethree = sort(ways)
        XCTAssertEqual(negativethree[0].0, Grid.Coordinate(0, 1))
        XCTAssertEqual(negativethree[0].1, Grid.Coordinate(0, 2))
        XCTAssertEqual(negativethree[1].0, Grid.Coordinate(0, 1))
        XCTAssertEqual(negativethree[1].1, Grid.Coordinate(1, 1))
        XCTAssertEqual(negativethree[2].0, Grid.Coordinate(4, 1))
        XCTAssertEqual(negativethree[2].1, Grid.Coordinate(4, 2))
   }

    func testGridUsesClientToWinowSolutions() {
        // TODO: this
    }
    
    func testGridDoesNotOffer2CharacterSolutionsToRound() {
        
        // given:
        let r = Game(gridFactory: SimpleGridFactory())
        // grid with game as its client
        let specifications = Grid.Specification(size: 5, range: 0...30, operators: [.plus], solutionRange: -30...30, allowsFractionalSolutions: false)
        let sut = """
            1 - 3 + 2
            + 3 + 4 +
            2 + 4 - 4
            - 1 + 4 +
            2 - 3 + 2
"""
        let grid = try! Grid(sut, specifications)
        let solutions = GridSolver(grid: grid, solutionFilter: Game.shouldAcceptSolution(r)).findSolutions()

        // since -3 only has 2-step solutions (ie "-3"), r should not have allowed them to be found
        // so there should be no -3 solution
        // TODO: bring back these tests
        let expectedSolutions = Set<Rational>(arrayLiteral: -1,-2,4,10,0,7,8,1,6,3,2,5) // all as for the filterless test, aside from the two values that only have 2-step solutions (-3 and -4)
        XCTAssertEqual(solutions.solutions, expectedSolutions)
        XCTAssert(solutions.waysToGet(solution: -3).isEmpty)
        XCTAssert(solutions.waysToGet(solution: -4).isEmpty)
        XCTAssertFalse(solutions.waysToGet(solution: -1).isEmpty)
        
        for r in expectedSolutions {
            XCTAssertFalse(solutions.waysToGet(solution: r).isEmpty)
        }
        
        // TODO: I could go through each solution and verify the existence of every known solution by hand
        // it would make for a safer experience
        
        // test:
        // grid's solutions do not include the possibility to just just "-" followed by the number
        // e.g. if there's a solution "-5", then there's a statement like "-4-2" in the grid, not just a "-5"
        // and you can't just select "-5+"
    }
    
}


//struct TGC {    // "TeastableGridCoordinate", shortened for readability
//    let coordinate : Grid.Coordinate
//}
//
//extension TGC : Equatable {}
//func ==(lhs: TGC, rhs: TGC) -> Bool {
//    return lhs.coordinate == rhs.coordinate
//}
//
func sort(_ solutions:[(Grid.Coordinate, Grid.Coordinate)]) -> [(Grid.Coordinate, Grid.Coordinate)] {
    return solutions.sorted() { lhs, rhs in
        if lhs.0.x < rhs.0.x {
            return true
        }
        else if lhs.0.x == rhs.0.x && lhs.0.y < rhs.0.y {
            return true
        }
        else if lhs.0.y == rhs.0.y && lhs.1.x < rhs.1.x {
            return true
        }
        else if lhs.1.x == rhs.1.x && lhs.1.y < rhs.1.y {
            return true
        }
        else {
            return false
        }
    }
}
