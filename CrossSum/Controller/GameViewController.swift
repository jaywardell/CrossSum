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
    
    @IBOutlet weak var wordSearchView: WordSearchView!
    @IBOutlet weak var statementLabel: StatementLabel!
    @IBOutlet weak var scoreLabel: UILabel!

    var round : Round? {
        didSet {
            connectRoundToUI()
            round?.displayDelegate = self
        }
    }
    
    class func createNew() -> GameViewController {
        return UIStoryboard.Main.instantiate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        connectRoundToUI()
        
        statementLabel.backgroundColor = nil
        wordSearchView.backgroundColor = nil
        wordSearchView.selectionColor = view.tintColor
        statementLabel.highlightColor = wordSearchView.selectionColor
        
        wordSearchView.centerXAnchor.constraint(equalTo: statementLabel.centerXAnchor)
        wordSearchView.topAnchor.constraint(equalTo: statementLabel.topAnchor)
        view.layoutIfNeeded()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Quit", style: .done, target: self, action: #selector(quitButtonPressed))
        navigationItem.hidesBackButton = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(wordSearchViewChoiceFontDidChange), name: WordSearchView.ChoiceFontDidChange, object: wordSearchView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        statementLabel.isHidden = true
        scoreLabel.isHidden = true
        
        round?.begin()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        statementLabel.isHidden = false
        scoreLabel.isHidden = false
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
        scoreLabel.font = wordSearchView.choiceFont
        statementLabel.font = wordSearchView.choiceFont
    }
}

// MARK:- Round Maintenance

extension GameViewController {
    
    private func connectRoundToUI() {
        
        round?.statementPresenter = statementLabel
        round?.scorePresenter = scoreLabel
        round?.wordSearchView = wordSearchView
    }
}

extension GameViewController : RoundDisplayDelegate {
    func willReplaceGrid(_ round: Round) {
        showHintButton?.isHidden = true
        skipButton?.isHidden = true
        statementLabel.isHidden = true
    }
    
    func didReplaceGrid(_ round: Round) {
        showHintButton?.isHidden = false
        skipButton?.isHidden = false
        statementLabel.isHidden = false
    }
}

// MARK:- UILabel : ScorePresenter

extension UILabel : ScorePresenter {
    var score: Int {
        get {
            return Int(text ?? "") ?? 0
        }
        set {
            text = "\(newValue)"
        }
    }
    
    
}
