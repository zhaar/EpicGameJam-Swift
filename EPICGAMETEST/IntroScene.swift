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
        self.addChild(bgSprite)
        labels = CompositeText(lines: lines, scene: self)
        
        bgSprite.runAction(SKAction.sequence(
            [SKAction.fadeAlphaTo(1, duration: fadeInDuration),
                SKAction.waitForDuration(displayDuration),
                SKAction.runBlock(
                    {println("running block");
                        self.labels.displayNext(1)}
                ),
                SKAction.fadeAlphaBy(-0.2, duration: 2)
            ]))
    }
    
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
        if bgSprite.alpha > 0.2 { bgSprite.runAction(SKAction.fadeAlphaBy(-0.2, duration: 2))}
        if !labels.displayNext(1) {
            endOfTextCallback(self.view)
        }
    }
}

func transitionner(view: SKView){
    let transition = SKTransition.revealWithDirection(SKTransitionDirection.Down, duration: 1)
    view.presentScene(GameScene.sceneWithSize(view.frame.size), transition: transition)
}

func level1Intro(size: CGSize) -> TextScene {
    return TextScene(size: size, bgName: "background_intro", textName: "script_intro", transitionner)
}

func level2Intro(size: CGSize) -> TextScene {
    return TextScene(size: size, bgName: "background_intro2", textName: "script_level2", transitionner)
}

func level2Story(size: CGSize) -> TextScene {
    return TextScene(size: size, bgName: "background_intro", textName: "script_story1", transitionner)
}