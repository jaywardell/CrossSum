//
//  HighScores.swift
//  CrossSum
//
//  Created by Joseph Wardell on 10/7/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import Foundation

typealias RoundScore = (score:Int, stage:Int)

class HighScores : NSObject {
    
    let highscores : [RoundScore]
    
    init(_ highscores:[RoundScore]) {
        self.highscores = highscores
    }
}

import UIKit

// TODO: get rid of this here, probably move to a generic data source
extension HighScores : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return highscores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .value1, reuseIdentifier: "cell")
        cell.textLabel?.text = "\(highscores[indexPath.row].score)"
        cell.detailTextLabel?.text = "stage \(highscores[indexPath.row].stage)"
        
        cell.textLabel?.textColor = tableView.tintColor
        cell.detailTextLabel?.textColor = tableView.tintColor
        
        return cell
    }
    
    
}
