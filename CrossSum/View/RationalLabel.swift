//
//  RationalLabel.swift
//  CrossSum
//
//  Created by Joseph Wardell on 9/24/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import UIKit

class RationalLabel: UIView {

    private func updateLayout() {
        
        wholeNumberLabel.directionalLayoutMargins = (wholeNumberLabel.text ?? "").count != 0 ? defaultLayoutMargins : .zero
        numeratorLabel.directionalLayoutMargins = (numeratorLabel.text ?? "").count != 0 ? defaultLayoutMargins : .zero
        denominatorLabel.directionalLayoutMargins = (denominatorLabel.text ?? "").count != 0 ? defaultLayoutMargins : .zero

        wholeNumberLabel.sizeToFit()
        numeratorLabel.sizeToFit()
        denominatorLabel.sizeToFit()
        fractionBar.sizeToFit()
        setNeedsLayout()
        layoutIfNeeded()
    }
    
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
    
    private let defaultLayoutMargins = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
    
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
            numeratorLabel.font = newValue.withSize(newValue.pointSize * 13/34)
            denominatorLabel.font = newValue.withSize(newValue.pointSize * 13/34)
        }
    }
    
    private lazy var wholeNumberLabel : CenteredLabel = {
        let out = CenteredLabel()
        out.textAlignment = .center
        out.font = UIFont.preferredFont(forTextStyle: .body)
        addSubview(out)
        
        return out
    }()

    private lazy var numeratorLabel : CenteredLabel = {
        let out = CenteredLabel()
        out.textAlignment = .center
        out.font = UIFont.preferredFont(forTextStyle: .body)
        addSubview(out)
        
        return out
    }()

    private lazy var denominatorLabel : CenteredLabel = {
        let out = CenteredLabel()
        out.textAlignment = .center
        out.font = UIFont.preferredFont(forTextStyle: .body)
        addSubview(out)
        
        return out
    }()

    private lazy var fractionBar : UIView = {
        let out = UIView()
        out.backgroundColor = .black
        addSubview(out)
        
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
        wholeNumberLabel.text = "wl"
        numeratorLabel.text = "nl"
        denominatorLabel.text = "dl"
        fractionBar.isHidden = true
    
        setupConstraints()
    }

    func setupConstraints() {
        
        wholeNumberLabel.constrain(to: [
            wholeNumberLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            wholeNumberLabel.topAnchor.constraint(equalTo: topAnchor),
            wholeNumberLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            wholeNumberLabel.heightAnchor.constraint(greaterThanOrEqualTo: wholeNumberLabel.heightAnchor, multiplier: 1)
            ])
        
        numeratorLabel.constrain(to: [
            numeratorLabel.leadingAnchor.constraint(equalTo: wholeNumberLabel.trailingAnchor),
            numeratorLabel.topAnchor.constraint(greaterThanOrEqualTo: topAnchor),
            numeratorLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            numeratorLabel.bottomAnchor.constraint(equalTo: fractionBar.topAnchor),
            
//            numeratorLabel.heightAnchor.constraint(equalTo: wholeNumberLabel.heightAnchor, multiplier: 13/34),

            numeratorLabel.heightAnchor.constraint(greaterThanOrEqualTo: numeratorLabel.widthAnchor, multiplier: 1)
            ])
        
        denominatorLabel.constrain(to: [
            denominatorLabel.leadingAnchor.constraint(equalTo: wholeNumberLabel.trailingAnchor),
            denominatorLabel.topAnchor.constraint(equalTo: fractionBar.bottomAnchor),
            denominatorLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            denominatorLabel.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor),
            
            denominatorLabel.widthAnchor.constraint(equalTo: numeratorLabel.widthAnchor, multiplier: 1),
            denominatorLabel.heightAnchor.constraint(equalTo: numeratorLabel.heightAnchor, multiplier: 1),
            
//            denominatorLabel.widthAnchor.constraint(equalTo: denominatorLabel.heightAnchor, multiplier: 1)
            ])
        
        fractionBar.constrain(to: [
            fractionBar.leadingAnchor.constraint(equalTo: numeratorLabel.leadingAnchor),
            fractionBar.widthAnchor.constraint(equalTo: numeratorLabel.widthAnchor),
            // TODO: make this depend on the font ligature
            fractionBar.heightAnchor.constraint(equalToConstant: 5)
            ])
        
    }

}
