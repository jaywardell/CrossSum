//
//  StatementLabel.swift
//  CrossSum
//
//  Created by Joseph Wardell on 9/25/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import UIKit

class StatementLabel: UIStackView {

    var statement : Statement? {
        didSet {
            guard let statement = statement else {
                expressionLabel.text = nil
                expressionLabel.backgroundColor = nil
                equalityLabel.text = nil
                solutionLabel.value = nil
                return
            }
            expressionLabel.text = statement.expression
            expressionLabel.backgroundColor = isPromptingForExpression ? highlightColor : nil
            equalityLabel.text = statement.hasExpression ? statement.title : statement.promptTitle
            solutionLabel.value = statement.targetSolution
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
    
    var highlightColor : UIColor = UIColor.cyan
    
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
        setup()
    }
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        setup()
//    }
    
    private func setup() {
        axis = .horizontal
//        distribution = .fillProportionally
        spacing = UIStackView.spacingUseDefault
        [
            expressionLabel,
            equalityLabel,
            solutionLabel
            ].forEach() { addArrangedSubview($0) }
        
//        setupConstraints()
    }
    
    private func setupConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        
        // TODO: autolayout constraints are not working well
        expressionLabel.trailingAnchor.constraint(equalTo: equalityLabel.leadingAnchor)
        equalityLabel.trailingAnchor.constraint(equalTo: solutionLabel.leadingAnchor)
        
        equalityLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        equalityLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
    }
}
