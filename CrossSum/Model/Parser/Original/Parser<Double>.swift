//
//  Parser<Double>.swift
//  ExpressionParser_iOS
//
//  Created by Joseph Wardell on 9/19/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import Foundation

extension Parser where A == Double? {
    // TODO: allow for parsing numbers with decimal values
    static let double = Parser<Character>.pos_negDigits.map {  Double($0) }
}

struct DoubleParser {
    static var multiplication =
        Parser.repeatableInfix(Parser.double,
                               .character(in:Op.times_dividedBy)) {  m_d($0, $1, $2) }
    
    static var addition =
        Parser.repeatableInfix(multiplication, .character(in:Op.plus + Op.minus)) { a_s($0, $1, $2) }
    
    
    private static func m_d(_ x:Double!, _ op:Character!, _ y:Double!) -> Double? {
        guard let x = x, let op = op, let y = y else { return nil }
        if Op.times.contains(op) {
            return x * y
        }
        else if Op.dividedBy.contains(op) {
            guard y != 0 else { return nil }
            return x / y
        }
        return nil
    }
    
    private static func a_s(_ x:Double!, _ op:Character!, _ y:Double!) -> Double? {
        guard let x = x, let op = op, let y = y else { return nil }
        if Op.plus.contains(op) {
            return x + y
        }
        else if Op.minus.contains(op) {
            return x - y
        }
        
        return nil
    }
}
