struct SKUnowned<T: AnyObject & Hashable>: Hashable  {
    var hashValue: Int {
        return value.hashValue * 31
    }
    
    static func ==(lhs: SKUnowned<T>, rhs: SKUnowned<T>) -> Bool {
        return lhs == rhs
    }
    
    unowned var value: T
}


class SKSpriteButtonGroup {
    
    public var buttons = Set<SKUnowned<SKSpriteButton>>()
    
    public func add(button: SKSpriteButton) {
        buttons.insert(SKUnowned(value: button))
    }
    
    public func remove(button: SKSpriteButton) {
        buttons.remove(SKUnowned(value: button))
    }
}
