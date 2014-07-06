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
    
}

func makeCloud() -> SKSpriteNode {
    let cloud = SKSpriteNode(imageNamed: spriteFromIndex(Int(rand() % 2) + 1))
    cloud.xScale = 0.4
    cloud.yScale = 0.4
    cloud.alpha = 0.4
    return cloud
}

func spriteFromIndex(i: Int) -> String {
    return "cloud" + i.description
}