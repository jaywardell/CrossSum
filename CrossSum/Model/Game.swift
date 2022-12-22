//
//  Round.swift
//  CrossSum
//
//  Created by Joseph Wardell on 9/30/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import Foundation

final class Game {
    
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
        }
    }
    
    enum State: Equatable {
        case starting   // the game is starting up, its begin() method has not been called yet
        case advancing  // the game is calculating its next grid
        case playing(hasHints: Bool, hasSkips: Bool)    // the game is presenting a grid that the user is playing
        case paused     // the game is paused
        case quitting   // the game is finishing because the user has failed or has hit the quit button

        static var allPlaying: [Self] {
            [
                .playing(hasHints: true, hasSkips: true),
                .playing(hasHints: true, hasSkips: false),
                .playing(hasHints: false, hasSkips: true),
                .playing(hasHints: false, hasSkips: false),
            ]
        }
        
        var isPlaying: Bool { Self.allPlaying.contains(self) }
    }
    var state : State {
        didSet {
            statePresenter?.present(gameState: state)
        }
    }
    
    private static let TimeForEachTargetSolution : TimeInterval = 60
    private var solutionTime : TimeInterval = 0
    private var timeKeeper : TimeKeeper?
    private(set) var showingGrid = false
    private(set) var showingSkip = false
    
    var hints : Int = 0 {
        didSet {
            hintCountPresenter?.present(integer: hints)
            if state.isPlaying {
                state = .playing(hasHints: hints > 0, hasSkips: skips > 0)
            }
        }
    }
    private var hint : Grid.Coordinate?

    var skips : Int = 0 {
        didSet {
            skipsCountPresenter?.present(integer: skips)
            if state.isPlaying {
                state = .playing(hasHints: hints > 0, hasSkips: skips > 0)
            }
        }
    }
    private var canEarnASkipThisGrid = true
    
    var foundSolutions = Set<Rational>()
    var currentTargetSolution : Rational?
    var acceptableSolutions : Set<Rational> {
        guard let solutions = solutions else { return Set() }
        return solutions.solutions
    }
    var availableSolutions : Set<Rational> {
        return acceptableSolutions.subtracting(foundSolutions)
    }

    var isPaused : Bool { return  state == .paused }
    
    // MARK:-
    
    // NOTE: as of Oct 10, 2018, expressionSymbolPresenter and expressionSelector are the same thing in the iOS app
    // but they don't tchnically have to be for Game to work
    var expressionSymbolPresenter : ExpressionSymbolPresenter?

    var expressionSelector : ExpressionSelector? {
        didSet {
            expressionSelector?.allowsDiagonalSelection = false
            expressionSelector?.didSelect = didSelect(_:)
            expressionSelector?.canStartSelectionWith = canStartSelection
        }
    }
    
    var statePresenter : GameStatePresenter?
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
        self.state = .starting
    }
}

// MARK:- Game Play

extension Game {
    
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
        
        self.state = .playing(hasHints: hints > 0, hasSkips: skips > 0)
        
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
        self.state = .advancing
        
        foundSolutions.removeAll()
        if canEarnASkipThisGrid {
            skips += 1
        }
        canEarnASkipThisGrid = true
        
        showingGrid = false
        
        let solvedGrid = gridFactory.gridAfter(grid, using: shouldAcceptSolution(solution:in:from:to:))
        self.grid = solvedGrid.grid
        self.solutions = solvedGrid.solutions
        expressionSymbolPresenter?.present(grid!, animated: true) { [weak self] in guard let self = self else { return }
        
            self.showNextTargetSolution()
            
            self.showingGrid = true
        }
        
        // give the user all the time he had accumulated by ansering quickly in previous rounds
        // but also give him an extra standard time allotment
        solutionTime = Game.TimeForEachTargetSolution +
            ((solutionTime > TimeInterval(0)) ? (solutionTime - Game.TimeForEachTargetSolution) : 0)
        
        stage += 1
        
        gridProgressPresenter?.present(progress: foundSolutions.count, of: acceptableSolutions.count)
    }
    
    private func userChoseTrue(statement:Statement) {
        if let timeKeeper = self.timeKeeper, timeKeeper.isDone { return }
        
        let timeScoreAdd = timeKeeper!.timeRemaining

        timeKeeper!.stop()
        let scoreForTarget = self.score(for:statement)
        self.score += scoreForTarget
        scoreAddPresenter?.present(addedScore: scoreForTarget)
        
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
        self.solutionTime = Game.TimeForEachTargetSolution +  (self.timeKeeper?.timeRemaining ?? TimeInterval(0))
        
        //but reduce the time slightly with each successive target slution
        self.solutionTime *= 0.99
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
        self.state = .paused
        callback()
    }
    
    func resume(_ callback:()->()) {
        print("\(#function)")
        timeKeeper?.resume()
        self.state = .playing(hasHints: hints > 0, hasSkips: skips > 0)
        callback()
    }

    
    static let DidQuit = Notification.Name("Round.DidQuit")
    func quit() {
        self.state = .quitting
        
        timeKeeper?.stop()
        
        showSolutionOnQuit {
            NotificationCenter.default.post(name: Game.DidQuit, object: self)
        }
    }
}

