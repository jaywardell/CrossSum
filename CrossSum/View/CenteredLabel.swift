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
    
    private lazy var leadingMargin = label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8)
    private lazy var trailingMargin = label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
    private lazy var zeroWidth = widthAnchor.constraint(equalToConstant: 0)

    private lazy var label : UILabel = {
        let out = UILabel()
        out.font = UIFont.preferredFont(forTextStyle: .body)
        addSubview(out)
        
        out.constrain(to: [
            
            out.centerYAnchor.constraint(equalTo: centerYAnchor),
            
                out.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 0),
                out.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor, constant: 0)
            ])
        
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
    
        self.translatesAutoresizingMaskIntoConstraints = false
        
        // ensure that label is in the view hierarchy as soon as init has been called
        label.text = nil
        
        updateLayout()
    }
    
    // MARK:-
    
    private func updateLayout() {

        zeroWidth.isActive = text == nil
        leadingMargin.isActive = text != nil
        trailingMargin.isActive = text != nil
        
        label.sizeToFit()
        setNeedsLayout()
        layoutIfNeeded()
    }
}
