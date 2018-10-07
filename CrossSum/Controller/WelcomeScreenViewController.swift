//
//  WelcomeScreenViewController.swift
//  CrossSum
//
//  Created by Joseph Wardell on 10/2/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import UIKit

class WelcomeScreenViewController: UIViewController {

    var didHitPlayButton : ()->() = {}
    
    private lazy var welcomeScreen : WelcomeScreen = {
        return WelcomeScreen()
    }()
    
    override func loadView() {
        self.view = welcomeScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        welcomeScreen.playButton.addTarget(self, action: #selector(playButtonPressed), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        welcomeScreen.playButton.fadeIn(duration: animated ? 0.2 : 0)
    }
    
    @IBAction private func playButtonPressed() {
        
        welcomeScreen.playButton.fadeOut(duration: 0.2) {
            self.didHitPlayButton()
        }
    }
}
