//
//  CenteredLabel.swift
//  StatementLabel
//
//  Created by Joseph Wardell on 9/24/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import UIKit

class CenteredLabel: UIStackView {

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
                label.backgroundColor = isHighlighted ? highlightColor : nil
            label.layer.cornerRadius = label.frame.height * 8/34
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

    private lazy var label : UILabel = {
        let out = UILabel()
        out.font = UIFont.preferredFont(forTextStyle: .body)
        out.isOpaque = false
        out.layer.masksToBounds = true

        return out
    }()

    // MARK:-

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder) {
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
    
    override func sizeToFit() {
        
        label.sizeToFit()
        super.sizeToFit()
    }
    
    override var intrinsicContentSize: CGSize {
        return label.intrinsicContentSize
    }
    
    private func setup() {
    
        self.translatesAutoresizingMaskIntoConstraints = false
        
        addArrangedSubview(label)
        
        // ensure that label is in the view hierarchy as soon as init has been called
        label.text = nil
        
        updateLayout()
    }
    
    // MARK:-
    
    private func updateLayout() {

        label.sizeToFit()
        
        setNeedsLayout()
        layoutIfNeeded()
    }
}
