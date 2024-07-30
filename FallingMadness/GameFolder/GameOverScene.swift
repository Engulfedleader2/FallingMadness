//
//  GameOverScene.swift
//  FallingMadness
//
//  Created by Israel on 7/29/24.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene{
    
    
    override func didMove(to view: SKView) {
        //setup background
        let background = SKSpriteNode(color: .red, size: self.size)
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        background.zPosition = -1
        addChild(background)
        
        // Setup game over label
        let gameOverLabel = SKLabelNode(text: "Game Over")
        gameOverLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        gameOverLabel.fontSize = 45
        gameOverLabel.fontColor = SKColor.white
        addChild(gameOverLabel)
        
        // Setup restart button
        let restartButton = SKLabelNode(text: "Restart")
        restartButton.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2 - 100)
        restartButton.fontSize = 30
        restartButton.fontColor = SKColor.white
        restartButton.name = "restartButton"
        addChild(restartButton)
        
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let node = atPoint(location)
        
        if node.name == "restartButton" {
            // Transition back to the main menu scene
            if let view = self.view {
                let scene = MainMenuScene(size: view.bounds.size)
                scene.scaleMode = .aspectFill
                view.presentScene(scene, transition: SKTransition.fade(withDuration: 1.0))
            }
        }
    }
}
