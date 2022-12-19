//
//  RationalTests.swift
//  RationalTests
//
//  Created by Joseph Wardell on 9/23/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import XCTest

@testable import CrossSum

class RationalTests: XCTestCase {

    func testRationalCreation() {
        let one = Rational(1)
        XCTAssertEqual(one.numerator, 1)
        XCTAssertEqual(one.denominator, 1)
        
        let two = Rational(2)
        XCTAssertEqual(two.numerator, 2)
        XCTAssertEqual(two.denominator, 1)

        let zero = Rational(0)
        XCTAssertEqual(zero.numerator, 0)
        XCTAssertEqual(zero.denominator, 1)

        let negativeTwo = Rational(-2)
        XCTAssertEqual(negativeTwo.numerator, -2)
        XCTAssertEqual(negativeTwo.denominator, 1)

        let onehalf = Rational(1, 2)
        XCTAssertEqual(onehalf.numerator, 1)
        XCTAssertEqual(onehalf.denominator, 2)
        
        XCTAssertEqual(Rational(1,1), Rational(5,5))
        XCTAssertEqual(Rational(5,10), Rational(1,2))
    }
    
    func testIsNan() {
        let nan = Rational(1,0)
        XCTAssert(nan.isNan)
    }
    
    func testRationalCreationFromString() {
        
        XCTAssertEqual(r("1"), Rational(1))
        XCTAssertEqual(r(" 1 "), Rational(1))
        XCTAssertEqual(r("2"), Rational(2))
        XCTAssertEqual(r("-2"), Rational(-2))
        XCTAssertEqual(r("-2/-2"), Rational(1))
        XCTAssertEqual(r("0"), Rational(0))
        XCTAssertEqual(r("1/2"), Rational(1,2))
        XCTAssertEqual(r(" 1 / 2 "), Rational(1,2))
        XCTAssertEqual(r("3/3"), Rational(1))

        XCTAssertNil(r("hello"))
        XCTAssertNil(r(""))
        XCTAssertNil(r("1/hello"))
        XCTAssertNil(r("1hello"))
        XCTAssertNil(r("1+hello"))
        XCTAssert((r("1/0")?.isNan)!)

        XCTAssertEqual(r("4/-9"), r("-4/9"))
    }
    
    func testRationalCreationFromDouble() {
        
        XCTAssertEqual(Rational(1.0), Rational(1))
        XCTAssertEqual(Rational(0.0), Rational(0))
        XCTAssertEqual(Rational(-1.0), Rational(-1))

        XCTAssertEqual(Rational(0.5), Rational(1,2))
        
        XCTAssertEqual(Rational(1.0/4), Rational(1,4))
        XCTAssertEqual(Rational(3.141592), Rational(3141592,1000000))

        XCTAssertEqual(Rational(15/24.0), Rational(30, 48))
        
        // repeating decimals cannot be translated directly to Rational safely
        XCTAssertNotEqual(Rational(1.0/3), Rational(1,3))
        // but they do approximate the intended value, fwiw
        XCTAssert(Double(Rational(1.0/3)! - Rational(1,3)) < 0.00000001)
    }
    
    func testAddition() {
        
        XCTAssertEqual(r("1") + r("1"), r("2"))
        XCTAssertEqual(r("0") + r("1"), r("1"))
        XCTAssertEqual(r("1") + r("-3"), r("-2"))
        XCTAssertEqual(r("1/2") + r("1/2"), r("1"))
        XCTAssertEqual(r("1/2") + r("1/2"), Rational(2,2))
        XCTAssertEqual(r("1/2") + r("1/2"), Rational(3,3))
        XCTAssertEqual(r("1/3") + r("1/3") + r("1/3"), r("5/5"))
        XCTAssertEqual(r("1/4") + r("1/4"), r("1/2"))
        XCTAssertEqual(r("1/4") + r("1/2"), r("3/4"))
        XCTAssertEqual(r("3/4") + r("1/2"), r("5/4"))
        XCTAssertEqual(r("3/4") + r("1/2"), r("1") + r("1/4"))
    }
    
