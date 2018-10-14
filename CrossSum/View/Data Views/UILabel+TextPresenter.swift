//
//  UILabel+TextPresenter.swift
//  CrossSum
//
//  Created by Joseph Wardell on 10/13/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import UIKit

extension UILabel : TextPresenter {
    
    func present(text: String) {
        self.text = text
    }
}
