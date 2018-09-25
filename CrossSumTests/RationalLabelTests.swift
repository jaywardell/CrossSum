//
//  RationalLabelTests.swift
//  CrossSumTests
//
//  Created by Joseph Wardell on 9/24/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import XCTest
@testable import CrossSum

class RationalLabelTests: XCTestCase {

    func testContainsLabelsAndFractionBar() {
        let sut = createSUT()
        XCTAssertNotNil(sut.rationalLabel.subviews.first)
        XCTAssertEqual(sut.wholeNumberLabel.superview, sut.rationalLabel)
        XCTAssertEqual(sut.numeratorLabel.superview, sut.rationalLabel)
        XCTAssertEqual(sut.denominatorLabel.superview, sut.rationalLabel)
        XCTAssertEqual(sut.fractionBar.superview, sut.rationalLabel)
    
        XCTAssertEqual(sut.wholeNumberLabel.text, "wl")
        XCTAssertEqual(sut.numeratorLabel.text, "nl")
        XCTAssertEqual(sut.denominatorLabel.text, "dl")
        XCTAssertEqual(sut.fractionBar.backgroundColor, .black)
    }

    func testTakesRational() {
        let sut = createSUT()
        
        // TODO: test isHidden property of fractionBar for each case
        
        // whole number
        sut.rationalLabel.value = 5
        XCTAssertEqual(sut.rationalLabel.value, 5)
        XCTAssertEqual(sut.wholeNumberLabel.text, "5")
        XCTAssertNil(sut.numeratorLabel.text)
        XCTAssertNil(sut.denominatorLabel.text)

        // negative whole number
        sut.rationalLabel.value = -5
        XCTAssertEqual(sut.rationalLabel.value, -5)
        XCTAssertEqual(sut.wholeNumberLabel.text, "-5")
        XCTAssertNil(sut.numeratorLabel.text)
        XCTAssertNil(sut.denominatorLabel.text)

        // zero
        sut.rationalLabel.value = 0
        XCTAssertEqual(sut.rationalLabel.value, 0)
        XCTAssertEqual(sut.wholeNumberLabel.text, "0")
        XCTAssertNil(sut.numeratorLabel.text)
        XCTAssertNil(sut.denominatorLabel.text)

        // mixed number
        sut.rationalLabel.value = 5.2
        XCTAssertEqual(sut.rationalLabel.value, 5.2)
        XCTAssertEqual(sut.wholeNumberLabel.text, "5")
        XCTAssertEqual(sut.numeratorLabel.text, "1")
        XCTAssertEqual(sut.denominatorLabel.text, "5")

        // negative mixed number
        sut.rationalLabel.value = -5.2
        XCTAssertEqual(sut.rationalLabel.value, -5.2)
        XCTAssertEqual(sut.wholeNumberLabel.text, "-5")
        XCTAssertEqual(sut.numeratorLabel.text, "1")
        XCTAssertEqual(sut.denominatorLabel.text, "5")

        // simple fraction
        sut.rationalLabel.value = 0.2
        XCTAssertEqual(sut.rationalLabel.value, 0.2)
        XCTAssertNil(sut.wholeNumberLabel.text)
        XCTAssertEqual(sut.numeratorLabel.text, "1")
        XCTAssertEqual(sut.denominatorLabel.text, "5")

        // negative simple fraction
        sut.rationalLabel.value = -0.2
        XCTAssertEqual(sut.rationalLabel.value, Rational(-2,10))
        XCTAssertEqual(sut.wholeNumberLabel.text, "-")
        XCTAssertEqual(sut.numeratorLabel.text, "1")
        XCTAssertEqual(sut.denominatorLabel.text, "5")

        // negative simple fraction done slightly differently
        sut.rationalLabel.value = Rational(-2,10)
        XCTAssertEqual(sut.rationalLabel.value, Rational(-2,10))
        XCTAssertEqual(sut.wholeNumberLabel.text, "-")
        XCTAssertEqual(sut.numeratorLabel.text, "1")
        XCTAssertEqual(sut.denominatorLabel.text, "5")

        // negative simple fraction done slightly differently
        sut.rationalLabel.value = Rational(2,-10)
        XCTAssertEqual(sut.rationalLabel.value, Rational(-2,10))
        XCTAssertEqual(sut.wholeNumberLabel.text, "-")
        XCTAssertEqual(sut.numeratorLabel.text, "1")
        XCTAssertEqual(sut.denominatorLabel.text, "5")

        // positive simple fraction done weirdly
        sut.rationalLabel.value = Rational(-2,-10)
        XCTAssertEqual(sut.rationalLabel.value, Rational(1,5))
        XCTAssertNil(sut.wholeNumberLabel.text)
        XCTAssertEqual(sut.numeratorLabel.text, "1")
        XCTAssertEqual(sut.denominatorLabel.text, "5")

        // if value is nan, then all labels should be blank
        let r4 = Rational(1.0/0)
        sut.rationalLabel.value = r4
        XCTAssertEqual(sut.rationalLabel.value, r4)
        XCTAssertNil(sut.wholeNumberLabel.text)
        XCTAssertNil(sut.numeratorLabel.text)
        XCTAssertNil(sut.denominatorLabel.text)

        // if value is nil, then all labels should be blank
        sut.rationalLabel.value = 5
        sut.rationalLabel.value = nil
        XCTAssertNil(sut.wholeNumberLabel.text)
        XCTAssertNil(sut.numeratorLabel.text)
        XCTAssertNil(sut.denominatorLabel.text)

    }
    