// MARK:- Hints

extension Game {
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
    
    private func findAnyCurrentSolution() -> (Grid.Coordinate, Grid.Coordinate)? {
        guard let currentTargetSolution = currentTargetSolution,
        let ways = solutions?.waysToGet(solution: currentTargetSolution),
        let hint = hintedCoordinate()
        else { return nil }
        
        return ways.first {
            $0.0 == hint
        }
    }
    
    func showASolution() {
        guard skips > 0,
            !showingSkip,
                let thisWay = findAnyCurrentSolution()
        else { return }
                
        showingSkip = true
        if timeKeeper?.isDone == false {
            timeKeeper?.stop()
        }
        expressionSelector?.prepareToSimulateSelection()
        expressionSelector?.select(from: thisWay.0.x, thisWay.0.y, to: thisWay.1.x, thisWay.1.y, animated:true)
        
        skips -= 1
        canEarnASkipThisGrid = false
        
        // we know that another foundSolution is going to be added, so present it now with a count of +1
        gridProgressPresenter?.present(progress: foundSolutions.count + 1, of: acceptableSolutions.count)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.expressionSelector?.removeSelection(animated: true) {
                self?.advanceToNextTargetSolution()
                self?.expressionSelector?.doneSimulatingSelection()
                
                self?.showingSkip = false
            }
        }
    }
    
    func showSolutionOnQuit(_ completion: @escaping ()->()) {
        guard let thisWay = findAnyCurrentSolution()
        else {
            completion()
            return
        }
        showingSkip = true

        expressionSelector?.prepareToSimulateSelection()
        expressionSelector?.select(from: thisWay.0.x, thisWay.0.y, to: thisWay.1.x, thisWay.1.y, animated:true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.expressionSelector?.removeSelection(animated: true) {
                DispatchQueue.main.async {
                    self?.expressionSelector?.doneSimulatingSelection()
                    
                    self?.showingSkip = false
                    
                    completion()
                }
            }
        }
    }
}


// TODO: I'm being prompted for 2 character expressions (e.g. -5)
// this should not happen!!!!!!
// actually, I think I'm just being shown hints for them, not being prompted for them, there are probably longer solutions available in these cases
// as of Oct 21, 2018, I believe that this has been fixed

// MARK:- ExpressionSelector Methods

extension Game {
    
    func canStartSelection(with string:String?) -> Bool {
        guard !(string?.isEmpty ?? false) else { return false }
        if string == "-" { return true }
        if nil != Int(string!) {
            return !"+-×÷".contains(string!.last!)
        }
        return false
    }
    
    func didSelect(_ string: String) {
        
        // if the user only selected one or two squares (e.g. "-2" for -2)
        // then consider it illegal
        guard string.count > 2 else { return }

        // if the user selected a single number surrounded by operators (e.g. "-3+" for 3)
        // then consider it illegal
        if string.count == 3 && "+-×÷".contains(string.first!) && "+-×÷".contains(string.last!) {
            return
        }
        
        // a little hysterysis: if the user stopped selecting on an operator,
        // then just drop it and assume he meant to select
        // the string up to but not including the operator
        let solutionString = "+-×÷".contains(string.last!) ? String(string.dropLast()) : string
        
        // calculate the value of the statement passed in
        let statement = Statement(solutionString, currentTargetSolution)
        
        // whether it's true or false, display the selected statement
        statementPresenter?.present(statement: statement)
        
        // and use the truth of the statement to determine whatto do next
        if statement.isTrue {
            userChoseTrue(statement: statement)
        }
        else {
            userChoseFalse(statement: statement)
        }

    }

}

// MARK:- Score

extension Game {
    
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

extension Game /*: GridSolverClient*/ {
    func shouldAcceptSolution(solution: Rational, in grid:Grid, from start: Grid.Coordinate, to end: Grid.Coordinate) -> Bool {
        
        // don't offer solutions that can only be gotten
        // from one or two squares (e.g. - and 5 becomes -5)
       if abs(end.x - start.x) >= 2 || abs(end.y - start.y) >= 2 {
            return true
        }
        return false
    }
}
