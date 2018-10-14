//
//  StatementLabel.swift
//  CrossSum
//
//  Created by Joseph Wardell on 9/25/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import UIKit

class StatementLabel: UIStackView {

    static let PromptSpace = "       "

    
    var statement : Statement? {
        didSet {
            guard let statement = statement else {
                expressionLabel.text = nil
                expressionLabel.backgroundColor = nil
                equalityLabel.text = nil
                solutionLabel.value = nil
                updateLayout()
                return
            }
            
            expressionLabel.text = statement.expression ?? StatementLabel.PromptSpace
            expressionLabel.isHighlighted = isPromptingForExpression
            equalityLabel.text = statement.hasExpression ? statement.title : statement.promptTitle
            solutionLabel.value = statement.targetSolution
            
            updateLayout()
        }
    }
    
    var isPromptingForExpression : Bool {
        guard let statement = statement else { return false }
        return !statement.hasExpression
    }
    
    var textColor : UIColor {
        get { return expressionLabel.textColor }
        set {
            expressionLabel.textColor = newValue
            equalityLabel.textColor = newValue
            solutionLabel.textColor = newValue
        }
    }
    
    var highlightColor : UIColor? {
        get { return expressionLabel.highlightColor }
        set {
            expressionLabel.highlightColor = newValue
        }
    }
    
    var font : UIFont {
        get { return expressionLabel.font }
        set {
            expressionLabel.font = newValue
            equalityLabel.font = newValue
            solutionLabel.font = newValue
        }
    }
    
    // MARK:- 

    
    private lazy var expressionLabel : CenteredLabel = {
        let out = CenteredLabel()
        out.font = UIFont.preferredFont(forTextStyle: .body)
        return out
    }()

    private lazy var equalityLabel : CenteredLabel = {
        let out = CenteredLabel()
        out.font = UIFont.preferredFont(forTextStyle: .body)
        return out
    }()

    private lazy var solutionLabel : RationalLabel = {
        let out = RationalLabel()
        out.font = UIFont.preferredFont(forTextStyle: .body)
        return out
    }()

    // MARK:-

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)

        // if there are width or height constraints tied to this view in the storyboard,
        // then we don't want them. THey're there to prevent the storyboard from complaining
        // We only want constraints that define position, e.g. centerXAnchor or leadingAnchor
        deactivateWidthAndHeightConstriants()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        setup()
    }
    
    private func setup() {
        axis = .horizontal
        spacing = 6
        
        [
            expressionLabel,
            equalityLabel,
            solutionLabel
            ].forEach() { addArrangedSubview($0) }
        
        highlightColor = .cyan
        
        updateLayout()
    }
    
    
    private func updateLayout() {
        
        expressionLabel.sizeToFit()
        equalityLabel.sizeToFit()
        solutionLabel.sizeToFit()
        setNeedsLayout()
        layoutIfNeeded()
    }

}

extension StatementLabel : OptionalStatementPresenter {
    
    func present(statement: Statement?) {
        self.statement = statement
    }
}
