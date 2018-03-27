import SpriteKit

// MARK: SKSpriteButton

/// (SeriousKit) SKSpriteButton.
/// This is a special kind of `SKSpriteNode` that behaves
/// like a button.
///
/// Try out different `MoveType` for different event trigger
/// behavior!
///
/// - note: all `write` interaction with the object will
/// set `isUserInteractionEnabled` to `true` so no need
/// to explicitly set the variable.
///
/// User should expect similar ergonomics when using `UIButton`.
public class SKSpriteButton: SKSpriteNode {
    
    /// Button states indicating the current state of the button. Button can only have one state at a time
    ///
    /// - __normal__: button is not tapped by user or toggledOff in toggle mode
    /// - __tapped__: button is held down
    /// - __disabled__: button is disabled and will not respond to user input
    /// - __toggledOn__: button is in the toggled on state, can only enter this state if isToggleMode is true
    public enum StateType {
        case normal
        case tapped
        case disabled
        case toggledOn
    }

    /// __Readonly__ button state represented by `SKSpriteButton.StateType`.
    private(set) public var state: StateType = .normal

    /// Used to store and return state after .tapped event
    private var previousState: StateType = .normal

    /// There are 3 types of move type.
    ///
    /// - __alwaysHeld__: button won't be considered "released"
    /// until user lift the tap. (default)
    /// - __releaseOut__: button won't be considered "up"
    /// unless user lift the tap or all touches are moved
    /// out of the button frame.
    /// - __releaseFast__: the button is considered "released"
    /// instantly when user moves the tap point.
    /// - __reentry__: user can leave/enter button without
    /// lifting finger. When one touch point is in the button,
    /// it's in `.tapped` status, otherwise it's `.normal`.
    public enum MoveType {
        case alwaysHeld
        case releaseOut
        case releaseFast
        case reentry
    }

    /// Button becomes a toggle switch that switches between normal and toggledOn. When true, button will not
    /// invoke the touchesEnded event listener but rather the touchesToggleOn/Off listener
    public var isToggleMode: Bool = false

    /// isToogleMode must be set to true for this method to take effect, otherwise ignored
    public func setToggledOnState(_ toggledOn: Bool) {
        // don't do anything if not it toggleMode and the new state matches the current state
        guard toggledOn != (state == .toggledOn) && isToggleMode else {
            return
        }

        // Don't call handlers as this is not an action when set manually
        // this is necessary when having a group of buttons to toggle each other
        if toggledOn {
            showAppearance(forState: .toggledOn)
            state = .toggledOn
        } else {
            showAppearance(forState: .normal)
            state = .normal
        }
    }

    /// Used to prevent touch recognition
    /// Will show the disabled texture and disabled color
    public func setDisabledState(_ disabled: Bool) {
        // don't do anything if the new state matches the current state
        guard disabled != (state == .disabled) else {
            return
        }

        if disabled {
            showAppearance(forState: .disabled)
            state = .disabled
        } else {
            showAppearance(forState: .normal)
            state = .normal
        }
    }

    /// The `SKSpriteButton.MoveType` of this button.
    /// Default to `.alwaysHeld`.
    public var moveType: MoveType = .alwaysHeld
    

    /// Set the new texture and maintain a copy of it for the current state
    override public var texture: SKTexture? {
        didSet {
            // Cache new state texture
            stateTextures[state] = texture
        }
    }
    
    /// Set the new color and maintain a copy of it for the current state
    override public var color: UIColor? {
        didSet {
            // Cache new state color
            stateColors[state] = color
        }
    }

    public func setColor(_ stateColor: UIColor, forState stateType: StateType) {
        stateColors[stateType] = stateColor

        if self.state == stateType {
            showColor(forState: stateType)
        }
    }

    public func setTexture(_ stateTexture:SKTexture, forState stateType: StateType) {
        stateTextures[stateType] = stateTexture

        if self.state == stateType {
            showTexture(forState: stateType)
        }
    }

    internal var stateColors: [StateType : UIColor] = [:]
    internal var stateTextures: [StateType : SKTexture] = [:]
    internal var eventListeners: [SKSpriteButtonEventListener] = []
    

    /// Add a method handler.
    ///
    /// - Parameter handler: a closure conforms to `SKSpriteButton.EventHandler`.
    public func addEventListener(_ listener: SKSpriteButtonEventListener) {
        isUserInteractionEnabled = true
        eventListeners.append(listener)
    }
    
    /// Remove a method handler.
    ///
    /// - Parameter handler: a closure conforms to `SKSpriteButtonEvent`.
    public func removeEventListener(_ listener: SKSpriteButtonEventListener) {
        if let index = eventListeners.index(of: listener) {
            eventListeners.remove(at: index)
        }
    }
}


