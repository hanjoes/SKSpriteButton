import SpriteKit
import SKSpriteButton

class SKSpriteButtonToggleDemoScene: SKScene {
    
    let TestButton1Key = "TestButton1"
    let TestButton2Key = "TestButton2"
    let TestButton3Key = "TestButton3"
    let TestButton4Key = "TestButton4"
    
    let TestLabelKey = "DemoTestLabel"
    let ButtonTappedTexture = "button_white"
    
    var testButton1: SKSpriteButton {
        return childNode(withName: TestButton1Key) as! SKSpriteButton
    }
    
    var testButton2: SKSpriteButton {
        return childNode(withName: TestButton2Key) as! SKSpriteButton
    }
    
    var testButton3: SKSpriteButton {
        return childNode(withName: TestButton3Key) as! SKSpriteButton
    }
    
    var testButton4: SKSpriteButton {
        return childNode(withName: TestButton4Key) as! SKSpriteButton
    }
    
    var testLabel: SKLabelNode {
        return childNode(withName: TestLabelKey) as! SKLabelNode
    }
    
    override func didMove(to view: SKView) {
        testButton1.isUserInteractionEnabled = true
        testButton1.tappedColor = testButton1.color.inverted()
        testButton1.moveType = .releaseFast
        
        testButton2.isUserInteractionEnabled = true
        testButton2.tappedColor = testButton2.color.inverted()
        testButton2.moveType = .releaseOut
        
        testButton3.isUserInteractionEnabled = true
        testButton3.tappedColor = testButton3.color.inverted()
        testButton3.moveType = .reentry
        
        testButton4.isUserInteractionEnabled = true
        testButton4.tappedTexture = SKTexture(imageNamed: ButtonTappedTexture)
        testButton4.moveType = .alwaysHeld
    }
}

