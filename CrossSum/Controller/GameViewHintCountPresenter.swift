//
//  GameViewHintCountPresenter.swift
//  CrossSum
//
//  Created by Joseph Wardell on 10/13/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import UIKit

final class GameViewHintCountPresenter {
    
    weak var game : GameViewController!
    
    private var hintCountLabel : UIView & IntegerPresenter { return game.hintCountTally }
    private var showHintButton : UIButton { return game.showHintButton! }
    
    private var round : Round? { return game?.round }
    
    private var lastHintCount : Int?
    
    init(_ game:GameViewController) {
        self.game = game
    }

    func hide() {
        
        hintCountLabel.isHidden = true
        showHintButton.isHidden = true
    }
    
    func update() {
        
        let showingGrid = round?.showingGrid ?? false
        let hide = !showingGrid || ((lastHintCount ?? 0) == 0)
        
        hintCountLabel.isHidden = hide
        showHintButton.isHidden = hide
    }

    private func hintsIncreased(by dHints: Int) {
        game?.hintsIncreased(by: dHints)
    }
}

extension GameViewHintCountPresenter : IntegerPresenter {
    
    func present(integer: Int) {
//        hintCountLabel?.text = "\(integer)"
        
        hintCountLabel.present(integer: integer)
        
        if let lastHintCount = lastHintCount {
            let dHints = integer - lastHintCount
            if dHints > 0 {
                hintsIncreased(by: dHints)
            }
        }
        
        lastHintCount = integer
        update()
    }
}
