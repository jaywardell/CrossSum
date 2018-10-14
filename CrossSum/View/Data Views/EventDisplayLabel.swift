//
//  ScoreAddLabel.swift
//  CrossSum
//
//  Created by Joseph Wardell on 10/6/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import UIKit

// a view that displays the number of points added to the score
// when the user increases his score
class EventDisplayLabel: CenteredLabel {

    @IBOutlet weak var vPosition: NSLayoutConstraint?
    
    var suffix : String = ""
    var pluralSuffix : String = ""

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        isHidden = true
        backgroundColor = .clear
    }
    
}

extension EventDisplayLabel : ScoreAddPresenter {
    func present(addedScore: Int) {
        
        let prefix = addedScore > 0 ? "+" : ""
        text = "\(prefix)\(addedScore)\(addedScore == 1 ? suffix : pluralSuffix)!"
        
        isHidden = false
        vPosition!.constant -= frame.height * 21/34
        
        UIView.animate(withDuration: 0.4, animations: { [weak self] in
            self?.superview?.layoutIfNeeded()
            self?.alpha = 0
            self?.transform = CGAffineTransform(scaleX: 13/34, y: 13/34)
        }) { _ in
            self.vPosition?.constant = 0
            self.alpha = 1
            self.isHidden = true
            self.transform = .identity
        }
    }
}


