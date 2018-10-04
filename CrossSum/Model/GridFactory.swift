//
//  GridFactory.swift
//  CrossSum
//
//  Created by Joseph Wardell on 10/1/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import Foundation

// an object that creates grids, perhaps based on what grids were created before (to allow for progressively harder grids)
protocol GridFactory {
    
    func gridAfter(_ grid:Grid?) -> Grid
}


struct SimpleGridFactory : GridFactory {
    func gridAfter(_ grid: Grid?) -> Grid {
        
//        let filter = Grid.SolutionFilter(name: "between one and ten") { $0 > 0 && $0 < 10 }
        return Grid(size: 7, range: 0...10, operators: [.plus, .minus, .times], solutionRange:0...10, allowsFractionalSolutions: false)
    }
}

