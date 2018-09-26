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

// only needed for the below TODO
//protocol Calculatable : ExpressibleByIntegerLiteral {
//    static func + (lhs: Self, rhs: Self) -> Self
//    static func * (lhs: Self, rhs: Self) -> Self
//    static func - (lhs: Self, rhs: Self) -> Self
//    static func / (lhs: Self, rhs: Self) -> Self
//}

// TODO: I REALLY want to make these universal functions instead of embedding them in each parser type
//       has to be a way...
//func m_d<T:Calculatable>(_ x:T!, _ op:Character!, _ y:T!) -> T? {
//    guard let x = x, let op = op, let y = y else { return nil }
//    if Op.times.contains(op) {
//        return x * y
//    }
//    else if Op.dividedBy.contains(op) {
////        guard y != 0 else { return nil }
//        return x / y
//    }
//    return nil
//}
//
//
//func a_s<T:Calculatable>(_ x:T!, _ op:Character!, _ y:T!) -> T? {
//    guard let x = x, let op = op, let y = y else { return nil }
//    if Op.plus.contains(op) {
//        return x + y
//    }
//    else if Op.minus.contains(op) {
//        return x - y
//    }
//
//    return nil
//}

struct IntParser {

    static var multiplication =
        Parser.repeatableInfix(Parser.int, .character(in:Op.times_dividedBy)) { m_d($0, $1, $2) }
//        int.optional(
//            int.followed(by: Parser<Character>.character(in:Op.times + Op.dividedBy))
//            .followed(by: int)
//                .map { lhs, rhs in m_d(lhs.0, lhs.1, rhs) }
//    )

    static var addition =
        Parser.repeatableInfix(multiplication, .character(in:Op.plus_minus)) { a_s($0, $1, $2) }

//        multiplication.optional(
//            multiplication.followed(by: Parser<Character>.character(in:Op.plus + Op.minus))
//            .followed(by: multiplication)
//            .map { lhs, rhs in a_s(lhs.0, lhs.1, rhs) }
//    )

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

//extension Parser where A == Int {
//    static func <*><A, B>(lhs: Parser<(A)->B>, rhs: Parser<A>) -> Parser<B> {
//        return lhs.followed(by: rhs).map { f, x in f(x) }
//    }
//}
