//
//  GameScene.swift
//  FallingMadness
//
//  Created by Israel on 7/29/24.
//

import SpriteKit
import GameplayKit
import Combine

struct PhysicsCategory {
    static let player: UInt32 = 0x1 << 0 // 1
    static let fallingObject: UInt32 = 0x1 << 1 // 2
    static let ground: UInt32 = 0x1 << 2 // 4
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var player: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var ground: SKNode!
    
    var score: Int = 0 {
        didSet{
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var spawnInterval: TimeInterval = 1.0
    let minSpawnIntervan: TimeInterval = 0.5
    let spawnDecreaseRate: TimeInterval = 0.1
    
    var fallSpeed: CGFloat = 300.00
    let maxFallSpeed: CGFloat = 1000.0
    let speedIncreaseRate: CGFloat = 20.0
    
    
    override func didMove(to view: SKView) {
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        physicsWorld.contactDelegate = self
        view.showsPhysics = true

        setupBackground()
        setupPlayer()
        setupScoreLabel()
        setupGround()
        startSpawning()
        startIncreasingDifficulty()
        
        

    }
    func setupBackground(){
        if let background = childNode(withName: "//background") as? SKSpriteNode {
            background.zPosition = -1
        }
    }
    func setupPlayer(){
        if let playerNode = childNode(withName: "//player") as? SKSpriteNode {
            player = playerNode
            let hitboxSize = CGSize(width: player.size.width * 0.4, height: player.size.height * 0.6)
            player.physicsBody = SKPhysicsBody(rectangleOf: hitboxSize)
            player.physicsBody?.isDynamic = false
            player.physicsBody?.categoryBitMask = PhysicsCategory.player
            player.physicsBody?.contactTestBitMask = PhysicsCategory.fallingObject
            player.physicsBody?.collisionBitMask = 0
        }
    }
    func setupScoreLabel(){
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.position = CGPoint(x: size.width / 2, y: size.height / 2)
        scoreLabel.fontSize = 40
        scoreLabel.zPosition = 10
        scoreLabel.fontColor = SKColor.black
        addChild(scoreLabel)
    }
    func setupGround(){
        ground = SKNode()
        ground.position = CGPoint(x: size.width / 2, y: 50)
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width, height: 1))
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.categoryBitMask = PhysicsCategory.ground
        ground.physicsBody?.contactTestBitMask = PhysicsCategory.fallingObject
        ground.physicsBody?.collisionBitMask = PhysicsCategory.fallingObject
        addChild(ground)
    }
    func updatePlayerSprite(with item: StoreItem?){
        guard let item = item else {return}
        
        let texture = SKTexture(imageNamed: item.imageName)
        player.texture = texture
        player.size = texture.size()
    }
    
    func startSpawning(){
        let spawn = SKAction.run {
            self.spawnFallingObject()
        }
        let wait = SKAction.wait(forDuration: spawnInterval)
        let sequence = SKAction.sequence([spawn, wait])
        let repeatSpawn = SKAction.repeatForever(sequence)
        run(repeatSpawn, withKey: "spawning")
    }
    
    func startIncreasingDifficulty(){
        let decreaseSpawnInterval = SKAction.run {
            if self.spawnInterval > self.minSpawnIntervan{
                self.spawnInterval -= self.spawnDecreaseRate
                self.removeAction(forKey: "spawning")
                self.startSpawning()
            }
        }
        let waitToDecreaseSpawnInterval = SKAction.wait(forDuration: 10) // Decrease every 10 seconds

           let increaseFallSpeed = SKAction.run {
               if self.fallSpeed < self.maxFallSpeed {
                   self.fallSpeed += self.speedIncreaseRate
               }
           }
        let waitToIncreaseFallSpeed = SKAction.wait(forDuration: 5) // Increase speed every 5 seconds

        let sequence = SKAction.sequence([decreaseSpawnInterval, waitToDecreaseSpawnInterval, increaseFallSpeed, waitToIncreaseFallSpeed])
        let repeatSequence = SKAction.repeatForever(sequence)
        run(repeatSequence)
    }

    func spawnFallingObject() {
        let fallingObject = SKSpriteNode(imageNamed: "fallingObject")
        fallingObject.position = CGPoint(x: CGFloat.random(in: 0...size.width), y: size.height)
        fallingObject.setScale(0.15)
        fallingObject.physicsBody = SKPhysicsBody(rectangleOf: fallingObject.size)
        fallingObject.physicsBody?.isDynamic = true
        fallingObject.physicsBody?.categoryBitMask = PhysicsCategory.fallingObject
        fallingObject.physicsBody?.contactTestBitMask = PhysicsCategory.player
        fallingObject.physicsBody?.collisionBitMask = PhysicsCategory.ground
        fallingObject.physicsBody?.affectedByGravity = true
        fallingObject.physicsBody?.velocity = CGVector(dx: 0, dy: -fallSpeed)
        addChild(fallingObject)
    }


    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
         guard let touch = touches.first else { return }
         let touchLocation = touch.location(in: self)
         
         // Move player to touch location
         if let player = childNode(withName: "//player") as? SKSpriteNode {
             player.position = CGPoint(x: touchLocation.x, y: player.position.y)
         }
     }

    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        print("Contact detected between:")
        print("First Body Category Bit Mask: \(firstBody.categoryBitMask)")
        print("Second Body Category Bit Mask: \(secondBody.categoryBitMask)")
        
        // Check if the collision is between the player and the falling object
        if (firstBody.categoryBitMask == PhysicsCategory.player && secondBody.categoryBitMask == PhysicsCategory.fallingObject) ||
           (firstBody.categoryBitMask == PhysicsCategory.fallingObject && secondBody.categoryBitMask == PhysicsCategory.player) {
            if let fallingObject = (firstBody.categoryBitMask == PhysicsCategory.fallingObject ? firstBody.node : secondBody.node) as? SKSpriteNode {
                fallingObject.removeFromParent()
                print("Player hit a falling object")
                gameOver()
            }
        }
        // Check if the collision is between the ground and the falling object
        else if (firstBody.categoryBitMask == PhysicsCategory.ground && secondBody.categoryBitMask == PhysicsCategory.fallingObject) ||
                (firstBody.categoryBitMask == PhysicsCategory.fallingObject && secondBody.categoryBitMask == PhysicsCategory.ground) {
            print("Falling object hit the ground")
            if let fallingObject = (firstBody.categoryBitMask == PhysicsCategory.fallingObject ? firstBody.node : secondBody.node) as? SKSpriteNode {
                fallingObject.removeFromParent()
                print("Score before update: \(score)")
                score += 1
                print("Score after update: \(score)")
            }
        }
        else {
            print("Contact does not match expected categories")
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

