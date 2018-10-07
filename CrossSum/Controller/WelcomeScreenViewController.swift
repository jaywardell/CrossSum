//
//  WelcomeScreenViewController.swift
//  CrossSum
//
//  Created by Joseph Wardell on 10/2/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import UIKit

class WelcomeScreenViewController: UIViewController {

    var didHitPlayButton : ()->() = {}
    
    var highScores : [(score:Int, stage:Int)] = []
    private var highScoresDS : TableDataSource<(score:Int, stage:Int)>?
    
    private lazy var welcomeScreen : WelcomeScreen = {
        return WelcomeScreen()
    }()
    
    override func loadView() {
        self.view = welcomeScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        welcomeScreen.playButton.addTarget(self, action: #selector(playButtonPressed), for: .touchUpInside)
        
        highScoresDS = TableDataSource(highScores, title:"High Scores" , style: .value1)
        highScoresDS?.configure = { cell, score in
            cell.textLabel?.text = "\(score.score)"
            cell.detailTextLabel?.text = "stage \(score.stage)"
        }
        highScoresDS?.style = { cell in
            cell.backgroundColor = nil
            cell.textLabel?.textColor = .white
            cell.detailTextLabel?.textColor = .white
        }
        
        welcomeScreen.highScoresView.dataSource = highScoresDS
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        welcomeScreen.playButton.fadeIn(duration: animated ? 0.2 : 0)
    }
    
    @IBAction private func playButtonPressed() {
        
        welcomeScreen.playButton.fadeOut(duration: 0.2) {
            self.didHitPlayButton()
        }
    }
}
