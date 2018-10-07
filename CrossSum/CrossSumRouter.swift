//
//  CrossSumRouter.swift
//  CrossSum
//
//  Created by Joseph Wardell on 10/2/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import UIKit

final class CrossSumRouter : NSObject {
    
    private var initialViewController : UIViewController {
        return navigationViewController
    }
    
    private lazy var navigationViewController : UINavigationController = {
        
        let out = UINavigationController(rootViewController: welcomeScreen)
        out.delegate = self
        
        // using this combination will both hide the naigation bar
        // AND set the status bar to use light content (other combinations will not)
        // this way we can keep status bar settings out of the view controller code
        out.navigationBar.barStyle = .black
        out.navigationBar.isHidden = true
        
        return out
    }()
    
    private lazy var welcomeScreen : WelcomeScreenViewController = {
        let out = WelcomeScreenViewController()
        out.didHitPlayButton = playGame
        out.highScores = [(score:100,stage:2), (score:15, stage:3), (score:100,stage:2), (score:15, stage:3)]
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

// MARK:- UINavigationControllerDelegate

extension CrossSumRouter : UINavigationControllerDelegate {
    func navigationControllerSupportedInterfaceOrientations(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask {
        // TODO: go back to allowing autorotation, but for now it's off
//        return .all
       return .portrait
    }
}
