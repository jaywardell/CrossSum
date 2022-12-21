//
//  RationalLabel.swift
//  CrossSum
//
//  Created by Joseph Wardell on 9/30/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import UIKit

class RationalLabel: UIStackView {
    
    
    var value : Rational? {
        didSet {
            // TODO: perhaps this label-setting code should really be properties on Rational, wholeNumberDescription and friends, perhaps
            guard let value = value,
                let integerPart = value.integerPart,
                let fractionalPart = value.fractionalPart?.standardized.abs else {
                    self.wholeNumberLabel.text = nil
                    self.numeratorLabel.text = nil
                    self.denominatorLabel.text = nil
                    updateLayout()
                    return
            }
            
            if integerPart != 0 {
                self.wholeNumberLabel.text = String(integerPart)
            }
            else if fractionalPart.numerator == 0 {
                self.wholeNumberLabel.text = String(integerPart)
            }
            else if value < 0 {
                self.wholeNumberLabel.text = "-"
            }
            else {
                self.wholeNumberLabel.text = nil
            }
            
            if fractionalPart.numerator != 0 {
                self.numeratorLabel.text = String(fractionalPart.numerator)
                self.denominatorLabel.text = String(fractionalPart.denominator)
            }
            else {
                self.numeratorLabel.text = nil
                self.denominatorLabel.text = nil
            }
            updateLayout()
        }
    }
    
    var textColor : UIColor {
        get {  return wholeNumberLabel.textColor }
        set {
            wholeNumberLabel.textColor = newValue
            numeratorLabel.textColor = newValue
            denominatorLabel.textColor = newValue
            fractionBar.backgroundColor = newValue
        }
    }
    
    var font : UIFont {
        get { return wholeNumberLabel.font }
        set {
            wholeNumberLabel.font = newValue
            numeratorLabel.font = newValue.withSize(newValue.pointSize * 21/34)
            denominatorLabel.font = newValue.withSize(newValue.pointSize * 21/34)
            updateLayout()
        }
    }
    
    // MARK:-
    
    
    private lazy var wholeNumberLabel : CenteredLabel = {
        let out = CenteredLabel()
        out.textAlignment = .center
        out.font = UIFont.preferredFont(forTextStyle: .body)
        
        return out
    }()
    
    private lazy var numeratorLabel : CenteredLabel = {
        let out = CenteredLabel()
        out.textAlignment = .center
        out.font = UIFont.preferredFont(forTextStyle: .body)
        
        return out
    }()
    
    private lazy var denominatorLabel : CenteredLabel = {
        let out = CenteredLabel()
        out.textAlignment = .center
        out.font = UIFont.preferredFont(forTextStyle: .body)
        
        return out
    }()
    
    private lazy var fractionBar : FractionBar = {
        let out = FractionBar()
        out.backgroundColor = .black
        
        return out
    }()
    
    private lazy var fractionBarHeight : NSLayoutConstraint = {
        return fractionBar.heightAnchor.constraint(equalToConstant: 10)
    }()
    
    // MARK:-
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        
        let fractionView = UIStackView(arrangedSubviews: [numeratorLabel, fractionBar, denominatorLabel])
        fractionView.axis = .vertical
        
        [
            wholeNumberLabel,
            fractionView
            ].forEach { addArrangedSubview($0) }
    }
        
    private func updateLayout() {

        wholeNumberLabel.sizeToFit()
        numeratorLabel.sizeToFit()
        denominatorLabel.sizeToFit()

        fractionBar.height = font.underlineThickness
        fractionBar.width = denominatorLabel.intrinsicContentSize.width
        fractionBar.sizeToFit()

        setNeedsLayout()
        layoutIfNeeded()

    }
}

// MARK:-

private final class FractionBar : UIView {

    var width : CGFloat = 0 {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    var height : CGFloat = 0 {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        let out = CGSize(width: width, height: ceil(height))
        return out
    }
}

