//
//  GameScene.swift
//  EPICGAMETEST
//
//  Created by zephyz on 04/07/14.
//  Copyright (c) 2014 zephyz. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    // func createShip(image: String, scene: SKScene) -> Ship {


    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        //let ship = createShip("carrier", self)
        
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Hello, World!";
        myLabel.fontSize = 65;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));

        self.addChild(myLabel)
        
        //self.userInteractionEnabled = true
}
    
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
//        
//        for touch: AnyObject in touches {
//            print(event.description)
//           
//        }
    }
    
    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!) {
        print(event.description)
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
