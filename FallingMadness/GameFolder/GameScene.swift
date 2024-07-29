//
//  GameScene.swift
//  FallingMadness
//
//  Created by Israel on 7/29/24.
//

import SpriteKit
import GameplayKit

struct PhysicsCategory {
    static let player: UInt32 = 0x1 << 0
    static let fallingObject: UInt32 = 0x1 << 1
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var player: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        
        //this setups physics world
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        physicsWorld.contactDelegate = self
        view.showsPhysics = true         //show physics bodies
        
        if let background = childNode(withName: "//background") as? SKSpriteNode {
             background.zPosition = -1
         }
        
        if let player = childNode(withName: "//player") as? SKSpriteNode {
            // Define hitbox size as a proportion of the sprite size
            let hitboxSize = CGSize(width: player.size.width * 0.4, height: player.size.height * 0.6)
            
            player.physicsBody = SKPhysicsBody(rectangleOf: hitboxSize)
            player.physicsBody?.isDynamic = false
            player.physicsBody?.categoryBitMask = PhysicsCategory.player
            player.physicsBody?.contactTestBitMask = PhysicsCategory.fallingObject
            player.physicsBody?.collisionBitMask = 0
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
        fallingObject.physicsBody?.categoryBitMask = PhysicsCategory.fallingObject
        fallingObject.physicsBody?.contactTestBitMask = PhysicsCategory.player
        fallingObject.physicsBody?.collisionBitMask = 0
        fallingObject.physicsBody?.affectedByGravity = true
        addChild(fallingObject)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let touchLocation = touch.location(in: self)
        
        //this will move player to touch location
        if let player = childNode(withName: "//player") as? SKSpriteNode{
            player.position = CGPoint(x: touchLocation.x, y: player.position.y)
        }
    }

    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody: SKPhysicsBody
        let secondBody: SKPhysicsBody

        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }

        if firstBody.categoryBitMask == PhysicsCategory.player && secondBody.categoryBitMask == PhysicsCategory.fallingObject {
            if let fallingObject = secondBody.node as? SKSpriteNode {
                fallingObject.removeFromParent()
                gameOver()
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        //Called before each frame is rendered
    }
    
    func gameOver(){
        //implement a game over scene soon
        print("Game OVer!")
        
        if let view = self.view{
            let scene = GameOverScene(size: view.bounds.size)
            scene.scaleMode = .aspectFill
            view.presentScene(scene, transition: SKTransition.fade(withDuration: 1.0))
        }
    }
}