    func testTextAlignments() {
        
        let sut = createSUT()
        XCTAssertEqual(sut.wholeNumberLabel.textAlignment, .center)
        XCTAssertEqual(sut.numeratorLabel.textAlignment, .center)
        XCTAssertEqual(sut.denominatorLabel.textAlignment, .center)
    }
    
    func testTakesTextColor() {
        let sut = createSUT()
        let c = UIColor.green
        
        sut.rationalLabel.textColor = c
        XCTAssertEqual(sut.rationalLabel.textColor, c)
        XCTAssertEqual(sut.wholeNumberLabel.textColor, c)
        XCTAssertEqual(sut.numeratorLabel.textColor, c)
        XCTAssertEqual(sut.denominatorLabel.textColor, c)
        XCTAssertEqual(sut.fractionBar.backgroundColor, c)
    }

    func testTakesFont() {
        let sut = createSUT()
        let f = UIFont.systemFont(ofSize: 34)

        sut.rationalLabel.font = f
        XCTAssertEqual(sut.rationalLabel.font, f)
        XCTAssertEqual(sut.wholeNumberLabel.font, f)
        XCTAssertEqual(sut.numeratorLabel.font, UIFont.systemFont(ofSize: 13))
        XCTAssertEqual(sut.denominatorLabel.font, UIFont.systemFont(ofSize: 13))
    }
    
    func testAutolayoutIsValid() {
        let sut = createSUT()

        XCTAssertFalse(sut.rationalLabel.translatesAutoresizingMaskIntoConstraints)
        XCTAssertFalse(sut.wholeNumberLabel.translatesAutoresizingMaskIntoConstraints)
        XCTAssertFalse(sut.numeratorLabel.translatesAutoresizingMaskIntoConstraints)
        XCTAssertFalse(sut.denominatorLabel.translatesAutoresizingMaskIntoConstraints)
        XCTAssertFalse(sut.fractionBar.translatesAutoresizingMaskIntoConstraints)

        XCTAssertFalse(sut.rationalLabel.hasAmbiguousLayout)
        XCTAssertFalse(sut.wholeNumberLabel.hasAmbiguousLayout)
        XCTAssertFalse(sut.numeratorLabel.hasAmbiguousLayout)
        XCTAssertFalse(sut.denominatorLabel.hasAmbiguousLayout)
        XCTAssertFalse(sut.fractionBar.hasAmbiguousLayout)
   }

    // TODO: I may need to test this visually, I'm getting nowhere with the code
    func testExpandsWhenValueChangesToMixedNumber() {
        let sut = createSUT()
        
        // mixed number
        sut.rationalLabel.value = 5.2
        XCTAssertEqual(sut.rationalLabel.frame.width, 26.5+26.5)
        XCTAssertEqual(sut.rationalLabel.frame.height, 69.5)

        XCTAssertEqual(sut.wholeNumberLabel.frame.width, 26.5)
        XCTAssertEqual(sut.wholeNumberLabel.frame.height, 69.5)

        XCTAssertEqual(sut.numeratorLabel.frame.width, 26.5)
        XCTAssertEqual(sut.numeratorLabel.frame.height, 26.5)

        XCTAssertEqual(sut.denominatorLabel.frame.width, 26.5)
        XCTAssertEqual(sut.denominatorLabel.frame.height, 26.5)

        XCTAssertEqual(sut.numeratorLabel.frame.width, sut.denominatorLabel.frame.width)
        XCTAssertEqual(sut.numeratorLabel.frame.height, sut.denominatorLabel.frame.height)

        XCTAssertEqual(sut.fractionBar.frame.width, 26.5)
        XCTAssertEqual(sut.fractionBar.frame.height, 5)
        
        XCTAssertEqual(sut.numeratorLabel.frame.origin.x, sut.denominatorLabel.frame.origin.x)
        XCTAssertEqual(sut.numeratorLabel.frame.origin.x, sut.fractionBar.frame.origin.x)
        XCTAssert(sut.wholeNumberLabel.frame.origin.x < sut.numeratorLabel.frame.origin.x)
    }

