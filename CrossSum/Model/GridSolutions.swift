//
//  GridSolutions.swift
//  CrossSum
//
//  Created by Joseph Wardell on 10/17/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import Foundation

struct GridSolutions {
    
    var solutionsToExpressionLocations = ThreadSafe([Rational:[(Grid.Coordinate, Grid.Coordinate)]]())
    var solutions : Set<Rational> {
        return Set(solutionsToExpressionLocations.value.keys)
    }
    
    var isEmpty : Bool {
        return solutionsToExpressionLocations.value.isEmpty
    }
    
    func waysToGet(solution:Rational) -> [(Grid.Coordinate, Grid.Coordinate)] {
        return solutionsToExpressionLocations.value[solution] ?? []
    }
    
    mutating func append(solution:Rational, coordinates start:Grid.Coordinate, end:Grid.Coordinate) {
        solutionsToExpressionLocations.atomically { solutionsDictionary in
            var array = (solutionsDictionary[solution] ?? [(Grid.Coordinate, Grid.Coordinate)]())
            array.append((start, end))
            solutionsDictionary[solution] = array
        }
    }
}
