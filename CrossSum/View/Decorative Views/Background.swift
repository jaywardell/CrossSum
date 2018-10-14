//
//  Background.swift
//  CrossSum
//
//  Created by Joseph Wardell on 10/14/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import UIKit

class Background: UIImageView {
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        // TODO: I probably want to get a higher resolution image...
        self.image = #imageLiteral(resourceName: "background")
    }
    
}
