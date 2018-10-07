//
//  UIView+AutolayoutSetup.swift
//  CrossSum
//
//  Created by Joseph Wardell on 9/30/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import UIKit


extension UIView {
    
    var widthConstraints : [NSLayoutConstraint] {
        return constraints.filter {
            $0.firstAnchor == widthAnchor ||
                $0.secondAnchor == widthAnchor
        }
    }
    
    var heightConstraints : [NSLayoutConstraint] {
        return constraints.filter {
            $0.firstAnchor == heightAnchor ||
                $0.secondAnchor == heightAnchor
        }
    }
    
    func deactivateWidthAndHeightConstriants() {
        
        removeConstraints(widthConstraints+heightConstraints)
    }
    
}
