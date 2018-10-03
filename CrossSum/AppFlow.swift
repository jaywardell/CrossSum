//
//  AppFlow.swift
//  CrossSum
//
//  Created by Joseph Wardell on 10/2/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import UIKit

final class AppFlow {
    
    var initialViewController : UIViewController {
       return navigationViewController
    }
    
    lazy var navigationViewController : UINavigationController = {
        return UINavigationController(rootViewController: welcomeScreen)
    }()
    
    lazy var welcomeScreen : WelcomeScreenViewController = {
        let out = WelcomeScreenViewController()
        out.didHitPlayButton = playGame
        return out
    }()
    
    private func playGame() {

        let gvc = GameViewController.createNew()
        let round = Round(gridFactory: GameReadyGridFactory())
        NotificationCenter.default.addObserver(self, selector: #selector(userDidQuitRound(_:)), name: Round.DidQuit, object: round)
        gvc.round = round
        navigationViewController.pushViewController(gvc, animated: true)
    }
    
    @objc func userDidQuitRound(_ notification:Notification) {
        print("\(#function)")
        
        // TODO: record score for round into a history object
        navigationViewController.popToRootViewController(animated: true)
    }
}
