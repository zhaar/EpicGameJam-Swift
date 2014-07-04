import Cocoa
import SpriteKit
import XCPlayground

let view:SKView = SKView(frame: CGRectMake(0, 0, 320, 586))

XCPShowView("Live view", view)

class Ship: SKSpriteNode {


    
}



let scene:SKScene = SKScene(size: CGSizeMake(320, 586))
scene.scaleMode = SKSceneScaleMode.AspectFit
scene.userInteractionEnabled = true


view.presentScene(scene)

func getSceneCenter(scene : SKScene) -> CGPoint {
    return CGPoint(x:scene.size.width * 0.5, y:scene.size.height * 0.5)
}

let ship = Ship(imageNamed: "/Users/zephyz/Documents/Projects/iOS/EPICGAMETEST/carrier.png")
ship.anchorPoint = CGPoint(x:0.5, y:0.5)
ship.xScale = 0.15
ship.yScale = 0.15
ship.zRotation = M_PI*0.5
ship.position = getSceneCenter(scene)
ship.position.y *= 0.3

scene.addChild(ship)

//let redBox:SKSpriteNode = SKSpriteNode(color: SKColor.redColor(), size:CGSizeMake(300, 300))
//redBox.position = CGPointMake(512, 384)
//redBox.runAction(SKAction.repeatActionForever(SKAction.rotateByAngle(20, duration: 2)))
//scene.addChild(redBox)
