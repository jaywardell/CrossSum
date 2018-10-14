//
//  Presenters.swift
//  CrossSum
//
//  Created by Joseph Wardell on 9/24/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import Foundation

// Presenters provide a generic way to set a value of a given type
// we use them to allow view-layer objects to be passed around other layers generically
protocol TextPresenter {
    func present(text:String)
}

// MARK:-

protocol IntegerPresenter {
    func present(integer:Int)
}

// MARK:-

private struct SemanticIntegerPresenter : IntegerPresenter {
    
    let presenter : TextPresenter

    let formatString : String
    let replacedString : String
    
    func present(integer: Int) {
        presenter.present(text:formatString.replacingOccurrences(of: replacedString, with: "\(integer)"))
    }
}

private struct PrefixedPresenter : IntegerPresenter {
    
    let semanticPresenter : SemanticIntegerPresenter
    
    init(_ presenter:TextPresenter, prefix:String) {
        self.semanticPresenter = SemanticIntegerPresenter(presenter: presenter, formatString: "\(prefix): XXXX", replacedString: "XXXX")
    }
    
    func present(integer: Int) {
        semanticPresenter.present(integer: integer)
    }
}

// MARK:-

func ScorePresenter(_ presenter:TextPresenter) -> IntegerPresenter {
    return PrefixedPresenter(presenter, prefix: "score")
}

func StagePresenter(_ presenter:TextPresenter) -> IntegerPresenter {
    return PrefixedPresenter(presenter, prefix: "stage")
}

// MARK:-

protocol OptionalStatementPresenter {
//    var statement : Statement? { get set }
    func present(statement:Statement?)
}

// MARK:-

protocol TimeRemainingPresenter {
    
    /// tells the presenter to present a new total time
    /// the presenter can assume that remainingtime is now the same as totaltime
    ///
    /// - Parameter totalTime: total time in seconds
    func present(totalTime:Double)
    
    /// tells the presenter to present a new remaining time
    /// the presenter should assume that the total time has not changed
    ///
    /// - Parameter remainingTime: remaining time in seconds
    func present(remainingTime:Double)
}

// MARK:-

protocol ScoreAddPresenter {
    func present(addedScore:Int)
}
