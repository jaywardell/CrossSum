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
    
    private let calculation : Rational?
    
    var isTrue : Bool {
        return calculation == targetSolution
    }
    
    init?(expression:String, targetSolution:Rational) {
        self.expression = expression
        self.targetSolution = targetSolution
        self.calculation = RationalParser.parse(expression)
    }
}
