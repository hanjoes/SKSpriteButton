import Quick
import Nimble

@testable import SKSpriteButton

// MARK: - SKSpriteButtonGroupSpec

class SKSpriteButtonGroupSpec: QuickSpec {
    override func spec() {
        describe("a SKSpriteButtonGroup") {
            var group: SKSpriteButtonGroup!
            
            beforeEach {
                group = SKSpriteButtonGroup()
            }
            
            it("contains nothing when created") {
                expect(group.buttons).to(beEmpty())
            }
            
            it("contains buttons added by user") {
                let button1 = SKSpriteButton()
                let button2 = SKSpriteButton()
                group.add(button: button1)
                group.add(button: button2)
                
                expect(group.buttons.count) == 2
                expect(group.buttons.contains(button1)).to(beTrue())
                expect(group.buttons.contains(button2)).to(beTrue())
            }
            
            it("can remove added button") {
                let button1 = SKSpriteButton()
                let button2 = SKSpriteButton()
                group.add(button: button1)
                group.add(button: button2)
                group.remove(button: button1)
                
                expect(group.buttons.count) == 1
                expect(group.buttons.contains(button2)).to(beTrue())
            }
            
            it("is noop when removing button not added") {
                let button1 = SKSpriteButton()
                let button2 = SKSpriteButton()
                group.add(button: button1)
                group.remove(button: button2)
                
                expect(group.buttons.count) == 1
            }
        }
    }
}