    func testSubtraction() {
        XCTAssertEqual(r("1") - r("0"), r("1"))
        XCTAssertEqual(r("1") - r("1"), r("0"))
        XCTAssertEqual(r("1") - r("2"), r("-1"))
        XCTAssertEqual(r("1") - r("1/2"), r("1/2"))
        XCTAssertEqual(r("1/2") - r("1"), r("-1/2"))
        XCTAssertEqual(r("20/5") - r("5/2"), r("3/2"))
    }
    
    func testMultiplication() {
        XCTAssertEqual(r("1") * r("1"), r("1"))
        XCTAssertEqual(r("2") * r("2"), r("4"))
        XCTAssertEqual(r("2") * r("1/2"), r("1"))
        XCTAssertEqual(r("1/2") * r("1/2"), r("1/4"))
        XCTAssertEqual(r("1/3") * r("8/6"), r("4/9"))
        XCTAssertEqual(r("-1/3") * r("8/6"), r("-4/9"))
        XCTAssertEqual(r("-1/3") * r("8/-6"), r("4/9"))
        XCTAssertEqual(r("-1/3") * r("0"), r("0"))
        XCTAssert((r("3/4") * r("1/0")).isNan)
    }
    
    func testDivision() {
        XCTAssertEqual(r("1") / r("1"), r("1"))
        XCTAssertEqual(r("2") / r("2"), r("1"))
        XCTAssertEqual(r("2") / r("1/2"), r("4"))
        XCTAssertEqual(r("1/2") / r("1/2"), r("1"))
        XCTAssertEqual(r("1/3") / r("8/6"), r("1/4"))
        XCTAssertEqual(r("-1/3") / r("8/6"), r("-1/4"))
        XCTAssertEqual(r("-1/3") / r("8/-6"), r("1/4"))
        XCTAssert((r("3/4") / r("0")).isNan)
    }

    func testDoubleValue() {
        
        XCTAssertEqual(r("1")?.decimalValue, 1)
        XCTAssertEqual(r("1/2")?.decimalValue, 0.5)
        XCTAssertEqual(r("3/2")?.decimalValue, 1.5)
        XCTAssertEqual(r("-3/2")?.decimalValue, -1.5)
        XCTAssertEqual(r("0/2")?.decimalValue, 0)
        
        XCTAssertEqual(Double(r("1")), 1)
        XCTAssertEqual(Double(r("1/2")), 0.5)
        XCTAssertEqual(Double(r("3/2")), 1.5)
        XCTAssertEqual(Double(r("-3/2")), -1.5)
        XCTAssertEqual(Double(r("0/2")), 0)
    }
    
    func testMixedNumbers() {
        
        XCTAssertEqual(r("3/2")?.integerPart, 1)
        XCTAssertEqual(r("3/2")?.fractionalPart, r("1/2"))

        XCTAssertEqual(r("-3/2")?.integerPart, -1)
        XCTAssertEqual(r("-3/2")?.fractionalPart, r("-1/2"))
        
        XCTAssertEqual(r("16/4")?.fractionalPart, r("0"))
 
        XCTAssertEqual(r("1/2")?.integerPart, 0)
    }
    
    func testIntegerLiteralType() {
        
        let one : Rational = 1
        let two = one + one

        XCTAssertEqual(one + 5, Rational(6))
        XCTAssertEqual(one + 5, 6)
        XCTAssertEqual(two, 2)

        let onea = Rational(1,2) + Rational(1,2)
        XCTAssertEqual(one, onea)
        
        let onehalf = one / two
        XCTAssertEqual(onehalf, Rational(1.0/2))
    }
    
    func testOperationsWithInt() {
        
        // the swift compiler gives us these automatically due to conformance to ExpressibleByIntegerLiteral
        XCTAssertEqual(Rational(1) + 5, Rational(6))
        XCTAssertEqual(Rational(1) - 5, Rational(-4))
        XCTAssertEqual(5 + Rational(1), Rational(6))
        
        // these require custom operator functions between Int and Rational
        let five = 5
        let six = Rational(1) + five
        XCTAssertEqual(six, 6)
        let sixb = five + Rational(1)
        XCTAssertEqual(sixb, 6)
        
        XCTAssertEqual(six - five, 1)
        XCTAssertEqual(five - six, -1)
        
        let twenty : Rational = 20
        XCTAssertEqual(twenty * five, 100)
        XCTAssertEqual(five * twenty, 100)
        XCTAssertEqual(twenty / five, 4)
        XCTAssertEqual(five/twenty, "1/4")
    }
    
