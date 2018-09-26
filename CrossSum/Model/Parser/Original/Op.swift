//
//  Op.swift
//  ExpressionParser
//
//  Created by Joseph Wardell on 9/23/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import Foundation

struct Op {
    static let plus = "+"
    static let minus = "-"
    static let times = "*×"
    static let dividedBy = "/÷"
    static let plus_minus = plus + minus
    static var times_dividedBy = times + dividedBy
}
