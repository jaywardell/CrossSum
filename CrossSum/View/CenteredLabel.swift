//
//  CenteredLabel.swift
//  StatementLabel
//
//  Created by Joseph Wardell on 9/24/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import UIKit

class CenteredLabel: UIView {

    var text: String? {
        get { return label.text }
        set {
            label.text = newValue
            updateLayout()
        }
    }
    
    var textColor: UIColor {
        get {  return label.textColor }
        set { label.textColor = newValue }
    }
    
    var highlightColor : UIColor?
    var isHighlighted : Bool = false {
        didSet {
            label.backgroundColor = highlightColor
        }
    }
    
    var textAlignment : NSTextAlignment {
        get { return label.textAlignment }
        set { label.textAlignment = newValue }
    }
    
    var font : UIFont {
        get { return label.font }
        set {
            label.font = newValue
            label.sizeToFit()
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    // MARK:- 

    private lazy var leadingMargin = label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8)
    private lazy var trailingMargin = label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
    private lazy var zeroWidth = widthAnchor.constraint(equalToConstant: 0)

    private lazy var label : UILabel = {
        let out = UILabel()
        out.font = UIFont.preferredFont(forTextStyle: .body)
        
        return out
    }()

    // MARK:-

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

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
    
        self.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(label)
        
        label.constrain(to: [
            
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            label.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 0),
            label.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor, constant: 0)
            ])

        
        // ensure that label is in the view hierarchy as soon as init has been called
        label.text = nil
        
        updateLayout()
    }
    
    // MARK:-
    
    private func updateLayout() {

        // first turn off these constraints to prevent unnecessary logging of unsatisfiable constriants
        [zeroWidth, leadingMargin, trailingMargin].forEach { $0.isActive = false }
        
        label.sizeToFit()

        zeroWidth.isActive = text == nil
        leadingMargin.isActive = text != nil
        trailingMargin.isActive = text != nil
        
        setNeedsLayout()
        layoutIfNeeded()
    }
}
