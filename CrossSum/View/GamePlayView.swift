//
//  GamePlayView.swift
//  CrossSum
//
//  Created by Joseph Wardell on 10/20/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import UIKit

/// A container view for the game play UI
/// vends objects to the controller layer and manages appearance
class GamePlayView: UIView {
    
    lazy var backgroundView : UIView = {
        let out = Background()
        return out
    }()
    
    lazy var gameProgressView : SquareTilesProgressView = {
        let out = SquareTilesProgressView()
        out.geometry = .horizontal
        out.leftToRight = true
        out.maxItems = 10
        out.completedItems = 10
        return out
    }()
    
    lazy var stageProgressView : TimeRemainingView = {
        let out = TimeRemainingView()
        out.maxTime = 10
        out.remainingTime = 3
        return out
    }()
    
    lazy var play_pauseButton : UIButton = {
        let out = UIButton(type: .system)
        out.setImage(#imageLiteral(resourceName: "pause-button"), for: .normal)
        out.setImage(#imageLiteral(resourceName: "play-button"), for: .selected)
        out.addTarget(self, action: #selector(play_pauseButtonTapped), for: .touchUpInside)
        return out
    }()

    lazy var skipButton : UIButton = {
       let out = UIButton(type: .system)
        out.setTitle("Skip", for: .normal)
        out.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
        if let titleLabel = out.titleLabel {
            titleLabel.font = UIFontMetrics.default.scaledFont(for: titleLabel.font)
            titleLabel.adjustsFontForContentSizeCategory = true
        }

        return out
    }()

    lazy var skipTally : TallyView = {
        let out = TallyView()
        out.messiness = .loose
        return out
    }()

    lazy var hintButton : UIButton = {
        let out = UIButton(type: .system)
        out.setTitle("Hint", for: .normal)
        out.addTarget(self, action: #selector(hintButtonTapped), for: .touchUpInside)
        if let titleLabel = out.titleLabel {
            titleLabel.font = UIFontMetrics.default.scaledFont(for: titleLabel.font)
            titleLabel.adjustsFontForContentSizeCategory = true
        }
        return out
    }()

    lazy var hintTally : TallyView = {
        let out = TallyView()
        out.messiness = .loose
        out.isReversed = true
        return out
    }()

    lazy var gridContainer : UIView = {
        let out = UIView()
        out.addSubview(expressionChooser)
        return out
    }()

    private let displayFont = UIFont(name: UIFont.BPMono, size: 24)!

    
    lazy var expressionChooser : ExpressionChooserView = {
        let out = ExpressionChooserView()
        out.textColor = .white
        out.textFont = displayFont
        out.shadowOffset = CGSize(width: 1, height: 1)
        out.shadowColor = UIColor(white: 0.5, alpha: 0.9)
       NotificationCenter.default.addObserver(self, selector: #selector(expressionChooserFontDidChange(_:)), name: ExpressionChooserView.ChoiceFontDidChange, object: out)
        return out
    }()
    
    lazy var quitButton : UIButton = {
        let out = UIButton(type: .system)
        out.setImage(#imageLiteral(resourceName: "circle-x"), for: .normal)
        out.addTarget(self, action: #selector(quitButtonTapped), for: .touchUpInside)
        return out
    }()

    lazy var scoreLabel : UILabel = {
        let out = UILabel()
        out.font = UIFont.preferredFont(forTextStyle: .footnote)
        out.adjustsFontForContentSizeCategory = true
        out.text = "score:"
        return out
    }()

    lazy var stageLabel : UILabel = {
        let out = UILabel()
        out.font = UIFont.preferredFont(forTextStyle: .footnote)
        out.adjustsFontForContentSizeCategory = true
        out.text = "stage:"
        return out
    }()

    lazy var statementPlacard : UIView = {
        let out = UIView()
//        out.addSubview(statementLabel)
        return out
    }()

    lazy var statementLabel : StatementLabel = {
        let out = StatementLabel()

        return out
    }()
    
    lazy var layout : [UIView] = {
        return [
            backgroundView,
            gameProgressView,
            stageProgressView,
            play_pauseButton,
            skipButton,
            skipTally,
            hintButton,
            hintTally,
            gridContainer,
            quitButton,
            scoreLabel,
            stageLabel,
            statementLabel
        ]
    }()
    
    // MARK:-

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        backgroundColor = .black

        layout.forEach() { addSubview($0) }

        statementLabel.textColor = .white
        scoreLabel.textColor = .white
        stageLabel.textColor = .white
        
        setupConstraints()
    }
    
    override func tintColorDidChange() {
        super.tintColorDidChange()
        
        hintTally.tallyColor = tintColor
        skipTally.tallyColor = tintColor
        
        expressionChooser.selectionColor = tintColor
        statementLabel.highlightColor = tintColor
    }
    
    // MARK:- Constraints
    
    // TODO: I'd love to support landscape modes,
    // but I can't get the constraints to take in that case
    // need to research programmatic autolayout more
    
    func setupConstraints() {
        
        removeConstraints(constraints)
        
        backgroundView.removeConstraints(backgroundView.constraints)
        backgroundView.constrainToFillSuperview()
        
        // three sections:
        // top: quit button, stage and score labels
        // middle: expression chooser, statement label, play/pause button, hint and skip UI
        // bottom: game and stage progress
        
        // TOP
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        quitButton.removeConstraints(quitButton.constraints)
        quitButton.anchor(leading: safeAreaLayoutGuide.leadingAnchor,
                          top: safeAreaLayoutGuide.topAnchor,
                          padding: UIEdgeInsets(top: statusBarHeight, left: statusBarHeight, bottom: 0, right: 0))
        
        scoreLabel.removeConstraints(scoreLabel.constraints)
        scoreLabel.anchor(trailing: safeAreaLayoutGuide.trailingAnchor,
                          middle: quitButton.centerYAnchor,
                          padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: statusBarHeight))
        
        stageLabel.removeConstraints(stageLabel.constraints)
        stageLabel.anchor(trailing: scoreLabel.leadingAnchor,
                          middle: scoreLabel.centerYAnchor,
                          padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8))


        // MIDDLE
        
        gridContainer.removeConstraints(gridContainer.constraints)
        gridContainer.constrainToPositionInSuperview(.middle, .center)
        gridContainer.anchor(leading: safeAreaLayoutGuide.leadingAnchor,
                             trailing: safeAreaLayoutGuide.trailingAnchor)
        gridContainer.constrainToAspectRatio(1)
        
        expressionChooser.removeConstraints(expressionChooser.constraints)
        expressionChooser.anchor(leading:gridContainer.leadingAnchor, trailing: gridContainer.trailingAnchor, top:gridContainer.topAnchor, bottom: gridContainer.bottomAnchor)
        expressionChooser.constrainToAspectRatio(1)

        
        play_pauseButton.removeConstraints(play_pauseButton.constraints)
        play_pauseButton.constrain(to: [
            play_pauseButton.heightAnchor.constraint(equalTo: play_pauseButton.widthAnchor),
            play_pauseButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            play_pauseButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 5.0/34),
            play_pauseButton.topAnchor.constraint(equalTo: gridContainer.bottomAnchor)
            ])
        
        skipButton.removeConstraints(skipButton.constraints)
        skipButton.anchor(leading: play_pauseButton.trailingAnchor,
                          middle: play_pauseButton.centerYAnchor,
                          padding: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0))
        skipButton.constrain(to: [
            skipButton.widthAnchor.constraint(greaterThanOrEqualTo: widthAnchor, multiplier: 3.0/34),
            ])

        skipTally.removeConstraints(skipTally.constraints)
        skipTally.anchor(leading: skipButton.trailingAnchor, middle: skipButton.centerYAnchor, padding: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0))
        skipTally.constrain(to: [
            skipTally.heightAnchor.constraint(equalTo: skipButton.heightAnchor, multiplier: 21.0/34),
            skipTally.widthAnchor.constraint(equalTo: skipTally.heightAnchor, multiplier: 55.0/21.0)
            ])

        hintButton.removeConstraints(hintButton.constraints)
        hintButton.anchor(trailing: play_pauseButton.leadingAnchor,
                          middle: play_pauseButton.centerYAnchor,
                          padding: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0))
        hintButton.constrain(to: [
            hintButton.widthAnchor.constraint(greaterThanOrEqualTo: widthAnchor, multiplier: 3.0/34),
            ])

        hintTally.removeConstraints(hintTally.constraints)
        hintTally.anchor(trailing: hintButton.leadingAnchor, middle: hintButton.centerYAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8))
        hintTally.constrain(to: [
                hintTally.heightAnchor.constraint(equalTo: hintButton.heightAnchor, multiplier: 21.0/34),
                hintTally.widthAnchor.constraint(equalTo: hintTally.heightAnchor, multiplier: 55.0/21.0)
            ])

