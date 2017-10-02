import SpriteKit
import UIKit

class ViewController: UIViewController {
    
    let SceneName = "SKSpriteButtonTestScene"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            if let scene = SKScene(fileNamed: SceneName) {
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

}