    func testExpandsWhenValueChangesToFraction() {
        let sut = createSUT()
        
        // mixed number
        sut.rationalLabel.value = 0.2
        XCTAssertEqual(sut.rationalLabel.frame.width, 16+26.5)
        XCTAssertEqual(sut.rationalLabel.frame.height, 53.5)
        
        XCTAssertEqual(sut.wholeNumberLabel.frame.width, 0)
        XCTAssertEqual(sut.wholeNumberLabel.frame.height, 53.5)
        
        XCTAssertEqual(sut.numeratorLabel.frame.width, 26.5)
        XCTAssertEqual(sut.numeratorLabel.frame.height, 20.5)
        
        XCTAssertEqual(sut.denominatorLabel.frame.width, 26.5)
        XCTAssertEqual(sut.denominatorLabel.frame.height, 20.5)
        
        XCTAssertEqual(sut.numeratorLabel.frame.width, sut.denominatorLabel.frame.width)
        XCTAssertEqual(sut.numeratorLabel.frame.height, sut.denominatorLabel.frame.height)

        XCTAssertEqual(sut.fractionBar.frame.width, 26.5)
        XCTAssertEqual(sut.fractionBar.frame.height, 5)
        
        XCTAssertEqual(sut.numeratorLabel.frame.origin.x, sut.denominatorLabel.frame.origin.x)
        XCTAssertEqual(sut.numeratorLabel.frame.origin.x, sut.fractionBar.frame.origin.x)
        XCTAssert(sut.wholeNumberLabel.frame.origin.x < sut.numeratorLabel.frame.origin.x)
    }

    func testExpandsWhenValueChangesToWholeNumber() {
        let sut = createSUT()
        
        // mixed number
        sut.rationalLabel.value = 5
        XCTAssertEqual(sut.rationalLabel.frame.width, 16+26.5)
        XCTAssertEqual(sut.rationalLabel.frame.height, 69.5)
        
        XCTAssertEqual(sut.wholeNumberLabel.frame.width, 26.5)
        XCTAssertEqual(sut.wholeNumberLabel.frame.height, 69.5)
        
        XCTAssertEqual(sut.numeratorLabel.frame.width, 0)
        XCTAssertEqual(sut.numeratorLabel.frame.height, 26.5)
        
        XCTAssertEqual(sut.denominatorLabel.frame.width, 0)
        XCTAssertEqual(sut.denominatorLabel.frame.height, 26.5)
        
        XCTAssertEqual(sut.numeratorLabel.frame.width, sut.denominatorLabel.frame.width)
        XCTAssertEqual(sut.numeratorLabel.frame.height, sut.denominatorLabel.frame.height)

        XCTAssertEqual(sut.fractionBar.frame.width, 0)
        XCTAssertEqual(sut.fractionBar.frame.height, 5)
        
        XCTAssertEqual(sut.numeratorLabel.frame.origin.x, sut.denominatorLabel.frame.origin.x)
        XCTAssertEqual(sut.numeratorLabel.frame.origin.x, sut.fractionBar.frame.origin.x)
        XCTAssert(sut.wholeNumberLabel.frame.origin.x < sut.numeratorLabel.frame.origin.x)
    }

    func testLabelSize() {
        let l = UILabel()
        XCTAssertEqual(l.directionalLayoutMargins, NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
        XCTAssertEqual(l.intrinsicContentSize, .zero)
    }
    
    // MARK:-
    
    func createSUT() -> (rationalLabel:RationalLabel,
        wholeNumberLabel:CenteredLabel,
        numeratorLabel:CenteredLabel,
        denominatorLabel:CenteredLabel,
        fractionBar:UIView) {
        
        let rl = RationalLabel()
        let wl = rl.subviews[0] as! CenteredLabel
            let nl = rl.subviews[1] as! CenteredLabel
            let dl = rl.subviews[2] as! CenteredLabel
            let fb = rl.subviews[3]

            return (rationalLabel:rl,
                    wholeNumberLabel:wl,
                    numeratorLabel:nl,
                    denominatorLabel:dl,
                    fractionBar:fb)
    }

}
