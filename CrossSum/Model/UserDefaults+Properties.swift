//
//  NSUserDefaults+Properties.swift
//  CrossSum
//
//  Created by Joseph Wardell on 10/7/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    private static let HighScoresKey = "highscores"

    func addHighScore(_ newscore:HighScore) {
        
        highScores.append(newscore)
    }
    
    ver lastHighscore : HighScore {
    
    }
    
    private(set) var highScores : [HighScore] {
        get {
            guard let d = data(forKey: UserDefaults.HighScoresKey),
                let decoded = try? JSONDecoder().decode([HighScore].self, from: d) else { return [] }
            return decoded
                .sorted() { lhs, rhs in
                    // sorted by highest score, highest stage, earliest date
                    if lhs.score > rhs.score { return true }
                    else if lhs.score == rhs.score && lhs.stage > rhs.stage { return true }
                    else if lhs.score == rhs.score && lhs.stage == rhs.stage && lhs.date > rhs.date { return true }
                    return false
                }
                .filter {
                    $0.score > 0
            }
        }
        set {
            let encoded = try! JSONEncoder().encode(newValue)
            set(encoded, forKey: UserDefaults.HighScoresKey)
        }
    }
}
