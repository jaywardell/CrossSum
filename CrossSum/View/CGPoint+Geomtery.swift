//
//  CGPoint+Geomtery.swift
//  Bouncy Bao Test Suite
//
//  Created by Joseph Wardell on 8/12/18.
//  Copyright © 2018 Joseph Wardell. All rights reserved.
//

import Foundation
import CoreGraphics

extension CGPoint {
    
    func distance(from point:CGPoint) -> CGFloat {
        let dX = self.x - point.x
        let dY = self.y - point.y
        return sqrt( dX*dX + dY*dY )
    }
    
    func distanceSquared(from point:CGPoint) -> CGFloat {
        let dX = self.x - point.x
        let dY = self.y - point.y
        return dX*dX + dY*dY
    }
    
    func midpoint(with point:CGPoint) -> CGPoint {
        return CGPoint(x: self.x + (point.x - self.x)/2,
                       y: self.y + (point.y - self.y)/2)
    }
    
    func angle(with point:CGPoint) -> CGFloat {
        return atan2(point.y - y, point.x - x)
    }
}


extension CGPoint : Hashable {
    
    public var hashValue: Int {
        return (x + y).hashValue
    }
}
