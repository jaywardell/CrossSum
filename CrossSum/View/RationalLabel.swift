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
    
//    private func setupConstraints() {
//
//        self.translatesAutoresizingMaskIntoConstraints = false
//
//        wholeNumberLabel.constrain(to: [
//            wholeNumberLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
//            wholeNumberLabel.topAnchor.constraint(equalTo: topAnchor),
//            wholeNumberLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
//            wholeNumberLabel.heightAnchor.constraint(greaterThanOrEqualTo: wholeNumberLabel.heightAnchor, multiplier: 1)
//            ])
//
//        numeratorLabel.constrain(to: [
//            numeratorLabel.leadingAnchor.constraint(equalTo: wholeNumberLabel.trailingAnchor),
//            numeratorLabel.topAnchor.constraint(greaterThanOrEqualTo: topAnchor),
//            numeratorLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
//            numeratorLabel.bottomAnchor.constraint(equalTo: fractionBar.topAnchor),
//
//            numeratorLabel.heightAnchor.constraint(equalTo: wholeNumberLabel.heightAnchor, multiplier: 13/34),
//            ])
//
//        denominatorLabel.constrain(to: [
//            denominatorLabel.leadingAnchor.constraint(equalTo: numeratorLabel.leadingAnchor),
//            denominatorLabel.topAnchor.constraint(equalTo: fractionBar.bottomAnchor),
//            denominatorLabel.trailingAnchor.constraint(equalTo: numeratorLabel.trailingAnchor),
//            denominatorLabel.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor),
//
//            denominatorLabel.widthAnchor.constraint(equalTo: numeratorLabel.widthAnchor, multiplier: 1),
//            denominatorLabel.heightAnchor.constraint(equalTo: numeratorLabel.heightAnchor, multiplier: 1),
//            ])
//
//        fractionBar.constrain(to: [
//            fractionBar.leadingAnchor.constraint(equalTo: numeratorLabel.leadingAnchor),
//            fractionBar.trailingAnchor.constraint(equalTo: numeratorLabel.trailingAnchor),
//            fractionBarHeight
//            ])
//
//    }
    
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
        print("\(#function) \(out)")
        return out
    }
}

