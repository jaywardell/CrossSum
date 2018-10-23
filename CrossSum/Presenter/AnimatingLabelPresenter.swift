//
//  AnimatingLabelPresenter.swift
//  CrossSum
//
//  Created by Joseph Wardell on 10/21/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import UIKit


/// An object that can animate a label showing text from one view to another
final class AnimatingLabel {
    
    weak var startingView : UIView?
    weak var endingView : UIView?
    
    var font : UIFont = UIFont.preferredFont(forTextStyle: .caption1)
    var textColor : UIColor = .yellow
    
    init(_ startingView:UIView, endingView:UIView) {
        
        self.startingView = startingView
        self.endingView = endingView
    }
    
    private func createLabelToAnimate(_ string:String) -> UILabel {
        let out = UILabel()
        out.textColor = .yellow
        out.text = string
        out.font = font
        out.textColor = textColor
        out.sizeToFit()
        return out
    }
    
    func animate(_ string:String) {
        guard let startingView = startingView,
            let endingView = endingView,
            let startingSuperview = startingView.superview,
            let endingSuperview = endingView.superview
            else { return }
        
        let label = createLabelToAnimate(string)
        startingSuperview.addSubview(label)
        label.center = startingView.center
        
        //TODO: start and end can be anywhere in the associated views
        let start = startingSuperview.convert(startingView.center, to: startingView.superview)
        let end = endingSuperview.convert(endingView.center, to: startingView.superview)
        
        let paths = UIBezierPath()
        paths.move(to: start)
        
        let controlPoint1 = CGPoint(x: CGFloat.random(in: min(start.x, end.x)...max(start.x, end.x)),
                                    y: CGFloat.random(in: min(start.y, end.y)...max(start.y, end.y)))

        paths.addQuadCurve(to: end, controlPoint: controlPoint1)
        
        let duration = Double.random(in: 0.5...0.8)
        let delay = Double.random(in: 0...0.2)
        
        let animatePosition: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: #keyPath(CALayer.position))
        animatePosition.path = paths.cgPath
        animatePosition.duration = duration
        animatePosition.beginTime = CACurrentMediaTime() + delay
        animatePosition.isRemovedOnCompletion = false
        animatePosition.fillMode = .both

        let animateAlpha = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        animateAlpha.fromValue = 1
        animateAlpha.toValue = 0
        animateAlpha.timingFunction = CAMediaTimingFunction(name: .easeIn)
        animateAlpha.duration = duration
        animateAlpha.beginTime = CACurrentMediaTime() + delay
        animateAlpha.isRemovedOnCompletion = false
        animateAlpha.fillMode = .both

        let animateTransform = CABasicAnimation(keyPath: #keyPath(CALayer.transform))
        animateTransform.fromValue = CATransform3DIdentity
        animateTransform.toValue = CATransform3DMakeScale(13.0/34, 13.0/34, 1)
        animateTransform.timingFunction = CAMediaTimingFunction(name: .easeIn)
        animateTransform.duration = duration
        animateTransform.beginTime = CACurrentMediaTime() + delay
        animateTransform.isRemovedOnCompletion = false
        animateTransform.fillMode = .both

        CATransaction.begin()
        CATransaction.setCompletionBlock {
            label.removeFromSuperview()
        }
        label.layer.add(animatePosition, forKey: "animate position along path")
        label.layer.add(animateAlpha, forKey: "animate alpha to fade out")
        label.layer.add(animateTransform, forKey: "animate size to get smaller")
        CATransaction.commit()
    }
}

extension AnimatingLabel : ScoreAddPresenter {
    
    func present(addedScore: Int) {
        animate("\(addedScore > 0 ? "+" : "")\(addedScore)")
    }
}
