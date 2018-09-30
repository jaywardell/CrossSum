//
//  UIView+AutolayoutConvenience.swift
//  Programmatic Autolayout
//
//  Created by Joseph Wardell on 9/8/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import UIKit

extension UIView {
    
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
        
        constrain(to:constraints)
    }
    
    func constrainToFillSuperview(insets:UIEdgeInsets = .zero, usingSafeLayoutGuides:Bool = false) {
        
        let guide : LayoutPositioning = usingSafeLayoutGuides ? superview!.safeAreaLayoutGuide : superview!
        
        anchor(leading: guide.leadingAnchor,
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
    
    func constrainToPositionInSuperview(_ verticalPosition:VerticalPosition,
                                        _ horizontalPosition:HorizontalPosition,
                                        size:CGSize = .zero,
                                        padding:UIEdgeInsets = .zero,
                                        usingSafeLayoutGuides:Bool = false) {
        
        let guide : LayoutPositioning = usingSafeLayoutGuides ? superview!.safeAreaLayoutGuide : superview!
        
        switch horizontalPosition
        {
        case .leading:
            switch verticalPosition {
            case .top:
                anchor(leading: guide.leadingAnchor, center: nil, trailing: nil,
                       top: guide.topAnchor, middle: nil, bottom: nil,
                       size: size, padding:padding)
            case .middle:
                anchor(leading: guide.leadingAnchor, center: nil, trailing: nil,
                       top: nil, middle: guide.centerYAnchor, bottom: nil,
                       size: size, padding:padding)
            case .bottom:
                anchor(leading: guide.leadingAnchor, center: nil, trailing: nil,
                       top: nil, middle: nil, bottom: guide.bottomAnchor,
                       size: size, padding:padding)
            }
        case .center:
            switch verticalPosition {
            case .top:
                anchor(leading: nil, center: guide.centerXAnchor, trailing: nil,
                       top: guide.topAnchor, middle: nil, bottom: nil,
                       size: size, padding:padding)
            case .middle:
                anchor(leading: nil, center: guide.centerXAnchor, trailing: nil,
                       top: nil, middle: guide.centerYAnchor, bottom: nil,
                       size: size, padding:padding)
            case .bottom:
                anchor(leading: nil, center: guide.centerXAnchor, trailing: nil,
                       top: nil, middle: nil, bottom: guide.bottomAnchor,
                       size: size, padding:padding)
            }
        case .trailing:
            switch verticalPosition {
            case .top:
                anchor(leading: nil, center: nil, trailing: guide.trailingAnchor,
                       top: guide.topAnchor, middle: nil, bottom: nil,
                       size: size, padding:padding)
            case .middle:
                anchor(leading: nil, center: nil, trailing: guide.trailingAnchor,
                       top: nil, middle: guide.centerYAnchor, bottom: nil,
                       size: size, padding:padding)
            case .bottom:
                anchor(leading: nil, center: nil, trailing: guide.trailingAnchor,
                       top: nil, middle: nil, bottom: guide.bottomAnchor,
                       size: size, padding:padding)
            }
        }
    }
    
    func constrainToLimitSize(of viewOrGuide:LayoutPositioning, widthMultiplier:CGFloat? = nil, heightMultiplier:CGFloat? = nil) {
        
        var constraints = [NSLayoutConstraint]()
        
        if let widthMultiplier = widthMultiplier {
            constraints.append(widthAnchor.constraint(lessThanOrEqualTo: viewOrGuide.widthAnchor, multiplier: widthMultiplier))
        }
        
        if let heightMultiplier = heightMultiplier {
            constraints.append(heightAnchor.constraint(lessThanOrEqualTo: viewOrGuide.heightAnchor, multiplier: heightMultiplier))
        }
        
        constrain(to: constraints)
    }
    
    func constrainToMeetOrExceedSize(of viewOrGuide:LayoutPositioning, widthMultiplier:CGFloat? = nil, heightMultiplier:CGFloat? = nil) {
        
        var constraints = [NSLayoutConstraint]()
        
        if let widthMultiplier = widthMultiplier {
            constraints.append(widthAnchor.constraint(greaterThanOrEqualTo: viewOrGuide.widthAnchor, multiplier: widthMultiplier))
        }
        
        if let heightMultiplier = heightMultiplier {
            constraints.append(heightAnchor.constraint(greaterThanOrEqualTo: viewOrGuide.heightAnchor, multiplier: heightMultiplier))
        }
        
        constrain(to: constraints)
    }

    func constrainToMatchSize(of viewOrGuide:LayoutPositioning, widthMultiplier:CGFloat? = nil, heightMultiplier:CGFloat? = nil) {
        
        var constraints = [NSLayoutConstraint]()
        
        if let widthMultiplier = widthMultiplier {
            constraints.append(widthAnchor.constraint(equalTo: viewOrGuide.widthAnchor, multiplier: widthMultiplier))
        }
        
        if let heightMultiplier = heightMultiplier {
            constraints.append(heightAnchor.constraint(equalTo: viewOrGuide.heightAnchor, multiplier: heightMultiplier))
        }
        
        constrain(to: constraints)
    }
    
    func constrainToAspectRatio(_ aspectRatio:CGFloat) {
        
        constrain(to: [
            widthAnchor.constraint(equalTo: heightAnchor, multiplier: aspectRatio)
            ])
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
