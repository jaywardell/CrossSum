//
//  Statement.swift
//  CrossSum
//
//  Created by Joseph Wardell on 9/25/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import Foundation

struct Statement {
    
    // TODO: Write test cases
    
    let expression : String
    let targetSolution : Rational
    let comparator : (Rational, Rational) -> Bool
    
    private let calculation : Rational?
    
    var isValid : Bool {
        return nil != calculation
    }
    
    var isTrue : Bool {
        guard let calculation = calculation else { return false }
        return comparator(calculation, targetSolution)
    }
    
    init(_ expression:String, _ targetSolution:Rational, _ comparator:@escaping (Rational, Rational) -> Bool) {
        self.expression = expression
        self.targetSolution = targetSolution
        self.calculation = RationalParser.parse(expression)
        self.comparator = comparator
    }
}
