//
//  RationalParserTests.swift
//  CrossSumTests
//
//  Created by Joseph Wardell on 9/25/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import XCTest
@testable import CrossSum

class RationalParserTests: XCTestCase {
    
    // TODO: test parsing of doubles with decimal points
    // TODO: test infinity
    
    func testChainOfAddition() {
        
        XCTAssertEqual(d().parse("3+4-6+10")?.0, 11)
    }
    
    func testChainOfMultiplication() {
        
        XCTAssertEqual(d().parse("3*4*6*10")?.0, 720)
        XCTAssertEqual(d().parse("3*4÷6*10")?.0, 20)
        XCTAssertEqual(d().parse("-3*4÷-6*10")?.0, 20)
        XCTAssertEqual(d().parse("3*4÷-6*10")?.0, -20)
    }
    
    func testComplexExpression() {
        XCTAssertEqual(d().parse("1-1×2×7")?.0, -13)
        XCTAssertEqual(d().parse("1-2×7")?.0, -13)
        XCTAssertEqual(d().parse("3×2×7")?.0, 42)
        XCTAssertEqual(d().parse("3+2/8")?.0, 3.25)
        XCTAssertEqual(d().parse("3+2/8-5")?.0, -1.75)
    }
    
    func testDivideByZero() {
        // TODO: I probably need more tests here for robustness
        XCTAssertNil(d().parse("1/0")?.0)
    }
    
    func testInvalid() {
        
        XCTAssertNil(d().parse(""))
        XCTAssertNil(d().parse("spam"))
        XCTAssertNil(d().parse("-"))
        XCTAssertNil(d().parse("5-"))
        XCTAssertNil(d().parse("5*+9"))
        XCTAssertNil(d().parse("*+9"))
        XCTAssertNil(d().parse("*9"))
        XCTAssertNil(d().parse("3*3=9"))
        XCTAssertNil(d().parse("-4x"))
        XCTAssertNil(d().parse("-3+"))
    }
    
    // MARK:-
    
    func d() -> Parser<Rational?> {
        return RationalParser.grammar
    }
    
}
