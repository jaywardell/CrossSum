//
//  Round.swift
//  CrossSum
//
//  Created by Joseph Wardell on 9/30/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import Foundation

protocol RoundDisplayDelegate : NSObjectProtocol {
    func willReplaceGrid(_ round:Round)
    func didReplaceGrid(_ round:Round)
}

// MARK:-

final class Round {
    
    var grid : Grid?
    var solutions : GridSolutions?
    
    var gridFactory : GridFactory

    var highScore : HighScore {
        return HighScore(score:score, stage:stage)
    }
    
    var score : Int = 0 {
        didSet {
            scorePresenter?.present(integer:score)
        }
    }
    
    var stage : Int = 0 {
        didSet {
            stagePresenter?.present(integer:stage)
            print("stage: \(stage)")
        }
    }
    
    private static let TimeForEachTargetSolution : TimeInterval = 20
    private var solutionTime : TimeInterval = 0
    private var timeKeeper : TimeKeeper?
    private(set) var showingGrid = false
    private(set) var showingSkip = false
    
    var hints : Int = 0 {
        didSet {
            hintCountPresenter?.present(integer: hints)
        }
    }
    private var hint : Grid.Coordinate?

    var skips : Int = 0 {
        didSet {
            skipsCountPresenter?.present(integer: skips)
        }
    }
    private var canEarnASkipThisGrid = true
    
    var displayDelegate : RoundDisplayDelegate?
    
    var foundSolutions = Set<Rational>()
    var currentTargetSolution : Rational?
    var acceptableSolutions : Set<Rational> {
        guard let solutions = solutions else { return Set() }
        return solutions.solutions
        // Round should no longer have to worry about this since it's filtering the acceptable solutions in the delegate method
        // don't offer solutions that can only be gotten from one or two squares (e.g. - and 5 becomes -5)
//        return solutions.filter() { solution in
//            guard let locations = grid?.solutionsToExpressionLocations.value[solution] else { return false }
//            for choice in locations {
//                if abs(choice.0.0 - choice.1.0) >= 2 ||
//                    abs(choice.0.1 - choice.1.1) >= 2 {
//                    return true
//                }
//            }
//            return false
//        }
    }
    var availableSolutions : Set<Rational> {
        return acceptableSolutions.subtracting(foundSolutions)
    }

    var isPaused : Bool { return timeKeeper?.isPaused ?? false }
    
    // MARK:-
    
    // NOTE: as of Oct 10, 2018, expressionSymbolPresenter and expressionSelector are the same thing in the iOS app
    // but they don't tchnically have to be for Round to work
    var expressionSymbolPresenter : ExpressionSymbolPresenter?

    var expressionSelector : ExpressionSelector? {
        didSet {
            expressionSelector?.allowsDiagonalSelection = false
            expressionSelector?.didSelect = didSelect(_:)
            expressionSelector?.canStartSelectionWith = canStartSelection
        }
    }
    
