//
//  SquareTilesProgressView+DiscreteProgressPresenter.swift
//  CrossSum
//
//  Created by Joseph Wardell on 10/16/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import Foundation

extension SquareTilesProgressView : DiscreteProgressPresenter {
    
    func present(progress: Int, of maxProgress: Int) {
        
        if maxProgress != maxItems {
            // only set this if necessary
            maxItems = maxProgress
        }
        
        completedItems = progress
    }
}

