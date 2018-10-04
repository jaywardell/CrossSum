//
//  GameReadyGridFactory.swift
//  CrossSum
//
//  Created by Joseph Wardell on 10/1/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import Foundation

struct GridMutator : Equatable, Hashable {

    let name : String
    let probability : Double // a value between 0 and 1
    let canMutate : (Grid) -> Bool
    let mutate : (Grid) -> Grid

    static func == (lhs: GridMutator, rhs: GridMutator) -> Bool {
        return lhs.name == rhs.name
    }
    func hash(into hasher: inout Hasher) {
        name.hash(into:&hasher)
    }
}

struct GameReadyGridFactory : GridFactory {
    
    let mutators : Set<GridMutator> = Set([
        
        // increasing size
        GridMutator(name: "increase size to 7x7", probability:0.8, canMutate: { $0.size == 5}, mutate: { $0.mutatedCopy(size:7)}),

        // expanding range
        GridMutator(name: "include zero options",
                    probability:0.5,
                    canMutate: { !$0.range.contains(0)},
                    mutate: {
            let newRange : ClosedRange<Int> = 0...$0.range.upperBound
            return $0.mutatedCopy(range:newRange)}),

        GridMutator(name: "expand range of options",
                    probability:1,
                    canMutate: { _ in true },
                    mutate: {

                        // create the new range, growing it slightly
                        let newRange = $0.range.lowerBound...(Int(Double($0.range.upperBound) * 1.25))
                        
                        // ensure that the solutionRange is at least as large as the options range
                        let newSolutionRange = min(Rational($0.range.lowerBound), $0.solutionRange.lowerBound)...max(Rational($0.range.upperBound), $0.solutionRange.upperBound)
                        
                        return $0.mutatedCopy(range: newRange, solutionRange:newSolutionRange)
        }),
        
        // adding more operators
        GridMutator(name: "add operator", probability:0.5, canMutate: { $0.operators.count < 4 }, mutate: {
            let newOperators : [Grid.Operator]
            switch $0.operators.count {
            case 1:
                newOperators = [.plus, .minus]
            case 2:
                newOperators = [.plus, .minus, .times]
            case 3:
                newOperators = [.plus, .minus, .times, .dividedeBy]
            default:
                fatalError("We should never have more than 4 operators, and the canMutate should prevent that from getting here")
            }
            return $0.mutatedCopy(operators: newOperators)
        }),
        
        // solutionRange
        GridMutator(name: "allow negative solutions",
                    probability:0.5,
                    canMutate: {
                        // only if it's not already happened
                        $0.solutionRange.lowerBound >= Int(0) &&
                            // only if we allow minus operators
                            $0.operators.contains(.minus) },
                    mutate: {
                        // allow negative solutions at least as far from 0
                        // as positive solutions
                        $0.mutatedCopy(solutionRange: -($0.solutionRange.upperBound)...($0.solutionRange.upperBound))
        }),
        

        GridMutator(name: "double solution range",
                    probability:1,
                    canMutate: { _ in true },
                    mutate: {
                        // if lower bound is 0, it will still be zero
                        // if it is negative, then it will double in magnitude
                        $0.mutatedCopy(solutionRange: ($0.solutionRange.lowerBound * 2)...($0.solutionRange.upperBound * 2))
                        }),
        
        GridMutator(name: "allow infinite range",
                    probability:0.2,
                    canMutate: { $0.solutionRange.lowerBound < 0 },
                    mutate: {
                        // if lower bound is 0, it will still be zero
                        // if it is negative, then it will double in magnitude
                        $0.mutatedCopy(solutionRange: Rational.minimum...Rational.maximum)
        }),

        // fractional solutions
        GridMutator(name: "allow fractional solutions", probability:0.5, canMutate: { !$0.allowsFractionalSolutions && $0.operators.count == 4 }, mutate: { $0.mutatedCopy(allowsFractionalSolutions:true)}),
        
        // if nothing else works, then return a Grid with the same characteristics
        // also, every once in a while, we can have two grds in a row with the same characteristics
        GridMutator(name: "same", probability:1, canMutate: { _ in true }, mutate: { $0.mutatedCopy() })

        
        ])
    
    func gridAfter(_ grid: Grid?) -> Grid {

        guard let lastGrid = grid else { return firstGrid() }
        var mutators = self.mutators
        
        while mutators.count > 0 {
            guard let mutator = mutators.randomElement() else  { break }
            if Double.random(in: 0...1) < mutator.probability &&
                mutator.canMutate(lastGrid) {
                print("mutator:\(mutator.name)")
                
                return mutator.mutate(lastGrid)
            }
            
            mutators.remove(mutator)
        }
        fatalError("If nothing else, same mutator should work, so control flow should never reach here")
    }
    
    private func firstGrid() -> Grid {
        return Grid(size: 5, range: 1...5, operators: [.plus], solutionRange:0...5, allowsFractionalSolutions:false)
    }
}
