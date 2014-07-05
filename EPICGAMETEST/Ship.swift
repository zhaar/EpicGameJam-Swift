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
    
    var isShooting = false
    var laserSprite:Laser!
    
    func startShooting() {
        isShooting = true
        laserSprite.alpha = 1
    }
    
    func stopShooting(){
        isShooting = false
        laserSprite.alpha = 0
    }
    
    func createLaser(scene: SKScene) {
        laserSprite = Laser(imageNamed: "laser")
        laserSprite.anchorPoint = CGPointMake(0.5, 0.0)
        laserSprite.position = CGPointMake(self.size.width * 0.5, 0.0)
        laserSprite.size.height = scene.size.height * 2
        self.addChild(laserSprite)
    }
    
}

func getSceneCenter(scene : SKScene) -> CGPoint {
    return CGPoint(x:scene.size.width * 0.5, y:scene.size.height * 0.5)
}

func createShip(image: String) -> Ship {
    let ship = Ship(imageNamed: image)
    ship.anchorPoint = CGPoint(x:0.5, y:0.5)
    ship.xScale = 0.36
    ship.yScale = 0.36
    return ship
}

func placeInScene(ship: Ship, scene: SKScene) {
    ship.position = getSceneCenter(scene)
    ship.position.y *= 0.3
    ship.createLaser(scene)
    scene.addChild(ship)
}