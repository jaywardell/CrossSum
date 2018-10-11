//
//  Grid.swift
//  CrossSum
//
//  Created by Joseph Wardell on 9/30/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import Foundation


class Grid {
    typealias Coordinate = (Int, Int)
    
    let size : Int
    let range : ClosedRange<Int>
    let operators : [Operator]
    let solutionRange : ClosedRange<Rational>
    let allowsFractionalSolutions : Bool
    
    private var _symbols : [[String]] = []
    private(set) var symbols : [[String]] {
        get {
            return _symbols
        }
        set {
            // don't allow non-square strings to be set, but instead crash
            
            guard newValue.allTheSame({
                $0.count
            }) else {
                fatalError("symbolds must be in a rectangular grid\n\(newValue)\nIs not rectangular\n")
            }
            
            _symbols = newValue
        }
    }
    
    var solutionsToExpressionLocations = ThreadSafe([Rational:[(Coordinate, Coordinate)]]())
    var solutions : Set<Rational> {
        return Set(solutionsToExpressionLocations.value.keys)
    }
    
    func waysToGet(solution:Rational) -> [(Coordinate, Coordinate)] {
        let d = solutionsToExpressionLocations.value[solution]
        return d ?? []
    }
    
    enum Operator : String {
        case plus = "+"
        case minus = "-"
        case times = "×"
        case dividedeBy = "÷"
    }
    
    
    
    init(size:Int,
         range:ClosedRange<Int>,
         operators:[Operator],
        solutionRange:ClosedRange<Rational>,
        allowsFractionalSolutions:Bool
        ) {
        self.size = size
        self.range = range
        self.operators = operators
        self.solutionRange = solutionRange
        self.allowsFractionalSolutions = allowsFractionalSolutions

        let _operators = operators.reduce("") { $0 + $1.rawValue }
        
        // randomly build the grid
        var ss = [[String]]()
        var i = 0
        (0..<size).forEach { _ in
            var row = [String]()
            (0..<size).forEach { _ in
                
                row.append(
                    i%2 == 0 ?
                        "\(Int.random(in: range))" :
                    "\(_operators.randomElement()!)"
                )
                
                i += 1
            }
            ss.append(row)
        }
        
        self.symbols = ss
        
        // build the solutions
        findSolutions()
    }
    
    func mutatedCopy(size:Int? = nil,
                     range:ClosedRange<Int>? = nil,
                     operators:[Operator]? = nil,
                     solutionRange:ClosedRange<Rational>? = nil,
                     allowsFractionalSolutions:Bool? = nil) -> Grid {
        
        return Grid(size: size ?? self.size,
                    range: range ?? self.range,
                    operators: operators ?? self.operators,
                    solutionRange: solutionRange ?? self.solutionRange,
                    allowsFractionalSolutions: allowsFractionalSolutions ?? self.allowsFractionalSolutions)
        
    }
    
    
    // TODO: init from a String
    // TODO: COdable
}

// MARK:- WordSearchDataSource

extension Grid : ExpressionSymbolViewDataSource {
    var rows: Int {
        return symbols.count
    }
    
    var columns: Int {
        return symbols.first?.count ?? 0
    }
    
    func symbol(at row: Int, _ column: Int) -> String {
        return symbols[row][column]
    }
}

// MARK:- Managing Solutions

extension Grid {
    
    private func accepts(solution:Rational) -> Bool {
        if !allowsFractionalSolutions && solution.fractionalPart != 0 {
            return false
        }
        if !solutionRange.contains(solution) {
            return false
        }
        return true
    }
    
    private func findSolutions() {
        
//        let start = Date().timeIntervalSinceReferenceDate
        
        DispatchQueue.concurrentPerform(iterations: rows) { row in

            for column in 0..<columns {
                let s = symbol(at: row, column)
                if nil != Rational(s) || "-" == s {
                    
                    // solutions on the same row
                    
                    // forward
                    for i in column + 1 ..< columns {
                        if let solution = solution(for: (row, column), to: (row, i)) {
                            if accepts(solution: solution) {
                                appendToPossibleSolutions(solution: solution, coordinates: (row, column), end: (row, i))
                            }
                        }
                    }
                    
                    // backward
                    for i in stride(from: column - 1, through: 0, by: -1) {
                        if let solution = solution(for: (row, column), to: (row, i)) {
                            if accepts(solution: solution) {
                                appendToPossibleSolutions(solution: solution, coordinates: (row, column), end: (row, i))
                            }
                        }
                    }

                    // solutions on the same column
                    
                    // forward
                    for i in row + 1 ..< rows {
                        if let solution = solution(for: (row, column), to: (i, column)) {
                            if accepts(solution: solution) {
                                appendToPossibleSolutions(solution: solution, coordinates: (row, column), end: (i, column))
                            }
                        }
                    }
                    
                    // backward
                    for i in stride(from: row - 1, through: 0, by: -1) {
                        if let solution = solution(for: (row, column), to: (i, column)) {
                            if accepts(solution: solution) {
                                appendToPossibleSolutions(solution: solution, coordinates: (row, column), end: (i, column))
                            }
                        }
                    }
                }
            }
        }
        
//        print("solutions: \(self.solutionsToLocations.value)")
//        print("\(#function) \(Date().timeIntervalSinceReferenceDate - start)")
    }
    
    private func appendToPossibleSolutions(solution:Rational, coordinates start:Coordinate, end:Coordinate) {
        solutionsToExpressionLocations.atomically { s in
            var array = (s[solution] ?? [(Coordinate, Coordinate)]())
            array.append((start, end))
            s[solution] = array
        }
    }
    
    private func solution (for start:(Int, Int), to end:(Int, Int)) -> Rational? {
        let s = stringForSymbols(between: start, and: end)
        let statement = Statement(s)
        if statement.isValid, let solution = statement.calculation {
            return solution
        }
        return nil
    }

}

