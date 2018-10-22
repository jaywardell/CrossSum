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
        highScoresDS?.configure = { [weak self] row, cell, score in
            cell.textLabel?.text = "\(row + 1): \(score.score)"
            cell.detailTextLabel?.text = "Stage \(score.stage)"

            cell.textLabel?.textColor = self?.lastHighScore == score ? self?.view.tintColor : .white
            cell.detailTextLabel?.textColor = self?.lastHighScore == score ? self?.view.tintColor : .white
        }
        highScoresDS?.style = { cell in
            cell.backgroundColor = nil
            cell.textLabel?.font = UIFontMetrics.default.scaledFont(for: UIFont(name: UIFont.BPMono, size: 21)!)
            cell.detailTextLabel?.font = UIFontMetrics.default.scaledFont(for: UIFont(name: UIFont.BPMono, size: 21)!)
        }
        
        welcomeScreen.highScoresView.dataSource = highScoresDS
        welcomeScreen.highScoresView.allowsSelection = false
        
        let background = Background()
        self.view.addSubview(background)
        
        background.constrainToFillSuperview()
        
        welcomeScreen.highScoresView.reloadData()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        welcomeScreen.playButton.fadeIn(duration: 0.2)
        welcomeScreen.highScoresLabel.isHidden = highScores.isEmpty
        
        scrollLastScoreIntoView()
    }
    
    private func scrollLastScoreIntoView() {
        guard !highScores.isEmpty else { return }
        
        let rollToScroll : Int
        if let highscore = lastHighScore,
            let index = highScores.firstIndex(of: highscore) {
            rollToScroll = index
        }
        else {
            rollToScroll = 0
        }
        welcomeScreen.highScoresView.scrollToRow(at: IndexPath(item: rollToScroll, section: 0), at: .top, animated: false)
    }
    
    @IBAction private func playButtonPressed() {
        
        welcomeScreen.playButton.fadeOut(duration: 0.2) {
            self.didHitPlayButton()
        }
    }
}
