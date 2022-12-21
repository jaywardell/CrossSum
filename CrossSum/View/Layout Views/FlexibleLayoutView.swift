//
//  FlexibleLayoutView.swift
//  FlexibleLayoutTest
//
//  Created by Joseph Wardell on 10/24/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import UIKit

// NOTE: If the app doesn't support all orientations, then you may get strange behavior

open class FlexibleLayoutView: UIView {
    
    /// Contains a set of properties that describe a current view state
    /// some or all of these can be nil, and they often are
    struct ViewState : Hashable, CustomStringConvertible {
        
        let interfaceIdiom : UIUserInterfaceIdiom?
        let horizontalSizeClass : UIUserInterfaceSizeClass?
        let verticalSizeClass : UIUserInterfaceSizeClass?
        let layoutDirection : UIUserInterfaceLayoutDirection?
        let contentSizeCategories : [UIContentSizeCategory]?
        let orientations : [UIDeviceOrientation]?
        
        init(interfaceIdiom : UIUserInterfaceIdiom?=nil,
             horizontalSizeClass : UIUserInterfaceSizeClass?=nil,
             verticalSizeClass : UIUserInterfaceSizeClass?=nil,
             layoutDirection : UIUserInterfaceLayoutDirection?=nil,
             contentSizeCategories : [UIContentSizeCategory]?=nil,
             orientations : [UIDeviceOrientation]?=nil) {
            self.interfaceIdiom = interfaceIdiom
            self.horizontalSizeClass = horizontalSizeClass
            self.verticalSizeClass = verticalSizeClass
            self.layoutDirection = layoutDirection
            self.contentSizeCategories = contentSizeCategories
            self.orientations = orientations
        }
        
        func mutatedCopy(interfaceIdiom : UIUserInterfaceIdiom?=nil,
                         horizontalSizeClass : UIUserInterfaceSizeClass?=nil,
                         verticalSizeClass : UIUserInterfaceSizeClass?=nil,
                         layoutDirection : UIUserInterfaceLayoutDirection?=nil,
                         contentSizeCategories : [UIContentSizeCategory]?=nil,
                         orientations : [UIDeviceOrientation]?=nil) -> ViewState {
            return ViewState(interfaceIdiom: interfaceIdiom ?? self.interfaceIdiom,
                             horizontalSizeClass: horizontalSizeClass ?? self.horizontalSizeClass,
                             verticalSizeClass: verticalSizeClass ?? self.verticalSizeClass,
                             layoutDirection: layoutDirection ?? self.layoutDirection,
                             contentSizeCategories: contentSizeCategories ?? self.contentSizeCategories,
                             orientations: orientations ?? self.orientations)
        }
        
        static let all = ViewState()
        
        var opposite : ViewState {
            return ViewState(interfaceIdiom: interfaceIdiom,
                             horizontalSizeClass: horizontalSizeClass?.opposite,
                             verticalSizeClass: verticalSizeClass?.opposite,
                             layoutDirection: layoutDirection?.opposite,
                             contentSizeCategories: contentSizeCategories?.opposite,
                             orientations: orientations?.opposite)
        }
        
        func matches(_ orientation:UIDeviceOrientation) -> Bool {
            if let orientations = orientations,
                !orientations.contains(orientation) {
                return false
            }
            return true
        }
        
        func matches(_ traitEnvironment:UITraitEnvironment) -> Bool {
            
            if let interfaceIdiom = interfaceIdiom,
                traitEnvironment.traitCollection.userInterfaceIdiom != interfaceIdiom {
                return false
            }
            
            if let horizontalSizeClass = horizontalSizeClass,
                traitEnvironment.traitCollection.horizontalSizeClass != horizontalSizeClass {
                return false
            }
            
            if let verticalSizeClass = verticalSizeClass,
                traitEnvironment.traitCollection.verticalSizeClass != verticalSizeClass {
                return false
            }
            
            if let layoutDirection = layoutDirection,
                traitEnvironment.traitCollection.layoutDirection.rawValue != layoutDirection.rawValue {
                return false
            }
            
            if let contentSizeCategories = contentSizeCategories,
                !contentSizeCategories.contains(traitEnvironment.traitCollection.preferredContentSizeCategory) {
                return false
            }
            
            return true
        }
        
        static prefix func !(_ viewState:ViewState) -> ViewState {
            return viewState.opposite
        }
        
        var description : String {
            
            var out = ""
            
            if let i = interfaceIdiom {
                out += "\(i)"
            }
            if let sc = horizontalSizeClass {
                out += " \(sc)"
            }
            if let sc = verticalSizeClass {
                out += " \(sc)"
            }
            if let ld = layoutDirection {
                out += " \(ld)"
            }
            if let csc = contentSizeCategories {
                out += " \(csc)"
            }
            if let o = orientations {
                out += " \(o)"
            }

            return out
        }
    }
    
