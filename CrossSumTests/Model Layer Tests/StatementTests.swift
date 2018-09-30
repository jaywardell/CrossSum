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
        XCTAssert(Statement("2*3",6, Statement.equal).isTrue)
        XCTAssert(Statement("-2*3",-6).isTrue)
        XCTAssert(Statement("1-2*3",-5).isTrue)
        XCTAssert(Statement("0*3",0).isTrue)
        XCTAssert(Statement("25",25).isTrue)
        XCTAssert(Statement("5/2",2.5).isTrue)
    }
    
    func testShowsTitleWhenTrue() {
        XCTAssertEqual(Statement("1+1", 2).title, Statement.equal.title)
        XCTAssertEqual(Statement("2*2", 4).title, Statement.equal.title)
    }

    func testShowsFalseTitleWhenFalse() {
        XCTAssertEqual(Statement("1+1", 1).title, Statement.equal.falseTitle)
        XCTAssertEqual(Statement("2*2", 5).title, Statement.equal.falseTitle)
        XCTAssertEqual(Statement("", 5).title, Statement.equal.falseTitle)
    }

    func testEmptyTargetolution() {
        XCTAssertNil(Statement("1+1").targetSolution)
        XCTAssert(Statement("1+1").isValid)
        XCTAssert(!Statement("1+1").isTrue)
        XCTAssertEqual(Statement("1+1").title, nil)
    }
    
    func testNotEqual() {
        XCTAssert(Statement("2*-3",6, Statement.notequal).isTrue)
        XCTAssert(Statement("-2*-3",-6, Statement.notequal).isTrue)
        XCTAssert(Statement("2*3",-5, Statement.notequal).isTrue)
        XCTAssert(Statement("0*3",1, Statement.notequal).isTrue)
        XCTAssert(Statement("25",24, Statement.notequal).isTrue)
        XCTAssert(Statement("5/2",2.75, Statement.notequal).isTrue)
   }


    func testIsValid() {
        XCTAssert(Statement("2*3",6).isValid)
        XCTAssert(Statement("0*3",0).isValid)
        XCTAssert(!Statement("0*3-",0).isValid)
        XCTAssert(!Statement("",25).isValid)

        // if it's invalid, then it can't be true
        XCTAssert(!Statement("0*3-",0).isTrue)
        XCTAssert(!Statement("",25).isTrue)
    }

    func testLessThan() {
        XCTAssert(Statement("2*3",7, Statement.lessthan).isTrue)
        XCTAssert(Statement("-2*3",-5, Statement.lessthan).isTrue)
        XCTAssert(Statement("1-2*3",-4, Statement.lessthan).isTrue)
        XCTAssert(Statement("0*3",1, Statement.lessthan).isTrue)
        XCTAssert(Statement("25",30, Statement.lessthan).isTrue)

        XCTAssert(!Statement("2*3",6, Statement.lessthan).isTrue)
        XCTAssert(!Statement("-2*3",-6, Statement.lessthan).isTrue)
        XCTAssert(!Statement("1-2*3",-5, Statement.lessthan).isTrue)
        XCTAssert(!Statement("0*3",0, Statement.lessthan).isTrue)
        XCTAssert(!Statement("25",25, Statement.lessthan).isTrue)
    }

    func testLessThanOrEqualTo() {
        XCTAssert(Statement("2*3",7, Statement.lessthanorequal).isTrue)
        XCTAssert(Statement("-2*3",-5, Statement.lessthanorequal).isTrue)
        XCTAssert(Statement("1-2*3",-4, Statement.lessthanorequal).isTrue)
        XCTAssert(Statement("0*3",1, Statement.lessthanorequal).isTrue)
        XCTAssert(Statement("25",30, Statement.lessthanorequal).isTrue)
        
        XCTAssert(Statement("2*3",6, Statement.lessthanorequal).isTrue)
        XCTAssert(Statement("-2*3",-6, Statement.lessthanorequal).isTrue)
        XCTAssert(Statement("1-2*3",-5, Statement.lessthanorequal).isTrue)
        XCTAssert(Statement("0*3",0, Statement.lessthanorequal).isTrue)
        XCTAssert(Statement("25",25, Statement.lessthanorequal).isTrue)
    }

    func testGreaterThan() {
        XCTAssert(Statement("2*3",11/2, Statement.greatherthan).isTrue)
        XCTAssert(Statement("-2*3",-10, Statement.greatherthan).isTrue)
        XCTAssert(Statement("1-2*3",-10, Statement.greatherthan).isTrue)
        XCTAssert(Statement("0*3",-1, Statement.greatherthan).isTrue)
        XCTAssert(Statement("25",200/10, Statement.greatherthan).isTrue)
        
        XCTAssert(!Statement("2*3",6, Statement.greatherthan).isTrue)
        XCTAssert(!Statement("-2*3",-6, Statement.greatherthan).isTrue)
        XCTAssert(!Statement("1-2*3",-5, Statement.greatherthan).isTrue)
        XCTAssert(!Statement("0*3",0, Statement.greatherthan).isTrue)
        XCTAssert(!Statement("25",25, Statement.greatherthan).isTrue)
    }

    func testGreaterThanOrEqualTo() {
        XCTAssert(Statement("2*3",11/2, Statement.greatherthanorequal).isTrue)
        XCTAssert(Statement("-2*3",-10, Statement.greatherthanorequal).isTrue)
        XCTAssert(Statement("1-2*3",-10, Statement.greatherthanorequal).isTrue)
        XCTAssert(Statement("0*3",-1, Statement.greatherthanorequal).isTrue)
        XCTAssert(Statement("25",200/10, Statement.greatherthanorequal).isTrue)
        
        XCTAssert(Statement("2*3",6, Statement.greatherthanorequal).isTrue)
        XCTAssert(Statement("-2*3",-6, Statement.greatherthanorequal).isTrue)
        XCTAssert(Statement("1-2*3",-5, Statement.greatherthanorequal).isTrue)
        XCTAssert(Statement("0*3",0, Statement.greatherthanorequal).isTrue)
        XCTAssert(Statement("25",25, Statement.greatherthanorequal).isTrue)
    }    
}
