//
//  StatementLabelTests.swift
//  CrossSumTests
//
//  Created by Joseph Wardell on 9/25/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import XCTest
@testable import CrossSum

class StatementLabelTests: XCTestCase {

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
    
    func testHasExpectedParameters() {
        let sut = createSUT()
        
        XCTAssertEqual(sut.statementLabel.highlightColor, .cyan)
    }
    
    func testSetStatement() {
        
        let sut = createSUT()
        let s = Statement("1+1", 2)
        
        sut.statementLabel.statement = s
        XCTAssertEqual(sut.statementLabel.statement?.expression, s.expression)
        XCTAssertEqual(sut.statementLabel.statement?.targetSolution, s.targetSolution)
        XCTAssertEqual(sut.statementLabel.statement?.comparator.title, s.comparator.title)
        
        XCTAssertEqual(sut.expressionLabel.text, s.expression)
        XCTAssertEqual(sut.equalityLabel.text, s.comparator.title)
        XCTAssertEqual(sut.solutionLabel.value, s.targetSolution)
        
        XCTAssertNil(sut.expressionLabel.backgroundColor)
    }
    
    func testLabelsAreEmptyWHenStatementIsNil() {
        let sut = createSUT()
        
        // ensure that thigns are nil be default
        XCTAssertNil(sut.expressionLabel.text)
        XCTAssertNil(sut.equalityLabel.text)
        XCTAssertNil(sut.solutionLabel.value)
        XCTAssertNil(sut.expressionLabel.backgroundColor)

        // set the statement to something
        sut.statementLabel.statement = Statement("1+1", 2, Statement.notequal)
        
        // then set it back to nil
        sut.statementLabel.statement = nil
        XCTAssertNil(sut.expressionLabel.text)
        XCTAssertNil(sut.equalityLabel.text)
        XCTAssertNil(sut.solutionLabel.value)
        XCTAssertNil(sut.expressionLabel.backgroundColor)
   }

    func testSetStatementWithoutTargetSoluton() {
        
        let sut = createSUT()
        let s = Statement("1+1")
        
        sut.statementLabel.statement = s

        XCTAssertEqual(sut.expressionLabel.text, s.expression)
        XCTAssertNil(sut.equalityLabel.text)
        XCTAssertNil(sut.solutionLabel.value)
        XCTAssertNil(sut.expressionLabel.backgroundColor)
   }

    func testSetStatementWithoutExpression() {
        
        let sut = createSUT()
        let s = Statement(nil, 2)
        
        sut.statementLabel.statement = s
        
        XCTAssertNil(sut.expressionLabel.text)
        XCTAssertEqual(sut.equalityLabel.text, "=")
        XCTAssertEqual(sut.solutionLabel.value, 2)
        
        XCTAssert(sut.statementLabel.isPromptingForExpression)
        XCTAssertEqual(sut.expressionLabel.backgroundColor, sut.statementLabel.highlightColor)
    }

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
