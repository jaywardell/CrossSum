//
//  UIViewController+Debugging.swift
//  CrossSum
//
//  Created by Joseph Wardell on 10/10/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import UIKit

extension UIViewController {
    
    /// returns a snapshot of the view as it currently appears on screen
    public var snapshot : UIImage {
        
        let renderer = UIGraphicsImageRenderer(size: view.frame.size)
        let image = renderer.image(actions: { context in
            view.layer.render(in: context.cgContext)
        })
        return image
    }
    
    /// take a snapshot of the view and save it to the camera roll
    public func takeSnapshot() {
      
        //Save snapshot to camera roll
        UIImageWriteToSavedPhotosAlbum(snapshot, nil, nil, nil)
    }
}
