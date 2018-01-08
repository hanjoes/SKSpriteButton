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
    
    /// Button status indicating the current state of the button.
    ///
    /// - __normal__: button is not tapped by user
    /// - __tapped__: button is held down
    public enum Status {
        case normal
        case tapped
    }
    
    /// __Readonly__ button status represented by `SKSpriteButton.Status`.
    private(set) public var status: Status = .normal
    
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
    
    /// Used to prevent touch recognition
    /// Will show the disabled texture and disabled color
    public var disabled: Bool = false {
        willSet {
            isUserInteractionEnabled = !disabled
            if disabled {
                showDisabledAppearance()
            } else {
                showNormalAppearance()
            }
        }
    }
    
    /// The `SKSpriteButton.MoveType` of this button.
    /// Default to `.alwaysHeld`.
    public var moveType: MoveType = .alwaysHeld {
        willSet {
            isUserInteractionEnabled = !disabled
        }
    }
    
    /// The closure signature for the `event handler`.
    /// Closure can be added to this button for specific events by calling
    /// `add*` methods.
    public typealias EventHandler = (Set<UITouch>, UIEvent?) -> Void
    
    // Maintain a copy of the new normal texture so that it can be restored
    override public var texture: SKTexture? {
        didSet {
            storedNormalTexture = texture
        }
    }
    
    // Maintain a copy of the new normal color so that it can be restored
    override public var color: UIColor {
        didSet {
            storedNormalColor = color
        }
    }
    
    /// Set this variable if you want to display a
    /// different texture when the button is tapped.
    public var tappedTexture: SKTexture? {
        willSet {
            isUserInteractionEnabled = !disabled
        }
        didSet {
            // more than one texture is associated with node so keep of copy of the normal texture
            if storedNormalTexture == nil {
                storedNormalTexture = texture
            }
        }
    }
    
    /// Color to display when a button is tapped.
    public var tappedColor: UIColor? {
        willSet {
            isUserInteractionEnabled = !disabled
        }
        didSet {
            // more than one color is associated with node so keep of copy of the normal color
            if storedNormalColor == nil {
                storedNormalColor = color
            }
        }
    }
    
    /// Set this variable if you want to display a
    /// different texture when the button is disabled.
    public var disabledTexture: SKTexture? {
        willSet {
            isUserInteractionEnabled = !disabled
        }
        didSet {
            if storedNormalTexture == nil {
                storedNormalTexture = texture
            }
            if disabled {
                showDisabledTexture()
            }
        }
    }
    
    /// Color to display when a button is disabled.
    public var disabledColor: UIColor? {
        willSet {
            isUserInteractionEnabled = !disabled
        }
        didSet {
            if storedNormalColor == nil {
                storedNormalColor = color
            }
            if disabled {
                showDisabledColor()
            }
        }
    }
    
    internal var storedNormalColor: UIColor?
    
    internal var storedNormalTexture: SKTexture?

    internal var touchesBeganHandlers = [EventHandler]()
    
    internal var touchesUpHandlers = [EventHandler]()
    
    internal var touchesCancelledHandlers = [EventHandler]()
    
    internal var touchesMovedHandlers = [EventHandler]()
    
    /// Add a method handler for `touchesBegan` event.
    ///
    /// - Parameter handler: a closure conforms to `SKSpriteButton.EventHandler`.
    public func addTouchesBeganHandler(handler: @escaping EventHandler) {
        isUserInteractionEnabled = true
        touchesBeganHandlers.append(handler)
    }
    
    /// Add a method handler for `touchesUp` event.
    ///
    /// - Parameter handler: a closure conforms to `SKSpriteButton.EventHandler`.
    public func addTouchesUpHandler(handler: @escaping EventHandler) {
        isUserInteractionEnabled = true
        touchesUpHandlers.append(handler)
    }
    
    /// Add a method handler for `touchesCancelled` event.
    ///
    /// - Parameter handler: a closure conforms to `SKSpriteButton.EventHandler`.
    public func addTouchesCancelledHandler(handler: @escaping EventHandler) {
        isUserInteractionEnabled = true
        touchesCancelledHandlers.append(handler)
    }
    
    /// Add a method handler for `touchesMoved` event.
    ///
    /// - Parameter handler: a closure conforms to `SKSpriteButton.EventHandler`.
    public func addTouchesMovedHandler(handler: @escaping EventHandler) {
        isUserInteractionEnabled = true
        touchesMovedHandlers.append(handler)
    }
}


