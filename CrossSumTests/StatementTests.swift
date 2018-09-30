//
//  StatementTests.swift
//  CrossSumTests
//
//  Created by Joseph Wardell on 9/29/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import XCTest
@testable import CrossSum

class StatementTests: XCTestCase {

    func testEqual() {
        XCTAssert(Statement("2*3",6, ==).isTrue)
        XCTAssert(Statement("-2*3",-6, ==).isTrue)
        XCTAssert(Statement("1-2*3",-5, ==).isTrue)
        XCTAssert(Statement("0*3",0, ==).isTrue)
        XCTAssert(Statement("25",25, ==).isTrue)
        XCTAssert(Statement("5/2",2.5, ==).isTrue)
    }
    
    func testNotEqual() {
        XCTAssert(Statement("2*-3",6, !=).isTrue)
        XCTAssert(Statement("-2*-3",-6, !=).isTrue)
        XCTAssert(Statement("2*3",-5, !=).isTrue)
        XCTAssert(Statement("0*3",1, !=).isTrue)
        XCTAssert(Statement("25",24, !=).isTrue)
        XCTAssert(Statement("5/2",2.75, !=).isTrue)
   }

    
    func testIsValid() {
        XCTAssert(Statement("2*3",6, ==).isValid)
        XCTAssert(Statement("0*3",0, ==).isValid)
        XCTAssert(!Statement("0*3-",0, ==).isValid)
        XCTAssert(!Statement("",25, ==).isValid)

        // if it's invalid, then it can't be true
        XCTAssert(!Statement("0*3-",0, ==).isTrue)
        XCTAssert(!Statement("",25, ==).isTrue)
    }
    
    func testLessThan() {
        XCTAssert(Statement("2*3",7, <).isTrue)
        XCTAssert(Statement("-2*3",-5, <).isTrue)
        XCTAssert(Statement("1-2*3",-4, <).isTrue)
        XCTAssert(Statement("0*3",1, <).isTrue)
        XCTAssert(Statement("25",30, <).isTrue)

        XCTAssert(!Statement("2*3",6, <).isTrue)
        XCTAssert(!Statement("-2*3",-6, <).isTrue)
        XCTAssert(!Statement("1-2*3",-5, <).isTrue)
        XCTAssert(!Statement("0*3",0, <).isTrue)
        XCTAssert(!Statement("25",25, <).isTrue)
    }
    
    func testCustomComparator() {
        
        XCTAssert(Statement("6", 6, { 0 == ($0.abs - $1) }).isTrue)
        XCTAssert(Statement("2*-3", 6, { 0 == ($0.abs - $1) }).isTrue)
        XCTAssert(Statement("2*-3", 5, { 0 != ($0.abs - $1) }).isTrue)
    }
    
}
