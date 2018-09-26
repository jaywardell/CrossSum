//
//  RationalParser.swift
//  CrossSum
//
//  Created by Joseph Wardell on 9/25/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import Foundation

extension Parser where A == Rational? {
    static let rational = Parser<Character>.pos_negDigits.map {  Rational($0) }
}

struct RationalParser {
    
    static func parse(_ string:String) -> Rational? {
        return grammar.parse(string[...])?.0
    }
    
    static var grammar = addition.complete
    
    private static var multiplication =
        Parser.repeatableInfix(Parser.rational, .character(in:Op.times_dividedBy)) { m_d($0, $1, $2) }
    
    private static var addition =
        Parser.repeatableInfix(multiplication, .character(in:Op.plus_minus)) { a_s($0, $1, $2) }
    
    
    private static func m_d(_ x:Rational!, _ op:Character!, _ y:Rational!) -> Rational? {
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
    
    private static func a_s(_ x:Rational!, _ op:Character!, _ y:Rational!) -> Rational? {
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
