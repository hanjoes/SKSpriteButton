import SpriteKit
import Quick
import Nimble

@testable import SKSpriteButton

// MARK: - Constants

struct Something {
    static let CanSetMoveType = "can set moveType"
    static let CanSetTappedColor = "can set tapped color"
    static let CanSetTappedTexture = "can set tapped texture"
}

let MoveType = "moveType"
let TappedColor = "tappedColor"
let TappedTexture = "tappedTexture"

// MARK: - Shared Examples

class SKSpriteButtonTestConfiguration: QuickConfiguration {
    override class func configure(_ configuration: Configuration) {
        sharedExamples(Something.CanSetMoveType) {
            (sharedExampleContext: @escaping SharedExampleContext) in
            let moveType = sharedExampleContext()[MoveType] as! SKSpriteButton.MoveType
            it("to \(moveType)") {
                let button = SKSpriteButton()
                button.moveType = moveType
                expect(button.moveType) == moveType
            }
        }
        
        sharedExamples(Something.CanSetTappedColor) {
            (sharedExampleContext: @escaping SharedExampleContext) in
            let tappedColor = sharedExampleContext()[TappedColor] as? UIColor
            it("to \(String(describing: tappedColor))") {
                let button = SKSpriteButton()
                if let tappedColor = tappedColor {
                    button.tappedColor = tappedColor
                    expect(button.tappedColor) == tappedColor
                }
                else {
                    expect(button.tappedColor).to(beNil())
                }
            }
        }
        
        sharedExamples(Something.CanSetTappedTexture) {
            (sharedExampleContext: @escaping SharedExampleContext) in
            let tappedTexture = sharedExampleContext()[TappedTexture] as? SKTexture
            it("to \(String(describing: tappedTexture))") {
                let button = SKSpriteButton()
                if let tappedTexture = tappedTexture {
                    button.tappedTexture = tappedTexture
                    expect(button.tappedTexture) == tappedTexture
                }
                else {
                    expect(button.tappedTexture).to(beNil())
                }
            }
        }

    }
}

// MARK: - SKSpriteButton Spec

class SKSpriteButtonSpec: QuickSpec {
    
