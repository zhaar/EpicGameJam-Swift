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
let introText = "The dawn of our civilisation is upon us."

class IntroScene: SKScene {
    func gotoGame(){
        self.view.presentScene(GameScene())
    }

    override func didMoveToView(view: SKView!) {
        
        println()
        let bg = SKSpriteNode(imageNamed: "background_intro")
        bg.anchorPoint = CGPointZero
        bg.position = CGPointZero
        self.addChild(bg)
        bg.alpha = 0
        
        bg.runAction(SKAction.sequence(
            [SKAction.fadeAlphaTo(1, duration: fadeInDuration),
            SKAction.waitForDuration(displayDuration),
            SKAction.fadeAlphaTo(0.5, duration: 2)]))
//        bg.runAction(SKAction.waitForDuration(2))
//        bg.runAction(SKAction.fadeAlphaTo(0.5, duration: 2))
        
        let firstLine = SKLabelNode(text: "hello")
        firstLine.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.9)
        firstLine.fontSize = 15
        firstLine.alpha = 0
        firstLine.runAction(SKAction.sequence([
            SKAction.waitForDuration(fadeInDuration + displayDuration),
            SKAction.fadeAlphaTo(1, duration: 2)]))
        firstLine.fontName = "Courier"
        self.addChild(firstLine)
    }

}