    var statementPresenter : OptionalStatementPresenter?
    var scorePresenter : IntegerPresenter?
    var stagePresenter : IntegerPresenter?
    var timeRemainingPresenter : TimeRemainingPresenter?
    var scoreAddPresenter : ScoreAddPresenter?
    var scoreTimeAddPresenter : ScoreAddPresenter?
    var hintCountPresenter : IntegerPresenter?
    var skipsCountPresenter : IntegerPresenter?
    var gridProgressPresenter : DiscreteProgressPresenter?
    
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
        scorePresenter?.present(integer:0)
   }
    
    private func showNextTargetSolution() {
        guard let next = availableSolutions.randomElement() else {
            showNextGrid()
            return
        }
        
        hint = nil
        currentTargetSolution = next
        presentCurrentTargetSolution()
        
        timeKeeper = TimeKeeper(solutionTime, presenter: timeRemainingPresenter) { [weak self] _ in
            print("Timer Finished")
            self?.quit()
        }
        timeKeeper?.start()
        
        hintCountPresenter?.present(integer: hints)
        skipsCountPresenter?.present(integer:skips)
    }
    
    private func presentCurrentTargetSolution() {
        statementPresenter?.present(statement: Statement(nil, currentTargetSolution))
    }
    
    private func showNextGrid() {
        foundSolutions.removeAll()
        if canEarnASkipThisGrid {
            skips += 1
        }
        canEarnASkipThisGrid = true
        
        showingGrid = false
        displayDelegate?.willReplaceGrid(self)
        
        let solvedGrid = gridFactory.gridAfter(grid, using: shouldAcceptSolution(solution:in:from:to:))
        self.grid = solvedGrid.grid
        self.solutions = solvedGrid.solutions
//        self.grid?.solutionClient = self
        expressionSymbolPresenter?.present(grid!, animated: true) { [weak self] in guard let self = self else { return }
        
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

        gridProgressPresenter?.present(progress: foundSolutions.count, of: acceptableSolutions.count)
    }
    
    private func userChoseTrue(statement:Statement) {
        if let timeKeeper = self.timeKeeper, timeKeeper.isDone { return }
        
        timeKeeper!.stop()
        let scoreForTarget = self.score(for:statement)
        self.score += scoreForTarget
        scoreAddPresenter?.present(addedScore: scoreForTarget)
        
        let timeScoreAdd = timeKeeper!.timeRemaining
        self.score += Int(timeScoreAdd)
        scoreTimeAddPresenter?.present(addedScore: Int(timeScoreAdd))

        // we know that another foundSolution is going to be added, so present it now with a cout of +1
        gridProgressPresenter?.present(progress: foundSolutions.count + 1, of: acceptableSolutions.count)

        // getting one right without using a hint  gives you a chance to get an extra hint
        // and the chance increases when you use higher-scoring expressions
        if nil == hint && Int.random(in: 0...100) + scoreForTarget > 100 {
            hints += 1
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

    func pause(_ callback:()->()) {
        print("\(#function)")
        timeKeeper?.pause()
        callback()
    }
    
    func resume(_ callback:()->()) {
        print("\(#function)")
        timeKeeper?.resume()
        callback()
    }

    
    static let DidQuit = Notification.Name("Round.DidQuit")
    func quit() {
        print("\(#function)")
        
        timeKeeper?.stop()
        
        NotificationCenter.default.post(name: Round.DidQuit, object: self)
    }
}

// MARK:- Hints

extension Round {
    /// Tells the ExpressionSelector to show a selection over the first symbol of ONE OF the possible ways to get the solution, chosen randomly
    func showAHint() {
        guard hints > 0 else { return }
        guard let thisFirstSelectedCoordinate = hintedCoordinate() else { return }
        
        expressionSelector?.select(thisFirstSelectedCoordinate.x, thisFirstSelectedCoordinate.y, animated:true)
        hints -= 1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.expressionSelector?.removeSelection(animated: true) {}
        }
    }
    
    private func hintedCoordinate() -> Grid.Coordinate? {
        if let hint = hint { return hint}
        guard let currentTargetSolution = currentTargetSolution,
            let ways = solutions?.waysToGet(solution: currentTargetSolution),
            let thisWay = ways.randomElement()  else { return nil }

        hint = thisWay.0
        canEarnASkipThisGrid = false
        print("\(#function) \(thisWay)")
        return hint
    }
    
    func showASolution() {
        guard skips > 0,
            !showingSkip,
            let currentTargetSolution = currentTargetSolution,
            let ways = solutions?.waysToGet(solution: currentTargetSolution),
            let hint = hintedCoordinate(),
            let thisWay = ways.first(where:{
                $0.0 == hint
        }) else { return }

        showingSkip = true
        timeKeeper?.stop()
        expressionSelector?.prepareToSimulateSelection()
        expressionSelector?.select(from: thisWay.0.x, thisWay.0.y, to: thisWay.1.x, thisWay.1.y, animated:true)
        
        skips -= 1
        canEarnASkipThisGrid = false
        
        // we know that another foundSolution is going to be added, so present it now with a cout of +1
        gridProgressPresenter?.present(progress: foundSolutions.count + 1, of: acceptableSolutions.count)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.expressionSelector?.removeSelection(animated: true) {
                self?.advanceToNextTargetSolution()
                self?.expressionSelector?.doneSimulatingSelection()
                
                self?.showingSkip = false
            }
        }
    }
}


// TODO: I'm being prompted for 2 character expressions (e.g. -5)
// this should not happen!!!!!!
// actually, I think I'm just being shown hints for them, not being prompted for them, there are probably longer solutions available in these cases

// MARK:- ExpressionSelector Methods

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
        statementPresenter?.present(statement: statement)
        
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

// MARK:- GridSolutionClient

extension Round /*: GridSolverClient*/ {
    func shouldAcceptSolution(solution: Rational, in grid:Grid, from start: Grid.Coordinate, to end: Grid.Coordinate) -> Bool {
        
        // don't offer solutions that can only be gotten
        // from one or two squares (e.g. - and 5 becomes -5)
       if abs(end.x - start.x) >= 2 || abs(end.y - start.y) >= 2 {
            return true
        }
        return false
    }
}
