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
        
        out.view.tintColor = UIColor(hue: 164/360, saturation: 1, brightness: 21/34, alpha: 1)
        
        return out
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
        
        restoreHighScores()
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

        // don't let the navigation controller support pop on swipe
        // or else the user can swipe out of the game
        navigationViewController.interactivePopGestureRecognizer?.isEnabled = false
        
        navigationViewController.pushViewController(gvc, animated: false)

    }
        
    @objc private func userDidQuitRound(_ notification:Notification) {
        
        // TODO: this is being called sometimes for unexpected reasons
        // probably a timer is not being stopped when it should be, but I'm not sure
        
        let round = notification.object as! Round
        UserDefaults.standard.addHighScore(round.highScore)
        
//        #if DEBUG
//        navigationViewController.takeSnapshot()
//        #endif
        
        restoreHighScores()
        navigationViewController.popToRootViewController(animated: false)
        
        // turn pop on swipe back on here, in case it's needed for another view controller
        navigationViewController.interactivePopGestureRecognizer?.isEnabled = true
   }
    
    private func restoreHighScores() {
        welcomeScreen.highScores = UserDefaults.standard.highScores
        welcomeScreen.lastHighScore = UserDefaults.standard.lastHighScore
    }
}

// MARK:- UINavigationControllerDelegate

extension CrossSumRouter : UINavigationControllerDelegate {
    func navigationControllerSupportedInterfaceOrientations(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask {
        // TODO: go back to allowing autorotation, but for now it's off
        return .all
//       return .portrait
    }
}
