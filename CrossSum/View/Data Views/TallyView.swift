//
//  TallyView.swift
//  TallyViewTest
//
//  Created by Joseph Wardell on 10/5/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import UIKit

@IBDesignable class TallyView: UIView {
    
    @IBInspectable var numberOfLines : Int = 1
    @IBInspectable var isReversed : Bool = false
    
    enum Messiness : Int {
        case immaculate
        case neat
        case loose
        case messy
        case childish
        
        private var downStrokeNumerator : CGFloat {
            switch self {
            case .immaculate: return 0
            case .neat: return 1
            case .loose: return 5
            case .messy: return 8
            case .childish: return 13
            }
        }
        
        var downStroke : CGFloat {
            return self.downStrokeNumerator/34
        }
        
        var crossStroke : CGFloat {
            switch self {
            case .immaculate: return 0
            case .neat: return 5.0/34
            default: return 13.0/34
            }
        }
    }
    
    @IBInspectable var messyness : Int {
        get {
            return messiness.rawValue
        }
        set {
            messiness = Messiness(rawValue: newValue) ?? .immaculate
        }
    }
    
    var messiness : Messiness = .messy
    @IBInspectable var tallyColor : UIColor? = nil {
        didSet {
            tallyMarks.forEach() { tally in
                tally.strokeColor = _tallyColor.cgColor
            }
        }
    }
    
    @IBInspectable var maximumTally : Int {
        get {
            return maxTally ?? 0
        }
        set {
            maxTally = newValue > 0 ? newValue : nil
        }
    }
    
    @IBInspectable var masksToBounds : Bool = false {
        didSet {
            layer.masksToBounds = masksToBounds
        }
    }
    
    private var _tallyColor : UIColor { return (tallyColor ?? tintColor) }
    
    private var _tally : Int = 0
    var tally : Int {
        get {
            return _tally
        }
        set {
            var new = newValue
            if let max = maxTally, new > max {
                new = max
            }
            let d = newValue - tally
            
            (0..<abs(d)).forEach() { _ in
                if d < 0 {
                    decrementTally()
                }
                else {
                    incrementTally()
                }
            }
        }
    }
    
    var maxTally : Int?
    
    
    func incrementTally(animated:Bool=false) {
        if let max = maxTally, _tally >= max { return }
        
        _tally += 1
        
        synchronizeTally(animated: animated)
    }
    
    func decrementTally(animated:Bool=false) {
        guard _tally >= 0 else { return }
        _tally -= 1
        
        synchronizeTally(animated: animated)
    }
    
    private func synchronizeTally(animated:Bool) {
        while tallyMarks.count > tally && tallyMarks.count > 0 {
            removeTallyMark(animated: animated)
        }
        while tallyMarks.count < tally {
            addTallyMark(animated: animated)
        }
    }
    
    
    
    private func points(for tally:Int) -> (CGPoint, CGPoint) {
        assert(numberOfLines > 0) // TODO: perhaps we could come up with some kind of best-fitting algorithm in this case, but not yet
        
        let bunch = tally/5
        let mark = tally % 5
        
        let rowHeight = numberOfLines == 1 ? bounds.height : bounds.height / (CGFloat(numberOfLines) * 39.0/34)
        
        var square = !isReversed ?
            CGRect(origin: CGPoint(x: bounds.minX, y: bounds.minY), size: CGSize(width: rowHeight, height: rowHeight)):
            CGRect(origin: CGPoint(x: bounds.maxX, y: bounds.minY), size: CGSize(width: rowHeight, height: rowHeight))
        
        let additionalSquareSpace = (square.width + square.width * 5.0/34)  // space for a square and the space to the next square
        square.origin.x += !isReversed ?
            CGFloat(bunch) * additionalSquareSpace :
            -CGFloat(bunch + 1) * additionalSquareSpace
        
        var additionalBunchesPerRow = floor((bounds.width - square.width)/additionalSquareSpace)
        if numberOfLines > 1 {
            while bounds.minX > square.minX || bounds.maxX < square.maxX { // !bounds.contains(square) {
                // wrap, direction depends on whether we're reversed
                square.origin.y += rowHeight * 39.0/34
                if !isReversed {
                    square.origin.x -= (additionalBunchesPerRow + 1) * additionalSquareSpace
                    if square.origin.x < bounds.minX {
                        square.origin.x = bounds.minX
                    }
                }
                else {
                    square.origin.x += (additionalBunchesPerRow + 1) * additionalSquareSpace
                    if square.maxX > bounds.maxX {
                        square.origin.x = bounds.maxX - square.width
                    }
                }
            }
        }
        
        let xMargin = square.width * 1/8
        let xStep = square.width * 1/4
        
        func sugar() -> CGFloat {
            let scalar = CGFloat(messiness.downStroke)
            return CGFloat.random(in: -xStep*scalar...xStep*scalar)
        }
        
        func bunchSugar() -> CGFloat {
            let scalar = CGFloat(messiness.crossStroke)
            return CGFloat.random(in: -xStep*scalar...xStep*scalar)
        }
        
        if mark < 4 {
            let startX = !isReversed ? square.minX : square.maxX
            let stepX = !isReversed ? xMargin + CGFloat(mark) * xStep : -(xMargin + CGFloat(mark) * xStep)
            return (
                CGPoint(x: startX + stepX + sugar(),
                        y: square.minY + sugar()),
                CGPoint(x: startX + stepX + sugar(),
                        y: square.maxY + sugar())
            )
        }
        else {
            let lowY = square.minY + square.height * 13/34
            let highY = square.maxY - square.height * 13/34
            return (
                CGPoint(x: square.minX + sugar(), y: highY + bunchSugar()),
                CGPoint(x: square.maxX + sugar(), y: lowY + bunchSugar())
            )
        }
    }
    
    private var tallyMarks : [CAShapeLayer] = []
    private func addTallyMark(animated:Bool) {
        let newLayer = CAShapeLayer()
        newLayer.lineWidth = 1
        let path = UIBezierPath()
        
        let pts = points(for: tallyMarks.count)
        path.move(to: pts.0)
        path.addLine(to: pts.1)
        newLayer.path = path.cgPath
        
        newLayer.strokeColor = _tallyColor.cgColor
        newLayer.fillColor = _tallyColor.cgColor
        
        tallyMarks.append(newLayer)
        
        layer.addSublayer(newLayer)
        
        if animated {
            newLayer.strokeStart = 0
            newLayer.strokeEnd = 1
            
            let drawTally = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.strokeEnd))
            drawTally.fromValue = 0
            drawTally.toValue = 1
            drawTally.duration = 0.3
            drawTally.fillMode = .both
            newLayer.add(drawTally, forKey: nil)
        }
    }
    
    private func removeTallyMark(animated:Bool) {
        guard !tallyMarks.isEmpty else { return }
        
        let removed = tallyMarks.removeLast()
        
        func removeLayer() {
            removed.removeFromSuperlayer()
        }
        
        if animated {
            
            removed.strokeEnd = 0
            removed.strokeStart = 0
            
            let drawTally = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.strokeEnd))
            drawTally.fromValue = 1
            drawTally.toValue = 0
            drawTally.duration = 0.3
            drawTally.fillMode = .both
            
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                removeLayer()
            }
            removed.add(drawTally, forKey: nil)
            CATransaction.commit()
        }
        else {
            removeLayer()
        }
    }
}

