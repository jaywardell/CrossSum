//
//  UIView+AutolayoutConvenience.swift
//  Programmatic Autolayout
//
//  Created by Joseph Wardell on 9/8/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import UIKit

extension UIView {
    
    
    func constraintsToPin(leading:NSLayoutXAxisAnchor? = nil,
                center:NSLayoutXAxisAnchor? = nil,
                trailing:NSLayoutXAxisAnchor? = nil,
                top:NSLayoutYAxisAnchor? = nil,
                middle:NSLayoutYAxisAnchor? = nil,
                bottom:NSLayoutYAxisAnchor? = nil,
                size:CGSize = .zero,
                padding:UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
        
        var constraints = [NSLayoutConstraint]()
        
        if let leading = leading {
            constraints.append(leadingAnchor.constraint(equalTo: leading, constant:padding.left))
        }
        
        if let center = center {
            constraints.append(centerXAnchor.constraint(equalTo: center))
        }
        
        if let trailing  = trailing {
            constraints.append(trailingAnchor.constraint(equalTo: trailing, constant:-padding.right))
        }
        
        if let top = top {
            constraints.append(topAnchor.constraint(equalTo: top, constant:padding.top))
        }
        
        if let middle = middle {
            constraints.append(centerYAnchor.constraint(equalTo: middle))
        }
        
        if let bottom = bottom {
            constraints.append(bottomAnchor.constraint(equalTo: bottom, constant:-padding.bottom))
        }
        
        if size.width != 0 {
            constraints.append(widthAnchor.constraint(equalToConstant: size.width))
        }
        
        if size.height != 0 {
            constraints.append(heightAnchor.constraint(equalToConstant: size.height))
        }
        
        return constraints
    }
    
    func constraintsToFillSuperview(insets:UIEdgeInsets = .zero, usingSafeLayoutGuides:Bool = false) -> [NSLayoutConstraint] {
        
        let guide : LayoutPositioning = usingSafeLayoutGuides ? superview!.safeAreaLayoutGuide : superview!
        
        return constraintsToPin(leading: guide.leadingAnchor,
               trailing: guide.trailingAnchor,
               top: guide.topAnchor,
               bottom: guide.bottomAnchor,
               padding:insets)
    }
    
    enum HorizontalPosition {
        case leading
        case center
        case trailing
    }
    
    enum VerticalPosition {
        case top
        case middle
        case bottom
    }
    
    func constraintsToPositionInSuperview(_ verticalPosition:VerticalPosition,
                                        _ horizontalPosition:HorizontalPosition,
                                        size:CGSize = .zero,
                                        padding:UIEdgeInsets = .zero,
                                        usingSafeLayoutGuides:Bool = false) -> [NSLayoutConstraint] {
        
        let guide : LayoutPositioning = usingSafeLayoutGuides ? superview!.safeAreaLayoutGuide : superview!
        
        var constraints = [NSLayoutConstraint]()
        
        switch horizontalPosition
        {
        case .leading:
            switch verticalPosition {
            case .top:
                constraints.append(contentsOf:constraintsToPin(leading: guide.leadingAnchor, center: nil, trailing: nil,
                       top: guide.topAnchor, middle: nil, bottom: nil,
                       size: size, padding:padding))
            case .middle:
                constraints.append(contentsOf:constraintsToPin(leading: guide.leadingAnchor, center: nil, trailing: nil,
                       top: nil, middle: guide.centerYAnchor, bottom: nil,
                       size: size, padding:padding))
            case .bottom:
                constraints.append(contentsOf:constraintsToPin(leading: guide.leadingAnchor, center: nil, trailing: nil,
                       top: nil, middle: nil, bottom: guide.bottomAnchor,
                       size: size, padding:padding))
            }
        case .center:
            switch verticalPosition {
            case .top:
                constraints.append(contentsOf:constraintsToPin(leading: nil, center: guide.centerXAnchor, trailing: nil,
                       top: guide.topAnchor, middle: nil, bottom: nil,
                       size: size, padding:padding))
            case .middle:
                constraints.append(contentsOf:constraintsToPin(leading: nil, center: guide.centerXAnchor, trailing: nil,
                       top: nil, middle: guide.centerYAnchor, bottom: nil,
                       size: size, padding:padding))
            case .bottom:
                constraints.append(contentsOf:constraintsToPin(leading: nil, center: guide.centerXAnchor, trailing: nil,
                       top: nil, middle: nil, bottom: guide.bottomAnchor,
                       size: size, padding:padding))
            }
        case .trailing:
            switch verticalPosition {
            case .top:
                constraints.append(contentsOf:constraintsToPin(leading: nil, center: nil, trailing: guide.trailingAnchor,
                       top: guide.topAnchor, middle: nil, bottom: nil,
                       size: size, padding:padding))
            case .middle:
                constraints.append(contentsOf:constraintsToPin(leading: nil, center: nil, trailing: guide.trailingAnchor,
                       top: nil, middle: guide.centerYAnchor, bottom: nil,
                       size: size, padding:padding))
            case .bottom:
                constraints.append(contentsOf:constraintsToPin(leading: nil, center: nil, trailing: guide.trailingAnchor,
                       top: nil, middle: nil, bottom: guide.bottomAnchor,
                       size: size, padding:padding))
            }
        }
        return constraints
    }
    
