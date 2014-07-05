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
    
}

func getSceneCenter(scene : SKScene) -> CGPoint {
    return CGPoint(x:scene.size.width * 0.5, y:scene.size.height * 0.5)
}

func createShip(image: String, scene: SKScene) -> Ship {
    let ship = Ship(imageNamed: image)
    ship.anchorPoint = CGPoint(x:0.5, y:0.5)
    ship.xScale = 0.15
    ship.yScale = 0.15
    ship.zRotation = CGFloat(PI * 0.5)
    ship.position = getSceneCenter(scene)
    ship.position.y *= 0.3
    
    scene.addChild(ship)
    return ship
}