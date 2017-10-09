import SpriteKit

class SKSpriteButtonTouch: UITouch {
    var customLocation: CGPoint?
    
    override func location(in node: SKNode) -> CGPoint {
        if let customLocation = customLocation {
            return customLocation
        }
        return super.location(in: node)
    }
}
