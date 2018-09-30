//
//  UIFont+CoreTextConvenience.swift
//  CrossSum
//
//  Created by Joseph Wardell on 9/30/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import UIKit

extension UIFont {
    
    var underlineThickness : CGFloat {
        let ctfont = CTFontCreateWithName(fontName as CFString, pointSize, nil);
        return CTFontGetUnderlineThickness(ctfont)
    }
}
