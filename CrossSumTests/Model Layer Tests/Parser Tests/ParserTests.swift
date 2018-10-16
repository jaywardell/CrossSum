//
//  ParserTests.swift
//  ExpressionParser_iOSTests
//
//  Created by Joseph Wardell on 9/16/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import XCTest
@testable import CrossSum

class ParserTests: XCTestCase {
    
    let onetwothree = "123"
    
    func testParsesOptionalSpaces() {
        let s = Parser.whitespace.parse(" ")
        XCTAssertNotNil(s)
        XCTAssertEqual(s?.0, [" "])
        XCTAssertEqual(s?.1, "")

        let ss = Parser.ignoredWhitespace.parse("     ")
        XCTAssertNotNil(ss)
        XCTAssertNil(ss?.0)
        XCTAssertEqual(ss?.1, "")

        let sss = Parser.ignoredWhitespace.parse("    abc")
        XCTAssertNotNil(sss)
        XCTAssertNil(sss?.0)
        XCTAssertEqual(sss?.1, "abc")
    }
    
    func testParsesCharacter() {
        let c = Parser.character(in:"*").parse("*")
        XCTAssertEqual(c?.0, "*")
        XCTAssertEqual(c?.1, "")
        
        let n = Parser.character(in:"*").parse("_")
        XCTAssertNil(n)
    }
    
    func testParsesDigit() {
        let d  = Parser.digit.parse("123")
        XCTAssertEqual(d?.0, "1")
        XCTAssertEqual(d?.1, "23")
    }
    
    func testParsesManyDigits() {
        let dd = Parser.digit.many.parse("123")
        XCTAssertEqual(dd?.0, ["1","2","3"])
        XCTAssertEqual(dd?.1, "")

        let ddr = Parser.digits.parse("123abc123")
        XCTAssertEqual(ddr?.0, "123")
        XCTAssertEqual(ddr?.1, "abc123")
        
        let dds = Parser.digits.parse("  123abc  123")
        XCTAssertEqual(dds?.0, "123")
        XCTAssertEqual(dds?.1, "abc  123")

        let ddss = Parser.digits.parse("  123   ")
        XCTAssertEqual(ddss?.0, "123")
        XCTAssertEqual(ddss?.1, "")

        let nothing = Parser.digits.parse("")
        XCTAssertNil(nothing?.0)
        XCTAssertEqual(nothing?.1, "")
    }
    
    func testParserDotComplete() {
        
        XCTAssertNotNil(Parser.digits.complete.parse("1 "))
        XCTAssertNotNil(Parser.digits.complete.parse(""))
        XCTAssertNil(Parser.digits.complete.parse("+"))
        XCTAssertNil(Parser.digits.complete.parse("  123abc  123"))
    }

    func testFollowedBy() {
        
        let digitFactorial = Parser.digits.followed(by: .character(in:"!"))
        let r = digitFactorial.parse("123!")
        XCTAssertEqual(r?.0.0, "123")
        XCTAssertEqual(r?.0.1, "!")
        XCTAssertEqual(r?.1, "")

        let r2 = digitFactorial.parse("123! ")
        XCTAssertEqual(r2?.0.0, "123")
        XCTAssertEqual(r2?.0.1, "!")
        XCTAssertEqual(r2?.1, " ")

        let r3 = digitFactorial.parse("")
        XCTAssertNil(r3?.0)
        XCTAssertNil(r3?.1)

    }

    func testOptional() {
        
        let aOrb = Parser.character(in: "a").optional(.character(in:"b"))
        let r1 = aOrb.parse("a")
        XCTAssertEqual(r1?.0, "a")
        XCTAssertEqual(r1?.1, "")

        let r2 = aOrb.parse("b ")
        XCTAssertEqual(r2?.0, "b")
        XCTAssertEqual(r2?.1, " ")

        let r3 = aOrb.parse("cdefb ")
        XCTAssertNil(r3?.0)
        XCTAssertNil(r3?.1)
    }
    
    func testStringParser() {
        let sut = Parser.character(in: "a").string()

        let r1 = sut.parse("a")
        XCTAssertEqual(r1!.0, "a")
        XCTAssertEqual(r1!.1, "")

        let r2 = sut.parse("ab")
        XCTAssertEqual(r2!.0, "a")
        XCTAssertEqual(r2!.1, "b")
        
        let r3 = sut.parse("aaaab")
        XCTAssertEqual(r3!.0, "aaaa")
        XCTAssertEqual(r3!.1, "b")

    }
    
    func testLengthLimitedStringParser() {
        let sut = Parser.character(in: "a").string(length:1)
        
        let r1 = sut.parse("a")
        XCTAssertEqual(r1!.0, "a")
        XCTAssertEqual(r1!.1, "")
        
        let r2 = sut.parse("ab")
        XCTAssertEqual(r2!.0, "a")
        XCTAssertEqual(r2!.1, "b")
        
        let r3 = sut.parse("aaaab")
        XCTAssertEqual(r3!.0, "a")
        XCTAssertEqual(r3!.1, "aaab")
        
    }

}
