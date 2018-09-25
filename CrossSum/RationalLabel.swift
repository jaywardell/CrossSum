//
//  RationalLabel.swift
//  CrossSum
//
//  Created by Joseph Wardell on 9/24/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import UIKit

class RationalLabel: UIView {

    var value : Rational? {
        didSet {
            // TODO: perhaps this label-setting code should really be properties on Rational, wholeNumberDescription and friends, perhaps
            guard let value = value,
                let integerPart = value.integerPart,
                let fractionalPart = value.fractionalPart?.standardized.abs else {
                self.wholeNumberLabel.text = nil
                self.numeratorLabel.text = nil
                self.denominatorLabel.text = nil
                return
            }
            
            if integerPart != 0 { // || fractionalPart.numerator == 0  {
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
            numeratorLabel.font = newValue.withSize(newValue.pointSize * 13/34)
            denominatorLabel.font = newValue.withSize(newValue.pointSize * 13/34)
        }
    }
    
    private lazy var wholeNumberLabel : UILabel = {
        let out = UILabel()
        out.textAlignment = .center
        out.font = UIFont.preferredFont(forTextStyle: .body)
        addSubview(out)
        
        return out
    }()

    private lazy var numeratorLabel : UILabel = {
        let out = UILabel()
        out.textAlignment = .center
        out.font = UIFont.preferredFont(forTextStyle: .body)
        addSubview(out)
        
        return out
    }()

    private lazy var denominatorLabel : UILabel = {
        let out = UILabel()
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
        
        setupConstraints()
        
        // ensure that label is in the view hierarchy as soon as init has been called
        wholeNumberLabel.text = "wl"
        numeratorLabel.text = "nl"
        denominatorLabel.text = "dl"
        fractionBar.isHidden = true
    }

    func setupConstraints() {
        
    }

}
