//
//  File.swift
//  EPICSWIFTGAME
//
//  Created by zephyz on 05/07/14.
//  Copyright (c) 2014 zephyz. All rights reserved.
//

import Foundation
import SpriteKit

class CompositeText: SKNode{
    
    var labels : SKLabelNode[] = []
    var currentIndex = 0
    
    init(lines: String[], scene: SKScene){
        super.init()
        var labelWithLine = labelMaker(15, "Courier", 30, Int(scene.size.height * 0.9), scene )
        for l in lines {
            labels += labelWithLine(text: l)
        }
        for l2 in labels {
            l2.alpha = 0;
            println("text: \(l2.text), x: \(l2.position.x), y: \(l2.position.y)")
            scene.addChild(l2)
        }
    }
    
    func displayNext(fade: NSTimeInterval) -> Bool{
        if currentIndex < labels.count {
            labels[currentIndex].runAction(SKAction.fadeAlphaTo(1, duration: fade))
            if ++currentIndex < labels.count {
                if labels[currentIndex].text.hasSuffix(".") {
                    return displayNext(fade)
                }
            }
            return true
        }else{ return false }
    }
    
    func displayAll(timeOffset: NSTimeInterval, duration: NSTimeInterval){
        println("displaying line \(labels[currentIndex])")
        self.runAction(SKAction.sequence([
            SKAction.waitForDuration(timeOffset),
            SKAction.runBlock({self.displayNext(duration);
                self.displayAll(timeOffset, duration: duration)})]))
    }

}

func counter(initialCount: Int, limit: Int, sideEffect: (Int) -> ()) -> () -> (){
    var c = 0
    return {
        if c < limit {sideEffect(c++)}
    }
}

func labelMaker(fontSize: Int, fontName: String, yOffset:Int, startPosition: Int, scene:SKScene) -> (text:String) -> SKLabelNode{
    var i = 0;
    func f(line: String) -> SKLabelNode{
        let l:SKLabelNode = SKLabelNode(text: line)
        l.fontSize = CGFloat(fontSize)
        l.fontName = fontName
        l.position.x = scene.size.width * 0.5
        l.position.y = CGFloat(startPosition - i++ * yOffset)
        return l
    }
    return f
}