//
//  GameViewSkipCountPresenter.swift
//  CrossSum
//
//  Created by Joseph Wardell on 10/13/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import UIKit

final class GameViewSkipCountPresenter {
    
    weak var game : GameViewController?
    
    private var skipCountLabel : UILabel? { return game?.skipCountLabel }
    private var skipButton : UIButton? { return game?.skipButton }
    
    private var round : Round? { return game?.round }

    private var skips = 0
    
    init(_ game:GameViewController) {
        self.game = game
    }
    
    func hide() {
        
        skipCountLabel?.isHidden = true
        skipButton?.isHidden = true
    }
    
    func update() {
        
        let showingGrid = round?.showingGrid ?? false
        let hide = !showingGrid || (skips == 0)

        skipCountLabel?.isHidden = hide
        skipButton?.isHidden = hide
    }
}

extension GameViewSkipCountPresenter : IntegerPresenter {
    
    func present(integer: Int) {
        skipCountLabel?.text = "\(integer)"
        update()
        self.skips = integer
    }
}
