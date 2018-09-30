import CoreGraphics

extension CGPoint {
    public static func + (left: CGPoint, right: CGPoint) -> CGVector {
        return CGVector(dx: left.x + right.x, dy: left.y + right.y)
    }
    
    public static func - (left: CGPoint, right: CGPoint) -> CGVector {
        return CGVector(dx: left.x - right.x, dy: left.y - right.y)
    }
    
    public static func + (left: CGPoint, right: CGVector) -> CGPoint {
        return CGPoint(x: left.x + right.dx, y: left.y + right.dy)
    }

    public static func - (left: CGPoint, right: CGVector) -> CGPoint {
        return CGPoint(x: left.x - right.dx, y: left.y - right.dy)
    }
}
