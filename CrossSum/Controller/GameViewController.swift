//
//  GameViewController.swift
//  CrossSum
//
//  Created by Joseph Wardell on 9/30/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var wordSearchView: WordSearchView!
    @IBOutlet weak var statementLabel: StatementLabel!
    @IBOutlet weak var scoreLabel: ScoreLabel!
    @IBOutlet weak var stageLabel: StageLabel!
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
        
        wordSearchView.centerXAnchor.constraint(equalTo: statementLabel.centerXAnchor)
        wordSearchView.topAnchor.constraint(equalTo: statementLabel.topAnchor)
        view.layoutIfNeeded()
        
        NotificationCenter.default.addObserver(self, selector: #selector(wordSearchViewChoiceFontDidChange), name: WordSearchView.ChoiceFontDidChange, object: wordSearchView)
        
        view.backgroundColor = .black
        [
        statementLabel,
        wordSearchView,
        scoreLabel,
        stageLabel,
        hintCountLabel,
        skipCountLabel
        ].forEach() { $0.backgroundColor = nil }
        
        statementLabel.textColor = .white
        wordSearchView.textColor = .white
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
        wordSearchView.selectionColor = view.tintColor
        statementLabel.highlightColor = wordSearchView.selectionColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        statementLabel.isHidden = true
        scoreLabel.isHidden = true
        stageLabel.isHidden = true
        quitButton?.isHidden = true
        
        round?.begin()
        
        wordSearchView.textFont = displayFont
        
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
        
        if round.paused {
            statementLabel.fadeIn(duration:0.2)
            wordSearchView.fadeIn(duration: 0.2) {
                round.resume() { [weak self] in guard let self = self else { return }
                    self.updatePlayPauseButton()
                    self.showGamePlayUI()
                }
            }
        }
        else {
            round.pause() {// [weak self] in guard let self = self else { return }
                hideGamePlayUI()
                wordSearchView.fadeOut(duration: 0.2)
                updatePlayPauseButton()
           }
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
    
    @objc func wordSearchViewChoiceFontDidChange(_ notification:Notification) {
        matchUIToWordSearchUI()
    }

}

// MARK:- Round Maintenance

extension GameViewController {
    
    private func connectRoundToUI() {
        
        round?.statementPresenter = statementLabel
        round?.scorePresenter = scoreLabel
        round?.stagePresenter = stageLabel
        round?.scoreAddPresenter = scoreAddLabel
        round?.scoreTimeAddPresenter = scoreTimeAddLabel
        round?.wordSearchView = wordSearchView
        round?.timeRemainingPresenter = timeRemainingView
        round?.hintCountPresenter = self
        round?.skipsCountPresenter = self
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

// MARK:- Updating UI

extension GameViewController {
    
    private func showGamePlayUI() {
        let round = self.round!
        
        updateHintUI(round.showingGrid ? round.hints : 0)
        updateSkipUI(round.showingGrid ? round.skips : 0)
        [quitButton,
         scoreLabel,
         stageLabel,
         statementLabel,
         timeRemainingView].forEach { $0?.isHidden = false }
    }
    
    private func hideGamePlayUI() {
        [showHintButton,
         hintCountLabel,
         skipCountLabel,
         skipButton,
         statementLabel,
         timeRemainingView].forEach { $0?.isHidden = true }
    }
    
    private func matchUIToWordSearchUI() {
        
        let statementFont = wordSearchView.choiceFont.withSize(max(wordSearchView.choiceFont.pointSize * 34/21, statementLabel.font.pointSize))
        statementLabel.font = statementFont
    }

    private func updateHintUI(_ hintCount:Int) {
        
        hintCountLabel.isHidden = hintCount <= 0
        showHintButton?.isHidden = hintCount <= 0
    }
    
    private func updateSkipUI(_ skipCount:Int) {
        
        skipCountLabel.isHidden = skipCount <= 0
        skipButton?.isHidden = skipCount <= 0
    }
    
    private func updatePlayPauseButton() {
        guard let round = round else { return }
        
        
        playPauseButton.imageView?.contentMode = .scaleAspectFit
        
        let preferredImage = round.paused ? #imageLiteral(resourceName: "play-button") : #imageLiteral(resourceName: "pause-button")
        playPauseButton.setImage(preferredImage, for: .normal)
    }
}

// MARK:- HintCountPresenter

extension GameViewController : HintCountPresenter {
    
    func hintsIncreased(by dHints: Int) {
        print("\(#function) \(dHints)")
        
        hintCountAddLabel.showScoreAdd(dHints)
    }
    
    func showHints(_ hints: Int, for round: Round) {
        hintCountLabel.text = "\(hints)"
        if round.showingGrid {
            updateHintUI(hints)
        }
        else {
            updateHintUI(0)
        }
    }
}


extension GameViewController : SkipCountPresenter {
    
    func skipsIncreased(by dSkips: Int) {
        print("\(#function) \(dSkips)")
        
        // I'm choosing to show no special UI for this right now
        // let the user be surprised when she sees it go up, for now...
    }

    func showSkips(_ skips: Int, for round: Round) {
        skipCountLabel.text = "\(skips)"
        if round.showingGrid {
            updateSkipUI(skips)
        }
        else {
            updateSkipUI(0)
        }
    }
    
    
    
}
