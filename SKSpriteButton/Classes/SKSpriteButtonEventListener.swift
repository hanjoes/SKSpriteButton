//
// Created by Nader Eloshaiker on 25/3/18.
// Copyright (c) 2018 Rotate Gears. All rights reserved.
//

import SpriteKit

public class SKSpriteButtonEventListener {
    /// The closure signature for the `event handler`.
    /// Closure can be added to this button for specific events by calling
    /// `add*` methods.
    /// NSMutableDictionary? is passed down from the Node's userData
    public typealias EventHandler = (Set<UITouch>, UIEvent?, SKSpriteButton) -> Void

    public enum EventType {
        case touchesBegan
        case touchesMoved
        case touchesEnded
        case touchesCanceled
        case touchesToggledOn
        case touchesToggledOff
    }


    public let id = UUID().uuidString
    public let event: EventType
    public let handler: EventHandler

    init(handler: @escaping EventHandler, forEvent event: EventType) {
        self.handler = handler
        self.event = event
    }
}

// MARK: - Enumeration Support
extension SKSpriteButtonEventListener: Hashable {
    public var hashValue: Int {
        return id.hashValue
    }

    public static func == (lhs: SKSpriteButtonEventListener, rhs: SKSpriteButtonEventListener) -> Bool {
        return lhs.id == rhs.id
    }
}
