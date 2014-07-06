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

    
    func hit(){
        hitPoints = hitPoints - 1
        
        if (hitPoints > 0) {
            gotHit()
        } else if ( hitPoints == 0)
        {
            explode()
        }
    }
    
    func shootInDirection(directionVector :CGVector){
        
        var projectile = SKSpriteNode(imageNamed: "dead3")
        projectile.position = self.position
        
        projectile.physicsBody = SKPhysicsBody(circleOfRadius: 20.0)
        
        projectile.physicsBody.categoryBitMask = enemyProjectileCategory
        projectile.physicsBody.collisionBitMask = 0
        projectile.physicsBody.contactTestBitMask = enemyProjectileCategory
        
        self.scene.addChild(projectile)
        
        projectile.physicsBody.applyImpulse(directionVector)

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
    return makeEnemy(withIndex: 2)
}

func makeEnemy(withIndex i:Int) -> Enemy {
    let e = Enemy(imageNamed: "monster" + i.description)
    e.hitPoints = getHpForIndex(i)
    
    e.physicsBody = SKPhysicsBody(rectangleOfSize: e.size)

    let p = e.physicsBody
    p.categoryBitMask = monsterCategory
    p.collisionBitMask = 0
    p.contactTestBitMask = missileCategory
    p.mass = CGFloat(0)
    p.linearDamping = CGFloat(0)

    e.xScale = 0.4;
    e.yScale = 0.4;

    return e
}

func getHpForIndex(index: Int) -> Int{
    switch index {
    case 0, 1, 2, 3, 4, 5: return 10
    default: return 20
    }
}

func makeRandomEnemy() -> Enemy {
    return makeEnemy(withIndex: Int(rand() % 6) + 1)

}