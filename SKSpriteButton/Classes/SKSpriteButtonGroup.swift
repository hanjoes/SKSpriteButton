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

/// `SKSpriteButtonGroup` is a group of SKSpriteButtons.
/// It comes in handy in some cases when user wants to have group-specific
/// behavior. e.g.: mutually exclusive toggle group.
public class SKSpriteButtonGroup {
    
    public var buttons: [SKSpriteButton] {
        return storedButtons.map { $0.value }
    }
    
    private var storedButtons = Set<SKUnowned<SKSpriteButton>>()
    
    public func add(button: SKSpriteButton) {
        storedButtons.insert(SKUnowned(value: button))
    }
    
    public func remove(button: SKSpriteButton) {
        storedButtons.remove(SKUnowned(value: button))
    }
}