    func testExpressibleByFloatLiteral() {
        
        let five : Rational = 5.0
        let two : Rational = 2.0
        let onehalf : Rational = 0.5

        XCTAssertEqual(five, Rational(5))
        XCTAssertEqual(two, Rational(2))
        XCTAssertEqual(onehalf, Rational(1,2))

        let negativeOneFifth : Rational = -0.2
        XCTAssertEqual(negativeOneFifth, Rational(-1,5))

        let negFivePoint2 : Rational = -5.2
        XCTAssertEqual(negFivePoint2, -5.2)
        XCTAssertEqual(Rational(26,5), 5.2)
        XCTAssertEqual(negFivePoint2, Rational(-26,5))

        XCTAssertEqual(five/2, Rational("5/2"))
        XCTAssertEqual(5.0/0, Rational(5,0))
        XCTAssertEqual(Rational(5,0), 5/0.0)

        let invalid : Rational = 5.0/0
        XCTAssert(invalid.isNan)
    }
    
    func testComparisons() {
        
        XCTAssert(Rational(0) < Rational(1))
        XCTAssert(Rational(1.0/2) < Rational(1))
        XCTAssert(1.0/2.0 < Rational(1))
        XCTAssert(Rational(1.0/2) < Rational(2.0/3))
        XCTAssert(Rational(1.0/2) > Rational(1.0/3))
        XCTAssert(Rational(-1.0/2) < 0)
        XCTAssert(Rational(-1.0/2) < -1.0/4.0)
        XCTAssert(Rational(-3,2) < 0)
        XCTAssert(Rational(3,-2) < 0)
        XCTAssert(Rational(3,-2) < -1)

        let one = 1
        XCTAssert(Rational(3,-2) < one)
        XCTAssert(Rational(3,2) > one)
        XCTAssert(one > Rational(3,-2))
        XCTAssert(one < Rational(3,2))

        XCTAssert(Rational(3,-2) <= one)
        XCTAssert(Rational(3,2) >= one)
        XCTAssert(one >= Rational(3,-2))
        XCTAssert(one <= Rational(3,2))

        let oned = 1.0
        XCTAssert(Rational(3,-2) < oned)
        XCTAssert(Rational(3,2) > oned)
        XCTAssert(oned > Rational(3,-2))
        XCTAssert(oned < Rational(3,2))
        
        XCTAssert(Rational(3,-2) <= oned)
        XCTAssert(Rational(3,2) >= oned)
        XCTAssert(oned >= Rational(3,-2))
        XCTAssert(oned <= Rational(3,2))

        XCTAssertEqual(Rational(3,-2), Rational(-3,2))
    }
    
    func testStandardized() {
        XCTAssertEqual(Rational(3,-2).standardized.numerator, -3)
        XCTAssertEqual(Rational(3,-2).standardized.denominator, 2)

        XCTAssertEqual(Rational(-3,2).standardized.numerator, -3)
        XCTAssertEqual(Rational(-3,2).standardized.denominator, 2)

        XCTAssertEqual(Rational(3,2).standardized.numerator, 3)
        XCTAssertEqual(Rational(3,2).standardized.denominator, 2)

        XCTAssertEqual(Rational(-3,-2).standardized.numerator, 3)
        XCTAssertEqual(Rational(-3,-2).standardized.denominator, 2)

        XCTAssertEqual(Rational(-9,-6).standardized.numerator, 3)
        XCTAssertEqual(Rational(-9,-6).standardized.denominator, 2)

        XCTAssertEqual(Rational(-9,6).standardized.numerator, -3)
        XCTAssertEqual(Rational(-9,6).standardized.denominator, 2)

        XCTAssertEqual(Rational(-6,9).standardized.numerator, -2)
        XCTAssertEqual(Rational(-6,9).standardized.denominator, 3)
    }
    
