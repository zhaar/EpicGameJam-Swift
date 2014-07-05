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

class Ship: SKSpriteNode {
    
    // ------ Physics ------
    
    let missileCategory: UInt32 = 1 << 0
    let shipCategory:    UInt32 = 1 << 1
    let monsterCategory: UInt32 = 1 << 2
    
    var isShooting = false
    let laserSprite:SKSpriteNode = SKSpriteNode(imageNamed: "laser")
    
    func startShooting() {
        isShooting = true

        laserSprite.yScale = 200
        //self.addChild(laserSprite)
    }
    
    func stopShooting(){
        isShooting = false
    }
    
    func shootMissile() {
        var missileSprite = SKSpriteNode(imageNamed: "laser_munition")
        missileSprite.position = self.position
        self.scene.addChild(missileSprite)
        
        missileSprite.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(missileSprite.size.width, missileSprite.size.height))

        missileSprite.physicsBody.categoryBitMask = missileCategory
        missileSprite.physicsBody.collisionBitMask = monsterCategory
        missileSprite.physicsBody.contactTestBitMask = monsterCategory
        
        missileSprite.physicsBody.applyImpulse(CGVectorMake(0, 10))
    }
//    
//    func createLaser(scene: SKScene) {
//        laserSprite = Laser(imageNamed: "laser")
//        laserSprite.anchorPoint = CGPointMake(0.5, 0.0)
//        laserSprite.position = CGPointMake(self.size.width * 0.5, 0.0)
//        laserSprite.size.height = scene.size.height * 2
//        self.addChild(laserSprite)
//    }
    
}

func getSceneCenter(scene : SKScene) -> CGPoint {
    return CGPoint(x:scene.size.width * 0.5, y:scene.size.height * 0.5)
}

func createShip(image: String) -> Ship {
    let ship = Ship(imageNamed: image)
    ship.anchorPoint = CGPoint(x:0.5, y:0.5)
    ship.xScale = 0.15
    ship.yScale = 0.15
    ship.zRotation = CGFloat(PI * 0.5)
    
    return ship
}

func placeInScene(ship: Ship, scene: SKScene) {
    ship.position = getSceneCenter(scene)
    ship.position.y *= 0.3
    
    scene.addChild(ship)
}