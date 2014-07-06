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

func makeCloud() -> SKSpriteNode {
    return SKSpriteNode(imageNamed: spriteFromIndex(Int(rand() % 2)))
}

func spriteFromIndex(i: Int) -> String {
    println("generating files \"cloud\(i.description)\"")
    return "could" + i.description
}