//
//  ScoreLabel.swift
//  CrossSum
//
//  Created by Joseph Wardell on 10/7/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import UIKit

class ScoreLabel: UILabel {

    var score : Int = 0 {
        didSet {
            text = "score: \(score)"
        }
    }
    
}

extension ScoreLabel : ScorePresenter {}
