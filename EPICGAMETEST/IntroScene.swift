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


class IntroScene: SKScene {
    
    var time = NSTimeInterval(0)
    var labels: CompositeText!

    override func didMoveToView(view: SKView!) {
        
        let bg = SKSpriteNode(imageNamed: "background_intro")
        bg.anchorPoint = CGPointZero
        bg.position = CGPointZero
        self.addChild(bg)
        bg.alpha = 0
        
        bg.runAction(SKAction.sequence(
            [SKAction.fadeAlphaTo(1, duration: fadeInDuration),
            SKAction.waitForDuration(displayDuration),
            SKAction.fadeAlphaTo(0.0, duration: 10)]))
        
        
        let lines = loadText("script1")!

        labels = CompositeText(lines: lines, scene: self)
        labels.displayNext(1)
    }
    
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
        labels.displayNext(1)
    }
}