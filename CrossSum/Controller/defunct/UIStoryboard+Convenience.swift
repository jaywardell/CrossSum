//
//  UIStoryboard+Convenience.swift
//  Bouncy Pao
//
//  Created by Joseph Wardell on 7/18/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard {
    
    static var Main : UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    func instantiateViewController(named name:String) -> UIViewController {
        return instantiateViewController(withIdentifier: name)
    }

    func instantiate<Type:UIViewController>() -> Type {
        return instantiateViewController(named: String(describing: Type.self)) as! Type
    }
}

