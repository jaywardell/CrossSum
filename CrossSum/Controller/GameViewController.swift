//
//  GameViewController.swift
//  CrossSum
//
//  Created by Joseph Wardell on 9/30/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var newGameButton: UIButton? {
        didSet {
            newGameButton?.addTarget(self, action: #selector(newGameButtonPressed), for: .touchUpInside)
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
    
    @IBOutlet weak var wordSearchView: WordSearchView!
    @IBOutlet weak var statementLabel: StatementLabel!
    @IBOutlet weak var scoreLabel: ScoreLabel!
    @IBOutlet weak var stageLabel: StageLabel!
    @IBOutlet weak var scoreAddLabel: ScoreAddLabel!
    @IBOutlet weak var timeRemainingView: TimeRemainingView!
    
    
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
        
        navigationItem.hidesBackButton = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(wordSearchViewChoiceFontDidChange), name: WordSearchView.ChoiceFontDidChange, object: wordSearchView)
        
        view.tintColor = navigationController?.view.tintColor
        
        view.backgroundColor = .black
        statementLabel.backgroundColor = nil
        wordSearchView.backgroundColor = nil
        statementLabel.textColor = .white
        wordSearchView.textColor = .white
        scoreLabel.textColor = .white
        stageLabel.textColor = .white
        scoreAddLabel.textColor = UIColor(hue: 60/360, saturation: 1, brightness: 21/34, alpha: 1)
        wordSearchView.selectionColor = view.tintColor
        statementLabel.highlightColor = wordSearchView.selectionColor
    }
    
    private var navigationBarHiddenAtStart : Bool?
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        statementLabel.isHidden = true
        scoreLabel.isHidden = true
        stageLabel.isHidden = true
        
        round?.begin()

        navigationBarHiddenAtStart = navigationController?.isNavigationBarHidden
        navigationController?.isNavigationBarHidden = true
        
        wordSearchView.textFont = displayFont
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        statementLabel.isHidden = false
        scoreLabel.isHidden = false
        stageLabel.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let navigationBarHiddenAtStart = navigationBarHiddenAtStart,
            !navigationBarHiddenAtStart {
            navigationController?.isNavigationBarHidden = false
        }
    }
    
    @IBAction func newGameButtonPressed() {
        fatalError("\(#function) should not longer be called here")
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
        scoreLabel.font = supportFont
        stageLabel.font = supportFont
        scoreAddLabel.font = supportFont
        [skipButton, showHintButton, quitButton].forEach() { $0?.titleLabel?.font = supportFont }
        
        let statementFont = wordSearchView.choiceFont.withSize(max(wordSearchView.choiceFont.pointSize, statementLabel.font.pointSize))
        statementLabel.font = statementFont
        scoreAddLabel.font = statementFont
    }
}

// MARK:- Round Maintenance

extension GameViewController {
    
    private func connectRoundToUI() {
        
        round?.statementPresenter = statementLabel
        round?.scorePresenter = scoreLabel
        round?.stagePresenter = stageLabel
        round?.scoreAddPresenter = scoreAddLabel
        round?.wordSearchView = wordSearchView
        round?.timeRemainingPresenter = timeRemainingView
    }
}

extension GameViewController : RoundDisplayDelegate {
    func willReplaceGrid(_ round: Round) {
        showHintButton?.isHidden = true
        skipButton?.isHidden = true
        statementLabel.isHidden = true
        timeRemainingView.isHidden = true
    }
    
    func didReplaceGrid(_ round: Round) {
        showHintButton?.isHidden = false
        skipButton?.isHidden = false
        statementLabel.isHidden = false
        timeRemainingView.isHidden = false
    }
}

// MARK:- UILabel : ScorePresenter

//extension UILabel : ScorePresenter {
//    var score: Int {
//        get {
//            guard let text = text else { return 0 }
//            let t = text.suffix(from:text.index(text.startIndex, offsetBy:7))
//            return Int(t) ?? 0
//        }
//        set {
//            text = "score: \(newValue)"
//        }
//    }
//
//
//}
