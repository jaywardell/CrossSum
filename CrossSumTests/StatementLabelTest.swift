//
//  StatementLabelTest.swift
//  CrossSumTests
//
//  Created by Joseph Wardell on 9/25/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import XCTest
@testable import CrossSum

class StatementLabelTest: XCTestCase {

    func testContainsExpectedSubviews() {
        let sut = createSUT()
        
        XCTAssertNotNil(sut.statementLabel.subviews.first)
        XCTAssertEqual(sut.expressionLabel.superview, sut.statementLabel)
        XCTAssertEqual(sut.equalityLabel.superview, sut.statementLabel)
        XCTAssertEqual(sut.solutionLabel.superview, sut.statementLabel)

        XCTAssertEqual(sut.expressionLabel.text, nil)
        XCTAssertEqual(sut.equalityLabel.text, nil)
        XCTAssertEqual(sut.solutionLabel.value, nil)
    }
    
    // TODO: test giving a Statement to the StatementLabel
    
    // MARK:-

    func testTakesTextColor() {
        let sut = createSUT()
        let c = UIColor.green
        
        sut.statementLabel.textColor = c
        XCTAssertEqual(sut.statementLabel.textColor, c)
        XCTAssertEqual(sut.expressionLabel.textColor, c)
        XCTAssertEqual(sut.equalityLabel.textColor, c)
        XCTAssertEqual(sut.solutionLabel.textColor, c)
    }
    
    func testTakesFont() {
        let sut = createSUT()
        let f = UIFont.systemFont(ofSize: 128)
        
        sut.statementLabel.font = f
        XCTAssertEqual(sut.statementLabel.font, f)
        XCTAssertEqual(sut.expressionLabel.font, f)
        XCTAssertEqual(sut.equalityLabel.font, f)
        XCTAssertEqual(sut.solutionLabel.font, f)
    }

    
    // MARK:-

    func testAutolayoutIsValid() {
        let sut = createSUT()
        
        XCTAssertFalse(sut.statementLabel.translatesAutoresizingMaskIntoConstraints)
        XCTAssertFalse(sut.expressionLabel.translatesAutoresizingMaskIntoConstraints)
        XCTAssertFalse(sut.equalityLabel.translatesAutoresizingMaskIntoConstraints)
        XCTAssertFalse(sut.solutionLabel.translatesAutoresizingMaskIntoConstraints)
        XCTAssertFalse(sut.statementLabel.hasAmbiguousLayout)
    }

    // TODO: test autolayout before and after setting statement
    
    // MARK:-

    func createSUT() -> (statementLabel:StatementLabel,
        expressionLabel:CenteredLabel,
        equalityLabel:CenteredLabel,
        solutionLabel:RationalLabel) {
            
            let st = StatementLabel()
            let ex = st.subviews[0] as! CenteredLabel
            let eq = st.subviews[1] as! CenteredLabel
            let so = st.subviews[2] as! RationalLabel
            
            return (statementLabel:st,
                    expressionLabel:ex,
                    equalityLabel:eq,
                    solutionLabel:so)
    }

}
