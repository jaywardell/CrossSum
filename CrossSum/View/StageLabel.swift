//
//  StageLabel.swift
//  CrossSum
//
//  Created by Joseph Wardell on 10/7/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import UIKit

class StageLabel: UILabel {

    var stage : Int = 0 {
        didSet {
            text = "stage: \(stage)"
            print("stage: \(stage)")
            print("text: \(text)")
        }
    }
    
}

extension StageLabel : StagePresenter {}
