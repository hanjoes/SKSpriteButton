/// Wrapper for `unowned` reference. Using unowned instead of weak since
/// it doesn't makes sense for a wrapper to contain `nil` value.
struct SKUnowned<T: AnyObject & Hashable>: Hashable  {
    var hashValue: Int {
        return value.hashValue * 31
    }
    
    static func ==(lhs: SKUnowned<T>, rhs: SKUnowned<T>) -> Bool {
        return lhs.value == rhs.value
    }
    
    unowned var value: T
}

// MARK: - SKSpriteButtonGroup

/// `SKSpriteButtonGroup` is a group of SKSpriteButtons.
/// It comes in handy in some cases when user wants to have group-specific
/// behavior. e.g.: mutually exclusive toggle-group.
///
/// - note: User should maintain ownership of the `SKSpriteButton`s that meant
/// to be added.
public class SKSpriteButtonGroup {
    
    /// Returns an array of `SKSpriteButton`s.
    public var buttons: [SKSpriteButton] {
        return storedButtons.map { $0.value }
    }
    
    private var storedButtons = Set<SKUnowned<SKSpriteButton>>()
    
    /// Adds an `SKSpriteButton` to a group.
    ///
    /// - Parameter button: the `SKSpriteButton` to be added.
    public func add(button: SKSpriteButton) {
        storedButtons.insert(SKUnowned(value: button))
    }
    
    /// Removes an `SKSpriteButton` added previously.
    /// If the group doesn't contain the button, this will become a no-op.
    ///
    /// - Parameter button: the `SKSpriteButton` needs to be removed
    public func remove(button: SKSpriteButton) {
        storedButtons.remove(SKUnowned(value: button))
    }
}
