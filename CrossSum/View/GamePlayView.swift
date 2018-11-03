//
//  GamePlayView.swift
//  CrossSum
//
//  Created by Joseph Wardell on 10/27/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import UIKit

class GamePlayView: FlexibleLayoutView {

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
        out.setImage(#imageLiteral(resourceName: "play-button"), for: .selected)    // TODO: i don't think this is needed
        out.contentHorizontalAlignment = .fill  // to make the button fill its expected size
        out.contentVerticalAlignment = .fill
        out.contentMode = .scaleAspectFit
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
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(expressionChooserFontDidChange(_:)),
//                                               name: ExpressionChooserView.ChoiceFontDidChange,
//                                               object: out)
        return out
    }()
    
    lazy var quitButton : UIButton = {
        let out = UIButton(type: .system)
        // TODO: find a pdf version of this button
        out.setImage(#imageLiteral(resourceName: "circle-x"), for: .normal)
        out.contentHorizontalAlignment = .fill
        out.contentVerticalAlignment = .fill
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

    // MARK:- Appearance
    
    private func setupAppearance() {
        
        backgroundColor = .black
        
        statementLabel.textColor = .white
        scoreLabel.textColor = .white
        stageLabel.textColor = .white
    }
    
    // MARK:- Layout
    
    override func configureManagedSubviews() {
        addManagedSubviews(layout)
        addManagedSubview(expressionChooser)
    }
    
    override func configureLayouts() {
        
        addCallback(for: .all, setupAppearance)
        
        let statusBarHeight : CGFloat = 44.0// found by calling UIApplication.shared.statusBarFrame.height in portrait mode

        // note: we treat flat as portrait
        let portrait = ViewState(orientations:.allbutLandscape)
        let ipad = ViewState(interfaceIdiom: .pad)
        let iPadPortrait = ViewState(interfaceIdiom: .pad, orientations:.allbutLandscape)
        
        // note: smaller iphones offer compact:compact in landscape, larger ones offer regular:compact
        // so we can only depend on orientation for this
        let iphonePortrait = ViewState(interfaceIdiom: .phone, orientations:.allbutLandscape)
        let iphoneLandscape = !iphonePortrait
        let iphoneLandscapeRight = (iphoneLandscape).mutatedCopy(orientations: [.landscapeRight])
        let iphoneLandscapeLeft = (iphoneLandscape).mutatedCopy(orientations: [.landscapeLeft])

        // relative sizes for all layouts
        addConstraints(for: .all,
            quitButton.aspectRatioConstraints(1))
        addConstraints(for: .all,
            quitButton.constraintsToMatchSize(of: expressionChooser, widthMultiplier: 2.0/34))
        addConstraints(for: .all,
            expressionChooser.aspectRatioConstraints(1))
        addConstraints(for: .all,
            play_pauseButton.aspectRatioConstraints(1))
        addConstraints(for: .all,
            play_pauseButton.constraintsToMatchSize(of: expressionChooser, widthMultiplier: 3/34.0))
        addConstraints(for: .all,
            backgroundView.constraintsToFillSuperview())
        addConstraints(for: .all,
                       // TODO: I need this to be smaller in landscape mode
            quitButton.constraintsToPin(leading: safeAreaLayoutGuide.leadingAnchor,
                                        top: safeAreaLayoutGuide.topAnchor,
                                        padding: UIEdgeInsets(top: statusBarHeight, left: statusBarHeight, bottom: 0, right: 0)))
        addConstraints(for: .all, [
            stageProgressView.heightAnchor.constraint(equalTo: gameProgressView.heightAnchor)])
        addConstraints(for: .all,
            stageProgressView.constraintsToPin(leading:expressionChooser.leadingAnchor, trailing:expressionChooser.trailingAnchor))
        addConstraint(for: .all,
                      scoreLabel.centerYAnchor.constraint(equalTo: quitButton.centerYAnchor))
        addConstraint(for: .all,
                      stageLabel.centerYAnchor.constraint(equalTo: scoreLabel.centerYAnchor))
        addConstraint(for: .all,
                      stageLabel.trailingAnchor.constraint(equalTo: scoreLabel.leadingAnchor, constant:-8))
        addConstraint(for: .all,
                      hintTally.centerYAnchor.constraint(equalTo: hintButton.centerYAnchor))
        addConstraint(for: .all,
                      skipTally.centerYAnchor.constraint(equalTo: skipButton.centerYAnchor))
        addConstraints(for: .all, [
            hintTally.heightAnchor.constraint(equalTo: hintButton.heightAnchor, multiplier: 21.0/34),
            hintTally.widthAnchor.constraint(equalTo: hintTally.heightAnchor, multiplier: 55.0/21.0),
            skipTally.heightAnchor.constraint(equalTo: skipButton.heightAnchor, multiplier: 21.0/34),
            skipTally.widthAnchor.constraint(equalTo: skipTally.heightAnchor, multiplier: 55.0/21.0)
            ])
        
        // on iPhone, the expression chooser always grows to meet the smallest dimension of the screen
        // and is positioned in the most accessible position for the user
        addConstraints(for: iphonePortrait,
            expressionChooser.constraintsToMatchSize(of: self, widthMultiplier: 1))
        addConstraints(for: iphonePortrait,
            expressionChooser.constraintsToPositionInSuperview(.middle, .center))
        addConstraints(for: iphonePortrait,[
            gameProgressView.bottomAnchor.constraint(equalTo:safeAreaLayoutGuide.bottomAnchor)])
        addConstraints(for: iphonePortrait,[
            stageProgressView.bottomAnchor.constraint(equalTo:gameProgressView.topAnchor, constant:-2)])
        addConstraints(for: iphonePortrait,
            gameProgressView.aspectRatioConstraints(34.0/1.0))
        addConstraints(for: iphonePortrait,
            gameProgressView.constraintsToPin(leading:expressionChooser.leadingAnchor, trailing:expressionChooser.trailingAnchor))
        addConstraint(for: iphonePortrait,
                      play_pauseButton.centerXAnchor.constraint(equalTo: centerXAnchor))
        addConstraint(for: iphonePortrait,
                      play_pauseButton.topAnchor.constraint(equalTo: expressionChooser.bottomAnchor))
        addConstraint(for: iphonePortrait,
                      scoreLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -statusBarHeight))
        addConstraint(for: iphonePortrait,
                      hintButton.leadingAnchor.constraint(equalTo: play_pauseButton.trailingAnchor, constant: statusBarHeight))
        addConstraint(for: iphonePortrait,
                      hintTally.leadingAnchor.constraint(equalTo: hintButton.trailingAnchor, constant: 8))
        addConstraint(for: iphonePortrait,
                      hintButton.centerYAnchor.constraint(equalTo: play_pauseButton.centerYAnchor))
        addConstraint(for: iphonePortrait,
                      skipButton.centerYAnchor.constraint(equalTo: play_pauseButton.centerYAnchor))
        addConstraint(for: iphonePortrait,
                      skipButton.trailingAnchor.constraint(equalTo: play_pauseButton.leadingAnchor, constant: -statusBarHeight))
        addConstraint(for: iphonePortrait, skipButton.centerYAnchor.constraint(equalTo: play_pauseButton.centerYAnchor))
        addConstraint(for: iphonePortrait,
                      skipTally.trailingAnchor.constraint(equalTo: skipButton.leadingAnchor, constant: -8))
        addConstraints(for: iphonePortrait, [
            statementLabel.centerXAnchor.constraint(equalTo: expressionChooser.centerXAnchor),
            statementLabel.centerYAnchor.constraint(equalTo: expressionChooser.topAnchor, constant: 0)])

        addConstraints(for: iphoneLandscape,
                       expressionChooser.constraintsToMatchSize(of: self, heightMultiplier: 1))
        addConstraints(for: iphoneLandscape,[stageProgressView.bottomAnchor.constraint(equalTo:safeAreaLayoutGuide.bottomAnchor)])
        addConstraints(for: iphoneLandscape,
                       gameProgressView.aspectRatioConstraints(34.0/1.0))
        addConstraint(for: iphoneLandscape,
                      gameProgressView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor))
        addConstraints(for: iphoneLandscape, [
            statementLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            statementLabel.centerXAnchor.constraint(equalTo: gameProgressView.centerXAnchor)])
        addConstraints(for: iphoneLandscape, [
            hintButton.bottomAnchor.constraint(equalTo: gameProgressView.topAnchor, constant:-statusBarHeight),
            skipButton.bottomAnchor.constraint(equalTo: hintButton.topAnchor, constant: -8)
            ])
        addConstraint(for: iphoneLandscape,
                    play_pauseButton.bottomAnchor.constraint(equalTo: hintButton.bottomAnchor))
        
        // the gameProgressView changes appearance depending on the layout
        addCallback(for: iphonePortrait) { [weak self] in
            self?.gameProgressView.geometry = .horizontal
        }
        addCallback(for: iphoneLandscape) { [weak self] in
            self?.gameProgressView.geometry = .horizontal
        }
        addCallback(for: ipad) { [weak self] in
            self?.gameProgressView.geometry = .square
        }
        
        addConstraints(for: iphoneLandscapeRight,
                       expressionChooser.constraintsToPin(leading: leadingAnchor, top: topAnchor)
        )
        addConstraints(for: iphoneLandscapeRight, [
            gameProgressView.leadingAnchor.constraint(equalTo: stageProgressView.trailingAnchor),
            gameProgressView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
            ])
        addConstraint(for: iphoneLandscapeRight,
                      scoreLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -statusBarHeight))
        addConstraints(for: iphoneLandscapeRight, [
                hintButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -statusBarHeight),
                skipButton.trailingAnchor.constraint(equalTo: hintButton.trailingAnchor),
                hintTally.trailingAnchor.constraint(equalTo: hintButton.leadingAnchor, constant: -8),
                skipTally.trailingAnchor.constraint(equalTo: skipButton.leadingAnchor, constant: -8)
            ])
        addConstraint(for: iphoneLandscapeRight,
                      play_pauseButton.leadingAnchor.constraint(equalTo: gameProgressView.leadingAnchor))
        
        addConstraints(for: iphoneLandscapeLeft,
                       expressionChooser.constraintsToPositionInSuperview(.middle, .trailing,
                                                                          usingSafeLayoutGuides:true))
        addConstraints(for: iphoneLandscapeLeft, [
            gameProgressView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            gameProgressView.trailingAnchor.constraint(equalTo: stageProgressView.leadingAnchor)
            ])
        addConstraint(for: iphoneLandscapeLeft,
                      scoreLabel.trailingAnchor.constraint(equalTo: expressionChooser.leadingAnchor, constant: -statusBarHeight))
        addConstraints(for: iphoneLandscapeLeft, [
            hintButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: statusBarHeight),
            skipButton.leadingAnchor.constraint(equalTo: hintButton.leadingAnchor),
            hintTally.leadingAnchor.constraint(equalTo: hintButton.trailingAnchor, constant: 8),
            skipTally.leadingAnchor.constraint(equalTo: skipButton.trailingAnchor, constant: 8)
            ])
        addConstraint(for: iphoneLandscapeLeft,
                      play_pauseButton.trailingAnchor.constraint(equalTo: gameProgressView.trailingAnchor))
        
        
        // TODO: finish iPad layouts
        
        
