//
//  RationalLabelTests.swift
//  CrossSumTests
//
//  Created by Joseph Wardell on 9/24/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import XCTest
@testable import CrossSum

// TODO: autolayout is flaking out
class RationalLabelTests: XCTestCase {

    func testContainsLabelsAndFractionBar() {
        let sut = createSUT()
        XCTAssertNotNil(sut.rationalLabel.subviews.first)
        XCTAssertEqual(sut.wholeNumberLabel.superview, sut.rationalLabel)
        XCTAssertEqual(sut.numeratorLabel.superview?.superview, sut.rationalLabel)
        XCTAssertEqual(sut.denominatorLabel.superview?.superview, sut.rationalLabel)
        XCTAssertEqual(sut.fractionBar.superview?.superview, sut.rationalLabel)
    
        XCTAssertEqual(sut.wholeNumberLabel.text, nil)
        XCTAssertEqual(sut.numeratorLabel.text, nil)
        XCTAssertEqual(sut.denominatorLabel.text, nil)
        XCTAssertEqual(sut.fractionBar.backgroundColor, .black)
    }

    // TODO: test loading from storyboard, verify proper tnumber of constraints
    
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
    
    // MARK:-

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
        XCTAssertEqual(sut.numeratorLabel.font, UIFont.systemFont(ofSize: 21))
        XCTAssertEqual(sut.denominatorLabel.font, UIFont.systemFont(ofSize: 21))
    }
    
    // MARK:-

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
        let unsatisfiableConstraintsCount = InterceptUnsatisfiableConstraints.callCount()

        // NOTE: the magic numbers here are more or less arbitrary
        // they represent values returned in iOS 12 Simulator as of Sep 25, 2018
        // if they change in the future, that's probably okay
        // as long as they more or less represent the same relative values
        // the only ones that are really important are the metrics that are zero
        sut.rationalLabel.value = 5.2
        XCTAssertEqual(sut.rationalLabel.frame.width, 26.5+26.5)
        XCTAssertEqual(sut.rationalLabel.frame.height, 53.5)

        XCTAssertEqual(sut.wholeNumberLabel.frame.width, 26.5)
        XCTAssertEqual(sut.wholeNumberLabel.frame.height, 53.5)

        XCTAssertEqual(sut.numeratorLabel.frame.width, 26.5)
        XCTAssertEqual(sut.numeratorLabel.frame.height, 20.5)

        XCTAssertEqual(sut.denominatorLabel.frame.width, 26.5)
        XCTAssertEqual(sut.denominatorLabel.frame.height, 20.5)

        XCTAssertEqual(sut.numeratorLabel.frame.width, sut.denominatorLabel.frame.width)
        XCTAssertEqual(sut.numeratorLabel.frame.height, sut.denominatorLabel.frame.height)

        XCTAssertEqual(sut.fractionBar.frame.width, 26.5)
        XCTAssertEqual(sut.fractionBar.frame.height, 1)
        
        XCTAssertEqual(sut.numeratorLabel.frame.origin.x, sut.denominatorLabel.frame.origin.x)
        XCTAssertEqual(sut.numeratorLabel.frame.origin.x, sut.fractionBar.frame.origin.x)
        XCTAssert(sut.wholeNumberLabel.frame.origin.x < sut.numeratorLabel.frame.origin.x)
 
        // we expect one issue with unsatisfiable constraints during the transition step
        XCTAssertEqual(unsatisfiableConstraintsCount + 1, InterceptUnsatisfiableConstraints.callCount())
        // but the layout should be satisfiable after the set
        XCTAssertFalse(sut.rationalLabel.hasAmbiguousLayout)
    }

    func testExpandsWhenValueChangesToFraction() {
        let sut = createSUT()
        let unsatisfiableConstraintsCount = InterceptUnsatisfiableConstraints.callCount()

        // NOTE: the magic numbers here are more or less arbitrary
        // they represent values returned in iOS 12 Simulator as of Sep 25, 2018
        // if they change in the future, that's probably okay
        // as long as they more or less represent the same relative values
        // the only ones that are really important are the metrics that are zero
        sut.rationalLabel.value = 0.2
        XCTAssertEqual(sut.rationalLabel.frame.width, 26.5)
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
        XCTAssertEqual(sut.fractionBar.frame.height, 1)
        
        XCTAssertEqual(sut.numeratorLabel.frame.origin.x, sut.denominatorLabel.frame.origin.x)
        XCTAssertEqual(sut.numeratorLabel.frame.origin.x, sut.fractionBar.frame.origin.x)
        XCTAssert(sut.wholeNumberLabel.frame.origin.x <= sut.numeratorLabel.frame.origin.x)
 
        // we expect one issue with unsatisfiable constraints during the transition step
        XCTAssertEqual(unsatisfiableConstraintsCount + 1, InterceptUnsatisfiableConstraints.callCount())
        // but the layout should be satisfiable after the set
        XCTAssertFalse(sut.rationalLabel.hasAmbiguousLayout)
   }

    func testExpandsWhenValueChangesToWholeNumber() {
        let sut = createSUT()
        let unsatisfiableConstraintsCount = InterceptUnsatisfiableConstraints.callCount()

        // NOTE: the magic numbers here are more or less arbitrary
        // they represent values returned in iOS 12 Simulator as of Sep 25, 2018
        // if they change in the future, that's probably okay
        // as long as they more or less represent the same relative values
        // the only ones that are really important are the metrics that are zero
        sut.rationalLabel.value = 5
        
        
        
        XCTAssertEqual(sut.rationalLabel.frame.width, 26.5)
        XCTAssertEqual(sut.rationalLabel.frame.height, 20.5)
        
        XCTAssertEqual(sut.wholeNumberLabel.frame.width, 26.5)
        XCTAssertEqual(sut.wholeNumberLabel.frame.height, 20.5)
        
        XCTAssertEqual(sut.numeratorLabel.frame.width, 0)
        // NOTE: don't care about numeratorLabel.frame.height, becuase it's invisible

        XCTAssertEqual(sut.denominatorLabel.frame.width, 0)
        // NOTE: don't care about denominatorLabel.frame.height, becuase it's invisible
        
        XCTAssertEqual(sut.fractionBar.frame.width, 0)
        XCTAssertEqual(sut.fractionBar.frame.height, 1)
        
        XCTAssertEqual(sut.numeratorLabel.frame.origin.x, sut.denominatorLabel.frame.origin.x)
        XCTAssertEqual(sut.numeratorLabel.frame.origin.x, sut.fractionBar.frame.origin.x)
        XCTAssert(sut.wholeNumberLabel.frame.origin.x < sut.numeratorLabel.frame.origin.x)

        XCTAssertEqual(unsatisfiableConstraintsCount, InterceptUnsatisfiableConstraints.callCount())
        // the layout should be satisfiable after the set
        XCTAssertFalse(sut.rationalLabel.hasAmbiguousLayout)
    }

    func testExpandsWhenFontChanges() {
        let sut = createSUT()
        let unsatisfiableConstraintsCount = InterceptUnsatisfiableConstraints.callCount()
        
        sut.rationalLabel.value = 5.2
        sut.rationalLabel.font = UIFont.systemFont(ofSize: 64)

        XCTAssertEqual(sut.rationalLabel.frame.width, 54+39.5)
        XCTAssertEqual(sut.rationalLabel.frame.height, 124)
        
        XCTAssertEqual(sut.wholeNumberLabel.frame.width, 54)
        XCTAssertEqual(sut.wholeNumberLabel.frame.height, 124)
        
        XCTAssertEqual(sut.numeratorLabel.frame.width, 39.5)
        XCTAssertEqual(sut.numeratorLabel.frame.height, 47.5)
        
        XCTAssertEqual(sut.denominatorLabel.frame.width, 39.5)
        XCTAssertEqual(sut.denominatorLabel.frame.height, 47.5)
        
        XCTAssertEqual(sut.numeratorLabel.frame.width, sut.denominatorLabel.frame.width)
        XCTAssertEqual(sut.numeratorLabel.frame.height, sut.denominatorLabel.frame.height)
        
        XCTAssertEqual(sut.fractionBar.frame.width, 39.5)
        XCTAssertEqual(sut.fractionBar.frame.height, 3.5)
        
        XCTAssertEqual(sut.numeratorLabel.frame.origin.x, sut.denominatorLabel.frame.origin.x)
        XCTAssertEqual(sut.numeratorLabel.frame.origin.x, sut.fractionBar.frame.origin.x)
        XCTAssert(sut.wholeNumberLabel.frame.origin.x < sut.numeratorLabel.frame.origin.x)
        
        // we expect one issue with unsatisfiable constraints during the transition step
        XCTAssertEqual(unsatisfiableConstraintsCount + 1, InterceptUnsatisfiableConstraints.callCount())
        // but the layout should be satisfiable after the set
        XCTAssertFalse(sut.rationalLabel.hasAmbiguousLayout)
}
    
    // MARK:-
    
    private func createSUT() -> (rationalLabel:RationalLabel,
        wholeNumberLabel:CenteredLabel,
        numeratorLabel:CenteredLabel,
        denominatorLabel:CenteredLabel,
        fractionBar:UIView) {
            
            let rl = RationalLabel()
            let wl = rl.arrangedSubviews[0] as! CenteredLabel
            let fr = rl.arrangedSubviews[1] as! UIStackView
            let nl = fr.arrangedSubviews[0] as! CenteredLabel
            let fb = fr.arrangedSubviews[1]
            let dl = fr.arrangedSubviews[2] as! CenteredLabel
            
            return (rationalLabel:rl,
                    wholeNumberLabel:wl,
                    numeratorLabel:nl,
                    denominatorLabel:dl,
                    fractionBar:fb)
    }

}
