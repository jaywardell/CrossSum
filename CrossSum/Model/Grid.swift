//
//  Grid.swift
//  CrossSum
//
//  Created by Joseph Wardell on 9/30/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import Foundation


struct Grid {
        
    private var _symbols : [[String]] = []
    var symbols : [[String]] {
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
    
//    var solutions : Set<Rational>?
    private var solutionsToLocations : [Rational:[((Int,Int), (Int,Int))]]?
    var solutions : Set<Rational> {
        guard let solutionKeys = solutionsToLocations?.keys else { return Set() }
        return Set(solutionKeys)
    }
}

extension Grid {
    
    enum Operator : String {
        case plus = "+"
        case minus = "-"
        case times = "×"
        case dividedeBy = "÷"
    }
    
    init(size:Int, range:Range<Int>, operators:[Operator]) {
        let operators = operators.reduce("") { $0 + $1.rawValue }
        
        var ss = [[String]]()
        var i = 0
        (0..<size).forEach { _ in
            var row = [String]()
            (0..<size).forEach { _ in
                
                row.append(
                    i%2 == 0 ?
                        "\(Int.random(in: range))" :
                    "\(operators.randomElement()!)"
                )
                
                i += 1
            }
            ss.append(row)
        }
        
        self.symbols = ss
    }
}

// MARK:- WordSearchDataSource

extension Grid : WordSearchDataSource {
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

// MARK:-

extension Grid {
    
    mutating func findSolutions(filter:(Rational)->Bool = { _ in true }) {
        
        let start = Date().timeIntervalSinceReferenceDate
        
//        var solutions = Set<Rational>()
        
        var ss = [Rational:[((Int,Int), (Int,Int))]]()
        
        // TODO: use GCD to speed this up
        for row in 0..<rows {
            for column in 0..<columns {
                let s = symbol(at: row, column)
                if nil != Rational(s) || "-" == s {
                    // I can build solutions here
                    
                    // solutions on the same row
                    
                    // forward
                    for i in column + 1 ..< columns {
                        if let solution = solution(for: (row, column), to: (row, i)) {
                            if filter(solution) {
//                                solutions.insert(solution)
                                var array = (ss[solution] ?? [((Int,Int), (Int,Int))]())
                                array.append(((row, column), (row, i)))
                                ss[solution] = array
                            }
                        }
                    }
                    
                    // backward
                    for i in stride(from: column - 1, through: 0, by: -1) {
                        if let solution = solution(for: (row, column), to: (row, i)) {
                            if filter(solution) {
                                //                                solutions.insert(solution)
                                var array = (ss[solution] ?? [((Int,Int), (Int,Int))]())
                                array.append(((row, column), (row, i)))
                                ss[solution] = array
                            }
                        }
                    }

                    // solutions on the same column
                    
                    // forward
                    for i in row + 1 ..< rows {
                        if let solution = solution(for: (row, column), to: (i, column)) {
                            if filter(solution) {
                                //                                solutions.insert(solution)
                                var array = (ss[solution] ?? [((Int,Int), (Int,Int))]())
                                array.append(((row, column), (i, column)))
                                ss[solution] = array
                            }
                        }
                    }
                    
                    // backward
                    for i in stride(from: row - 1, through: 0, by: -1) {
                        if let solution = solution(for: (row, column), to: (i, column)) {
                            if filter(solution) {
                                //                                solutions.insert(solution)
                                var array = (ss[solution] ?? [((Int,Int), (Int,Int))]())
                                array.append(((row, column), (i, column)))
                                ss[solution] = array
                            }
                        }
                    }
                }
            }
        }
        self.solutionsToLocations = ss
        
        print("solutions: \(self.solutionsToLocations)")
        print("\(#function) \(Date().timeIntervalSinceReferenceDate - start)")
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

