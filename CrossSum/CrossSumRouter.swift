//
//  CrossSumRouter.swift
//  CrossSum
//
//  Created by Joseph Wardell on 10/2/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import UIKit

final class CrossSumRouter {
    
    private var initialViewController : UIViewController {
        let out = navigationViewController
        out.isNavigationBarHidden = true
        out.navigationBar.barStyle = .blackTranslucent
        return out
    }
    
    private lazy var navigationViewController : UINavigationController = {
        return UINavigationController(rootViewController: welcomeScreen)
    }()
    
    private lazy var welcomeScreen : WelcomeScreenViewController = {
        let out = WelcomeScreenViewController()
        out.didHitPlayButton = playGame
        return out
    }()
}

// MARK:- Router

extension CrossSumRouter : Router {
    
    func display(in window:UIWindow) {
        window.rootViewController = initialViewController
    }
}


// MARK:- Game Play

extension CrossSumRouter {
    
    private func playGame() {

        let gvc = GameViewController.createNew()
        let round = Round(gridFactory: GameReadyGridFactory())
        NotificationCenter.default.addObserver(self, selector: #selector(userDidQuitRound(_:)), name: Round.DidQuit, object: round)
        gvc.round = round
        navigationViewController.pushViewController(gvc, animated: false)
    }
    
    @objc private func userDidQuitRound(_ notification:Notification) {
        print("\(#function)")
        
        // TODO: record score for round into a history object
        navigationViewController.popToRootViewController(animated: false)
    }
}