    func constraintsToLimitSize(of viewOrGuide:LayoutPositioning, widthMultiplier:CGFloat? = nil, heightMultiplier:CGFloat? = nil) -> [NSLayoutConstraint] {
        
        var constraints = [NSLayoutConstraint]()
        
        if let widthMultiplier = widthMultiplier {
            constraints.append(widthAnchor.constraint(lessThanOrEqualTo: viewOrGuide.widthAnchor, multiplier: widthMultiplier))
        }
        
        if let heightMultiplier = heightMultiplier {
            constraints.append(heightAnchor.constraint(lessThanOrEqualTo: viewOrGuide.heightAnchor, multiplier: heightMultiplier))
        }
        
        return constraints
    }
    
    func constraintsToMeetOrExceedSize(of viewOrGuide:LayoutPositioning, widthMultiplier:CGFloat? = nil, heightMultiplier:CGFloat? = nil) -> [NSLayoutConstraint] {
        
        var constraints = [NSLayoutConstraint]()
        
        if let widthMultiplier = widthMultiplier {
            constraints.append(widthAnchor.constraint(greaterThanOrEqualTo: viewOrGuide.widthAnchor, multiplier: widthMultiplier))
        }
        
        if let heightMultiplier = heightMultiplier {
            constraints.append(heightAnchor.constraint(greaterThanOrEqualTo: viewOrGuide.heightAnchor, multiplier: heightMultiplier))
        }
        
        return constraints
    }

    func constraintsToMatchSize(of viewOrGuide:LayoutPositioning, widthMultiplier:CGFloat? = nil, heightMultiplier:CGFloat? = nil) -> [NSLayoutConstraint] {
        
        var constraints = [NSLayoutConstraint]()
        
        if let widthMultiplier = widthMultiplier {
            constraints.append(widthAnchor.constraint(equalTo: viewOrGuide.widthAnchor, multiplier: widthMultiplier))
        }
        
        if let heightMultiplier = heightMultiplier {
            constraints.append(heightAnchor.constraint(equalTo: viewOrGuide.heightAnchor, multiplier: heightMultiplier))
        }
        
        return constraints
    }
    
    func aspectRatioConstraints(_ aspectRatio:CGFloat) -> [NSLayoutConstraint] {
        
        return [widthAnchor.constraint(equalTo: heightAnchor, multiplier: aspectRatio)]
    }
    
    
    // MARK:-
    
