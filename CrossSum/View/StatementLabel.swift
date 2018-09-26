//
//  StatementLabel.swift
//  CrossSum
//
//  Created by Joseph Wardell on 9/25/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import UIKit

class StatementLabel: UIView {

    // TODO: var statement : Statement
    
    var textColor : UIColor {
        get { return expressionLabel.textColor }
        set {
            expressionLabel.textColor = newValue
            equalityLabel.textColor = newValue
            solutionLabel.textColor = newValue
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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        
        [
            expressionLabel,
            equalityLabel,
            solutionLabel
            ].forEach() { addSubview($0) }
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        
        // TODO: setup autolayout constraints
    }
}
