//
//  GameViewController.swift
//  CrossSum
//
//  Created by Joseph Wardell on 9/30/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var expressionChooserView: ExpressionChoserView!
    @IBOutlet weak var statementLabel: StatementLabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var stageLabel: UILabel!
    @IBOutlet weak var scoreAddLabel: EventDisplayLabel!
    @IBOutlet weak var timeRemainingView: TimeRemainingView!
    @IBOutlet weak var hintCountLabel: UILabel!
    @IBOutlet weak var skipCountLabel: UILabel!
    @IBOutlet weak var hintCountAddLabel: EventDisplayLabel! {
        didSet {
            // note: in the storyboard, there's a width equal constraint
            // between this label and hintCOuntLabel
            // which is there just to keep IB from complaining
            // we ahve it set to be removed at load in IB
            hintCountAddLabel.suffix = " hint"
            hintCountAddLabel.pluralSuffix = "hints"
        }
    }
    @IBOutlet weak var scoreTimeAddLabel: EventDisplayLabel! {
        didSet {
            scoreTimeAddLabel.suffix = "second"
            scoreTimeAddLabel.pluralSuffix = "seconds"
        }
    }

    @IBOutlet weak var playPauseButton: UIButton! {
        didSet {
            playPauseButton.addTarget(self, action: #selector(playPauseButtonTapped), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var showHintButton: UIButton? {
        didSet {
            showHintButton?.addTarget(self, action: #selector(showHintButtonPressed), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var skipButton: UIButton? {
        didSet {
            skipButton?.addTarget(self, action: #selector(skipButtonPressed), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var quitButton: UIButton? {
        didSet {
            quitButton?.addTarget(self, action: #selector(quitButtonPressed), for: .touchUpInside)
        }
    }

    // MARK:-

    var round : Round? {
        didSet {
            connectRoundToUI()
            round?.displayDelegate = self
        }
    }
    
    // MARK:-
    private let displayFont = UIFont(name: "CourierNewPS-BoldMT", size: 24)!
    
    // MARK:-
    
    class func createNew() -> GameViewController {
        return UIStoryboard.Main.instantiate()
    }
    
    // MARK:-
    
    override func viewDidLoad() {
        super.viewDidLoad()

        connectRoundToUI()
        
        view.layoutIfNeeded()
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActive(_:)), name: UIApplication.willResignActiveNotification, object: UIApplication.shared)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive(_:)), name: UIApplication.didBecomeActiveNotification, object: UIApplication.shared)

        NotificationCenter.default.addObserver(self, selector: #selector(axpressionChooserViewChoiceFontDidChange), name: ExpressionChoserView.ChoiceFontDidChange, object: expressionChooserView)
        
        view.backgroundColor = .black
        [
        statementLabel,
        expressionChooserView,
        scoreLabel,
        stageLabel,
        hintCountLabel,
        skipCountLabel
        ].forEach() { $0.backgroundColor = nil }
        
        statementLabel.textColor = .white
        expressionChooserView.textColor = .white
        [scoreLabel,
        stageLabel,
        hintCountLabel,
        skipCountLabel].forEach() { $0.textColor = .white }
        
        [scoreAddLabel,
         hintCountAddLabel,
         scoreTimeAddLabel].forEach() {
            $0?.textColor = UIColor(hue: 60/360, saturation: 1, brightness: 21/34, alpha: 1)
        }

        // TODO: I shouldn't need this, but right now I do, why?
        view.tintColor = UIColor(hue: 164/360, saturation: 1, brightness: 21/34, alpha: 1)
        expressionChooserView.selectionColor = view.tintColor
        statementLabel.highlightColor = expressionChooserView.selectionColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        statementLabel.isHidden = true
        scoreLabel.isHidden = true
        stageLabel.isHidden = true
        quitButton?.isHidden = true
        
        round?.begin()
        
        expressionChooserView.textFont = displayFont
        
        updatePlayPauseButton()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        statementLabel.isHidden = false
    }

    // MARK:- Actions
    
    @IBAction func playPauseButtonTapped(_ sender:UIButton) {
        assert(playPauseButton == sender)
        guard let round = round else { return }
        
        if round.isPaused {
            resumeGame()
        }
        else {
            pauseGame()
        }
    }

    
    @IBAction func quitButtonPressed() {
        print(#function)
        
        round?.quit()
    }

    
    @IBAction func showHintButtonPressed() {
        
        round?.showAHint()
    }

    @IBAction func skipButtonPressed() {
        
        round?.showASolution()
    }
    
    // MARK:- Notifications
    
    @objc func applicationWillResignActive(_ notification:Notification) {
        
        pauseGame()
    }

    @objc func applicationDidBecomeActive(_ notification:Notification) {
        
        // yuou would think this would be a good idea,
        // but it could be jarring to the user
        // if it's been a while since he played
        // and he doesn't know the state of the game when he's returning
        // OR if he had paused the game before leaving the app
        // resumeGame()
    }

    @objc func axpressionChooserViewChoiceFontDidChange(_ notification:Notification) {
        matchUIToWordSearchUI()
    }
    
    
    private lazy var hintCountPresenter : GameViewHintCountPresenter = {
       return GameViewHintCountPresenter(self)
    }()

    private lazy var skipCountPresenter : GameViewSkipCountPresenter = {
        return GameViewSkipCountPresenter(self)
    }()
}

// MARK:- Round Maintenance

extension GameViewController {
    
    private func connectRoundToUI() {
        guard isViewLoaded else { return }
        
        round?.statementPresenter = statementLabel
        round?.scorePresenter = ScorePresenter(scoreLabel)
        round?.stagePresenter = StagePresenter(stageLabel)
        round?.scoreAddPresenter = scoreAddLabel
        round?.scoreTimeAddPresenter = scoreTimeAddLabel
        round?.expressionSelector = expressionChooserView
        round?.expressionSymbolPresenter = expressionChooserView
        round?.timeRemainingPresenter = timeRemainingView
        round?.hintCountPresenter = hintCountPresenter
        round?.skipsCountPresenter = skipCountPresenter
    }
}

extension GameViewController : RoundDisplayDelegate {
    func willReplaceGrid(_ round: Round) {
        assert(round === self.round!)
        hideGamePlayUI()
    }
    
    func didReplaceGrid(_ round: Round) {
        assert(round === self.round!)
        showGamePlayUI()
    }
}

// MARK:- Play/Pause

extension GameViewController {
    
    private func pauseGame() {
        guard let round = self.round,
            !round.isPaused else { return }
        
        round.pause() {// [weak self] in guard let self = self else { return }
            hideGamePlayUI()
            expressionChooserView.fadeOut(duration: 0.2)
            updatePlayPauseButton()
        }
    }
    
    private func resumeGame() {
        guard let round = self.round,
            round.isPaused else { return }
        
        statementLabel.fadeIn(duration:0.2)
        expressionChooserView.fadeIn(duration: 0.2) { [weak self] in
            self?.round?.resume() { [weak self] in guard let self = self else { return }
                self.updatePlayPauseButton()
                self.showGamePlayUI()
            }
        }
    }
}


// MARK:- Updating UI

extension GameViewController {
    
    private func showGamePlayUI() {
        
        hintCountPresenter.update()
        skipCountPresenter.update()
        [quitButton,
         scoreLabel,
         stageLabel,
         statementLabel,
         timeRemainingView].forEach { $0?.isHidden = false }
    }
    
    private func hideGamePlayUI() {
        
        hintCountPresenter.hide()
        skipCountPresenter.hide()
        [
         statementLabel,
         timeRemainingView].forEach { $0?.isHidden = true }
    }
    
    private func matchUIToWordSearchUI() {
        
        let statementFont = expressionChooserView.choiceFont.withSize(expressionChooserView.choiceFont.pointSize * 34/21)
        statementLabel.font = statementFont
    }
    
    private func updatePlayPauseButton() {
        guard let round = round else { return }
        
        
        playPauseButton.imageView?.contentMode = .scaleAspectFit
        
        let preferredImage = round.isPaused ? #imageLiteral(resourceName: "play-button") : #imageLiteral(resourceName: "pause-button")
        playPauseButton.setImage(preferredImage, for: .normal)
    }
}

// MARK:- HintCountPresenter

extension GameViewController {
    
    #warning("there's got to be a better way to do this. My way is ugly and stilted")
    func hintsIncreased(by dHints: Int) {
        print("\(#function) \(dHints)")
        
        hintCountAddLabel.present(addedScore: dHints)
    }
}
