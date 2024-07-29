//
//  MainMenuScene.swift
//  FallingMadness
//
//  Created by Israel on 7/29/24.
//

import Foundation
import SpriteKit

class MainMenuScene: SKScene{
    
    var startButton: SKLabelNode!
    
    override func didMove(to view: SKView) {
        // Setup background
        let background = SKSpriteNode(color: .blue, size: self.size) // or use an image
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        background.zPosition = -1
        addChild(background)
        
        // Setup start button
        startButton = SKLabelNode(text: "Start Game")
        startButton.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        startButton.fontSize = 45
        startButton.fontColor = SKColor.white
        startButton.name = "startButton"
        addChild(startButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let node = atPoint(location)
        
        if node.name == "startButton" {
            // Transition to the game scene
            if let view = self.view {
                if let scene = SKScene(fileNamed: "GameScene") {
                    scene.scaleMode = .aspectFill
                    view.presentScene(scene, transition: SKTransition.fade(withDuration: 1.0))
                }
            }
        }
    }
}
