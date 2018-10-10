//
//  Round.swift
//  CrossSum
//
//  Created by Joseph Wardell on 9/30/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import Foundation

protocol RoundDisplayDelegate {
    func willReplaceGrid(_ round:Round)
    func didReplaceGrid(_ round:Round)
}

// MARK:-

final class Round {
    
    var grid : Grid?
    var gridFactory : GridFactory

    var highScore : HighScore {
        return HighScore(score:score, stage:stage)
    }
    
    var score : Int = 0 {
        didSet {
            scorePresenter?.score = score
        }
    }
    
    var stage : Int = 0 {
        didSet {
            stagePresenter?.stage = stage
            print("stage: \(stage)")
        }
    }
    
    private static let TimeForEachTargetSolution : TimeInterval = 10
    private var solutionTime : TimeInterval = 0
    private var timeKeeper : TimeKeeper?
    private(set) var showingGrid = false

    var hints : Int = 0 {
        didSet {
            hintCountPresenter?.showHints(hints, for: self)
        }
    }
    private var hint : (Int, Int)?

    var skips : Int = 0 {
        didSet {
            skipsCountPresenter?.showSkips(skips, for: self)
        }
    }
    private var canEarnASkipThisGrid = true
    
    var displayDelegate : RoundDisplayDelegate?
    
    var foundSolutions = Set<Rational>()
    var currentTargetSolution : Rational?
    var acceptableSolutions : Set<Rational> {
        guard let solutions = grid?.solutions else { return Set() }
        // don't offer solutions that can only be gotten from one or two squares (e.g. - and 5 becomes -5)
        return solutions.filter() {
            guard let locations = grid?.solutionsToExpressionLocations.value[$0] else { return false }
            for choice in locations {
                if abs(choice.0.0 - choice.1.0) >= 2 ||
                    abs(choice.0.1 - choice.1.1) >= 2 {
                    return true
                }
            }
            return false
        }
    }
    var availableSolutions : Set<Rational> {
        return acceptableSolutions.subtracting(foundSolutions)
    }

    var paused : Bool { return timeKeeper?.isPaused ?? false }
    
    // MARK:-
    
    // TODO: abstract this into a protocol of things you need to support a wordsearchview
    // probably a protocol called ExpressionSelector
    var wordSearchView : WordSearchView? = nil {
        didSet {
            wordSearchView?.allowsDiagonalSelection = false
            wordSearchView?.didSelect = didSelect(_:)
            wordSearchView?.canStartSelectionWith = canStartSelection
        }
    }
    
    var statementPresenter : OptionalStatementPresenter?
    var scorePresenter : ScorePresenter?
    var stagePresenter : StagePresenter?
    var timeRemainingPresenter : TimeRemainingPresenter?
    var scoreAddPresenter : ScoreAddPresenter?
    var scoreTimeAddPresenter : ScoreAddPresenter?
    var hintCountPresenter : HintCountPresenter?
    var skipsCountPresenter : SkipCountPresenter?
    
    var solutionFilter : (Rational) -> Bool = { _ in return true }
    
    // MARK:-
    init(gridFactory:GridFactory) {
        self.gridFactory = gridFactory
    }
}

// MARK:- Game Play

extension Round {
    
    func begin() {
        showNextGrid()
        hints = 5
        skips = 3
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
        
        timeKeeper = TimeKeeper(solutionTime, presenter: timeRemainingPresenter) { _ in
            print("Timer Finished")
        }
        timeKeeper?.start()
        
        hintCountPresenter?.showHints(hints, for: self)
        skipsCountPresenter?.showSkips(skips, for: self)
    }
    
    private func presentCurrentTargetSolution() {
        statementPresenter?.statement = Statement(nil, currentTargetSolution)
    }
    
    private func showNextGrid() {
        foundSolutions.removeAll()

        if canEarnASkipThisGrid {
            skips += 1
        }
        canEarnASkipThisGrid = true
        
        showingGrid = false
        displayDelegate?.willReplaceGrid(self)
        
        self.grid = gridFactory.gridAfter(grid)
        wordSearchView?.dataSource = grid
        wordSearchView?.reloadSymbols(animated:true) { [weak self] in guard let self = self else { return }
        
            self.showNextTargetSolution()
            
            self.showingGrid = true
            self.displayDelegate?.didReplaceGrid(self)
        }
        
        // give the user all the time he had accumulated by ansering quickly in previous rounds
        // but also give him an extra standard time allotment
        solutionTime = Round.TimeForEachTargetSolution +
            ((solutionTime > TimeInterval(0)) ? (solutionTime - Round.TimeForEachTargetSolution) : 0)
        print("solutionTime: \(solutionTime)")
        
        stage += 1
        
        print("accesptable solutions: \(acceptableSolutions)")

    }
    
