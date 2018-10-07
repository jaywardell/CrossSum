//
//  ScoreAddLabel.swift
//  CrossSum
//
//  Created by Joseph Wardell on 10/6/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import UIKit

// a view that displays the number of points added to the score
// when the user increases his score
class ScoreAddLabel: CenteredLabel {

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        isHidden = true
        backgroundColor = .clear
    }
    
    func showScoreAdd(_ scoreAdd:Int) {
        let prefix = scoreAdd > 0 ? "+" : ""
        text = "\(prefix)\(scoreAdd)"
        
        isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.isHidden = true
            self?.text = nil
        }
    }
}

extension ScoreAddLabel : ScoreAddPresenter {}

