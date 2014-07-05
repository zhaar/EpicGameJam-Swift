//
//  Enemy.swift
//  EPICSWIFTGAME
//
//  Created by Tibor Udvari on 05/07/14.
//  Copyright (c) 2014 zephyz. All rights reserved.
//

import Foundation
import SpriteKit

protocol EnemyDelegate {
    func enemyDidExplode(sender: Enemy)
}

class Enemy : SKSpriteNode {
    
    var delegate : EnemyDelegate?
    var hitPoints:Int = 20

//    init(name: String, maxHitPoints:Int){
//        hitPoints = maxHitPoints
//        super.init(imageNamed: name)
//    }
    
    func hit(){
        hitPoints = hitPoints - 1
        if hitPoints < 0 {
            explode()
        }
    }

    func gotHit() {
        runAction(SKAction.playSoundFileNamed("Death4.wav", waitForCompletion: false))
    }
    
    func explode() {
        self.delegate?.enemyDidExplode(self)
        
        // ---  Play sound ---
       var actions = [
        SKAction.playSoundFileNamed("Death6.wav", waitForCompletion: false),
        SKAction.runBlock({
            var emitterNode:SKEmitterNode = NSKeyedUnarchiver.unarchiveObjectWithFile(NSBundle.mainBundle().pathForResource("Explosion", ofType: "sks")) as SKEmitterNode
            
            emitterNode.name = "emitter"
            self.addChild(emitterNode)
            
            }),
        SKAction.waitForDuration(0.2),
        SKAction.runBlock({
            self.childNodeWithName("emitter").removeFromParent()
            self.removeFromParent()
            })
        ]
        runAction(SKAction.sequence(actions))
    }
}

func makeSquidEnemy() -> Enemy {
    let e = Enemy(imageNamed: "monster2")
    e.hitPoints = 10
    return e
}