    func testNegation() {
        
        XCTAssertEqual(-Rational(5), -5)
        XCTAssertEqual(-Rational(5), -5.0)
        XCTAssertEqual(-Rational(5), Rational(-5))
        XCTAssertEqual(-Rational(0), 0)
    }
    
    func testRounding() {
        XCTAssertEqual(Rational(0.5).rounded, 1)
        XCTAssertEqual(Rational(0.51).rounded, 1)
        XCTAssertEqual(Rational(0.49999).rounded, 0)
        XCTAssertEqual(Rational(-1,100000).rounded, 0)
        
        XCTAssertEqual(Rational(-99/100).fractionalPart, Rational(-99/100))
        XCTAssertEqual(Rational(-99/100).integerPart, 0)
        XCTAssertEqual(Rational(-99,100).rounded, -1)
    }
    
    func testAbsoluteValue() {
        
        XCTAssertEqual(Rational(1).abs, 1)
        XCTAssertEqual(Rational(-1).abs, 1)
        XCTAssertEqual(Rational(0).abs, 0)
        XCTAssertEqual(Rational(3.0/2).abs, 3.0/2)
        XCTAssertEqual(Rational(-3.0/2).abs, 3.0/2)
        XCTAssertEqual(Rational(3.0 / -2.0).abs, 3.0/2)
    }
    
    func testInfinity() {
        
        // we can't and don't handle infinite values
        XCTAssertNil(Rational(Double.infinity))
        XCTAssertNil(Rational(-Double.infinity))
        
        // but since Double interprests 1/infinity as 0, so do we
        XCTAssertEqual(Rational(1/Double.infinity), 0)
        XCTAssertEqual(Rational(-1/Double.infinity), 0)
    }
    
    func testDoubleNan() {
        
        XCTAssertEqual(Rational(Double.nan), Rational(5,0))
        XCTAssertEqual(Rational(Double.nan), Rational(1,0))
        XCTAssert((Rational(Double.nan)! * 5).isNan)
 
        XCTAssertEqual(Rational("1/0"), Rational(5,0))
    }
    
    func testMinMax() {
        
        XCTAssertEqual(Rational.maximum.numerator, Int.max)
        XCTAssertEqual(Rational.maximum.denominator, 1)

        XCTAssertEqual(Rational.minimum.numerator, Int.min)
        XCTAssertEqual(Rational.minimum.denominator, 1)
    }
    
    func testSyntax() {
        
        // just some interesting things we can do syntactically now
        XCTAssertEqual(1 + 0.5, Rational("3/2"))
        
        let r : Rational = "3/2"
        XCTAssertEqual(r, 3.0/2)
        XCTAssertEqual(r, Rational(3,2))
 
        let r2 = r + 1
        XCTAssertEqual(r2, Rational(5,2))
    }
    
    func testDescription() {
        
        XCTAssertEqual(Rational(1).description, "1")
        XCTAssertEqual(Rational(0).description, "0")
        XCTAssertEqual(Rational(-1).description, "-1")

        XCTAssertEqual(Rational(1.0/2).description, "1/2")
        XCTAssertEqual(Rational(1,2).description, "1/2")
        XCTAssertEqual(Rational(3,2).description, "1 1/2")
        XCTAssertEqual(Rational(13,12).description, "1 1/12")
        XCTAssertEqual(Rational(23,12).description, "1 11/12")
        XCTAssertEqual(Rational(22,12).description, "1 5/6")
        XCTAssertEqual(Rational(3,-2).description, "-1 1/2")
        XCTAssertEqual(Rational(-22,12).description, "-1 5/6")

        XCTAssertEqual(Rational(5,5).fractionalPart, 0)

        XCTAssertEqual(Rational(5,5).description, "1")
        XCTAssertEqual(Rational(-5,5).description, "-1")

        XCTAssertEqual(Rational(-5,0).description, "nan")
    }
    
    // MARK:-

    // just to make the syntax easier to read in the testing enviornment
    private func r(_ string:String) -> Rational! {
        return Rational(string)
    }
}