    override func spec() {
        // MARK: - General
        describe("a SKSpriteButton") {
            var button: SKSpriteButton!
            var beganCalled = 0
            var upCalled = 0
            var movedCalled = 0
            var cancelledCalled = 0
            
            beforeEach {
                button = SKSpriteButton(texture: nil, color: UIColor.black, size: CGSize.zero)
                
                beganCalled = 0
                let touchesBegan: SKSpriteButton.EventHandler = {
                    (_, _) in
                    beganCalled += 1
                }
                button.addTouchesBeganHandler(handler: touchesBegan)
                
                upCalled = 0
                let touchesUp: SKSpriteButton.EventHandler = {
                    (_, _) in
                    upCalled += 1
                }
                button.addTouchesUpHandler(handler: touchesUp)
                
                movedCalled = 0
                let touchesMoved: SKSpriteButton.EventHandler = {
                    (_, _) in
                    movedCalled += 1
                }
                button.addTouchesMovedHandler(handler: touchesMoved)
                
                cancelledCalled = 0
                let touchesCancelled: SKSpriteButton.EventHandler = {
                    (_, _) in
                    cancelledCalled += 1
                }
                button.addTouchesCancelledHandler(handler: touchesCancelled)
            }
            
            it("is an SKNode") {
                expect(button).to(beAKindOf(SKSpriteButton.self))
            }
            
            it("has .normal as default status after creation") {
                expect(button.status) == SKSpriteButton.Status.normal
            }
            
            it("has .alwaysHeld as default move type") {
                expect(button.moveType) == SKSpriteButton.MoveType.alwaysHeld
            }
            
            it("doesn't have tappedColor or tappedTexture when created") {
                expect(button.tappedColor).to(beNil())
                expect(button.tappedTexture).to(beNil())
            }
            
            it("can invoke touchesBeganHandler") {
                expect(beganCalled) == 0
                button.touchesBegan(Set<UITouch>(), with: nil)
                expect(beganCalled) == 1
            }
            
            it("won't invoke touchesUpHandler if not tapped") {
                expect(upCalled) == 0
                button.touchesEnded(Set<UITouch>(), with: nil)
                expect(upCalled) == 0
            }
            
            it("can invoke touchesUpHandler when touch ended") {
                button.touchesBegan(Set<UITouch>(), with: nil)
                expect(upCalled) == 0
                button.touchesEnded(Set<UITouch>(), with: nil)
                expect(upCalled) == 1
            }
            
            it("can invoke touchesMovedHandler") {
                expect(movedCalled) == 0
                button.touchesMoved(Set<UITouch>(), with: nil)
                expect(movedCalled) == 1
            }
            
            it("won't invoke touchesCancelledHandler if not tapped") {
                expect(cancelledCalled) == 0
                button.touchesCancelled(Set<UITouch>(), with: nil)
                expect(cancelledCalled) == 0
            }
            
            it("can invoke touchesCancelledHandler when touch cancelled") {
                button.touchesBegan(Set<UITouch>(), with: nil)
                expect(cancelledCalled) == 0
                button.touchesCancelled(Set<UITouch>(), with: nil)
                expect(cancelledCalled) == 1
            }
            
            it("sets status to tapped when tapped") {
                button.touchesBegan(Set<UITouch>(), with: nil)
                expect(button.status) == SKSpriteButton.Status.tapped
            }
            
            it("sets status to normal when released") {
                button.touchesBegan(Set<UITouch>(), with: nil)
                button.touchesCancelled(Set<UITouch>(), with: nil)
                expect(button.status) == SKSpriteButton.Status.normal
            }
            
            itBehavesLike(Something.CanSetMoveType) { [MoveType: SKSpriteButton.MoveType.reentry] }
            itBehavesLike(Something.CanSetMoveType) { [MoveType: SKSpriteButton.MoveType.alwaysHeld] }
            itBehavesLike(Something.CanSetMoveType) { [MoveType: SKSpriteButton.MoveType.releaseFast] }
            itBehavesLike(Something.CanSetMoveType) { [MoveType: SKSpriteButton.MoveType.releaseOut] }

            itBehavesLike(Something.CanSetTappedColor) { [TappedColor: UIColor.black] }
            itBehavesLike(Something.CanSetTappedColor) { [TappedColor: Optional<UIColor>.none as Any] }
            itBehavesLike(Something.CanSetTappedTexture) { [TappedTexture: SKTexture()] }
            itBehavesLike(Something.CanSetTappedTexture) { [TappedTexture: Optional<SKTexture>.none as Any] }
            
            context("when it has initial texture") {
                let initialTexture = SKTexture()
                let tappedTexture = SKTexture()
                beforeEach { button.texture = initialTexture }
                
                context("when it does not have tapped texture") {
                    it("does not change texture when tapped") {
                        button.touchesBegan(Set<UITouch>(), with: nil)
                        expect(button.texture) === initialTexture
                    }
                    
                    it("does not change texture when released") {
                        button.touchesBegan(Set<UITouch>(), with: nil)
                        expect(button.texture) === initialTexture
                    }
                }
                
                context("when has tapped texture") {
                    beforeEach { button.tappedTexture = tappedTexture }
                    
                    it("it changes texture if tapped") {
                        button.touchesBegan(Set<UITouch>(), with: nil)
                        expect(button.texture) === tappedTexture
                    }
                    
                    it("it resets texture if released") {
                        button.touchesBegan(Set<UITouch>(), with: nil)
                        button.touchesEnded(Set<UITouch>(), with: nil)
                        expect(button.texture) === initialTexture
                    }
                }
            }
            
            context("when it does not use texture") {
                let tappedTexture = SKTexture()
                context("when it does not have tapped texture") {
                    it("does not change texture") {
                        expect(button.texture).to(beNil())
                        button.touchesBegan(Set<UITouch>(), with: nil)
                        expect(button.texture).to(beNil())
                    }
                }
                
                context("when has tapped texture") {
                    beforeEach { button.tappedTexture = tappedTexture }
                    it("does not change texture") {
                        expect(button.texture).to(beNil())
                        button.touchesBegan(Set<UITouch>(), with: nil)
                        expect(button.texture).to(beNil())
                    }
                }
            }
            
            context("when it has tapped color") {
                beforeEach { button.tappedColor = UIColor.white }
                it("uses tapped color if tapped") {
                    button.touchesBegan(Set<UITouch>(), with: nil)
                    expect(button.color.isEquivalent(to: UIColor.white)).to(beTrue())
                }
                
                it("uses normal color if released") {
                    button.touchesBegan(Set<UITouch>(), with: nil)
                    button.touchesEnded(Set<UITouch>(), with: nil)
                    expect(button.color.isEquivalent(to: UIColor.black)).to(beTrue())
                }
            }
            
            context("when it does not have tapped color") {
                it("uses normal color if tapped") {
                    button.touchesBegan(Set<UITouch>(), with: nil)
                    expect(button.color.isEquivalent(to: UIColor.black)).to(beTrue())
                }
                
                it("uses normal color if released") {
                    button.touchesBegan(Set<UITouch>(), with: nil)
                    button.touchesEnded(Set<UITouch>(), with: nil)
                    expect(button.color.isEquivalent(to: UIColor.black)).to(beTrue())
                }
            }
            
            
            // MARK: - Different MoveTypes
            describe("handles events") {
                
                // MARK: .alwaysHeld
                context("when moveType is alwaysHeld") {
                    beforeEach {
                        button.moveType = SKSpriteButton.MoveType.alwaysHeld
                    }

                    it("keeps tapped when touch moved anywhere") {
                        button.size = CGSize(width: 10, height: 10)
                        button.touchesBegan(Set<UITouch>(), with: nil)
                        let touchInside = SKSpriteButtonTouch()
                        touchInside.customLocation = CGPoint(x: 5, y: 5)
                        let touchOutside = SKSpriteButtonTouch()
                        touchOutside.customLocation = CGPoint(x: 20, y: 20)

                        button.touchesMoved([touchInside] as Set<UITouch>, with: nil)
                        expect(button.status) == SKSpriteButton.Status.tapped

                        button.touchesMoved([touchOutside] as Set<UITouch>, with: nil)
                        expect(button.status) == SKSpriteButton.Status.tapped
                    }
                }
                
                // MARK: .releaseFast
                context("when moveType is releaseFast") {
                    beforeEach {
                        button.moveType = SKSpriteButton.MoveType.releaseFast
                    }
                    
                    it("resets to normal as long as we moved") {
                        button.size = CGSize(width: 10, height: 10)
                        button.touchesBegan(Set<UITouch>(), with: nil)
                        let touch = SKSpriteButtonTouch()
                        touch.customLocation = CGPoint(x: 1, y: 1)
                        
                        button.touchesMoved([touch] as Set<UITouch>, with: nil)
                        expect(button.status) == SKSpriteButton.Status.normal
                    }
                }
                
                // MARK: .releaseOut
                context("when moveType is releaseOut") {
                    beforeEach {
                        button.moveType = SKSpriteButton.MoveType.releaseOut
                    }
                    
                    it("resets to normal and keeps untapped once we moved outside") {
                        button.size = CGSize(width: 10, height: 10)
                        button.touchesBegan(Set<UITouch>(), with: nil)
                        let touchInside = SKSpriteButtonTouch()
                        touchInside.customLocation = CGPoint(x: 1, y: 1)
                        let touchOutside = SKSpriteButtonTouch()
                        touchOutside.customLocation = CGPoint(x: 20, y: 20)
                        
                        button.touchesMoved([touchInside] as Set<UITouch>, with: nil)
                        expect(button.status) == SKSpriteButton.Status.tapped
                        
                        button.touchesMoved([touchOutside] as Set<UITouch>, with: nil)
                        expect(button.status) == SKSpriteButton.Status.normal
                        
                        button.touchesMoved([touchInside] as Set<UITouch>, with: nil)
                        expect(button.status) == SKSpriteButton.Status.normal
                    }
                }
                
                // MARK: .reentry
                context("when moveType is reentry") {
                    beforeEach {
                        button.moveType = SKSpriteButton.MoveType.reentry
                    }

                    it("can invoke different eventHandlers when moved inside and outside") {
                        button.size = CGSize(width: 10, height: 10)
                        
                        expect(beganCalled) == 0
                        expect(upCalled) == 0
                        button.touchesBegan(Set<UITouch>(), with: nil)
                        expect(beganCalled) == 1
                        
                        let touchInside = SKSpriteButtonTouch()
                        touchInside.customLocation = CGPoint(x: 1, y: 1)
                        let touchOutside = SKSpriteButtonTouch()
                        touchOutside.customLocation = CGPoint(x: 20, y: 20)
                        
                        button.touchesMoved([touchInside] as Set<UITouch>, with: nil)
                        expect(upCalled) == 0
                        button.touchesMoved([touchOutside] as Set<UITouch>, with: nil)
                        expect(upCalled) == 1
                        button.touchesMoved([touchInside] as Set<UITouch>, with: nil)
                        expect(beganCalled) == 2
                        button.touchesMoved([touchOutside] as Set<UITouch>, with: nil)
                        expect(upCalled) == 2
                    }
                    
                    it("becomes normal when moved outside and becomes tapped when moved inside") {
                        button.size = CGSize(width: 10, height: 10)
                        button.touchesBegan(Set<UITouch>(), with: nil)
                        let touchInside = SKSpriteButtonTouch()
                        touchInside.customLocation = CGPoint(x: 1, y: 1)
                        let touchOutside = SKSpriteButtonTouch()
                        touchOutside.customLocation = CGPoint(x: 20, y: 20)
                        
                        button.touchesMoved([touchInside] as Set<UITouch>, with: nil)
                        expect(button.status) == SKSpriteButton.Status.tapped
                        
                        button.touchesMoved([touchOutside] as Set<UITouch>, with: nil)
                        expect(button.status) == SKSpriteButton.Status.normal
                        
                        button.touchesMoved([touchInside] as Set<UITouch>, with: nil)
                        expect(button.status) == SKSpriteButton.Status.tapped
                    }
                }
            }
        }
    }
}
