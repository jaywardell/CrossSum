//
//  IntParserTests.swift
//  ExpressionParser_iOSTests
//
//  Created by Joseph Wardell on 9/19/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import XCTest
@testable import CrossSum

class IntParserTests: XCTestCase {
    
    func testParsesInteger() {
        let i = Parser.int.parse("123abv")
        XCTAssertEqual(i?.0, 123)
        XCTAssertEqual(i?.1, "abv")
        
        let nothing = Parser.int.parse("")
        XCTAssertNil(nothing)
    }
    
    func testParsesNegatievInteger() {
        let i = Parser.int.parse("-15-45")
        XCTAssertEqual(i?.0, -15)
        XCTAssertEqual(i?.1, "-45")
        
        let i2 = Parser.int.parse(i!.1)
        XCTAssertEqual(i2?.0, -45)
        XCTAssertEqual(i2?.1, "")
    }
    
    func testParseInfix() {
        
        let p = Parser<Int?>.repeatableInfix(Parser.int, .character(in: "-")) { $0! - $2! }
        XCTAssertEqual(p.parse("3-1")?.0, 2)
        XCTAssertEqual(p.parse("3-5")?.0, -2)
        XCTAssertEqual(p.parse("-5")?.0, -5) // int parser covers this
        XCTAssertEqual(p.parse("3-5-9-0-2")?.0, -13)
        XCTAssertEqual(p.parse("25")?.0, 25)
        XCTAssertEqual(p.parse("2-")?.0, 2)
        XCTAssertEqual(p.parse("2--")?.0, 2)
        XCTAssertEqual(p.parse("2+7")?.0, 2)
        XCTAssertNil(p.parse("p"))
        
        XCTAssertEqual(p.parse("5-2+3")?.0, 3)
        XCTAssertEqual(p.parse("5-2+3")?.1, "+3")
    }
    
    func testParsesMultiplication() {
        let r = IntParser.multiplication.parse("12*3")
        XCTAssertEqual(r?.0, 36)
        XCTAssertEqual(r?.1, "")
        
        let rr = IntParser.multiplication.parse("12×3")
        XCTAssertEqual(rr?.0, 36)
        XCTAssertEqual(rr?.1, "")
        
        XCTAssertNil(IntParser.m_d(2, "%", 3))
    }
    
    func testMultiplicationFallsbackToInt() {
        
        let a = IntParser.multiplication.parse("15")
        XCTAssertEqual(a?.0, 15)
        XCTAssertEqual(a?.1, "")
    }
    
    func testParsesDivision() {
        let r = IntParser.multiplication.parse("12/3")
        XCTAssertEqual(r?.0, 4)
        XCTAssertEqual(r?.1, "")
        
        let rr = IntParser.multiplication.parse("12÷3")
        XCTAssertEqual(rr?.0, 4)
        XCTAssertEqual(rr?.1, "")
    }
    
    func testParsesAddition() {
        let r = IntParser.addition.parse("12+3")
        XCTAssertEqual(r?.0, 15)
        XCTAssertEqual(r?.1, "")
        
        XCTAssertNil(IntParser.a_s(2, "%", 3))
    }
    
    func testParsesSubtraction() {
        let r = IntParser.addition.parse("12-3")
        XCTAssertEqual(r?.0, 9)
        XCTAssertEqual(r?.1, "")
        
        let rs = IntParser.addition.parse("12- 3")
        XCTAssertEqual(rs?.0, 9)
        XCTAssertEqual(rs?.1, "")
        
        let rss = IntParser.addition.parse("12 \t\t - 3")
        XCTAssertEqual(rss?.0, 9)
        XCTAssertEqual(rss?.1, "")
    }
    
    func testMultiplyBeforeAdd() {
        
        let r = IntParser.addition.parse("3*4+8/2")
        XCTAssertEqual(r?.0, 16)
        XCTAssertEqual(r?.1, "")
        
        let s = IntParser.addition.parse("3*4-8/2")
        XCTAssertEqual(s?.0, 8)
        XCTAssertEqual(s?.1, "")
        
        let n = IntParser.addition.parse("-3*4--8/2")
        XCTAssertEqual(n?.0, -8)
        XCTAssertEqual(n?.1, "")
        
        XCTAssertEqual(i().parse("3*4+8/2")?.0, 16)
        XCTAssertEqual(i().parse("3*4-8/2")?.0, 8)
        XCTAssertEqual(i().parse("-3*4--8/2")?.0, -8)
    }
    
    func testChainOfAddition() {
        
        XCTAssertEqual(i().parse("3+4-6+10")?.0, 11)
    }
    
    func testChainOfMultiplication() {
        
        XCTAssertEqual(i().parse("3*4*6*10")?.0, 720)
        XCTAssertEqual(i().parse("3*4÷6*10")?.0, 20)
        XCTAssertEqual(i().parse("-3*4÷-6*10")?.0, 20)
        XCTAssertEqual(i().parse("3*4÷-6*10")?.0, -20)
    }
    
    func testComplexExpression() {
        XCTAssertEqual(i().parse("1-1×2×7")?.0, -13)
        XCTAssertEqual(i().parse("1-2×7")?.0, -13)
        XCTAssertEqual(i().parse("3×2×7")?.0, 42)
    }
    
    func testInvalid() {
        
        XCTAssertNil(i().parse(""))
        XCTAssertNil(i().parse("spam"))
        XCTAssertNil(i().parse("-"))
        XCTAssertNil(i().parse("5-"))
        XCTAssertNil(i().parse("5*+9"))
        XCTAssertNil(i().parse("*+9"))
        XCTAssertNil(i().parse("*9"))
        XCTAssertNil(i().parse("3*3=9"))
    }
    
    // MARK:-
    
    func i() -> Parser<Int?> {
        return IntParser.addition.complete
    }
    
}
