//
//  Ship.swift
//  EPICSWIFTGAME
//
//  Created by zephyz on 04/07/14.
//  Copyright (c) 2014 zephyz. All rights reserved.
//

import Foundation
import SpriteKit
let PI = 3.1415926535

protocol ShipDelegate {
    func shipLaunchedMissile(sender: Ship, missile: SKSpriteNode)
}

class Ship: SKSpriteNode {
    
    var lastTimeRanUpdateLoop: NSTimeInterval = NSDate.timeIntervalSinceReferenceDate()
    /*
    @lazy var lastTimeRanUpdateLoop: NSTimeInterval = {
        return CFAbsoluteTimeGetCurrent()
    }()*/
    
    var isShooting = false
    var delegate:ShipDelegate?
    let laserSprite:SKSpriteNode = SKSpriteNode(imageNamed: "laser")
    
    func startShooting() {
        isShooting = true
    }
    
    func stopShooting(){
        isShooting = false
    }
    
    func shootMissile() {
        
        runAction(SKAction.playSoundFileNamed("laser_shooting_sfx.wav", waitForCompletion: false))
        var missileSprite = SKSpriteNode(imageNamed: "laser_munition")
        missileSprite.position = self.position
        missileSprite.anchorPoint = CGPointMake(0.5, 0.0)
        self.scene.addChild(missileSprite)
        
        missileSprite.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(missileSprite.size.width, missileSprite.size.height))

        missileSprite.physicsBody.categoryBitMask = missileCategory
        missileSprite.physicsBody.collisionBitMask = monsterCategory
        missileSprite.physicsBody.contactTestBitMask = monsterCategory
        missileSprite.physicsBody.pinned = false
        
        missileSprite.physicsBody.applyImpulse(CGVectorMake(0, 10))
        
        self.delegate?.shipLaunchedMissile(self, missile: missileSprite)
    }
    
    func update(currentTime: NSTimeInterval)
    {
        var deltaTime = currentTime - lastTimeRanUpdateLoop
        if (deltaTime > 0.1 && isShooting) {
            shootMissile()
            lastTimeRanUpdateLoop = NSDate.timeIntervalSinceReferenceDate()
        }
    }
}

func getSceneCenter(scene : SKScene) -> CGPoint {
    return CGPoint(x:scene.size.width * 0.5, y:scene.size.height * 0.5)
}

func createShip(image: String) -> Ship {
    let ship = Ship(imageNamed: image)

    ship.anchorPoint = CGPoint(x:0.5, y:0.5)
    let hitPoint = SKSpriteNode(imageNamed:"hitbox")
    hitPoint.position = CGPointMake(-6,-ship.size.height * 0.25)
    ship.xScale = 0.6
    ship.yScale = 0.6
    ship.addChild(hitPoint)
    
    ship.physicsBody = SKPhysicsBody(circleOfRadius: hitPoint.size.width/2, center: CGPointMake(-6,-ship.size.height * 0.25))
    
    ship.physicsBody.categoryBitMask = shipCategory
    ship.physicsBody.collisionBitMask = 0
    ship.physicsBody.contactTestBitMask = enemyProjectileCategory
    
    ship.anchorPoint = CGPoint(x:0.5, y:1.0)

    ship.color = SKColor.redColor()
    
    return ship
}

func placeInScene(ship: Ship, scene: SKScene) {
    ship.position = getSceneCenter(scene)
    ship.position.y *= 0.3
    
    scene.addChild(ship)
}


