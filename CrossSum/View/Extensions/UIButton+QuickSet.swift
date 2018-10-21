//
//  UIButton+QuickSet.swift
//  CrossSum
//
//  Created by Joseph Wardell on 10/21/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import UIKit

extension UIButton {
    
    var image : UIImage? {
        get {
            return image(for: .normal)
        }
        set {
            setImage(newValue, for: .normal)
        }
    }
}
