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
        // it would be more accurate to use the commented code below,
        // but CoreText throws a fit and prints a nasty message to console
        // so for now we'll just assume a constant ratio
        pointSize/12

//        let ctfont = CTFontCreateWithName(fontName as CFString, pointSize, nil);
//        return CTFontGetUnderlineThickness(ctfont)
    }
}
