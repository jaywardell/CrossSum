//
//  GameReadyGridFactory.swift
//  CrossSum
//
//  Created by Joseph Wardell on 10/1/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import Foundation


struct GameReadyGridFactory : GridFactory {
    
    let filters : [Grid.SolutionFilter] = [
        Grid.SolutionFilter(name: "between one and five") { $0 > 0 && $0 < 5 },
        Grid.SolutionFilter(name: "between one and ten") { $0 > 0 && $0 < 10 }
    ]
    
    func gridAfter(_ grid: Grid?) -> Grid {

        guard let lastGrid = grid else { return firstGrid() }
        
        var size : Int = lastGrid.size
        var range : Range<Int> = lastGrid.range
        var operators : [Grid.Operator] = lastGrid.operators
        let solutionFilter : Grid.SolutionFilter = lastGrid.solutionFilter
        
        if lastGrid.size == 5 {
            size = 7
        }
        else if lastGrid.operators.count == 1 {
            operators = [.plus, .minus]
        }
        else {
            range = lastGrid.range.first!..<(lastGrid.range.last!+2)
        }
        
        return Grid(size: size, range: range, operators: operators, solutionFilter:solutionFilter)

    }
    
    private func firstGrid() -> Grid {
        return Grid(size: 5, range: 1..<5, operators: [.plus], solutionFilter:filters[0])
    }
}