    func constrain(to constraints:[NSLayoutConstraint]) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(constraints)
    }

    func anchor(leading:NSLayoutXAxisAnchor? = nil,
                          center:NSLayoutXAxisAnchor? = nil,
                          trailing:NSLayoutXAxisAnchor? = nil,
                          top:NSLayoutYAxisAnchor? = nil,
                          middle:NSLayoutYAxisAnchor? = nil,
                          bottom:NSLayoutYAxisAnchor? = nil,
                          size:CGSize = .zero,
                          padding:UIEdgeInsets = .zero) {
        
        constrain(to: constraintsToPin(leading:leading,
                                       center:center,
                                       trailing:trailing,
                                       top:top,
                                       middle:middle,
                                       bottom:bottom,
                                       size:size,
                                       padding:padding))
    }
    
    func constrainToFillSuperview(insets:UIEdgeInsets = .zero, usingSafeLayoutGuides:Bool = false) {
        
        constrain(to: constraintsToFillSuperview(insets:insets, usingSafeLayoutGuides:usingSafeLayoutGuides))
    }
    
    func constrainToPositionInSuperview(_ verticalPosition:VerticalPosition,
                                          _ horizontalPosition:HorizontalPosition,
                                          size:CGSize = .zero,
                                          padding:UIEdgeInsets = .zero,
                                          usingSafeLayoutGuides:Bool = false) {
        constrain(to: constraintsToPositionInSuperview(verticalPosition, horizontalPosition, size:size, padding:padding, usingSafeLayoutGuides:usingSafeLayoutGuides))
    }
    
    func constrainToLimitSize(of viewOrGuide:LayoutPositioning, widthMultiplier:CGFloat? = nil, heightMultiplier:CGFloat? = nil) {
        
        constrain(to: constraintsToLimitSize(of: viewOrGuide, widthMultiplier:widthMultiplier, heightMultiplier:heightMultiplier))
    }
    
    func constrainToMeetOrExceedSize(of viewOrGuide:LayoutPositioning, widthMultiplier:CGFloat? = nil, heightMultiplier:CGFloat? = nil) {
    
        constrain(to: constraintsToMeetOrExceedSize(of: viewOrGuide, widthMultiplier: widthMultiplier, heightMultiplier: heightMultiplier))
    }
    
    func constrainToMatchSize(of viewOrGuide:LayoutPositioning, widthMultiplier:CGFloat? = nil, heightMultiplier:CGFloat? = nil) {

        constrain(to: constraintsToMatchSize(of: viewOrGuide, widthMultiplier: widthMultiplier, heightMultiplier: heightMultiplier))
    }
    
    func constrainToAspectRatio(_ aspectRatio:CGFloat) {
        constrain(to: aspectRatioConstraints(aspectRatio))
    }
}

// MARK:- UIViewAlertForUnsatisfiableConstraints

extension UIView {
    
    /// calls the block passed in with UIViewAlertForUnsatisfiableConstraints logging turned off
    ///
    /// Use this in situations where you know that an unsatisfiable autolayout situation will occur but you know it can be ignored.
    /// For example, if you will immediately change one or more constraints to bring things back into compliance
    /// - Parameter callback: a block of code to be executed that you know may cause an _UIConstraintBasedLayoutLogUnsatisfiable to be logged and that you know is uninteresting to you
    func ignoringAutolayoutWarnings(_ callback:()->()) {
        
        UserDefaults.standard.setValue(false, forKey:"_UIConstraintBasedLayoutLogUnsatisfiable")

        callback()
        
        UserDefaults.standard.setValue(true, forKey:"_UIConstraintBasedLayoutLogUnsatisfiable")

    }
}

// we need to be able to refer to a UIVIew or a UILayoutGuide for the purposes of various anchors
protocol LayoutPositioning {
    
    var leadingAnchor: NSLayoutXAxisAnchor { get }
    var trailingAnchor: NSLayoutXAxisAnchor { get }
    var leftAnchor: NSLayoutXAxisAnchor { get }
    var rightAnchor: NSLayoutXAxisAnchor { get }
    var topAnchor: NSLayoutYAxisAnchor { get }
    var bottomAnchor: NSLayoutYAxisAnchor { get }
    var widthAnchor: NSLayoutDimension { get }
    var heightAnchor: NSLayoutDimension { get }
    var centerXAnchor: NSLayoutXAxisAnchor { get }
    var centerYAnchor: NSLayoutYAxisAnchor { get }
}

extension UIView : LayoutPositioning {}
extension UILayoutGuide : LayoutPositioning {}
