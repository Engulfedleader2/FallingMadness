//
//  MainMenuScene.swift
//  FallingMadness
//
//  Created by Israel on 7/29/24.
//

import Foundation
import SpriteKit
import GoogleMobileAds

class MainMenuScene: SKScene{
    
    var startButton: SKLabelNode!
    
    private let banner: GADBannerView = {
        // Define the ad size manually
        let adSize = GADAdSizeFromCGSize(CGSize(width: 320, height: 50))
        let banner = GADBannerView(adSize: adSize)
        banner.adUnitID = "HIDDNE VARIABLE"
        return banner
    }()
    
    
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
        
        // Add banner to the view
                banner.rootViewController = view.window?.rootViewController
                
        // Set banner constraints
        banner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(banner)
                
        NSLayoutConstraint.activate([
            banner.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            banner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            banner.heightAnchor.constraint(equalToConstant: banner.adSize.size.height),
            banner.widthAnchor.constraint(equalToConstant: banner.adSize.size.width)
        ])
        
        // Load the banner ad
        banner.load(GADRequest())
        
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
