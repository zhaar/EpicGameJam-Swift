//
//  Enemy.swift
//  EPICSWIFTGAME
//
//  Created by Tibor Udvari on 05/07/14.
//  Copyright (c) 2014 zephyz. All rights reserved.
//

import Foundation
import SpriteKit

class Enemy : SKSpriteNode {
    
    // TODO create initializer with -> image; and hitsToKill
    
    var hitPoints: Int {
        get {
            return self.hitPoints
        }
        set(hitsToDie) {
            self.hitPoints = hitsToDie
            if (hitsToDie > 0) { gotHit() } else { explode() }
        }
    }
    
    func hit(){
        hitPoints = hitPoints - 1
    }

    func gotHit() {
        // Maybe a little particle particle
        // Lil' sound effect
        
        runAction(SKAction.playSoundFileNamed("Death6.wav", waitForCompletion: false))
    }
    
    
    func explode() {
        
        
        // Create explosion 
        // Play an explosion sound
    }
    
    
}