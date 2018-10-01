//
//  Round.swift
//  CrossSum
//
//  Created by Joseph Wardell on 9/30/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import Foundation

final class Round {
    
    var grid : Grid?
    
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
    
    var solutionFilter : (Rational) -> Bool = { _ in return true }

    private var hint : (Int, Int)?
}

// MARK:- Game Play

extension Round {
    
    func begin(with grid:Grid) {
        self.grid = grid
        self.grid?.findSolutions(filter: solutionFilter)
        wordSearchView?.dataSource = grid
        wordSearchView?.reloadSymbols()
        
        showNextTargetSolution()
    }
    
    func showNextTargetSolution() {
        guard let next = availableSolutions.randomElement() else {
            showNextGrid()
            return
        }
        
        hint = nil
        currentTargetSolution = next
        presentCurrentTargetSolution()
    }
    
    func presentCurrentTargetSolution() {
        statementPresenter?.statement = Statement(nil, currentTargetSolution)
    }
    
    func showNextGrid() {
        print("\(#function) not yet implemented")
    }
}

// MARK:- Hints

extension Round {
    /// Tells the WordSearchView to show a selection over the first view of ONE OF the possible ways to get the solution, chosen randomly
    func showAHint() {
        guard let thisWay = hintedCoordinate() else { return }
        
        wordSearchView?.select(thisWay.0, thisWay.1)
        
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
        
        let statement = Statement(string, currentTargetSolution)
        statementPresenter?.statement = statement
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            if statement.isTrue {
                self?.foundSolutions.insert(self!.currentTargetSolution!)
                self?.showNextTargetSolution()
            }
            else {
                self?.presentCurrentTargetSolution()
            }
        }

    }

}
