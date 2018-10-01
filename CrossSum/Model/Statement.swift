//
//  Statement.swift
//  CrossSum
//
//  Created by Joseph Wardell on 9/25/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import Foundation

struct Comparator {
    let title : String
    let falseTitle : String
    let compare : (Rational, Rational) -> Bool
}

struct Statement {
    
    // TODO: Write test cases
    
    static let equal = Comparator(title: "=", falseTitle: "≠", compare: ==)
    static let notequal = Comparator(title: "≠", falseTitle: "=", compare: !=)
    static let lessthan = Comparator(title: "<", falseTitle: "≮", compare: <)
    static let lessthanorequal = Comparator(title: "≤", falseTitle: "≰", compare: <=)
    static let greatherthan = Comparator(title: ">", falseTitle: "≯", compare: >)
    static let greatherthanorequal = Comparator(title: "≥", falseTitle: "≱", compare: >=)

    
    let expression : String?
    let targetSolution : Rational?
    let comparator : Comparator
    
    let calculation : Rational?
    
    var hasExpression : Bool {
        return nil != expression
    }
    
    var isValid : Bool {
        return nil != calculation
    }
    
    var isTrue : Bool {
        guard let calculation = calculation,
        let targetSolution = targetSolution else { return false }
        return comparator.compare(calculation, targetSolution)
    }
    
    var title : String? {
        guard nil != targetSolution else { return nil }
        return isTrue ? comparator.title : comparator.falseTitle
    }
    
    var promptTitle : String? {
        return comparator.title
    }
    
    init(_ expression:String?, _ targetSolution:Rational? = nil, _ comparator:Comparator = Statement.equal) {
        self.expression = expression
        self.targetSolution = targetSolution
        self.calculation = RationalParser.parse(expression ?? "")
        self.comparator = comparator
    }
}
