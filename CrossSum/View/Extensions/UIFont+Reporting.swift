//
//  UIFont+Custom.swift
//  CrossSum
//
//  Created by Joseph Wardell on 10/21/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import UIKit

// MARK: - A category for reporting to the programmer font information
extension UIFont {
    
    /// prints out a listing of the fonts available
    ///
    /// - Parameter filter: an optional filter for family name
    class func reportAvailable(_ familyNameFilter:String?=nil) {
        print("Available Fonts \(familyNameFilter ?? "") =================")
        for family in UIFont.familyNames.sorted() {
            if let filter = familyNameFilter,
                nil == family.range(of:filter) { continue }
            
            let names = UIFont.fontNames(forFamilyName: family)
            print("Family: \(family) Font names: \(names)")
        }
    }
}