// MARK: - Touch Events From `UIResponder`
extension SKSpriteButton {
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard state != .disabled else {
            return
        }
        touchesDown(touches, event)
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard state != .disabled else {
            return
        }
        touchesUp(touches, event)
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard state != .disabled else {
            return
        }
        touchesCancelled(touches, event)
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard state != .disabled else {
            return
        }
        touchesMoved(touches, event)
    }
    
}

// MARK: - Custom Event Layer
private extension SKSpriteButton {
    
    func touchesDown(_ touches: Set<UITouch>, _ event: UIEvent?) {
        invokeTouchesBeganBehavior(touches, event)
    }
    
    func touchesMoved(_ touches: Set<UITouch>, _ event: UIEvent?) {
        invokeTouchesMovedBehavior(touches, event)
        
        switch moveType {
        case .releaseFast:
            if state == .tapped {
                touchesUp(touches, event)
            }
        case .alwaysHeld: break
        case .releaseOut:
            if state == .tapped && areOutsideOfButtonFrame(touches) {
                touchesUp(touches, event)
            }
        case .reentry:
            if state == .tapped && areOutsideOfButtonFrame(touches) {
                touchesUp(touches, event)
            }
            else if state == .normal && !areOutsideOfButtonFrame(touches) {
                touchesDown(touches, event)
            }
        }
    }
    
    func touchesUp(_ touches: Set<UITouch>, _ event: UIEvent?) {
        if isToggleMode {
            invokeToggleBehavior(touches, event)
        } else {
            invokeTouchesEndedBehavior(touches, event)
        }
    }
    
    func touchesCancelled(_ touches: Set<UITouch>, _ event: UIEvent?) {
        invokeTouchesCancelledBehavior(touches, event)
    }
}

// MARK: - Helper Methods
private extension SKSpriteButton {
    
    func showAppearance(forState stateType: StateType) {
        showColor(forState: stateType)
        showTexture(forState: stateType)
    }

    func showColor(forState stateType: StateType) {
        // Cache current state color if not present, required to capture .normal state
        if stateColors[state] == nil {
            stateColors[state] = super.color
        }

        if let storedColor = stateColors[stateType] {
            super.color = storedColor
        }
    }

    func showTexture(forState stateType: StateType) {
        // Cache current state color if not present, required to capture .normal state
        if stateTextures[state] == nil {
            stateTextures[state] = super.texture
        }

        if let storedTexture = stateTextures[stateType] {
            super.texture = storedTexture
        }
    }

    func invokeTouchesBeganBehavior(_ touches: Set<UITouch>, _ event: UIEvent?) {
        if isToggleMode {
            previousState = state
        }
        triggerTapped()
        invokeHandler(.touchesBegan, touches, event)
    }
    
    func invokeTouchesEndedBehavior(_ touches: Set<UITouch>, _ event: UIEvent?) {
        triggerNormal()
        invokeHandler(.touchesEnded, touches, event)
    }
    
    func invokeTouchesCancelledBehavior(_ touches: Set<UITouch>, _ event: UIEvent?) {
        if isToggleMode {
            if previousState == .toggledOn {
                triggerToggledOn()
            } else {
                triggerToggledOff()
            }
        } else {
            triggerNormal()
        }
        invokeHandler(.touchesCanceled, touches, event)
    }
    
    func invokeTouchesMovedBehavior(_ touches: Set<UITouch>, _ event: UIEvent?) {
        invokeHandler(.touchesMoved, touches, event)
    }

    func invokeToggleBehavior(_ touches: Set<UITouch>, _ event: UIEvent?) {
        if previousState == .toggledOn {
            triggerToggledOff()
            invokeHandler(.touchesToggledOff, touches, event)
        } else {
            triggerToggledOn()
            invokeHandler(.touchesToggledOn, touches, event)
        }

        invokeHandler(.touchesEnded, touches, event)
    }

    private func invokeHandler(_ eventType: SKSpriteButtonEventListener.EventType, _ touches: Set<UITouch>, _ event: UIEvent?) {
        for listener in eventListeners {
            if listener.event == eventType {
                listener.handler(touches, event, self)
            }
        }
    }

    func triggerNormal() {
        showAppearance(forState: .normal)
        state = .normal
    }
    
    func triggerTapped() {
        showAppearance(forState: .tapped)
        state = .tapped
    }
    
    func triggerToggledOff() {
        showAppearance(forState: .normal)
        state = .normal
    }

    func triggerToggledOn() {
        showAppearance(forState: .toggledOn)
        state = .toggledOn
    }
    
    func areOutsideOfButtonFrame(_ touches: Set<UITouch>) -> Bool {
        for touch in touches {
            let touchPointInButton = touch.location(in: self)
            if abs(touchPointInButton.x) < frame.width / 2 && abs(touchPointInButton.y) < frame.height / 2 {
                return false
            }
        }
        return true
    }

}

