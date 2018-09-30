import Foundation
import CoreGraphics

extension CGVector {
    
    init(angle theta:CGFloat, length:CGFloat) {
        self.init(dx:length * cos(theta), dy:length * sin(theta))
    }
    
    func twoDimensionalVectorCrossProduct(with vector:CGVector) -> CGFloat {
        return dx * vector.dy - dy * vector.dx
    }
    
    func dot(with vector:CGVector) -> CGFloat {
        return self.dx * vector.dx + self.dy * vector.dy
    }
    
    static func * (left: CGVector, right: CGFloat) -> CGVector {
        return CGVector(dx: left.dx * right, dy: left.dy * right)
    }
    
    static func * (left: CGFloat, right: CGVector) -> CGVector {
        return right * left
    }
    
    // NOTE: factored out for cases when efficiency may only demand a relative length comparison of 2 vectors
    var lengthSquared : CGFloat {
        return dx * dx + dy * dy
    }
    
    var length : CGFloat {
        return sqrt(lengthSquared)
    }
    
    var angle : CGFloat {
        return atan2(dy, dx)
    }
    
    func rotated(by angle:CGFloat) -> CGVector {
        var newAngle = self.angle + angle
        while newAngle > 2*CGFloat.pi { newAngle -= 2*CGFloat.pi}
        return CGVector(angle: self.angle + angle, length: self.length)
    }
}
