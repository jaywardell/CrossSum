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

