//
//  GameViewController.swift
//  CrossSum
//
//  Created by Joseph Wardell on 9/30/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
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

    var round : Round? {
        didSet {
            connectRoundToUI()
            round?.displayDelegate = self
        }
    }
    
    private let displayFont = UIFont(name: "CourierNewPS-BoldMT", size: 24)!
    
    class func createNew() -> GameViewController {
        return UIStoryboard.Main.instantiate()
    }
    
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
        
        wordSearchView.selectionColor = view.tintColor
        statementLabel.highlightColor = wordSearchView.selectionColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        statementLabel.isHidden = true
        scoreLabel.isHidden = true
        stageLabel.isHidden = true
        
        round?.begin()
        
        wordSearchView.textFont = displayFont
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        statementLabel.isHidden = false
        scoreLabel.isHidden = false
        stageLabel.isHidden = false
    }
    
    @IBAction func quitButtonPressed() {
        print(#function)
        
        round?.quit()
    }

    
    @IBAction func showHintButtonPressed() {
        
        round?.showAHint()
    }

    @IBAction func skipButtonPressed() {
        
        round?.showASolution(andAdvance: true)
    }
    
    @objc func wordSearchViewChoiceFontDidChange(_ notification:Notification) {
        matchUIToWordSearchUI()
    }

    private func matchUIToWordSearchUI() {
        let supportFont = wordSearchView.choiceFont.withSize(max(wordSearchView.choiceFont.pointSize * 21/34, scoreLabel.font.pointSize))
        [scoreLabel,
         stageLabel,
         hintCountLabel,
         skipCountLabel].forEach() { $0.font = supportFont }
        [skipButton,
         showHintButton,
         quitButton].forEach() { $0?.titleLabel?.font = supportFont }
        hintCountAddLabel.font = supportFont

        let statementFont = wordSearchView.choiceFont.withSize(max(wordSearchView.choiceFont.pointSize, statementLabel.font.pointSize))
        statementLabel.font = statementFont
        [scoreAddLabel,
         scoreTimeAddLabel].forEach() {
            $0.font = statementFont
        }
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
        
        [showHintButton,
        hintCountLabel,
        skipCountLabel,
        skipButton,
        statementLabel,
            timeRemainingView].forEach { $0?.isHidden = true }
    }
    
    func didReplaceGrid(_ round: Round) {
        updateHintUI(round.showingGrid ? round.hints : 0)
        updateSkipUI(round.showingGrid ? round.skips : 0)
        [statementLabel, timeRemainingView].forEach { $0?.isHidden = false }
    }
    
    func updateHintUI(_ hintCount:Int) {
        
        hintCountLabel.isHidden = hintCount <= 0
        showHintButton?.isHidden = hintCount <= 0
    }
    
    func updateSkipUI(_ skipCount:Int) {
        
        skipCountLabel.isHidden = skipCount <= 0
        skipButton?.isHidden = skipCount <= 0
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
        
        // TODO: this
//        skipCOuntAddLabel.showScoreAdd(dSkips)
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
