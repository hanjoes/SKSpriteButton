
import SpriteKit

public class SKSpriteKitButtonGroup {

    private var toggleGroup = Set<SKSpriteButton>()
    private var eventListener: SKSpriteButtonEventListener!

    init() {
        eventListener = SKSpriteButtonEventListener(handler: self.toggleAction, forEvent: .touchesToggledOn)
    }

    // Assumes buttons are added in their correct toggle state
    public func addButton(_ button:SKSpriteButton) {
        button.addEventListener(eventListener)
        toggleGroup.insert(button)
    }

    public func removeButton(_ button:SKSpriteButton) {
        if toggleGroup.contains(button) {
            button.removeEventListener(eventListener)
            toggleGroup.remove(button)
        }
    }

    private func toggleAction(touches: Set<UITouch>, event: UIEvent?, target: SKSpriteButton) {
        for button in toggleGroup {
            if button != target {
                button.setToggledOnState(false)
            }
        }
    }

}
