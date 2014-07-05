//
//  IntroScene.swift
//  EPICSWIFTGAME
//
//  Created by zephyz on 05/07/14.
//  Copyright (c) 2014 zephyz. All rights reserved.
//

import Foundation
import SpriteKit

let fadeInDuration = NSTimeInterval(3)
let displayDuration = NSTimeInterval(1)
var animationDuration = fadeInDuration + displayDuration
let introText = "The dawn of our civilisation is upon us."


//class IntroScene: SKScene {
//    
//    var labels: CompositeText!
//
//    override func didMoveToView(view: SKView!) {
//        
//        let bg = SKSpriteNode(imageNamed: "background_intro")
//        bg.anchorPoint = CGPointZero
//        bg.position = CGPointZero
//        self.addChild(bg)
//        bg.alpha = 0
//        
//        bg.runAction(SKAction.sequence(
//            [SKAction.fadeAlphaTo(1, duration: fadeInDuration),
//            SKAction.waitForDuration(displayDuration),
//            SKAction.fadeAlphaTo(0.0, duration: 10)]))
//        
//        
//        let lines = loadText("script1")!
//
//        labels = CompositeText(lines: lines, scene: self)
//        labels.displayNext(1)
//    }
//    
//    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
//        labels.displayNext(1)
//    }
//}


class TextScene: SKScene {
    
    var labels: CompositeText!
    var textName: String
    var endOfTextCallback: (SKView) -> ()
    var bgSprite: SKSpriteNode

    init(size: CGSize, bgName: String, textName: String, endOfTextCallback: (SKView)->()){
        self.textName = textName
        self.endOfTextCallback = endOfTextCallback
        bgSprite = SKSpriteNode(imageNamed: bgName)
        bgSprite.anchorPoint = CGPointZero
        bgSprite.position = CGPointZero
        bgSprite.alpha = 0

        super.init(size: size)
    }
    
    override func didMoveToView(view: SKView!) {
        let lines = loadText(textName)!
        labels = CompositeText(lines: lines, scene: self)
        
        self.addChild(bgSprite)
        bgSprite.runAction(SKAction.sequence(
            [SKAction.fadeAlphaTo(1, duration: fadeInDuration),
                SKAction.waitForDuration(displayDuration),
                SKAction.runBlock(
                    {println("running block");
                        self.labels.displayNext(1)}
                ),
                SKAction.fadeAlphaTo(0, duration: 10)
            ]))
//        self.runAction(SKAction.sequence([
//            SKAction.waitForDuration(animationDuration),
//            SKAction.runBlock({self.labels.displayNext(1)})]))
    }
    
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
        if !labels.displayNext(1) {
            endOfTextCallback(self.view)
        }
    }
}

func makeIntroScene(size: CGSize) -> TextScene {
    return TextScene(size: size, bgName: "background_intro", textName: "script_intro", {(view: SKView) in view.presentScene(GameScene.sceneWithSize(view.frame.size))})
}