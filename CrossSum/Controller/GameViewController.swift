//
//  GameViewController.swift
//  CrossSum
//
//  Created by Joseph Wardell on 9/30/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var newGameButton: UIButton! {
        didSet {
            newGameButton.addTarget(self, action: #selector(newGameButtonPressed), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var showHintButton: UIButton! {
        didSet {
            showHintButton.addTarget(self, action: #selector(showHintButtonPressed), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    // TODO: Skip Button - displays a way to solve the current target, then advances to the next target
    
    @IBOutlet weak var wordSearchView: WordSearchView!
    
    
    @IBOutlet weak var statementLabel: StatementLabel!
    
    var round : Round?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        statementLabel.backgroundColor = nil
        wordSearchView.backgroundColor = nil
//        statementLabel.highlightColor = .orange
        wordSearchView.selectionColor = statementLabel.highlightColor!
        statementLabel.highlightColor = wordSearchView.selectionColor
        
        startRound()
        
        scoreLabel.font = wordSearchView.choiceFont
        
        wordSearchView.centerXAnchor.constraint(equalTo: statementLabel.centerXAnchor)
        wordSearchView.topAnchor.constraint(equalTo: statementLabel.topAnchor)
        view.layoutIfNeeded()
        statementLabel.font = wordSearchView.choiceFont
        
    }
    
    @IBAction func newGameButtonPressed() {
        print(#function)
        
        startRound()
    }

    @IBAction func showHintButtonPressed() {
        print(#function)
        
        round?.showAHint()
        // TODO: implement this: highlight the first label needed to get this value
    }

}

// MARK:-

extension GameViewController {
    
    
    func isValidSelection(_:Int, _:Int, string:String?) -> Bool {
        guard !(string?.isEmpty ?? false) else { return false }
        if string == "-" { return true }
        if nil != Int(string!) {
            return !"+-×÷".contains(string!.last!)
        }
        return false
    }
    
    func didSelect(_ string: String) {
        
        let r = RationalParser.grammar.parse(string[...])
        let statement = Statement(string, r?.0)
        statementLabel.statement = statement
        
    }
}

extension GameViewController {
    
    func startRound() {
        
        round = Round(gridFactory: GameReadyGridFactory())
        round?.statementPresenter = statementLabel
        round?.scorePresenter = scoreLabel
        round?.wordSearchView = wordSearchView
                
        round?.begin()
    }
}


extension UILabel : ScorePresenter {
    var score: Int {
        get {
            return Int(text ?? "") ?? 0
        }
        set {
            text = "\(newValue)"
        }
    }
    
    
}
