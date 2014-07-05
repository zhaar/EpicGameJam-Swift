//
//  GameScene.swift
//  EPICGAMETEST
//
//  Created by zephyz on 04/07/14.
//  Copyright (c) 2014 zephyz. All rights reserved.
//

import SpriteKit
import Foundation
import AVFoundation
import AudioToolbox

@infix func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPointMake(left.x - right.x,
        left.y - right.y)
}

@infix func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPointMake(left.x + right.x,
        left.y + right.y)
}

func clamp(min: CGFloat, max: CGFloat, value: CGFloat) -> CGFloat {
    if( value > max ) {
        return max
    } else if( value < min ) {
        return min
    } else {
        return value
    }
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var firstTouch: CGPoint?
    var originalPosition: CGPoint?

    let ship: Ship = createShip("cruiser")
    let audioPlayer:AVAudioPlayer
    // -- Backgrounds --
    var lowerBackground :SKSpriteNode?
    var higherBackground :SKSpriteNode?
    var contentNode: SKNode?
    
    init(size: CGSize){
        var backgroundMusicUrl = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("backgroundMusic", ofType: "mp3"))
        audioPlayer = AVAudioPlayer(contentsOfURL: backgroundMusicUrl, error: nil)
        audioPlayer.prepareToPlay()
        super.init(size: size)
    }
    
    // ------ Physics ------
    let missileCategory: UInt32 = 1 << 0
    //let shipCategory:    UInt32 = 1 << 1
    let monsterCategory: UInt32 = 1 << 2
    
    override func didMoveToView(view: SKView) {
        
        setupLevelNode()
        
        placeInScene(ship, self)
        
        audioPlayer.play()
        
        /* --- Ship does not really need a physics body
        ship.physicsBody.categoryBitMask  = shipCategory
        ship.physicsBody.collisionBitMask = shipCategory
        */
        
        self.physicsWorld.gravity = CGVectorMake(0.0, 0.0)
        self.physicsWorld.contactDelegate = self
        
        for i in 0..3 {
            placeRandomMonster()
        }
        
        self.userInteractionEnabled = true
    }
    
    func setupLevelNode() {
        // Load the background
        
        contentNode = SKNode()
        
        self.lowerBackground = SKSpriteNode(imageNamed: "background")
        self.lowerBackground!.anchorPoint = CGPointZero
        self.lowerBackground!.position = CGPointZero
        contentNode!.addChild(lowerBackground)
        
        self.higherBackground = SKSpriteNode(imageNamed: "background")
        self.higherBackground!.anchorPoint = CGPointZero
        self.higherBackground!.position = CGPointMake(0.0, self.lowerBackground!.size.height)
        contentNode!.addChild(higherBackground)
        
        contentNode!.position = CGPointZero
        self.addChild(contentNode)
        
        //contentNode.runAction(SKAction.moveBy(CGVectorMake(0.0, -background.size.height), duration: 20.0))
        
        scheduleBackgroundReplacing()
    }
    
    func scheduleBackgroundReplacing() {
        var scrollingTime = 20.0
        let actions = [
            SKAction.moveBy(CGVectorMake(0.0, -self.lowerBackground!.size.height), duration: scrollingTime),
            SKAction.runBlock({
                
                self.lowerBackground!.position.y = self.lowerBackground!.size.height
                
                var temp = self.lowerBackground
                self.lowerBackground = self.higherBackground
                self.higherBackground = temp
                
                self.scheduleBackgroundReplacing()
                })
        ]
        var bgSequence:SKAction = SKAction.sequence(actions)
        contentNode!.runAction(bgSequence)
    }
    

    
    
    // ----- User interaction -----
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        var touch : UITouch! =  touches.anyObject() as UITouch;
        firstTouch = touch.locationInNode(self)
        
        println("Touched X: " + String(firstTouch!.x) + " and at Y : " + String(firstTouch!.y))
        
        originalPosition = ship.position
        ship.startShooting()

        var emitterNode:SKEmitterNode = NSKeyedUnarchiver.unarchiveObjectWithFile(NSBundle.mainBundle().pathForResource("Explosion", ofType: "sks")) as SKEmitterNode

        emitterNode.position = touch.locationInNode(self)
        
        self.addChild(emitterNode)
    }
    
    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!) {
        var touch : UITouch! =  touches.anyObject() as UITouch
        var diff = touch.locationInNode(self) - firstTouch!
        ship.shootMissile()
        var moveToPosition : CGPoint = diff + originalPosition!
        
        moveToPosition.x = clamp(0.0 + ship.frame.width * 0.5, self.size.width - ship.frame.width * 0.5, moveToPosition.x)
        moveToPosition.y = clamp(0.0, self.size.height - ship.frame.height * 0.5, moveToPosition.y)
        
        ship.position = moveToPosition
    }
    
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
        //ship.stopShooting()
    }
    
    // ----- Monster generation -----
    
    func placeRandomMonster() {
        // Get rand x
        let randX = arc4random() % UInt32(self.size.width)
        let randY = arc4random() % UInt32(self.size.height)
    
        println("RandX " + String(randX) + " : randY: " + String(randY))
        
        var randomPosition:CGPoint = CGPointMake(CGFloat(randX), CGFloat(randY))
        
        println("The random position is x:" + String(randomPosition.x) + " and y: " + String(randomPosition.y) )
        
        // Get random monster
        let randomMonsterIndex = (arc4random() % 6) + 1
        var randomMonsterSpriteName:String = "monster" + String(randomMonsterIndex)
        
        println("Random monster sprite name " + randomMonsterSpriteName)
        
        var randomMonster = SKSpriteNode(imageNamed: randomMonsterSpriteName)
        randomMonster.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(randomMonster.size.width, randomMonster.size.height))
        
        randomMonster.physicsBody.categoryBitMask = monsterCategory
        randomMonster.physicsBody.collisionBitMask = missileCategory
        randomMonster.physicsBody.contactTestBitMask = missileCategory
        
        randomMonster.xScale = 0.4;
        randomMonster.yScale = 0.4;
        
        randomMonster.position = randomPosition

        self.addChild(randomMonster)
        
        
    }

    
    // ----- Physics delegate methods -----
    
    func didBeginContact(contact: SKPhysicsContact!){
        
        var bodyA = contact.bodyA
        var bodyB = contact.bodyB
        
       // bodyA.node.removeFromParent()
        //bodyB.node.removeFromParent()
        
        // Detect Missile - Monster collision
        if (bodyA.categoryBitMask < bodyB.categoryBitMask){
            var temp = bodyA
            bodyA = bodyB
            bodyB = temp
        }
        
        if (bodyA.categoryBitMask == missileCategory && bodyB.categoryBitMask == monsterCategory ||
            bodyB.categoryBitMask == missileCategory && bodyA.categoryBitMask == monsterCategory ) {
            //TODO explode monsters
            var monster = bodyA.node
            monster.removeFromParent()
        }
    }
}
