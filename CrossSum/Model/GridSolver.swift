//
//  GridSolver.swift
//  CrossSum
//
//  Created by Joseph Wardell on 10/17/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import Foundation

typealias GridSolutionFilter = (_ solution:Rational,
    _ grid:Grid,
    _ start:Grid.Coordinate,
    _ end:Grid.Coordinate) -> Bool



struct GridSolver {
    
    weak var grid : Grid!
    
    var solutionFilter : GridSolutionFilter = {
            _, _, _, _ in return true
    }
    
    static func NoFilter(_ solution:Rational,
                         _ grid:Grid,
                         _ start:Grid.Coordinate,
                         _ end:Grid.Coordinate) -> Bool { return true }

    // MARK:-
    
    func findSolutions() -> GridSolutions {
        assert(nil != grid, "grid can't be nil when \(#function) is called")
        
        var out = GridSolutions()
        
        DispatchQueue.concurrentPerform(iterations: grid.rows) { row in
            
            for column in 0..<grid.columns {
                let s = grid.symbol(at: row, column)
                if nil != Rational(s) || "-" == s {
                    
                    // solutions on the same row
                    
                    // forward
                    for i in column + 1 ..< grid.columns {
                        let start = Grid.Coordinate(row, column)
                        let end = Grid.Coordinate(row, i)
                        if let solution = grid.solution(for: start, to: end) {
                            if accepts(solution: solution, from:start, to:end) {
                                out.append(solution: solution, coordinates: start, end: end)
                            }
                        }
                    }
                    
                    // backward
                    for i in stride(from: column - 1, through: 0, by: -1) {
                        let start = Grid.Coordinate(row, column)
                        let end = Grid.Coordinate(row, i)
                        if let solution = grid.solution(for: start, to: end) {
                            if accepts(solution: solution, from:start, to:end) {
                                out.append(solution: solution, coordinates: start, end: end)
                            }
                        }
                    }
                    
                    // solutions on the same column
                    
                    // forward
                    for i in row + 1 ..< grid.rows {
                        let start = Grid.Coordinate(row, column)
                        let end = Grid.Coordinate(i, column)
                        if let solution = grid.solution(for: start, to: end) {
                            if accepts(solution: solution, from:start, to:end) {
                                out.append(solution: solution, coordinates: start, end: end)
                            }
                        }
                    }
                    
                    // backward
                    for i in stride(from: row - 1, through: 0, by: -1) {
                        let start = Grid.Coordinate(row, column)
                        let end = Grid.Coordinate(i, column)
                        if let solution = grid.solution(for: start, to: end) {
                            if accepts(solution: solution, from:start, to:end) {
                                out.append(solution: solution, coordinates: start, end: end)
                            }
                        }
                    }
                }
            }
        }
        
        return out
    }
    
    private func accepts(solution:Rational, from start:Grid.Coordinate, to end:Grid.Coordinate) -> Bool {
        if !grid.specification.allowsFractionalSolutions && solution.fractionalPart != 0 {
            return false
        }
        if !grid.specification.solutionRange.contains(solution) {
            return false
        }

        if !solutionFilter(solution, grid, start, end) {
            return false
        }
        
        return true
    }
}
