//
//  TimeRemainingView.swift
//  TimeRemaningViewTests
//
//  Created by Joseph Wardell on 10/5/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import UIKit

@IBDesignable class TimeRemainingView: UIView {
    
    @IBInspectable var maxTime : Double = 1 {
        didSet {
            remainingTime = maxTime
            updateBarLayer()
        }
    }
    @IBInspectable var remainingTime : Double = 0 {
        didSet {
            updateBarLayer()
        }
    }
    
    @IBInspectable var barColorBrightness : CGFloat = 21/34
    @IBInspectable var barColorSaturation : CGFloat = 1
    @IBInspectable var barColorAlpha : CGFloat = 1
    
    private lazy var barLayer : CALayer = {
        let out = CALayer()
        out.frame = .zero
        return out
    }()
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        backgroundColor = .clear
        
        guard nil == layer.sublayers || layer.sublayers!.count == 0 else { return }
        layer.addSublayer(barLayer)
        
        updateBarLayer()
    }
    
    private func updateBarLayer() {
        
        let scalar = CGFloat(remainingTime/maxTime)
        let bar = CGRect(origin: bounds.origin, size: CGSize(width: bounds.width * scalar, height: bounds.height))
        let color = UIColor(hue: 1.0/3.0 * scalar, saturation: barColorSaturation, brightness: barColorBrightness, alpha: alpha)
        
        CATransaction.begin()
        CATransaction.setDisableActions(remainingTime == maxTime)
        barLayer.frame = bar
        CATransaction.commit()
        barLayer.backgroundColor = color.cgColor
        barLayer.isHidden = false
    }
    
}

extension TimeRemainingView : TimeRemainingPresenter {}