    // MARK:-
    
    private var layouts = [ViewState:[NSLayoutConstraint]]()
    
    func setConstraints(for viewstate:ViewState, _ constraints:[NSLayoutConstraint]) {
        validate(constraints)   // some safety checking
        layouts[viewstate] = constraints
    }
    
    func addConstraint(for viewstate:ViewState, _ constraint: NSLayoutConstraint) {
        addConstraints(for: viewstate, [constraint])
    }
    
    func addConstraints(for viewstate:ViewState, _ constraints:[NSLayoutConstraint]) {
        validate(constraints)   // some safety checking
        layouts[viewstate] = (layouts[viewstate] ?? []) + constraints
    }
    
    func removeConstraints(for viewstate:ViewState, _ constraints:[NSLayoutConstraint]) {
        layouts[viewstate] = (layouts[viewstate] ?? []).filter() {
            !constraints.contains($0)
        }
    }
    
    func removeConstraints(for viewstate:ViewState) {
        layouts[viewstate] = nil
    }
    
    private func validate(_ constraints:[NSLayoutConstraint]) {
        for constraint in constraints {
            if let firstView = constraint.firstItem as? UIView,
                !firstView.isDescendant(of: self) {
                fatalError("\(firstView) does not appear to be in the view hierarchy of \(self)")
            }
            if let secondView = constraint.secondItem as? UIView,
                !secondView.isDescendant(of: self) {
                fatalError("\(secondView) does not appear to be in the view hierarchy of \(self)")
            }
        }
    }
    
    // MARK:-
    
    private var callbacks = [ViewState:[()->()]]()
    
    func addCallback(for viewstate:ViewState, _ callback: @escaping ()->()) {
        callbacks[viewstate] = (callbacks[viewstate] ?? []) + [callback]
    }
    
    func removeCallbacks(for viewstate:ViewState) {
        callbacks[viewstate] = nil
    }
    
    // MARK:- Notifications
    
    @objc private func orientationChanged(_ notification:Notification) {
        
        updateLayout()
    }
    
    @objc private func contentSizeCategoryDidChange(_ notification:Notification) {
        
        updateLayout()
    }
    
    // MARK:-
    
    func addManagedSubview(_ view:UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        guard view.superview != self else { return }
        addSubview(view)
    }
    
    func addManagedSubviews(_ views:[UIView]) {
        views.forEach() {
            addManagedSubview($0)
        }
    }
    
    // MARK:-
    
    /// This method is called to give a chance for subviews to add managed subviews in a convenient place
    /// So a subclass would put its called to addManagedSubviews here
    open func configureManagedSubviews() {
        // the default implementation does nothing
        // subclasses override
    }
    
    /// This method is called to give a chance for subviews to configure their layouts
    /// So a subclass would put its calls to addcallback, addConstraints and addManagedSubview here
    open func configureLayouts() {
        // the default implementation does nothing
        // subclasses override
    }
    
    // MARK:-
    
    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
                
        NotificationCenter.default.removeObserver(self)
        
        if nil != superview {
            NotificationCenter.default.addObserver(self, selector: #selector(orientationChanged(_:)), name: UIDevice.orientationDidChangeNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(contentSizeCategoryDidChange(_:)), name: UIContentSizeCategory.didChangeNotification, object: nil)
        }
        
        configureManagedSubviews()
        configureLayouts()
        
        updateLayout()
    }
    
    override open func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        updateLayout()
    }
    
    private func disableAllConstraints() {
        layouts.forEach() { _, constraints in
            constraints.forEach() {
                $0.isActive = false
            }
        }
    }
    
    private func updateLayout() {
        
        // first, turn off all constraints
        disableAllConstraints()
        
        // then turn on the ones that we will want for this view state
        for (viewstate, contraints) in layouts {
            let active = viewstate.matches(self) && viewstate.matches(UIDevice.current.orientation)

            contraints.forEach() {
                $0.isActive = active
            }
        }
        
        for (viewstate, callbacks) in callbacks {
            if viewstate.matches(self) && viewstate.matches(UIDevice.current.orientation) {
                callbacks.forEach() {
                    $0()
                }
            }
        }
    }
}


// MARK:-

extension UIUserInterfaceSizeClass {
    
    var opposite : UIUserInterfaceSizeClass {
        switch self {
        case .unspecified:
            return .unspecified
        case .compact:
            return .regular
        case .regular:
            return .compact
        @unknown default:
            fatalError()
        }
    }
}

// MARK:-

extension UIUserInterfaceLayoutDirection {
    
    var opposite : UIUserInterfaceLayoutDirection {
        switch self {
            
        case .leftToRight:
            return .rightToLeft
        case .rightToLeft:
            return .leftToRight
        @unknown default:
            fatalError()
        }
    }
}

