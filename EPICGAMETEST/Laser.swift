//
//  Laser.swift
//  EPICSWIFTGAME
//
//  Created by Tibor Udvari on 05/07/14.
//  Copyright (c) 2014 zephyz. All rights reserved.
//

import SpriteKit

class Laser : SKSpriteNode {
    
}

func createLaser() -> Laser {
    let laserSprite = Laser(imageNamed: )
    laserSprite.anchorPoint = CGPointMake(0.0, 0.5)
    laserSprite.position = CGPointMake(self.size.width * 0.5, 0.0)
    
    laserSprite.xScale = 200
    
}
