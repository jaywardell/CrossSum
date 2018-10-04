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
    
    @IBAction private func playButtonPressed() {
        
        didHitPlayButton()
    }
}
