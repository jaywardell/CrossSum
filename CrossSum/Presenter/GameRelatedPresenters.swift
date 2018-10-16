//
//  GameRelatedPresenters.swift
//  CrossSum
//
//  Created by Joseph Wardell on 10/16/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import Foundation

// the following presenters are specific to CrossSum
// yet are simple enough to all fit together in one file

func ScorePresenter(_ presenter:TextPresenter) -> IntegerPresenter {
    return PrefixedPresenter(presenter, prefix: "score")
}

func StagePresenter(_ presenter:TextPresenter) -> IntegerPresenter {
    return PrefixedPresenter(presenter, prefix: "stage")
}

// MARK:-

protocol OptionalStatementPresenter {
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

// MARK:-

protocol DiscreteProgressPresenter {
    
    func present(progress:Int, of maxProgress:Int)
}
