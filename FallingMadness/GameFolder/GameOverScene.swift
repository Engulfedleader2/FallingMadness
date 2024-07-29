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
    }
}
