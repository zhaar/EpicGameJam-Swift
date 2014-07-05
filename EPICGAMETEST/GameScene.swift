//
//  GameScene.swift
//  EPICGAMETEST
//
//  Created by zephyz on 04/07/14.
//  Copyright (c) 2014 zephyz. All rights reserved.
//

import SpriteKit
import Foundation

@infix func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPointMake(left.x - right.x,
        left.y - right.y)
}

@infix func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPointMake(left.x + right.x,
        left.y + right.y)
}


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var firstTouch: CGPoint?
    var originalPosition: CGPoint?
    let ship: Ship = createShip("cruiser")
    
    // ------ Physics ------
    
    let missileCategory: UInt32 = 1 << 0
    //let shipCategory:    UInt32 = 1 << 1
    let monsterCategory: UInt32 = 1 << 2
    
    override func didMoveToView(view: SKView) {
        placeInScene(ship, self)
        
        /* --- Ship does not really need a physics body
        ship.physicsBody.categoryBitMask  = shipCategory
        ship.physicsBody.collisionBitMask = shipCategory
        */
        
        self.physicsWorld.gravity = CGVectorMake(0.0, 0.0)
        self.physicsWorld.contactDelegate = self
        
        for i in 0..3 {
            placeRandomMonster()
        }
        
        self.userInteractionEnabled = true
    }
    
    // ----- User interaction -----
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        var touch : UITouch! =  touches.anyObject() as UITouch;
        firstTouch = touch.locationInNode(self)
        
        println("Touched X: " + String(firstTouch!.x) + " and at Y : " + String(firstTouch!.y))
        
        originalPosition = ship.position
        ship.startShooting()
    }
    
    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!) {
        var touch : UITouch! =  touches.anyObject() as UITouch;
        var diff = touch.locationInNode(self) - firstTouch!
        ship.shootMissile()
        ship.position = diff + originalPosition!
    }
    
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
        ship.stopShooting()
    }
    
    // ----- Monster generation -----
    
    func placeRandomMonster() {
        // Get rand x
        let randX = arc4random() % UInt32(self.size.width)
        let randY = arc4random() % UInt32(self.size.height)
    
        println("RandX " + String(randX) + " : randY: " + String(randY))
        
        var randomPosition:CGPoint = CGPointMake(CGFloat(randX), CGFloat(randY))
        
        println("The random position is x:" + String(randomPosition.x) + " and y: " + String(randomPosition.y) )
        
        // Get random monster
        let randomMonsterIndex = (arc4random() % 6) + 1
        var randomMonsterSpriteName:String = "monster" + String(randomMonsterIndex)
        
        println("Random monster sprite name " + randomMonsterSpriteName)
        
        var randomMonster = SKSpriteNode(imageNamed: randomMonsterSpriteName)
        randomMonster.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(randomMonster.size.width, randomMonster.size.height))
        
        randomMonster.physicsBody.categoryBitMask = monsterCategory
        randomMonster.physicsBody.collisionBitMask = missileCategory
        randomMonster.physicsBody.contactTestBitMask = missileCategory
        
        randomMonster.xScale = 0.4;
        randomMonster.yScale = 0.4;
        
        randomMonster.position = randomPosition

        self.addChild(randomMonster)
    }
    
    // ----- Physics delegate methods -----
    
    func didBeginContact(contact: SKPhysicsContact!){
        
        var bodyA = contact.bodyA
        var bodyB = contact.bodyB
        
       // bodyA.node.removeFromParent()
        //bodyB.node.removeFromParent()
        
        // Detect Missile - Monster collision
        if (bodyA.categoryBitMask < bodyB.categoryBitMask){
            var temp = bodyA
            bodyA = bodyB
            bodyB = temp
        }
        
        if (bodyA.categoryBitMask == missileCategory && bodyB.categoryBitMask == monsterCategory ||
            bodyB.categoryBitMask == missileCategory && bodyA.categoryBitMask == monsterCategory ) {
            //TODO explode monsters
            var monster = bodyA.node
            monster.removeFromParent()
        }
    }
}
