# SKSpriteButton

[![CI Status](http://img.shields.io/travis/hanjoes/SKSpriteButton.svg?style=flat)](https://travis-ci.org/hanjoes/SKSpriteButton)
[![Version](https://img.shields.io/cocoapods/v/SKSpriteButton.svg?style=flat)](http://cocoapods.org/pods/SKSpriteButton)
[![License](https://img.shields.io/cocoapods/l/SKSpriteButton.svg?style=flat)](http://cocoapods.org/pods/SKSpriteButton)
[![Platform](https://img.shields.io/cocoapods/p/SKSpriteButton.svg?style=flat)](http://cocoapods.org/pods/SKSpriteButton)

## Info

SKSpriteButton is something obvious but somehow missing from the official SpriteKit library. 

## Usage 

This library should be very straightforward to use.

### Color

Set `tappedColor` property for a different display color when tapped. 

Since this widget inherits from SKSpriteNode, which will only show texture if both `texture` and `color` are set. `tappedColor` will not be shown if the button has a texture.

### Texture

Set `tappedTexture` property for displaying a different texture when tapped.

### Move Types

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

### More

There is no more, check `SKSpriteButton.swift` for public APIs.

## Example

I've built a simple example project to elaborate on how to use this widget. The example project shows how "move types" differ from each other.

To run the example project, clone the repo, and run `pod install` from the Example directory first.

__Note:__ I've actually included all files needed to compile the project in the git repo. You should be able to run the example even without `pod install`.

## Requirements

## Installation

SKSpriteButton is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SKSpriteButton'
```

## Author

hanjoes, hanzhou87@gmail.com

## License

SKSpriteButton is available under the MIT license. See the LICENSE file for more info.

## Contributors

hanjoes

nader-eloshaiker
