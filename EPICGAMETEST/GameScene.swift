//
//  GameScene.swift
//  EPICGAMETEST
//
//  Created by zephyz on 04/07/14.
//  Copyright (c) 2014 zephyz. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    override func didMoveToView(view: SKView) {
        let ship = createShip("carrier", self)
        ship.name = "ship"
        self.userInteractionEnabled = true
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        println("Touch happened")
        
        var touch : UITouch! =  touches.anyObject() as UITouch;
        self.childNodeWithName("ship").position = touch.locationInNode(self)
        
        //CGPoint location = touch.locationInView(self.view)
        //self.childNodeWithName("ship").position = location
    }
    
    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!) {
        //print(event.description)
        
        
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
