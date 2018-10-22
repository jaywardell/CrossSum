//
//  Parser<Int>.swift
//  ExpressionParser_iOS
//
//  Created by Joseph Wardell on 9/16/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import Foundation

extension Parser where A == Int? {
    static let int = Parser<Character>.pos_negDigits.map {  Int($0) }
}


struct IntParser {

    static var multiplication =
        Parser.repeatableInfix(Parser.int, .character(in:Op.times_dividedBy)) { m_d($0, $1, $2) }

    static var addition =
        Parser.repeatableInfix(multiplication, .character(in:Op.plus_minus)) { a_s($0, $1, $2) }

    static func m_d(_ x:Int!, _ op:Character!, _ y:Int!) -> Int? {
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

    static func a_s(_ x:Int!, _ op:Character!, _ y:Int!) -> Int? {
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
