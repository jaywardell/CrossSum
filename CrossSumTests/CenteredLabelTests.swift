//
//  CenteredLabelTests.swift
//  StatementLabelTests
//
//  Created by Joseph Wardell on 9/24/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import XCTest
@testable import CrossSum

class CenteredLabelTests: XCTestCase {
    
    func testContainsLabel() {
        let (sut, label) = createSUT()
        XCTAssertNotNil(sut.subviews.first)
        XCTAssertEqual(label.superview, sut)
    }
    
    func testLoadingFromStoryboard() {
        let storyboard = UIStoryboard(name: "Tests", bundle: Bundle(for: CenteredLabelTests.self))
        XCTAssertNotNil(storyboard)

        let tvc = storyboard.instantiateViewController(withIdentifier: "CenteredLabels") as! CenteredLabelTestsViewController
        XCTAssertNotNil(tvc)

        XCTAssertNotNil(tvc.view)
        
        let label = tvc.centeredLabel
        XCTAssertNotNil(label)
        
        // when the label is loaded from a storyboard,
        // any width or height constraints placed on it by the storybaord should be removed
        // only positioning constraints should apply to the centeredlabel
        XCTAssertEqual(label?.widthConstraints.count, 1)
        XCTAssertEqual(label?.widthConstraints.first?.constant, 0)
        XCTAssertEqual(label?.heightConstraints.count, 0)
    }
    
    func testTakesText() {
        let (sut, label) = createSUT()
        let t = "abc"
        sut.text = t
        XCTAssertEqual(sut.text, t)
        XCTAssertEqual(label.text, t)

        sut.text = nil
        XCTAssertNil(sut.text)
        XCTAssertNil(label.text)
    }

    func testTakesTextColor() {
        let (sut, label) = createSUT()
        let c = UIColor.green

        sut.textColor = c
        XCTAssertEqual(sut.textColor, c)
        XCTAssertEqual(label.textColor, c)
    }

    func testTakesTextAlignment() {
        let (sut, label) = createSUT()
        let a = NSTextAlignment.right

        sut.textAlignment = a
        XCTAssertEqual(sut.textAlignment, a)
        XCTAssertEqual(label.textAlignment, a)
    }

    func testTakesFont() {
        let (sut, label) = createSUT()
        let f = UIFont.systemFont(ofSize: 128)

        sut.font = f
        XCTAssertEqual(sut.font, f)
        XCTAssertEqual(label.font, f)
    }

    func testAutolayoutIsValid() {
        let (sut, label) = createSUT()
        
        XCTAssertFalse(label.translatesAutoresizingMaskIntoConstraints)
        XCTAssertFalse(sut.translatesAutoresizingMaskIntoConstraints)
        XCTAssertFalse(sut.hasAmbiguousLayout)
    }

    func testExpandsWhenTextChanges() {
        let (sut, label) = createSUT()

        sut.text = "abc"
        XCTAssertEqual(sut.frame.width, 44.5)
        XCTAssertEqual(sut.frame.height, 20.5)
        XCTAssertEqual(label.frame.width, 28.5)
        XCTAssertEqual(label.frame.height, 20.5)

        sut.text = ""
        XCTAssertEqual(sut.frame.width, 16)
        XCTAssertEqual(sut.frame.height, 0)
        XCTAssertEqual(label.frame.width, 0)
        XCTAssertEqual(label.frame.height, 0)

        sut.text = "abc"

        sut.text = nil
        XCTAssertEqual(sut.frame.width, 0)
        XCTAssertEqual(sut.frame.height, 0)
        XCTAssertEqual(label.frame.width, 0)
        XCTAssertEqual(label.frame.height, 0)
    }

    func testExpandsWhenFontChanges() {
        let (sut, label) = createSUT()

        // first verify the default size
        sut.text = "abc"
        XCTAssertEqual(sut.frame.width, 44.5)
        XCTAssertEqual(sut.frame.height, 20.5)
        XCTAssertEqual(label.frame.width, 28.5)
        XCTAssertEqual(label.frame.height, 20.5)

        // now change the font and see what happens
        sut.font = UIFont.preferredFont(forTextStyle: .title1)
        XCTAssertEqual(sut.frame.width, 61)
        XCTAssertEqual(sut.frame.height, 33.5)
        XCTAssertEqual(label.frame.width, 45)
        XCTAssertEqual(label.frame.height, 33.5)

    }
    
    // MARK:-

    private func createSUT() -> (CenteredLabel, UILabel) {
        
        let sut = CenteredLabel()
        sut.didMoveToSuperview()
        let label = sut.subviews.first! as! UILabel

        return (sut, label)
    }
}
