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
    @IBOutlet weak var scoreLabel: UILabel!

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
        
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Quit", style: .done, target: self, action: #selector(quitButtonPressed))
//        navigationItem.hidesBackButton = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(wordSearchViewChoiceFontDidChange), name: WordSearchView.ChoiceFontDidChange, object: wordSearchView)
        
        
//        navigationController?.view.tintColor = .yellow
        view.tintColor = navigationController?.view.tintColor
        
        view.backgroundColor = .black
        statementLabel.backgroundColor = nil
        wordSearchView.backgroundColor = nil
        statementLabel.textColor = .white
        wordSearchView.textColor = .white
        scoreLabel.textColor = .white
        wordSearchView.selectionColor = view.tintColor
        statementLabel.highlightColor = wordSearchView.selectionColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        statementLabel.isHidden = true
        scoreLabel.isHidden = true
        
        round?.begin()

        // TODO: idky this sin't working
//        wordSearchView.textFont = displayFont
//        scoreLabel.font = displayFont
//        [skipButton, showHintButton, quitButton].forEach() { $0?.titleLabel?.font = displayFont }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        statementLabel.isHidden = false
        scoreLabel.isHidden = false
        
        print("displayu font: \(wordSearchView.choiceFont)")
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
        let supportFont = wordSearchView.choiceFont.withSize(wordSearchView.choiceFont.pointSize * 21/34)
        scoreLabel.font = supportFont
        skipButton?.titleLabel?.font = supportFont
        showHintButton?.titleLabel?.font = supportFont
//        navigationItem.leftBarButtonItem?.setTitleTextAttributes([
//            NSAttributedString.Key.font : supportFont
//            ], for: .normal)
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
            guard let text = text else { return 0 }
            let t = text.suffix(from:text.index(text.startIndex, offsetBy:7))
            return Int(t) ?? 0
        }
        set {
            text = "score: \(newValue)"
        }
    }
    
    
}
