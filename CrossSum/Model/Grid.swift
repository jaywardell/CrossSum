//
//  Grid.swift
//  CrossSum
//
//  Created by Joseph Wardell on 9/30/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import Foundation



class Grid {
    
    struct Coordinate : Equatable {
        let x : Int
        let y : Int
        
        init(_ x:Int, _ y:Int) {
            self.x = x
            self.y = y
        }
        
        var raw : (Int, Int) { return (x,y) }
    }
    
    enum Operator : String {
        case plus = "+"
        case minus = "-"
        case times = "×"
        case dividedeBy = "÷"
        
        static var all : String {
            return self.plus.rawValue + self.minus.rawValue + self.times.rawValue + self.dividedeBy.rawValue
        }
    }

    public struct Specification {
        
        let size : Int
        let range : ClosedRange<Int>
        let operators : [Grid.Operator]
        let solutionRange : ClosedRange<Rational>
        let allowsFractionalSolutions : Bool
        
        func mutatedCopy(size:Int? = nil,
                         range:ClosedRange<Int>? = nil,
                         operators:[Grid.Operator]? = nil,
                         solutionRange:ClosedRange<Rational>? = nil,
                         allowsFractionalSolutions:Bool? = nil) -> Specification {
            
            return Specification(size: size ?? self.size,
                                     range: range ?? self.range,
                                     operators: operators ?? self.operators,
                                     solutionRange: solutionRange ?? self.solutionRange,
                                     allowsFractionalSolutions: allowsFractionalSolutions ?? self.allowsFractionalSolutions)
            
        }
    }

    let specification : Specification

    var size : Int { return specification.size }
    var range : ClosedRange<Int> { return specification.range }
    var operators : [Operator] { return specification.operators }
    var solutionRange : ClosedRange<Rational> { return specification.solutionRange }
    var allowsFractionalSolutions : Bool { return specification.allowsFractionalSolutions }
        
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
    
//    var solutionsToExpressionLocations = ThreadSafe([Rational:[(Coordinate, Coordinate)]]())
//    var solutions : Set<Rational> {
//        return Set(solutionsToExpressionLocations.value.keys)
//    }
    
//    func waysToGet(solution:Rational) -> [(Coordinate, Coordinate)] {
//        let d = solutionsToExpressionLocations.value[solution]
//        let filteredD = d?.filter() { coordinates in
//            guard let client = solutionClient else { return true } // no solution client, so no need to filter...
//            return client.willAcceptSolution(solution: solution, in: self, from: coordinates.0, to: coordinates.1)
//        }
//        return filteredD ?? []
//    }
    
    
    
    
    init(_ specification:Specification) {
        self.specification = specification
        
        let _operators = specification.operators.reduce("") { $0 + $1.rawValue }
        
        // randomly build the grid
        var ss = [[String]]()
        var i = 0
        (0..<specification.size).forEach { _ in
            var row = [String]()
            (0..<specification.size).forEach { _ in
                
                row.append(
                    i%2 == 0 ?
                        "\(Int.random(in: specification.range))" :
                    "\(_operators.randomElement()!)"
                )
                
                i += 1
            }
            ss.append(row)
        }
        
        self.symbols = ss
        
        // build the solutions
//        findSolutions()
    }
    
    init(_ string:String, _ specification:Specification) throws {
        self.specification = specification
        
        // parse the string into alternating integer/oeration array
        var parts = [String]()
        
        let integers = Parser<Character>.digits
        let operators = Parser.character(in: Operator.all).string(maxLength:1)
        
        let str = string.replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "\n", with: "")
            .replacingOccurrences(of: "\t", with: "")
        
        var remainder = str[...]
        var parsingInt = true
        var parser = integers
        while !remainder.isEmpty {
            guard let r = parser.parse(remainder) else {
                throw(NSError(domain: "Grid", code: 5, userInfo: [NSLocalizedDescriptionKey:"Couldn't parse string"]))
            }
            guard r.1 != remainder else {
                throw(NSError(domain: "Grid", code: 1, userInfo: [NSLocalizedDescriptionKey:"parser did not parse anything, malformed string: \(remainder)"]))
            }
            parts.append(r.0!)
            remainder = r.1
            
            parsingInt.toggle()
            parser = parsingInt ? integers : operators
        }
        
