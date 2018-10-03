//
//  Round.swift
//  CrossSum
//
//  Created by Joseph Wardell on 9/30/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import Foundation

final class Round {
    
    var score : Int = 0 {
        didSet {
            scorePresenter?.score = score
        }
    }
    
    var grid : Grid?
    var gridFactory : GridFactory
    
    var foundSolutions = Set<Rational>()
    var currentTargetSolution : Rational?
    var availableSolutions : Set<Rational> {
        return grid?.solutions.subtracting(foundSolutions) ?? Set()
    }
    
    var wordSearchView : WordSearchView? = nil {
        didSet {
            wordSearchView?.allowsDiagonalSelection = false
            wordSearchView?.didSelect = didSelect(_:)
            wordSearchView?.isValidSelection = isValidSelection
        }
    }
    
    var statementPresenter : OptionalStatementPresenter?
    var scorePresenter : ScorePresenter?
    
    var solutionFilter : (Rational) -> Bool = { _ in return true }

    private var hint : (Int, Int)?
    
    init(gridFactory:GridFactory) {
        self.gridFactory = gridFactory
    }
}

// MARK:- Game Play

extension Round {
    
    func begin() {
        showNextGrid()
        scorePresenter?.score = 0
    }
    
    private func showNextTargetSolution() {
        guard let next = availableSolutions.randomElement() else {
            showNextGrid()
            return
        }
        
        hint = nil
        currentTargetSolution = next
        presentCurrentTargetSolution()
    }
    
    private func presentCurrentTargetSolution() {
        statementPresenter?.statement = Statement(nil, currentTargetSolution)
    }
    
    private func showNextGrid() {
        foundSolutions.removeAll()

        self.grid = gridFactory.gridAfter(grid)
        wordSearchView?.dataSource = grid
        wordSearchView?.reloadSymbols()

        // TODO: fade old grid out and new grid in
        
        showNextTargetSolution()
    }
}

// MARK:- Hints

extension Round {
    /// Tells the WordSearchView to show a selection over the first view of ONE OF the possible ways to get the solution, chosen randomly
    func showAHint() {
        guard let thisWay = hintedCoordinate() else { return }
        
        wordSearchView?.select(thisWay.0, thisWay.1, animated:true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.wordSearchView?.removeSelection(animated: true)
        }
    }
    
    private func hintedCoordinate() -> (Int, Int)? {
        if let hint = hint { return hint}
        guard let currentTargetSolution = currentTargetSolution,
            let ways = grid?.waysToGet(solution: currentTargetSolution),
            let thisWay = ways.randomElement()  else { return nil }
        print("ways to get \(currentTargetSolution): \(ways)")
        hint = thisWay.0
        return hint
    }
    
    func showASolution(andAdvance advanceToNextTargetSolution:Bool = false) {
        guard let currentTargetSolution = currentTargetSolution,
            let ways = grid?.waysToGet(solution: currentTargetSolution),
            let hint = hintedCoordinate(),
            let thisWay = ways.first(where:{
                $0.0 == hint
        }) else { return }

        wordSearchView?.isUserInteractionEnabled = false
        wordSearchView?.select(from: thisWay.0.0, thisWay.0.1, to: thisWay.1.0, thisWay.1.1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.wordSearchView?.removeSelection(animated: true) {
                if advanceToNextTargetSolution {
                    self?.advanceToNextTargetSolution()
                }
                self?.wordSearchView?.isUserInteractionEnabled = true
            }
        }
    }
}


// MARK:- WordSearchView Methods

extension Round {
    
    func isValidSelection(_:Int, _:Int, string:String?) -> Bool {
        guard !(string?.isEmpty ?? false) else { return false }
        if string == "-" { return true }
        if nil != Int(string!) {
            return !"+-×÷".contains(string!.last!)
        }
        return false
    }
    
    func didSelect(_ string: String) {
        
        // a little hysterysis: if the user stopped selecting on an operator,
        // then just drop it and assume he meant to select
        // the string up to but not including the operator
        let solutionString = "+-×÷".contains(string.last!) ? String(string.dropLast()) : string
        
        let statement = Statement(solutionString, currentTargetSolution)
        statementPresenter?.statement = statement
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else { return }
            if statement.isTrue {
                self.advanceToNextTargetSolution(advancingScoreBy: self.score(for:statement))
            }
            else {
                self.presentCurrentTargetSolution()
            }
        }

    }

    func advanceToNextTargetSolution(advancingScoreBy scoreForTarget:Int = 0) {
        self.foundSolutions.insert(self.currentTargetSolution!)
        self.showNextTargetSolution()
        
        self.score += scoreForTarget
    }
}

// MARK:- Score

extension Round {
    
    func score(for statement:Statement) -> Int {
        guard let expression = statement.expression else { return 0 }
        var out = 1
        for i in 0..<expression.count {
            out *= 2
        }
        return out
    }
}

