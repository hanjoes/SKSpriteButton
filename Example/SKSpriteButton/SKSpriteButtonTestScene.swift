import SpriteKit
import SKSpriteButton

class SKSpriteButtonTestScene: SKScene {
    
    let TestButton1Key = "TestButton1"
    
    var testButton1: SKSpriteButton {
        return childNode(withName: TestButton1Key) as! SKSpriteButton
    }
    
    override func didMove(to view: SKView) {
        testButton1.addTouchesBeganHandler(handler: self.button1TouchBeganHandler0)
        testButton1.addTouchesBeganHandler(handler: self.button1TouchBeganHandler1)
        testButton1.addTouchesEndedHandlers(handler: self.button1TouchCancelledHandler0)
        
        testButton1.tappedColor = .purple
    }
}

// MARK: - SKSpriteButton Event Handlers
extension SKSpriteButtonTestScene {
    
    func button1TouchBeganHandler0(touches: Set<UITouch>, event: UIEvent?) {
        print("button1 touch began handler 0")
    }
    
    func button1TouchBeganHandler1(touches: Set<UITouch>, event: UIEvent?) {
        print("button1 touch began handler 1")
    }
    
    func button1TouchCancelledHandler0(touches: Set<UITouch>, event: UIEvent?) {
        print("button1 touch cancelled handler 0")
    }
}
