# SKSpriteButton

## Info

This is a fork from https://github.com/hanjoes/SKSpriteButton which reworks the state managemnet and event listeners. It also adds support for toggling buttons.

## Usage 

SKSpriteButton will have **one** of these states:

| State        | Description                                                                                              |
|--------------|----------------------------------------------------------------------------------------------------------|
| `.normal`    | Button is initialized to this state                                                                      |
| `.tapped`    | On touch down event                                                                                      |
| `.disabled`  | Button doesn't respond to user interaction                                                               |
| `.toggledOn` | When toggle mode is true, the button will flip between normal and toggledOn state on each touch up event |

You can set color, texture and eventListeners for any the button states. There can only be one color and/or texture for each state but ma have one or more eventListener for each state.

### Color

Set `color(SKColor, forState: StateType)` property for a different display color for a given state.

Since this widget inherits from SKSpriteNode, which will only show texture if both `texture` and `color` are set. `Color` will not be shown if the button has a texture.

### Texture

Set `texture(SKTexture, forState: StateType)` property for displaying a different texture for a given state.

### Toggle Support

Set `isToggleMode(Bool)` to enable toggling on button touchUp events.
Set `ToggledOnState(Bool)` to pre-load a toggle state

### EventListeners

Add/Remove `EventListener(SKSpriteButtonEventListener)` register and de-register an event listener

## Event Management

### EventType

| Supported Events     |
|----------------------|
| `.touchesMoved`      |
| `.touchesEnded`      |
| `.touchesCanceled`   |
| `.touchesToggledOn`  |
| `.touchesToggledOff` |

### Creating an Event Listener

Initialize an event `SKSpriteButtonEventListener(handler: EventHandler, forEvent: EventType)`

```swift
let button = SKSpriteButton(imageNamed:"InActive")
button.setTexture(SKTexture(imageNamed: "Active"), forState: .toggledOn)
button.isToggleMode = true
button.setToggledOnState(true)
button.addEventListener(SKSpriteButtonEventListener(handler: self.showTab, forEvent: .touchesToggledOn))
```

### EventHandler

This is a reference to a method call, eg. `self.fireBigFlippingGun` or `character.jumpUp`

### Creating an Event Handler

Event handlers will pass in the touches, event and the button itself to the method associated with the specific event.

```swift
func showTab(touches: Set<UITouch>, event: UIEvent?, target: SKSpriteButton) {
    guard let userData = target.userData else {
        return
    }

    target.setDisabledState(true)

    // do something with the user data

    // do some game code
}
```

## Toggle Group

You can group a set of buttons together so that when a single button it tapped, it toggles on and toggles off the remaining buttons.

### Example

```swift
let toggleGroup = SKSpriteButtonGroup()
toggleGroup.addButton(button1)
toggleGroup.addButton(button2)
```

__Note: Ensure buttons are in their correct toggle state when adding them to the group by using `setToggledOnState(Bool)`__

## Move Types

Set `moveType` property for different move types supported move types are:

```Swift
public enum MoveType {
    case alwaysHeld
    case releaseOut
    case releaseFast
    case reentry
}
```

The names should be self-explainatory. But still I put a screencast for different move type behaviors.

![Demo](./ios_demo.gif)

## Installation

Just copy the SKSpriteButton/Classes folder into your project and you are good to go.

## Author

Nader Eloshaiker, https://github.com/nader-eloshaiker

## License

SKSpriteButton is available under the MIT license. See the LICENSE file for more info.

## Contributors

hanjoes

nader-eloshaiker
