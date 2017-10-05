import SpriteKit

// MARK: SKSpriteButton

/// (SeriousKit) SKSpriteButton.
/// This is a special kind of `SKSpriteNode` that behaves
/// like a button.
///
/// - note: all `write` interaction with the object will
/// set `isUserInteractionEnabled` to `true` so no need
/// to explicitly set the variable.
///
/// User should expect similar ergonomics when using `UIButton`.
public class SKSpriteButton: SKSpriteNode {
    
    /// Button status indicating the current state of the button.
    ///
    /// - normal: button is not tapped by user
    /// - tapped: button is held down
    public enum Status {
        case normal
        case tapped
    }
    
    /// The closure signature for the `event handler`.
    /// Closure can be added to this button for specific events by calling
    /// `add*` methods.
    public typealias EventHandler = (Set<UITouch>, UIEvent?) -> Void

    /// Set this variable if you want to display a
    /// different texture when the button is tapped.
    public var tappedTexture: SKTexture? {
        willSet {
            isUserInteractionEnabled = true
        }
    }
    
    /// Color to display when a button is tapped.
    public var tappedColor: UIColor? {
        willSet {
            isUserInteractionEnabled = true
        }
    }
    
    /// __Readonly__ button status represented by `SKSpriteButton.Status`.
    private(set) public var status: Status = .normal {
        didSet {
            switch status {
            case .normal: showNormalAppearance()
            case .tapped: showTappedAppearance()
            }
        }
    }
    
    internal var storedNormalColor: UIColor?
    
    internal var storedNormalTexture: SKTexture?

    internal var touchesBeganHandlers = [EventHandler]()
    
    internal var touchesEndedHandlers = [EventHandler]()
    
    internal var touchesCancelledHandlers = [EventHandler]()
    
    internal var touchesMovedHandlers = [EventHandler]()
    
    /// Add a method handler for `touchesBegan` event.
    ///
    /// - Parameter handler: a closure conforms to `SKSpriteButton.EventHandler`.
    public func addTouchesBeganHandler(handler: @escaping EventHandler) {
        isUserInteractionEnabled = true
        touchesBeganHandlers.append(handler)
    }
    
    /// Add a method handler for `touchesEnded` event.
    ///
    /// - Parameter handler: a closure conforms to `SKSpriteButton.EventHandler`.
    public func addTouchesEndedHandler(handler: @escaping EventHandler) {
        isUserInteractionEnabled = true
        touchesEndedHandlers.append(handler)
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

// MARK: - Touch events.
extension SKSpriteButton {
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        status = .tapped
        touchesBeganHandlers.forEach {
            handler in
            handler(touches, event)
        }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        status = .normal
        touchesEndedHandlers.forEach {
            handler in
            handler(touches, event)
        }
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        status = .normal
        touchesCancelledHandlers.forEach {
            handler in
            handler(touches, event)
        }
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesMovedHandlers.forEach {
            handler in
            handler(touches, event)
        }
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
    
    func showTappedColor() {
        if let tappedColor = tappedColor {
            storedNormalColor = color
            color = tappedColor
        }
    }
    
    func showTappedTexture() {
        if let tappedTexture = tappedTexture {
            storedNormalTexture = texture
            texture = tappedTexture
        }
    }
}
