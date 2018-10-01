//
//  GameViewController.swift
//  CrossSum
//
//  Created by Joseph Wardell on 9/30/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var wordSearchView: WordSearchView! {
        didSet {
            wordSearchView.allowsDiagonalSelection = false
            wordSearchView.didSelect = didSelect(_:)
            wordSearchView.isValidSelection = isValidSelection
        }
    }
    
//    var statementLabel : StatementLabel = StatementLabel()
    
    @IBOutlet weak var statementLabel: StatementLabel!
    
    var grid : Grid?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        statementLabel.backgroundColor = nil
        wordSearchView.backgroundColor = nil
                
        let s = generateGrid(size: 7)
        grid = Grid()
        grid?.symbols = s
        wordSearchView.dataSource = grid
        wordSearchView.reloadSymbols()

        wordSearchView.centerXAnchor.constraint(equalTo: statementLabel.centerXAnchor)
        wordSearchView.topAnchor.constraint(equalTo: statementLabel.topAnchor)
        view.layoutIfNeeded()
        statementLabel.font = wordSearchView.choiceFont
    }
    
    func generateGrid(size:Int) -> [[String]] {
        
        let operators = "+-×÷"
        
        var out = [[String]]()
        var i = 0
        (0..<size).forEach { _ in
            var row = [String]()
            (0..<size).forEach { _ in
                
                row.append(
                    i%2 == 0 ?
                        "\(Int.random(in: 0..<20))" :
                    "\(operators.randomElement()!)"
                )
                
                i += 1
            }
            out.append(row)
        }
        return out
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
//        guard let r = RationalParser.grammar.parse(string[...]),
//            let result = r.0 else {
//                print("\(#function) \(string) = nil")
//                return
//        }
//        print("\(#function) \(string) = \(result)")
        
        // NOTE: right now the StatementLabel is not resizing as it should, but the various parts are being updated appropriately
        
        let r = RationalParser.grammar.parse(string[...])
        let statement = Statement(string, r?.0)
        statementLabel.statement = statement
        
    }
}
