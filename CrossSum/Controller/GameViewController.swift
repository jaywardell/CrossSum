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
    
    @IBOutlet weak var wordSearchView: WordSearchView!
    
    
    @IBOutlet weak var statementLabel: StatementLabel!
    
    var round : Round?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        statementLabel.backgroundColor = nil
        wordSearchView.backgroundColor = nil
        statementLabel.highlightColor = .orange
        
        startRound()
        
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
        
        round = Round()
        round?.statementPresenter = statementLabel
        round?.wordSearchView = wordSearchView
        
        let grid = Grid(size:7, range:0..<10, operators:[.plus, .minus, .times]) {
            $0 > 0
        }
        
        round?.begin(with: grid)
    }
}
