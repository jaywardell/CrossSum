//
//  NewGameViewController.swift
//  CrossSum
//
//  Created by Joseph Wardell on 10/20/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    private lazy var gamePlayView : GamePlayView = {
        let out = GamePlayView()
        out.play_pauseButton.addTarget(self, action: #selector(play_pauseInRound), for: .touchUpInside)
        out.quitButton.addTarget(self, action: #selector(quitRound), for: .touchUpInside)
        out.skipButton.addTarget(self, action: #selector(skipInRound), for: .touchUpInside)
        out.hintButton.addTarget(self, action: #selector(hintInRound), for: .touchUpInside)
        return out
    }()
    
    private lazy var scoreAddAnimator = {
        return AnimatingLabel(gamePlayView.statementLabel, endingView: gamePlayView.scoreLabel)
    }()

    private lazy var timeScoreAddAnimator = {
        return AnimatingLabel(gamePlayView.stageProgressView, endingView: gamePlayView.scoreLabel)
    }()

    // MARK:-
    
    var round : Round?

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
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActive(_:)), name: UIApplication.willResignActiveNotification, object: UIApplication.shared)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive(_:)), name: UIApplication.didBecomeActiveNotification, object: UIApplication.shared)
        NotificationCenter.default.addObserver(self, selector: #selector(userTookScreenshot(_:)), name: UIApplication.userDidTakeScreenshotNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(expressionChooserFontDidChange(_:)), name: ExpressionChooserView.ChoiceFontDidChange, object: gamePlayView.expressionChooser)

        round?.begin()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        gamePlayView.statementLabel.layoutIfNeeded()
        
        scoreAddAnimator.textColor = view.tintColor
        timeScoreAddAnimator.textColor = view.tintColor
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK:-
    
    class func createNew() -> GameViewController {
        return GameViewController()
    }

    // MARK:- Notifications
    
    @objc private func applicationWillResignActive(_ notification:Notification) {
        
        pauseGame()
    }
    
    @objc private func applicationDidBecomeActive(_ notification:Notification) {
        
        // yuou would think this would be a good idea,
        // but it could be jarring to the user
        // if it's been a while since he played
        // and he doesn't know the state of the game when he's returning
        // OR if he had paused the game before leaving the app
        // resumeGame()
    }

    @objc private func userTookScreenshot(_ notification:Notification) {
        
        // in iOS 12 and later, taking a screenshot brings up a spearate UI
        // so we want to automatically pause
        if #available(iOS 11.0, *) {
            pauseGame()
        }
    }
    
    @objc private func expressionChooserFontDidChange(_ notification:Notification) {
        guard let expressionchooser = notification.object as? ExpressionChooserView else { return }
        scoreAddAnimator.font = expressionchooser.choiceFont
        timeScoreAddAnimator.font = expressionchooser.choiceFont
        gamePlayView.synchronizeFontSizes()
    }
    
    // MARK:- Actions
    
    @IBAction func play_pauseInRound() {
        
        if round!.isPaused {
            resumeGame()
        }
        else {
            pauseGame()
        }
    }
    
    
    @IBAction func quitRound() {

        // if there's no score, then don't bother to prompt, just quit
        guard let round = round, round.score != 0 else {
            self.round?.quit()
            return
        }
        
        // otherwise, make sure the user wants to quit
        let prompt = SimplePromptAlert("Really Quit?",
                                       "Your current score will go in the high scores.",
                                       okButtonName: "Quit")
        present(prompt: prompt) {
            round.quit()
        }
    }
    
    
    @IBAction func hintInRound() {

        round?.showAHint()
    }
    
    @IBAction func skipInRound() {

        round?.showASolution()
    }


// MARK:- Play/Pause
    
    private func pauseGame() {
        guard let round = self.round,
            !round.isPaused else { return }
        
        round.pause() {// [weak self] in guard let self = self else { return }
            gamePlayView.expressionChooser.fadeOut(duration: 0.2)
        }
    }
    
    private func resumeGame() {
        guard let round = self.round,
            round.isPaused else { return }
        
        gamePlayView.statementLabel.fadeIn(duration:0.2)
        gamePlayView.expressionChooser.fadeIn(duration: 0.2) { [weak self] in
            self?.round?.resume() {}
        }
    }

