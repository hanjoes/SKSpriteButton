import SpriteKit
import Quick
import Nimble

@testable import SKSpriteButton

// MARK: - Constants

struct Something {
    static let CanSetMoveType = "can set moveType"
    static let CanSetTappedColor = "can set tapped color"
    static let CanSetTappedTexture = "can set tapped texture"
    static let CanSetDisabledColor = "can set disabled color"
    static let CanSetDisabledTexture = "can set disabled texture"
}

let MoveType = "moveType"
let TappedColor = "tappedColor"
let TappedTexture = "tappedTexture"
let DisabledColor = "disabledTexture"
let DisabledTexture = "disabledTexture"


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
        
        sharedExamples(Something.CanSetDisabledColor) {
            (sharedExampleContext: @escaping SharedExampleContext) in
            let disabledColor = sharedExampleContext()[DisabledColor] as? UIColor
            it("to \(String(describing: disabledColor))") {
                let button = SKSpriteButton()
                if let disabledColor = disabledColor {
                    button.disabledColor = disabledColor
                    expect(button.disabledColor) == disabledColor
                }
                else {
                    expect(button.disabledColor).to(beNil())
                }
            }
        }

        sharedExamples(Something.CanSetDisabledTexture) {
            (sharedExampleContext: @escaping SharedExampleContext) in
            let disabledTexture = sharedExampleContext()[DisabledTexture] as? SKTexture
            it("to \(String(describing: disabledTexture))") {
                let button = SKSpriteButton()
                if let disabledTexture = disabledTexture {
                    button.disabledTexture = disabledTexture
                    expect(button.disabledTexture) == disabledTexture
                }
                else {
                    expect(button.disabledTexture).to(beNil())
                }
            }
        }
    }
}

// MARK: - SKSpriteButtonSpec

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
            
            itBehavesLike(Something.CanSetDisabledColor) { [DisabledColor: UIColor.black] }
            itBehavesLike(Something.CanSetDisabledColor) { [DisabledColor: Optional<UIColor>.none as Any] }
            itBehavesLike(Something.CanSetDisabledTexture) { [DisabledTexture: SKTexture()] }
            itBehavesLike(Something.CanSetDisabledTexture) { [DisabledTexture: Optional<SKTexture>.none as Any] }
            
            context("when it has initial texture") {
                let initialTexture = SKTexture()
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
                
                context("when it has tapped texture") {
                    let tappedTexture = SKTexture()
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
            
            context("when disabled") {
                beforeEach {
                    button.disable()
                }
                
                it("is disabled") {
                    expect(button.disabled).to(beTrue())
                }
                
                it("can be reenabled") {
                    button.enable()
                    expect(button.disabled).to(beFalse())
                }
                
                it("cannot be interacted by user") {
                    expect(button.isUserInteractionEnabled).to(beFalse())
                }
                
                context("when it has disabled color") {
                    let disabledColor = UIColor.red
                    beforeEach {
                        button.disabledColor = disabledColor
                    }
                    
                    it("does not show disabled color if disable is not called") {
                        expect(button.color.isEquivalent(to: UIColor.black)).to(beTrue())
                    }
                    
                    it("shows disabled color when disabled explicitly") {
                        button.disable()
                        expect(button.color.isEquivalent(to: disabledColor)).to(beTrue())
                    }
                    
                    it("does not reflect change to color property immediately when disabled") {
                        button.disable()
                        let newNormalColor = UIColor.green
                        button.color = newNormalColor
                        expect(button.originalColor!.isEquivalent(to: newNormalColor)).to(beTrue())
                        expect(button.color.isEquivalent(to: disabledColor)).to(beTrue())
                    }
                    
                    it("reflect change to color property when enabled again") {
                        button.disable()
                        let newNormalColor = UIColor.green
                        button.color = newNormalColor
                        button.enable()
                        expect(button.originalColor!.isEquivalent(to: newNormalColor)).to(beTrue())
                        expect(button.color.isEquivalent(to: newNormalColor)).to(beTrue())
                    }
                    
                }
                
                context("when it has disabled texture") {
                    let disabledTexture = SKTexture()
                    beforeEach {
                        button.disabledTexture = disabledTexture
                    }
                    
                    it("does not show disabled texture if disable is called") {
                        button.disable()
                        expect(button.texture).to(beNil())
                    }
                    
                    context("when it has normal texture") {
                        let normalTexture = SKTexture()
                        beforeEach {
                            button.texture = normalTexture
                        }
                        
                        it("shows disabled texture even if disabled is not called") {
                            expect(button.texture) == disabledTexture
                        }
                        
                        it("shows disabled texture if disable is called") {
                            button.disable()
                            expect(button.texture) == disabledTexture
                        }
                        
                        it("shows normal texture if enable is called") {
                            button.enable()
                            expect(button.texture) == normalTexture
                        }
                    }
                    
                    
//                    it("shows disabled color when disabled explicitly") {
//                        button.disable()
//                        expect(button.color.isEquivalent(to: disabledColor)).to(beTrue())
//                    }
//
//                    it("does not reflect change to color property immediately when disabled") {
//                        button.disable()
//                        let newNormalColor = UIColor.green
//                        button.color = newNormalColor
//                        expect(button.originalColor!.isEquivalent(to: newNormalColor)).to(beTrue())
//                        expect(button.color.isEquivalent(to: disabledColor)).to(beTrue())
//                    }
//
//                    it("reflect change to color property when enabled again") {
//                        button.disable()
//                        let newNormalColor = UIColor.green
//                        button.color = newNormalColor
//                        button.enable()
//                        expect(button.originalColor!.isEquivalent(to: newNormalColor)).to(beTrue())
//                        expect(button.color.isEquivalent(to: newNormalColor)).to(beTrue())
//                    }
                    
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
