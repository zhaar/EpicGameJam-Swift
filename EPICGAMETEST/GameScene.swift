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

class GameScene: SKScene, SKPhysicsContactDelegate, EnemyDelegate, ShipDelegate {
    
    var missiles:Array<SKSpriteNode>

    var firstTouch: CGPoint?
    var originalPosition: CGPoint?

    let ship: Ship = createShip("fusee")
    
    let audioPlayer:AVAudioPlayer
    // -- Backgrounds --
    var lowerBackground :SKSpriteNode?
    var higherBackground :SKSpriteNode?
    var contentNode: SKNode?
    
    init(size: CGSize){
        var backgroundMusicUrl = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("backgroundMusic", ofType: "mp3"))
        audioPlayer = AVAudioPlayer(contentsOfURL: backgroundMusicUrl, error: nil)
        audioPlayer.prepareToPlay()
        self.missiles = []
        super.init(size: size)
    }
    
    override func didMoveToView(view: SKView) {
        
        ship.delegate = self

        
        setupLevelNode()
        
        placeInScene(ship, self)
        
        audioPlayer.play()
        
        /* --- Ship does not really need a physics body
        ship.physicsBody.categoryBitMask  = shipCategory
        ship.physicsBody.collisionBitMask = shipCategory
        */
        
        self.physicsWorld.gravity = CGVectorMake(0.0, 0.0)
        self.physicsWorld.contactDelegate = self
        /*
        for i in 0..3 {
            placeRandomMonster()
        }*/
        
        generateEntityContinuously(makeRandomEnemy, waitingTimeGenerator: {2})
        
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
                
        scheduleBackgroundReplacing()
    }
    
    func scheduleBackgroundReplacing() {
        var scrollingTime = 3.0
        let actions = [
            SKAction.moveBy(CGVectorMake(0.0, -self.lowerBackground!.size.height), duration: scrollingTime),
            SKAction.runBlock({
                
                self.lowerBackground!.position.y += 2 * self.lowerBackground!.size.height
                self.lowerBackground!.removeAllChildren()
                
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
        
        originalPosition = ship.position
        ship.startShooting()
        
        //ship.shootMissile()
    }
    
    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!) {
        var touch : UITouch! =  touches.anyObject() as UITouch
        var diff = touch.locationInNode(self) - firstTouch!
        //ship.shootMissile()
        var moveToPosition : CGPoint = diff + originalPosition!
        
        moveToPosition.x = clamp(0.0 + ship.frame.width * 0.5, self.size.width - ship.frame.width * 0.5, moveToPosition.x)
        moveToPosition.y = clamp(0.0, self.size.height - ship.frame.height * 0.5, moveToPosition.y)
        
        ship.position = moveToPosition
    }
    
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
        ship.stopShooting()
    }
    
    // ----- Monster generation -----
    
//    func generateMonstersContinously() {
//        
//        let actions = [
//            SKAction.waitForDuration(2.0),
//            SKAction.runBlock({
//                // TODO factory method / config for lvls etc ... ?
//                let monster = makeSquidEnemy()
//                monster.delegate = self
//                let monsterPoint = self.generateRandPoinOnTopOfScreenForSprite(monster)
//                monster.position = monsterPoint
//                //let monsterPointInContentCoordinates = self.contentNode?.convertPoint(monsterPoint, fromNode: self)
//                
//                self.addChild(monster)
//                monster.physicsBody.applyImpulse(CGVectorMake(0.0, -10.0))
//            })]
//        runAction( SKAction.repeatActionForever(SKAction.sequence(actions)) )
//    }
    
    func generateEntityContinuously(assetGenerator: () -> SKSpriteNode ,
        waitingTimeGenerator: () -> Double){
        let actions = [
            SKAction.waitForDuration(waitingTimeGenerator()),
            SKAction.runBlock({
                // TODO factory method / config for lvls etc ... ?
                let asset = assetGenerator()
                switch asset {
                case let e as Enemy : e.delegate = self
                default: println("no enemy to delegate to")
                }
                let point = self.generateRandPoinOnTopOfScreenForSprite(asset)
                asset.position = point
                //let monsterPointInContentCoordinates = self.contentNode?.convertPoint(monsterPoint, fromNode: self)
                
                self.addChild(asset)
                asset.physicsBody.applyImpulse(CGVectorMake(0.0, -10.0))
                })]
        runAction( SKAction.repeatActionForever(SKAction.sequence(actions)) )
    }
    
    /**
    *   Gets a point for a sprite with an anchor point of (0.5, 0.5)
    */
    func generateRandPoinOnTopOfScreenForSprite(spriteToPlace :SKSpriteNode) -> CGPoint {
        let halfSpriteWidth  = spriteToPlace.frame.size.width * 0.5
        let halfSpriteHeight = (spriteToPlace.frame.size.height * 0.5)
        
        let randX = CGFloat( generateRandInBounds( UInt32(halfSpriteWidth) , upperBound: UInt32(self.size.width - halfSpriteWidth) ))
        let y = self.size.height + CGFloat(halfSpriteHeight)

        return CGPointMake(randX, y)
    }
    
    func generateRandomPointOnScreen() -> CGPoint {
        let randX = generateRandInBounds(0, upperBound: UInt32(self.size.width))
        let randY = generateRandInBounds(0, upperBound: UInt32(self.size.height))
        
        return CGPointMake(CGFloat(randX), CGFloat(randY))
    }
    
    func generateRandInBounds( lowerBound: UInt32, upperBound : UInt32) -> UInt32 {
        return arc4random() % upperBound + lowerBound
    }
    
    func placeRandomMonster() {
        var randomPosition = generateRandomPointOnScreen()
        
        var randomMonster = makeSquidEnemy()
        randomMonster.delegate = self
        randomMonster.position = randomPosition
        self.addChild(randomMonster)
        
        /* --- TODO Make a monster
        let randomMonsterIndex:Int = Int((arc4random() % 6) + 1)
        var randomMonsterSpriteName:String = "monster" + String(randomMonsterIndex)
        */
    }

    // ----- Physics delegate methods -----
    
    func didBeginContact(contact: SKPhysicsContact!){
        
        var bodyA = contact.bodyA
        var bodyB = contact.bodyB
        
        if (bodyA.categoryBitMask < bodyB.categoryBitMask){
            var temp = bodyA
            bodyA = bodyB
            bodyB = temp
        }
        
        if (bodyA.categoryBitMask == missileCategory && bodyB.categoryBitMask == monsterCategory ||
            bodyB.categoryBitMask == missileCategory && bodyA.categoryBitMask == monsterCategory ) {

                var monster = bodyA.node as Enemy
                bodyB.node.removeFromParent()
                
                let diff = ship.position - monster.position
                monster.shootInDirection(CGVectorMake(diff.x * 0.1, diff.y * 0.1))
                monster.hit()
                
        }
    }
    
    // --- Enemy delegate methods ---
    
    func enemyDidExplode(sender: Enemy) {
        
        var blood = SKSpriteNode(imageNamed: "dead1")
        blood.position = sender.convertPoint(CGPointZero, toNode: lowerBackground)
        lowerBackground!.addChild(blood)
    }
    
    // --- Ship delegate methods ---
    
    func shipLaunchedMissile(sender: Ship, missile: SKSpriteNode) {
        missiles.insert(missile, atIndex: 0)
    }

    // --- Update loop ---
    
    override func update(currentTime: NSTimeInterval)
    {
        ship.update(currentTime)
        removeMissilesThatAreOutOfBounds()
    }
    
    func removeMissilesThatAreOutOfBounds () {
        if (missiles.count <= 0) { return; }
        
        for missile in missiles {
            if (missile.position.y) > self.size.height{
                missiles.removeLast()
                missile.removeFromParent()
            }
        }
    }
    
}