// MARK:- Round Maintenance

    
    private func connectRoundToUI() {
        guard isViewLoaded else { return }
        
        let statePresenters : [RoundStatePresenter] = [
            
            // the quit button should always be present, unless the round is quitting
            ToggleBasedOnStatePresenter(gamePlayView.quitButton, Round.State.allPlaying + [.advancing, .paused, .starting]),
            
            // but it cannot be enabled between grids, since that may cause conflicts with the time keeper
            ToggleBasedOnStatePresenter(ToggleableKeyedPresenter(gamePlayView.quitButton, key: \UIButton.isEnabled), Round.State.allPlaying + [.paused, .starting]),

            
            // the stage label and score label should be visible as soon as the round is being played, even if paused
            ToggleBasedOnStatePresenter(gamePlayView.stageLabel, Round.State.allPlaying + [.advancing, .paused]),
            ToggleBasedOnStatePresenter(gamePlayView.scoreLabel, Round.State.allPlaying + [.advancing, .paused]),

            // the hint UI should be visible unless the round is paused
            ToggleBasedOnStatePresenter(gamePlayView.hintButton, Round.State.allPlaying + [.advancing]),
            ToggleBasedOnStatePresenter(gamePlayView.hintTally, Round.State.allPlaying + [.advancing]),
            
            // the skip UI should be visible unless the round is paused
            ToggleBasedOnStatePresenter(gamePlayView.skipButton, Round.State.allPlaying + [.advancing]),
            ToggleBasedOnStatePresenter(gamePlayView.skipTally, Round.State.allPlaying + [.advancing]),
 
            // the hint button shouldn't be enabled if there are no hints available
            ToggleBasedOnStatePresenter(ToggleableKeyedPresenter(gamePlayView.hintButton, key: \UIButton.isEnabled), [
                .playing(hasHints: true, hasSkips: true),
                .playing(hasHints: true, hasSkips: false)
            ]),
            
            // the skip button shouldn't be enabled if there are no skips available
            ToggleBasedOnStatePresenter(ToggleableKeyedPresenter(gamePlayView.skipButton, key: \UIButton.isEnabled), [
                .playing(hasHints: true, hasSkips: true),
                .playing(hasHints: false, hasSkips: false)
            ]),
            
            // except the play_pause button should be enabled when the round is paused also
            ToggleBasedOnStatePresenter(ToggleableKeyedPresenter(gamePlayView.play_pauseButton, key: \UIButton.isEnabled), Round.State.allPlaying + [.paused]),

            // the progress views and the statement label should only be visible when the round is being played,
            // not even when the round is advancing to a new grid
            ToggleBasedOnStatePresenter(gamePlayView.statementLabel, Round.State.allPlaying),
            ToggleBasedOnStatePresenter(gamePlayView.stageProgressView, Round.State.allPlaying),
            ToggleBasedOnStatePresenter(gamePlayView.gameProgressView, Round.State.allPlaying),
            
            // the play button should be selected (showing pause) when the game is paused
            ToggleBasedOnStatePresenter(ToggleableKeyedPresenter(gamePlayView.play_pauseButton, key:\UIButton.image, on:#imageLiteral(resourceName: "play-button"), off:#imageLiteral(resourceName: "pause-button")), [.paused])
        ]
        let statePresenter = RoundStatePresenterGroup(statePresenters)
        round?.statePresenter = statePresenter
        
        round?.statementPresenter = gamePlayView.statementLabel
        round?.scorePresenter = ConcreteIntegerPresenter(presenter: gamePlayView.scoreLabel)
        round?.stagePresenter = ConcreteIntegerPresenter(presenter: gamePlayView.stageLabel)
        
        round?.scoreAddPresenter = scoreAddAnimator
        round?.scoreTimeAddPresenter = timeScoreAddAnimator

        round?.expressionSelector = gamePlayView.expressionChooser
        round?.expressionSymbolPresenter = gamePlayView.expressionChooser
        round?.timeRemainingPresenter = gamePlayView.stageProgressView
        round?.hintCountPresenter = gamePlayView.hintTally
        round?.skipsCountPresenter = gamePlayView.skipTally
        round?.gridProgressPresenter = gamePlayView.gameProgressView
    }
}
