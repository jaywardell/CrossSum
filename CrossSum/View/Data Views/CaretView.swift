//
//  CaretView.swift
//  CaretViewTest
//
//  Created by Joseph Wardell on 10/22/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import UIKit

@IBDesignable class CaretView: UIView {

    private var caret : CAShapeLayer? {
        willSet {
            caret?.removeFromSuperlayer()
        }
        didSet {
            guard let caret = caret else { return }
            layer.addSublayer(caret)
        }
    }
    
    @IBInspectable var flashSpeed : Double = 0.5 {
        didSet {
            flash.duration = flashSpeed
            buildCaret()
        }
    }
    
    private var flash : CAAnimation {
        let out = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        out.fromValue = 1
        out.toValue = 0
        out.repeatCount = 10000000000
        out.duration = flashSpeed
        out.autoreverses = true
        out.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        return out
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        buildCaret()
    }
    
    override func tintColorDidChange() {
        super.tintColorDidChange()
        
        caret?.strokeColor = tintColor.cgColor
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 2, height: bounds.height)
    }
    
    // MARK:-
    
    private func buildCaret() {
        let newLayer = CAShapeLayer()
        let path = UIBezierPath()
        path.move(to: CGPoint(x: bounds.minX, y: bounds.minY))
        path.addLine(to: CGPoint(x: bounds.minX, y: bounds.maxY))
        newLayer.path = path.cgPath
        
        newLayer.strokeColor = tintColor.cgColor
        newLayer.lineCap = .round
        newLayer.lineWidth = 2
        
        newLayer.add(flash, forKey: "flash the caret")
        
        caret = newLayer
    }

}
