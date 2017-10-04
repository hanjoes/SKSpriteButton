import SpriteKit
import UIKit

class ViewController: UIViewController {
    
    let SceneName = "SKSpriteButtonTestScene"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            if let scene = SKScene(fileNamed: SceneName) {
                scene.scaleMode = SKSceneScaleMode.aspectFit
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
        }
    }

}

