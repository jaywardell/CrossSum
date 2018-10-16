//
//  UIView+HidingPresenter.swift
//  CrossSum
//
//  Created by Joseph Wardell on 10/16/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import UIKit

extension UIView : ToggleablePresenter {
    func setIsPresenting(_ shouldPresent: Bool) {
        isHidden = !shouldPresent
    }
}
