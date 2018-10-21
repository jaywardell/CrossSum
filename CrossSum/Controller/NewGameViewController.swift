//
//  NewGameViewController.swift
//  CrossSum
//
//  Created by Joseph Wardell on 10/20/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import UIKit

class NewGameViewController: UIViewController {

    private lazy var gamePlayView : GamePlayView = {
        let out = GamePlayView()
        out.play_pauseButtonAction = playPauseButtonTapped
        out.quitButtonAction = quitButtonTapped
        out.skipButtonAction = skipButtonTapped
        out.hintButtonAction = showHintButtonTapped
        return out
    }()
    
    // MARK:-
    
    var round : Round? {
        didSet {
            round?.displayDelegate = self
        }
    }

    // MARK:-
    
    override func loadView() {
        super.loadView()
        
        self.view = gamePlayView
        
        connectRoundToUI()

        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        round?.begin()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        print("statementLabel.isHidden: \(gamePlayView.statementLabel.isHidden)")
        gamePlayView.statementLabel.isHidden = false
        print("statementLabel.isHidden: \(gamePlayView.statementLabel.isHidden)")
        gamePlayView.statementLabel.layoutIfNeeded()
        print("statementlabel frame: \(gamePlayView.statementLabel.frame)")
        
        print("expression chooser frame: \(gamePlayView.expressionChooser.frame)")
        
        print("progress view: \(gamePlayView.gameProgressView.frame)")
    }
    
    // MARK:-
    
    class func createNew() -> NewGameViewController {
        return NewGameViewController()
    }

    // MARK:- Actions
    
    func playPauseButtonTapped() {
        guard let round = round else { return }
        
        if round.isPaused {
            resumeGame()
        }
        else {
            pauseGame()
        }
    }
    
    
    func quitButtonTapped() {

        round?.quit()
    }
    
    
    func showHintButtonTapped() {

        round?.showAHint()
    }
    
    func skipButtonTapped() {

        round?.showASolution()
    }

    // MARK:- UI Updating
    private func showGamePlayUI() {
        
        // TODO: bring this back in some capacity
//        hintCountPresenter.update()
//        skipCountPresenter.update()
        [gamePlayView.quitButton,
         gamePlayView.scoreLabel,
         gamePlayView.stageLabel,
         gamePlayView.statementLabel,
         gamePlayView.stageProgressView,
         gamePlayView.gameProgressView
            ].forEach { $0?.isHidden = false }
    }
    
    private func hideGamePlayUI() {

        // TODO: bring this back in some capacity
//        hintCountPresenter.hide()
//        skipCountPresenter.hide()
        [
            gamePlayView.statementLabel,
            gamePlayView.stageProgressView,
            gamePlayView.gameProgressView].forEach { $0?.isHidden = true }
    }

    private func updatePlayPauseButton() {
        guard let round = round else { return }
        
        
        gamePlayView.play_pauseButton.imageView?.contentMode = .scaleAspectFit
        
        let preferredImage = round.isPaused ? #imageLiteral(resourceName: "play-button") : #imageLiteral(resourceName: "pause-button")
        gamePlayView.play_pauseButton.setImage(preferredImage, for: .normal)
    }

//}
//
//// MARK:- Play/Pause
//
//extension GameViewController {
    
    private func pauseGame() {
        guard let round = self.round,
            !round.isPaused else { return }
        
        round.pause() {// [weak self] in guard let self = self else { return }
            hideGamePlayUI()
            gamePlayView.expressionChooser.fadeOut(duration: 0.2)
            updatePlayPauseButton()
        }
    }
    
    private func resumeGame() {
        guard let round = self.round,
            round.isPaused else { return }
        
        gamePlayView.statementLabel.fadeIn(duration:0.2)
        gamePlayView.expressionChooser.fadeIn(duration: 0.2) { [weak self] in
            self?.round?.resume() { [weak self] in guard let self = self else { return }
                self.updatePlayPauseButton()
                self.showGamePlayUI()
            }
        }
    }
//}

// MARK:- Round Maintenance

//extension NewGameViewController {
    
    private func connectRoundToUI() {
        guard isViewLoaded else { return }
        
        round?.statementPresenter = gamePlayView.statementLabel
        round?.scorePresenter = ScorePresenter(gamePlayView.scoreLabel)
        round?.stagePresenter = StagePresenter(gamePlayView.stageLabel)
        
// TODO: bring this back
//        round?.scoreAddPresenter = gamePlayView.scoreAddLabel
// TODO: bring this back
//        round?.scoreTimeAddPresenter = gamePlayView.scoreTimeAddLabel

        round?.expressionSelector = gamePlayView.expressionChooser
        round?.expressionSymbolPresenter = gamePlayView.expressionChooser
        round?.timeRemainingPresenter = gamePlayView.stageProgressView
        round?.hintCountPresenter = gamePlayView.hintTally
        round?.skipsCountPresenter = gamePlayView.skipTally
        round?.gridProgressPresenter = gamePlayView.gameProgressView
    }
}

// MARK:- RoundDisplayDelegate

extension NewGameViewController : RoundDisplayDelegate {
    func willReplaceGrid(_ round: Round) {
        assert(round === self.round!)
        // TODO: this should be done via a presenter object
        hideGamePlayUI()
    }

    func didReplaceGrid(_ round: Round) {
        assert(round === self.round!)
        // TODO: this should be done via a presenter object
        showGamePlayUI()
    }


}