// MARK:-

extension Array where Element == UIDeviceOrientation {
    // MARK: [UIDeviceOrientation]
    
    static var all : Array<UIDeviceOrientation> {
        return [.unknown] +
            Array<UIDeviceOrientation>.portrait +
            Array<UIDeviceOrientation>.landscape +
            Array<UIDeviceOrientation>.flat
    }
    
    static var portrait : Array<UIDeviceOrientation> {
        return [
            .portrait, // Device oriented vertically, home button on the bottom
            .portraitUpsideDown, // Device oriented vertically, home button on the top
        ]
    }
    
    static var landscape : Array<UIDeviceOrientation> {
        return [
            .landscapeLeft, // Device oriented horizontally, home button on the right
            .landscapeRight, // Device oriented horizontally, home button on the left
        ]
    }
    
    static var flat : Array<UIDeviceOrientation> {
        return [
            .faceUp, // Device oriented flat, face up
            .faceDown // Device oriented flat, face down
        ]
    }
    
    static var allbutLandscape : Array<UIDeviceOrientation> {
        return [
            .portrait, // Device oriented vertically, home button on the bottom
            .portraitUpsideDown, // Device oriented vertically, home button on the top
            .faceUp, // Device oriented flat, face up
            .faceDown // Device oriented flat, face down
       ]
    }

    static var allbutPortrait : Array<UIDeviceOrientation> {
        return [
            .landscapeLeft, // Device oriented horizontally, home button on the right
            .landscapeRight, // Device oriented horizontally, home button on the left
            .faceUp, // Device oriented flat, face up
            .faceDown // Device oriented flat, face down
        ]
    }

    
    var opposite : Array<UIDeviceOrientation> {
        return Array<UIDeviceOrientation>.all.filter() {
            !contains($0)
        }
    }
}

// MARK:-

extension Array where Element == UIContentSizeCategory {
    // MARK: [UIContentSizeCategory]
    
    var opposite : Array<UIContentSizeCategory> {
        return Array<UIContentSizeCategory>.all.filter() {
            !contains($0)
        }
    }
    
    static var all : Array<UIContentSizeCategory> {
        return [.unspecified] +
            Array<UIContentSizeCategory>.standard +
            Array<UIContentSizeCategory>.accessibility
    }
    
    static let unspecified : UIContentSizeCategory = UIContentSizeCategory.unspecified
    
    static let standard : Array<UIContentSizeCategory> = [
        // standard
        UIContentSizeCategory.extraSmall,
        UIContentSizeCategory.small,
        UIContentSizeCategory.medium,
        UIContentSizeCategory.large,
        UIContentSizeCategory.extraLarge,
        UIContentSizeCategory.extraExtraLarge,
        UIContentSizeCategory.extraExtraExtraLarge,
        ]
    
    static var accessibility : Array<UIContentSizeCategory> = [
        // Accessibility sizes
        UIContentSizeCategory.accessibilityMedium,
        UIContentSizeCategory.accessibilityLarge,
        UIContentSizeCategory.accessibilityExtraLarge,
        UIContentSizeCategory.accessibilityExtraExtraLarge,
        UIContentSizeCategory.accessibilityExtraExtraExtraLarge
    ]
}

extension UIUserInterfaceIdiom : CustomStringConvertible {
    
    public var description : String {
        switch self {
        case .unspecified:
            return "unspecified"
        case .phone:
            return "phone"
        case .pad:
            return "pad"
        case .tv:
            return "tv"
        case .carPlay:
            return "carPlay"
        case .mac:
            return "mac"
        @unknown default:
            fatalError()
        }
    }
}

extension UIUserInterfaceSizeClass: CustomStringConvertible {
    public var description : String {
        switch self {
            
        case .unspecified:
            return "unspecified"
        case .compact:
            return "compact"
        case .regular:
            return "regular"
        @unknown default:
            fatalError()
        }
    }
}

extension UIUserInterfaceLayoutDirection : CustomStringConvertible {
    public var description : String {
        switch self {
        case .leftToRight:
            return "left to right"
        case .rightToLeft:
            return "right to left"
        @unknown default:
            fatalError()
        }
    }
}

extension UIContentSizeCategory : CustomStringConvertible {
    public var description : String {
        return rawValue
    }
}

extension UIDeviceOrientation : CustomStringConvertible {
    public var description : String {
        switch self {
            
        case .unknown:
            return "unknown"
        case .portrait:
            return "portrait"
        case .portraitUpsideDown:
            return "portrait upside down"
        case .landscapeLeft:
            return "landscape left"
        case .landscapeRight:
            return "landscape right"
        case .faceUp:
            return "face up"
        case .faceDown:
            return "face down"
        @unknown default:
            fatalError()
        }
    }
}
