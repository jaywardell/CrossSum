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
            label.sizeToFit()
            setNeedsLayout()
            layoutIfNeeded()
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
    
    private lazy var label : UILabel = {
        let out = UILabel()
        out.font = UIFont.preferredFont(forTextStyle: .body)
        addSubview(out)
        
        out.anchor(leading: leadingAnchor, trailing: trailingAnchor, middle: centerYAnchor, padding: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8))
        
        out.constrain(to: [
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
    }
}