        statementLabel.removeConstraints(statementLabel.constraints)
        statementLabel.constrain(to: [
                statementLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
                statementLabel.centerYAnchor.constraint(equalTo: gridContainer.topAnchor, constant: 0)
            ])
        
        // BOTTOM
        gameProgressView.removeConstraints(gameProgressView.constraints)
        gameProgressView.constrain(to: [
            gameProgressView.leadingAnchor.constraint(equalTo: leadingAnchor),
            gameProgressView.trailingAnchor.constraint(equalTo: trailingAnchor),
            gameProgressView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 2.0/55),
            gameProgressView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
            ])
        
        stageProgressView.removeConstraints(stageProgressView.constraints)
        stageProgressView.constrain(to: [
            stageProgressView.leadingAnchor.constraint(equalTo: leadingAnchor, constant:2),
            stageProgressView.trailingAnchor.constraint(equalTo: trailingAnchor, constant:-2),
            stageProgressView.heightAnchor.constraint(equalToConstant: 1),
            stageProgressView.bottomAnchor.constraint(equalTo: gameProgressView.topAnchor, constant: -4)
            ])

        setNeedsLayout()
        layout.forEach() { $0.setNeedsLayout() }
    }

    // MARK:- Notifications
    
    @objc private func expressionChooserFontDidChange(_ notification:Notification) {
        assert(notification.object as! ExpressionChooserView == expressionChooser)
        
        let statementFont = expressionChooser.choiceFont.withSize(expressionChooser.choiceFont.pointSize * 34/21)
        statementLabel.font = statementFont
    }
    
    // MARK:- Actions
    
    var play_pauseButtonAction : ()->() = {}
    @IBAction func play_pauseButtonTapped() {
        
        print("expressionchooser frame: \(expressionChooser.frame)")
        print("expressionchooser ishidden: \(expressionChooser.isHidden)")
        play_pauseButtonAction()
    }

    var hintButtonAction : ()->() = {}
    @IBAction func hintButtonTapped() {
        
        hintButtonAction()
    }

    var skipButtonAction : ()->() = {}
    @IBAction func skipButtonTapped() {
        
        skipButtonAction()
    }

    var quitButtonAction : ()->() = {}
    @IBAction func quitButtonTapped() {
        
        quitButtonAction()
    }

}

