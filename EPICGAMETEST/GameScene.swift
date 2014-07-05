//
//  GameScene.swift
//  EPICGAMETEST
//
//  Created by zephyz on 04/07/14.
//  Copyright (c) 2014 zephyz. All rights reserved.
//

import SpriteKit

@infix func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPointMake(left.x - right.x,
        left.y - right.y)
}

@infix func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPointMake(left.x + right.x,
        left.y + right.y)
}

@infix func infixOperate<T>(left: T, right: T, f: (T, T) ->T ) -> T {
    return f(left, right)
}

class GameScene: SKScene {
    
    var firstTouch: CGPoint?
    var originalPosition: CGPoint?
    
    func ship() -> SKNode { return self.childNodeWithName("ship")}
    
    override func didMoveToView(view: SKView) {
        let ship = createShip("carrier", self)
        ship.name = "ship"
        self.userInteractionEnabled = true
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        var touch : UITouch! =  touches.anyObject() as UITouch;
        firstTouch = touch.locationInNode(self)
        originalPosition = ship().position
        
        //CGPoint location = touch.locationInView(self.view)
        //self.childNodeWithName("ship").position = location
    }
    
    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!) {
        //print(event.description)
        var touch : UITouch! =  touches.anyObject() as UITouch;
        
        var diff = touch.locationInNode(self) - firstTouch! 
        
        println("difference: \(diff)")
        
        self.childNodeWithName("ship").position = diff + originalPosition!
        
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
