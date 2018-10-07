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

        playButton.backgroundColor = .orange
        playButton.constrain(to: [
            
            playButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            NSLayoutConstraint(item: playButton, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 34/21, constant: 0),
            
            playButton.widthAnchor.constraint(equalTo: widthAnchor, constant: 21/34),
            playButton.heightAnchor.constraint(equalTo: playButton.widthAnchor, constant: 21/34)
            ])
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        backgroundColor = .black
    }
    
}
