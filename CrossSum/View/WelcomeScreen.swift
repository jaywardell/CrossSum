//
//  WelcomeScreen.swift
//  CrossSum
//
//  Created by Joseph Wardell on 10/2/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import UIKit

class WelcomeScreen: UIView {

    lazy var playButton : UIButton = {
        let out = UIButton(type: .system)
        out.setTitle("Play", for: .normal)
        return out
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard nil == playButton.superview else { return }
        
        addSubview(playButton)
        playButton.constrainToPositionInSuperview(.middle, .center)
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        backgroundColor = .white
    }
    
}
