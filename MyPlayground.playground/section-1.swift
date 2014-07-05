import Cocoa
import SpriteKit
import XCPlayground

let view:SKView = SKView(frame: CGRectMake(0, 0, 320, 586))

XCPShowView("Live view", view)


class Ship: SKSpriteNode {

}

class PrototypeScene: SKScene {

    func getSceneCenter() -> CGPoint {
        return CGPoint(x:self.size.width * 0.5, y:self.size.height * 0.5)
    }
    
    override func didMoveToView(view: SKView) {
        let ship = Ship(imageNamed: "/Users/admin/Developer/GameDev/EpicGameJam-Swift/carrier.png")
        ship.anchorPoint = CGPoint(x:0.5, y:0.5)
        ship.xScale = 0.15
        ship.yScale = 0.15
        ship.zRotation = M_PI*0.5
        ship.position = getSceneCenter()
        ship.position.y *= 0.3
        
        self.addChild(ship)
        self.userInteractionEnabled = true
        
    }
    
    override func touchesBeganWithEvent(event: NSEvent!)
    {
        println("Hello touches")
        
    }
    
    override func touchesEndedWithEvent(event: NSEvent!)
    {
        println("Touch ended with event")
    }
}

let scene:PrototypeScene = PrototypeScene(size: CGSizeMake(320, 586))
scene.scaleMode = SKSceneScaleMode.AspectFit

view.presentScene(scene)

//let redBox:SKSpriteNode = SKSpriteNode(color: SKColor.redColor(), size:CGSizeMake(300, 300))
//redBox.position = CGPointMake(512, 384)
//redBox.runAction(SKAction.repeatActionForever(SKAction.rotateByAngle(20, duration: 2)))
//scene.addChild(redBox)
