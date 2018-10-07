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
    var text : String { get set }
}

protocol ScorePresenter {
    var score : Int { get set }
}

protocol StagePresenter {
    var stage : Int { get set }
}

protocol RationalPresenter {
    var value : Rational { get set }
}

protocol OptionalStatementPresenter {
    var statement : Statement? { get set }
}

protocol TimeRemainingPresenter {
    var maxTime : Double{ get set }
    var remainingTime : Double { get set }
}

protocol ScoreAddPresenter {
    func showScoreAdd(_ scoreAdd:Int)
}

protocol HintCountPresenter {
//    var hints : Int { get set }
    func showHints(_ hints:Int, for round:Round)
}

/*
 RationalPresenter
 TimeRemainingPresenter
 GridPresenter
 */
