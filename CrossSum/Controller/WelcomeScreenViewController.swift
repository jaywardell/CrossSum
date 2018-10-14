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
    
    var highScores : [HighScore] = [] {
        didSet {
            highScoresDS?.objects = highScores
            welcomeScreen.highScoresView.reloadData()
        }
    }
    private var highScoresDS : TableDataSource<HighScore>?
    
    var lastHighScore : HighScore?
    
    private lazy var welcomeScreen : WelcomeScreen = {
        return WelcomeScreen()
    }()
    
    override func loadView() {
        self.view = welcomeScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        welcomeScreen.playButton.addTarget(self, action: #selector(playButtonPressed), for: .touchUpInside)
        
        highScoresDS = TableDataSource(highScores, style: .value1)
        highScoresDS?.configure = { [weak self] cell, score in
            cell.textLabel?.text = "\(score.score)"
            cell.detailTextLabel?.text = "Stage \(score.stage)"

            cell.textLabel?.textColor = self?.lastHighScore == score ? self?.view.tintColor : .white
            cell.detailTextLabel?.textColor = self?.lastHighScore == score ? self?.view.tintColor : .white
        }
        highScoresDS?.style = { cell in
            cell.backgroundColor = nil
        }
        
        welcomeScreen.highScoresView.dataSource = highScoresDS
        welcomeScreen.highScoresView.allowsSelection = false
        
        let background = Background()
        self.view.addSubview(background)
        
        background.constrainToFillSuperview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        welcomeScreen.playButton.fadeIn(duration: 0.2)
        welcomeScreen.highScoresLabel.isHidden = highScores.count == 0
        
        // TODO: scroll the high scores list to the last high score
    }
    
    @IBAction private func playButtonPressed() {
        
        welcomeScreen.playButton.fadeOut(duration: 0.2) {
            self.didHitPlayButton()
        }
    }
}