        guard(parts.count == size*size) else {
            throw(NSError(domain: "Grid", code: 2, userInfo: [NSLocalizedDescriptionKey:"expect a square grid"]))
        }
        
        // massage the parts array into an array of arrays of string
        var symbols = [[String]]()
        for i in stride(from: 0, to: parts.count-size+1, by: size) {
            let arr = Array(parts[i..<i+size])
            guard arr.count == size else {
                throw(NSError(domain: "Grid", code: 3, userInfo: [NSLocalizedDescriptionKey:"expect each line to have \(size) items"]))
            }
            symbols.append(arr)
        }
        guard symbols.count == size else {
            throw(NSError(domain: "Grid", code: 4, userInfo: [NSLocalizedDescriptionKey:"expect the grid to have \(size) rows"]))
        }
        self.symbols = symbols
        print("symbolds: \(self.symbols)")
        
//        findSolutions()
    }
    
    
    func solution(for start:Coordinate, to end:Coordinate) -> Rational? {
        let s = stringForSymbols(between: start.raw, and: end.raw)
        let statement = Statement(s)
        if statement.isValid, let solution = statement.calculation {
            return solution
        }
        return nil
    }

    // TODO: COdable
}

// MARK:- ExpressionSymbolViewDataSource

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


//extension Grid {
//    
//    private func accepts(solution:Rational, from start:Coordinate, to end:Coordinate) -> Bool {
//        if !allowsFractionalSolutions && solution.fractionalPart != 0 {
//            return false
//        }
//        if !solutionRange.contains(solution) {
//            return false
//        }
//        
//        // let the client have a go at it
//        if let client =  client {
//            // NOTE: not being called b/c solutionCLient is not set at init when this is called
//            if !client.willAcceptSolution(solution: solution, in:self, from: start, to: end) {
//                return false
//            }
//        }
//        return true
//    }
//    
//    private func findSolutions() {
//        
//        DispatchQueue.concurrentPerform(iterations: rows) { row in
//
//            for column in 0..<columns {
//                let s = symbol(at: row, column)
//                if nil != Rational(s) || "-" == s {
//                    
//                    // solutions on the same row
//                    
//                    // forward
//                    for i in column + 1 ..< columns {
//                        let start = Coordinate(row, column)
//                        let end = Coordinate(row, i)
//                        if let solution = solution(for: start, to: end) {
//                            if accepts(solution: solution, from:start, to:end) {
//                                appendToPossibleSolutions(solution: solution, coordinates: start, end: end)
//                            }
//                        }
//                    }
//                    
//                    // backward
//                    for i in stride(from: column - 1, through: 0, by: -1) {
//                        let start = Coordinate(row, column)
//                        let end = Coordinate(row, i)
//                        if let solution = solution(for: start, to: end) {
//                            if accepts(solution: solution, from:start, to:end) {
//                                appendToPossibleSolutions(solution: solution, coordinates: start, end: end)
//                            }
//                        }
//                    }
//
//                    // solutions on the same column
//                    
//                    // forward
//                    for i in row + 1 ..< rows {
//                        let start = Coordinate(row, column)
//                        let end = Coordinate(i, column)
//                        if let solution = solution(for: start, to: end) {
//                            if accepts(solution: solution, from:start, to:end) {
//                                appendToPossibleSolutions(solution: solution, coordinates: start, end: end)
//                            }
//                        }
//                    }
//                    
//                    // backward
//                    for i in stride(from: row - 1, through: 0, by: -1) {
//                        let start = Coordinate(row, column)
//                        let end = Coordinate(i, column)
//                        if let solution = solution(for: start, to: end) {
//                            if accepts(solution: solution, from:start, to:end) {
//                                appendToPossibleSolutions(solution: solution, coordinates: start, end: end)
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
//    
//    private func appendToPossibleSolutions(solution:Rational, coordinates start:Coordinate, end:Coordinate) {
//        solutionsToExpressionLocations.atomically { s in
//            var array = (s[solution] ?? [(Coordinate, Coordinate)]())
//            array.append((start, end))
//            s[solution] = array
//        }
//    }
//    
//
//}
