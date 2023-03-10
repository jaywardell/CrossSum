//
//  Presenters.swift
//  CrossSum
//
//  Created by Joseph Wardell on 9/24/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import Foundation

// Presenters provide a generic way to present a value of a given type
// We use them to allow view-layer objects to be passed to the model layer generically
//
// Presenter protocols are typically implemented by views or view controllers
// but the protocols are completely agnostic to and ignorant of the view layer
//
// This file defines protocols for presenters of different types
// and some simple generic presenters that can be composed into other presenters
//
// Presenters may act as decorators, wrapping other presenters
// and a concrete class may implement more than one presenter protocol
//
// An important note: Presenters are not inspectable.
// Thye're told to present something, and they're expected to do it
// Clients of a presenter are not given information on how a presenter does its job
// or even when or if it does.

protocol TextPresenter {
    func present(text:String)
}

// MARK:-

protocol IntegerPresenter {
    func present(integer:Int)
}

// MARK:-

struct ConcreteIntegerPresenter : IntegerPresenter {
    
    let presenter : TextPresenter

    func present(integer: Int) {
        presenter.present(text:"\(integer)")
    }
}

/// presents an integer within a string
/// instances of a replacedString are replaced by the integer in the formatString
struct SemanticIntegerPresenter : IntegerPresenter {
    
    let presenter : TextPresenter

    let formatString : String
    let replacedString : String
    
    func present(integer: Int) {
        presenter.present(text:formatString.replacingOccurrences(of: replacedString, with: "\(integer)"))
    }
}

/// presents an integer with a prefix label of some time in a standardized format
struct PrefixedPresenter : IntegerPresenter {
    
    let semanticPresenter : SemanticIntegerPresenter
    
    init(_ presenter:TextPresenter, prefix:String) {
        self.semanticPresenter = SemanticIntegerPresenter(presenter: presenter, formatString: "\(prefix): XXXX", replacedString: "XXXX")
    }
    
    func present(integer: Int) {
        semanticPresenter.present(integer: integer)
    }
}


/// A presenter that can have its presenting state turned on or off
protocol ToggleablePresenter {
    
    /// tells the presenter to begin or end presenting whatever value it is currently displaying
    ///
    /// - Parameter shouldPresent: true if the presenter should show its current value, otherwise false
    func setIsPresenting(_ shouldPresent:Bool)
}

/// A wrapper for a series of HidingPresenters
struct ToggleablePresenterGroup : ToggleablePresenter {
    
    private let toggleables : [ToggleablePresenter]
    
    init(_ toggleables:[ToggleablePresenter]) {
        self.toggleables = toggleables
    }
    
    func setIsPresenting(_ shouldPresent: Bool) {
        
        toggleables.forEach() { $0.setIsPresenting(shouldPresent)}
    }
}

struct ToggleableKeyedPresenter<Element, KeyValue> : ToggleablePresenter {
    
    let key : ReferenceWritableKeyPath<Element, KeyValue>
    let canvass : Element
    let onValue : KeyValue
    let offValue : KeyValue
    
    init(_ canvass:Element, key:ReferenceWritableKeyPath<Element, KeyValue>, on onValue:KeyValue, off offValue:KeyValue) {
        self.canvass = canvass
        self.key = key
        self.onValue = onValue
        self.offValue = offValue
    }
    
    
    func setIsPresenting(_ shouldPresent: Bool) {
        canvass[keyPath:key] = shouldPresent ? onValue : offValue
    }
}

extension ToggleableKeyedPresenter where KeyValue == Bool {
    
    init(_ canvass:Element, key:ReferenceWritableKeyPath<Element, Bool>, inverted:Bool=false) {
        self.init(canvass, key: key, on:inverted ? false : true, off:inverted ? true : false)
    }
}
