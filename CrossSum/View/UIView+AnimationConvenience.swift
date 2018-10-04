//
//  UIView+AnimationConvenience.swift
//  CrossSum
//
//  Created by Joseph Wardell on 10/3/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import UIKit

extension UIView {
    
    func fadeOut(duration:TimeInterval, after delay:TimeInterval=0, completion:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            UIView.animate(withDuration: duration, animations: { [weak self] in
                self?.alpha = 0
            }) { _ in
                completion()
            }
        }
    }
    
    func fadeIn(duration:TimeInterval, after delay:TimeInterval=0, completion:@escaping ()->()) {
        
        alpha = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            UIView.animate(withDuration: duration, animations: { [weak self] in
                self?.alpha = 1
            }) { _ in
                completion()
            }
        }
    }
    
}