// MARK: - Touch Events From `UIResponder`
extension SKSpriteButton {
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesDown(touches, event)
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesUp(touches, event)
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesCancelled(touches, event)
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
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
            if status == .tapped {
                touchesUp(touches, event)
            }
        case .alwaysHeld: break
        case .releaseOut:
            if status == .tapped && areOutsideOfButtonFrame(touches) {
                touchesUp(touches, event)
            }
        case .reentry:
            if status == .tapped && areOutsideOfButtonFrame(touches) {
                touchesUp(touches, event)
            }
            else if status == .normal && !areOutsideOfButtonFrame(touches) {
                touchesDown(touches, event)
            }
            
        }
    }
    
    func touchesUp(_ touches: Set<UITouch>, _ event: UIEvent?) {
        guard status == .tapped else {
            return
        }
        
        invokeTouchesUpBehavior(touches, event)
    }
    
    func touchesCancelled(_ touches: Set<UITouch>, _ event: UIEvent?) {
        guard status == .tapped else {
            return
        }
        invokeTouchesCancelledBehavior(touches, event)
    }
}

// MARK: - Helper Methods
private extension SKSpriteButton {
    
    func showNormalAppearance() {
        showNormalColor()
        showNormalTexture()
    }
    
    func showTappedAppearance() {
        showTappedColor()
        showTappedTexture()
    }
    
    func showDisabledAppearance() {
        showDisabledColor()
        showDisabledTexture()
    }
    
    func showNormalColor() {
        if let storedNormalColor = storedNormalColor {
            color = storedNormalColor
        }
    }
    
    func showNormalTexture() {
        if let storedNormalTexture = storedNormalTexture {
            texture = storedNormalTexture
        }
    }
    
    func showDisabledColor() {
        if let disabledColor = disabledColor {
            color = disabledColor
        }
    }
    
    func showDisabledTexture() {
        guard let _ = texture else { return }
        
        if let disabledTexture = disabledTexture {
            texture = disabledTexture
        }
    }
    
    func showTappedColor() {
        if let tappedColor = tappedColor {
            color = tappedColor
        }
    }
    
    func showTappedTexture() {
        // doesn't make sense to show tapped texture if it doesn't have texture initially
        guard let _ = texture else { return }
        
        if let tappedTexture = tappedTexture {
            texture = tappedTexture
        }
    }
    
    func invokeTouchesBeganBehavior(_ touches: Set<UITouch>, _ event: UIEvent?) {
        triggerTapped()
        touchesBeganHandlers.forEach {
            handler in
            handler(touches, event)
        }
    }
    
    func invokeTouchesUpBehavior(_ touches: Set<UITouch>, _ event: UIEvent?) {
        triggerNormal()
        touchesUpHandlers.forEach {
            handler in
            handler(touches, event)
        }
    }
    
    func invokeTouchesCancelledBehavior(_ touches: Set<UITouch>, _ event: UIEvent?) {
        triggerNormal()
        touchesCancelledHandlers.forEach {
            handler in
            handler(touches, event)
        }
    }
    
    func invokeTouchesMovedBehavior(_ touches: Set<UITouch>, _ event: UIEvent?) {
        touchesMovedHandlers.forEach {
            handler in
            handler(touches, event)
        }
    }
    
    func triggerNormal() {
        status = .normal
        showNormalAppearance()
    }
    
    func triggerTapped() {
        status = .tapped
        showTappedAppearance()
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
