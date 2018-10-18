//
//  GridFactory.swift
//  CrossSum
//
//  Created by Joseph Wardell on 10/1/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import Foundation

// an object that creates grids, perhaps based on what grids were created before (to allow for progressively harder grids)
// it also calculates the solutions for the grid, based on the filter function passed in
protocol GridFactory {
    
    func gridAfter(_ grid:Grid?, using filter:@escaping GridSolutionFilter) -> SolvedGrid
}

extension GridFactory {
    
    func solved(_ grid:Grid, _ filter:@escaping GridSolutionFilter) -> SolvedGrid {
        
        let solver = GridSolver(grid:grid, solutionFilter:filter)
        let solutions = solver.findSolutions()
        
        return SolvedGrid(grid:grid, solutions:solutions)
    }
}


struct SimpleGridFactory : GridFactory {
    func gridAfter(_ grid: Grid?, using filter:@escaping GridSolutionFilter) -> SolvedGrid {
        
        let simple = Grid.Specification(size: 7,
                                       range: 1...10,
                                       operators:[.plus, .minus, .times],
                                       solutionRange:0...10,
                                       allowsFractionalSolutions:false)
        
        let grid = Grid(simple)

        return solved(grid, filter)
    }
}

