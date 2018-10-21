//
//  GameViewHintCountPresenter.swift
//  CrossSum
//
//  Created by Joseph Wardell on 10/13/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import Foundation

final class GameViewHintCountPresenter {
    
    weak var game : GameViewController!
    
    private var hintCountPresenter : ToggleablePresenter & IntegerPresenter
    private let toggleable : ToggleablePresenterGroup

    private weak var round : Round?
    
    private var lastHintCount : Int?
    
    init(_ game:GameViewController) {
        self.game = game
        
        self.round = game.round
        
        self.hintCountPresenter = game.hintCountTally
        
        self.toggleable = ToggleablePresenterGroup([game.hintCountTally, game.showHintButton!])
    }

    func hide() {

        toggleable.setIsPresenting(false)
    }
    
    func update() {
        
        let showingGrid = round?.showingGrid ?? false
        let hide = !showingGrid || ((lastHintCount ?? 0) == 0)

        toggleable.setIsPresenting(!hide)
    }

    private func hintsIncreased(by dHints: Int) {
        game?.hintsIncreased(by: dHints)
    }
}

extension GameViewHintCountPresenter : IntegerPresenter {
    
    func present(integer: Int) {
        
        hintCountPresenter.present(integer: integer)
        
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
