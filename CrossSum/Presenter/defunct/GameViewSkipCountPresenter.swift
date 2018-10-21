//
//  GameViewSkipCountPresenter.swift
//  CrossSum
//
//  Created by Joseph Wardell on 10/13/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import Foundation

final class GameViewSkipCountPresenter {
    
    private var skipCountPresenter : ToggleablePresenter & IntegerPresenter
    private var toggleable : ToggleablePresenterGroup
    
    private weak var round : Round?

    private var skips = 0
    
    init(_ game:GameViewController) {
        
        self.skipCountPresenter = game.skipCountTally
        self.round = game.round
        self.toggleable = ToggleablePresenterGroup([game.skipButton!, game.skipCountTally])
    }
    
    func hide() {

        toggleable.setIsPresenting(false)
    }
    
    func update() {
        
        let showingGrid = round?.showingGrid ?? false
        let hide = !showingGrid || (skips == 0)

        toggleable.setIsPresenting(!hide)
    }
}

extension GameViewSkipCountPresenter : IntegerPresenter {
    
    func present(integer: Int) {
        skipCountPresenter.present(integer:integer)
        update()
        self.skips = integer
    }
}
