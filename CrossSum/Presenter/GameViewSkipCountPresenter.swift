//
//  GameViewSkipCountPresenter.swift
//  CrossSum
//
//  Created by Joseph Wardell on 10/13/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import Foundation

final class GameViewSkipCountPresenter {
    
    weak var game : GameViewController?
    
    private var skipCountPresenter : HidingPresenter & IntegerPresenter { return game!.skipCountTally }
    private var skipButton : HidingPresenter { return game!.skipButton! }
    
    private var round : Round? { return game?.round }

    private var skips = 0
    
    init(_ game:GameViewController) {
        self.game = game
    }
    
    func hide() {
        
        skipCountPresenter.setIsPresenting(false)
        skipButton.setIsPresenting(false)
    }
    
    func update() {
        
        let showingGrid = round?.showingGrid ?? false
        let hide = !showingGrid || (skips == 0)

        skipCountPresenter.setIsPresenting(!hide)
        skipButton.setIsPresenting(!hide)
    }
}

extension GameViewSkipCountPresenter : IntegerPresenter {
    
    func present(integer: Int) {
        skipCountPresenter.present(integer:integer)
        update()
        self.skips = integer
    }
}
