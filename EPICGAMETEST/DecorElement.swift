//
//  DecorElement.swift
//  EPICSWIFTGAME
//
//  Created by zephyz on 06/07/14.
//  Copyright (c) 2014 zephyz. All rights reserved.
//

import Foundation
import SpriteKit

class DecorElement: SKSpriteNode {

    var respawn: () -> Double
    init(image: String, respawnRate: () -> Double){
        respawn = respawnRate
        super.init(imageNamed: image)
    }
    
    func continuouslyRespawn(){
        self.runAction(SKAction.sequence([
            SKAction.waitForDuration(respawn()),
            SKAction.runBlock({
                
                })
            ]))
    }
}

func makeCloud(type: Int, respawnRate: () -> Double) -> DecorElement {
    return DecorElement(image: spriteFromIndex(type), {5.0 + Double(arc4random_uniform(4))})
}

func spriteFromIndex(i: Int) -> String {
    return "could" + i.description
}