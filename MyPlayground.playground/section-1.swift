import Cocoa
import SpriteKit
import XCPlayground

let view:SKView = SKView(frame: CGRectMake(0, 0, 1024, 768))

XCPShowView("Live view", view)

let scene:SKScene = SKScene(size: CGSizeMake(1024, 768))
scene.scaleMode = SKSceneScaleMode.AspectFit
view.presentScene(scene)

let text = CompositeText()
scene.addChild(redBox)