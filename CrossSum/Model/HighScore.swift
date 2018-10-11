//
//  HighScore.swift
//  CrossSum
//
//  Created by Joseph Wardell on 10/7/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import Foundation

struct HighScore : Codable, Equatable {
    let score:Int
    let stage:Int
    let date : Date
    
    init(score:Int, stage:Int) {
        self.score = score
        self.stage = stage
        self.date = Date()
    }
}