    private func userChoseTrue(statement:Statement) {
        
        timeKeeper!.stop()
        let scoreForTarget = self.score(for:statement)
        self.score += scoreForTarget
        scoreAddPresenter?.showScoreAdd(scoreForTarget)
        
        let timeScoreAdd = timeKeeper!.timeRemaining
        self.score += Int(timeScoreAdd)
        scoreTimeAddPresenter?.showScoreAdd(Int(timeScoreAdd))
        
        // getting one right without using a hint  gives you a chance to get an extra hint
        // and the chance increases when you use higher-scoring expressions
        if nil == hint && Int.random(in: 0...100) + scoreForTarget > 100 {
            hints += 1
            hintCountPresenter?.hintsIncreased(by: 1)
        }
        
        // let the suer see the correct statement he chose for 1 second, then advance to the next one
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else { return }
            if statement.isTrue {
                
                self.updateSolutionTime()
                self.advanceToNextTargetSolution()
            }
        }
    }
    
    private func updateSolutionTime() {
        
        // reclaim any time that was not spent on this target solution
        self.solutionTime = Round.TimeForEachTargetSolution +  (self.timeKeeper?.timeRemaining ?? TimeInterval(0))
        
        //but reduce the time slightly with each successive target slution
        self.solutionTime *= 0.95
    }
    
    private func userChoseFalse(statement:Statement) {
        canEarnASkipThisGrid = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else { return }
            self.presentCurrentTargetSolution()
        }
    }
    
    func advanceToNextTargetSolution() {
        self.foundSolutions.insert(self.currentTargetSolution!)
        self.showNextTargetSolution()
    }

    func pause() {
        print("\(#function)")
        timeKeeper?.pause()
    }
    
    func resume() {
        print("\(#function)")
        timeKeeper?.resume()
    }

    
    static let DidQuit = Notification.Name("Round.DidQuit")

    func quit() {
        print("\(#function)")
        
        NotificationCenter.default.post(name: Round.DidQuit, object: self)
    }
}

// MARK:- Hints

extension Round {
    /// Tells the WordSearchView to show a selection over the first view of ONE OF the possible ways to get the solution, chosen randomly
    func showAHint() {
        guard hints > 0 else { return }
        guard let thisWay = hintedCoordinate() else { return }
        
        wordSearchView?.select(thisWay.0, thisWay.1, animated:true)
        hints -= 1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.wordSearchView?.removeSelection(animated: true)
        }
    }
    
    private func hintedCoordinate() -> (Int, Int)? {
        if let hint = hint { return hint}
        guard let currentTargetSolution = currentTargetSolution,
            let ways = grid?.waysToGet(solution: currentTargetSolution),
            let thisWay = ways.randomElement()  else { return nil }

        hint = thisWay.0
        canEarnASkipThisGrid = false
        return hint
    }
    
    func showASolution() {
        guard skips > 0,
            let currentTargetSolution = currentTargetSolution,
            let ways = grid?.waysToGet(solution: currentTargetSolution),
            let hint = hintedCoordinate(),
            let thisWay = ways.first(where:{
                $0.0 == hint
        }) else { return }

        timeKeeper?.stop()
        wordSearchView?.isUserInteractionEnabled = false
        wordSearchView?.select(from: thisWay.0.0, thisWay.0.1, to: thisWay.1.0, thisWay.1.1)
        
        skips -= 1
        canEarnASkipThisGrid = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.wordSearchView?.removeSelection(animated: true) {
                self?.advanceToNextTargetSolution()
                self?.wordSearchView?.isUserInteractionEnabled = true
            }
        }
    }
}


// TODO: I'm being prompted for 2 character expressions (e.g. -5)
// this should not happen!!!!!!

// MARK:- WordSearchView Methods

extension Round {
    
    func canStartSelection(with string:String?) -> Bool {
        guard !(string?.isEmpty ?? false) else { return false }
        if string == "-" { return true }
        if nil != Int(string!) {
            return !"+-×÷".contains(string!.last!)
        }
        return false
    }
    
    func didSelect(_ string: String) {
        guard string.count > 2 else { return }
        
        // a little hysterysis: if the user stopped selecting on an operator,
        // then just drop it and assume he meant to select
        // the string up to but not including the operator
        let solutionString = "+-×÷".contains(string.last!) ? String(string.dropLast()) : string
        
        let statement = Statement(solutionString, currentTargetSolution)
        
        // whether it's true or false, display the selected statement
        statementPresenter?.statement = statement
        
        if statement.isTrue {
            userChoseTrue(statement: statement)
        }
        else {
            userChoseFalse(statement: statement)
        }

    }

}

// MARK:- Score

extension Round {
    
    func score(for statement:Statement) -> Int {
        guard let expression = statement.expression,
        let targetSolution = statement.targetSolution else { return 0 }

        // TODO: write tests for this
        
        // length of the expression to the power of 2
        var out = (1...expression.count).reduce(1) { a,_ in a*2 }
        
        // times a scalar for each operation
        for char in expression {
            switch char {
            case "-":
                out *= 2
            case "×":
                out *= 4
            case "÷":
                out *= 8
            default:
                out *= 1
            }
        }
        
        // times 2 if result was negative
        if targetSolution < 0 {
            out *= 2
        }
        
        return out
    }
}