//                        gameProgressView.trailingAnchor.constraint(equalTo: expressionChooser.trailingAnchor))

//        addConstraints(for: ViewState(interfaceIdiom: .pad),
//                       expressionChooser.constraintsToPositionInSuperview(.middle, .center) +
//                        [gameProgressView.bottomAnchor.constraint(equalTo:safeAreaLayoutGuide.bottomAnchor)] +
//                        [stageProgressView.bottomAnchor.constraint(equalTo:gameProgressView.topAnchor, constant:-2)] +
//                        gameProgressView.aspectRatioConstraints(34.0/1.0) +
//                        gameProgressView.constraintsToPin(leading:expressionChooser.leadingAnchor, trailing:expressionChooser.trailingAnchor)
//        )
//
//        addConstraints(for: iPadPortrait,
//                       expressionChooser.constraintsToMatchSize(of: self, widthMultiplier: 21/34.0)
//        )
//
//        addConstraints(for: !iPadPortrait,
//                       expressionChooser.constraintsToMatchSize(of: self, heightMultiplier: 21/34.0)
//        )
        
        
        addCallback(for: iphonePortrait) { [weak self] in
            self?.hintTally.isReversed = false
            self?.skipTally.isReversed = true
        }
        addCallback(for: iphoneLandscapeLeft) { [weak self] in
            self?.hintTally.isReversed = false
            self?.skipTally.isReversed = false
        }
        addCallback(for: iphoneLandscapeRight) { [weak self] in
            self?.hintTally.isReversed = true
            self?.skipTally.isReversed = true
        }
    }
    
    // MARK:- 
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    override func tintColorDidChange() {
        super.tintColorDidChange()
        
        hintTally.tallyColor = tintColor
        skipTally.tallyColor = tintColor
        
        expressionChooser.selectionColor = tintColor
        statementLabel.highlightColor = tintColor
    }

    // MARK:- Notifications
    
//    @objc private func expressionChooserFontDidChange(_ notification:Notification) {
//        assert(notification.object as! ExpressionChooserView == expressionChooser)
//
//        let statementFont = expressionChooser.choiceFont.withSize(expressionChooser.choiceFont.pointSize * 34/21)
//        statementLabel.font = statementFont
//    }
    
    // TODO: idky the above notificaiton doesn't get called
    // but the view controller gets the same notification
    // I'd prefer to not have the view controller call this,
    // but that's what's happening right now
    func synchronizeFontSizes() {
        let statementFont = expressionChooser.choiceFont.withSize(expressionChooser.choiceFont.pointSize * 34/21)
        statementLabel.font = statementFont
    }

    // MARK:- Actions
    
    var play_pauseButtonAction : ()->() = {}
    @IBAction func play_pauseButtonTapped() {
        
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
