//
//  GameScene.swift
//  FallingMadness
//
//  Created by Israel on 7/29/24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    override func didMove(to view: SKView) {
        
        //this setups physics world
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        physicsWorld.contactDelegate = self
        if let background = childNode(withName: "//background") as? SKSpriteNode {
             background.zPosition = -1
         }
        
        //spawn falling objects
        let spawn = SKAction.run {
            self.spawnFallingObject()
        }
        let wait = SKAction.wait(forDuration: 1.0)
        let sequence = SKAction.sequence([spawn, wait])
        let repeatSpawn = SKAction.repeatForever(sequence)
        run(repeatSpawn)
    }
    func spawnFallingObject() {
        let fallingObject = SKSpriteNode(imageNamed: "fallingObject")
        fallingObject.position = CGPoint(x: CGFloat.random(in: 0...size.width), y: size.height)
        
        // Resize the falling object
//        let newSize = CGSize(width: 100, height: 100) // Change to your desired size
//        fallingObject.size = newSize
        
        //scaling falling object (IDEALLY this seems better due to differnet screen sizes)
        fallingObject.setScale(0.15) // Scale down to 15% of the original size
        
        fallingObject.physicsBody = SKPhysicsBody(rectangleOf: fallingObject.size)
        fallingObject.physicsBody?.categoryBitMask = 1
        fallingObject.physicsBody?.contactTestBitMask = 1
        fallingObject.physicsBody?.collisionBitMask = 1
        fallingObject.physicsBody?.affectedByGravity = true
        addChild(fallingObject)
    }

    
    func didBegin(_ contact: SKPhysicsContact) {
        //handles collision
    }
    override func update(_ currentTime: TimeInterval) {
        //Called before each frame is rendered
    }
}

