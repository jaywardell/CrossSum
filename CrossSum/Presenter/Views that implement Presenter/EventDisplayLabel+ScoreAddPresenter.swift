//
//  EventDisplayLabel+ScoreAddPresenter.swift
//  CrossSum
//
//  Created by Joseph Wardell on 10/16/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import UIKit

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


