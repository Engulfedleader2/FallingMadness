//
//  MainMenuScene.swift
//  FallingMadness
//
//  Created by Israel on 7/29/24.
//

import Foundation
import SpriteKit
import GoogleMobileAds
import SwiftUI

class MainMenuScene: SKScene{
    
    var startButton: SKLabelNode!
    let TESTbannerID = "ca-app-pub-3940256099942544/2934735716"
        
    private let banner: GADBannerView = {
        // Define the ad size manually
        let adSize = GADAdSizeFromCGSize(CGSize(width: 320, height: 50))
        let banner = GADBannerView(adSize: adSize)
        banner.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        return banner
    }()
    
    
    override func didMove(to view: SKView) {
        // Setup background
        let background = SKSpriteNode(color: .blue, size: self.size) // or use an image
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        background.zPosition = -1
        addChild(background)
        
        // Setup title
        let titleLabel = SKLabelNode(text: "Falling Madness")
        titleLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height - 100)
        titleLabel.fontSize = 60
        titleLabel.fontColor = SKColor.white
        titleLabel.name = "titleLabel"
        addChild(titleLabel)
        
        //Create buttons
        let buttonYOffset: CGFloat = 150
        createButton(text: "Start Game", position: CGPoint(x: self.size.width / 2, y: self.size.height / 2 + buttonYOffset), name: "startButton")
        createButton(text: "Settings", position: CGPoint(x: self.size.width / 2, y: self.size.height / 2 + buttonYOffset - 100), name: "settingsButton")
        createButton(text: "High Scores", position: CGPoint(x: self.size.width / 2, y: self.size.height / 2 + buttonYOffset - 200), name: "highScoresButton")
        createButton(text: "Credits", position: CGPoint(x: self.size.width / 2, y: self.size.height / 2 + buttonYOffset - 300), name: "creditsButton")
          
               
        // Add banner to the view & Set banner constraints
        banner.rootViewController = view.window?.rootViewController
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
        
        // Add background music
        let backgroundMusic = SKAudioNode(fileNamed: "1backgroundMusic.mp3")
        addChild(backgroundMusic)
        
    }
    func createButton(text: String, position: CGPoint, name: String){
        let buttonBackground = SKShapeNode(rectOf: CGSize(width: 300, height: 60), cornerRadius: 15)
        buttonBackground.fillColor = SKColor.darkGray
        buttonBackground.strokeColor = SKColor.clear
        buttonBackground.position = position
        buttonBackground.zPosition = 0
        
        let shadow = SKShapeNode(rectOf: CGSize(width: 300, height: 60), cornerRadius: 15)
        shadow.fillColor = SKColor.black.withAlphaComponent(0.5)
        shadow.strokeColor = SKColor.clear
        shadow.position = CGPoint(x: position.x, y: position.y - 10)
        shadow.zPosition = -1
        addChild(shadow)
        
        let label = SKLabelNode(text: text)
        label.position = CGPoint(x: 0, y: -10)
        label.fontSize = 45
        label.fontColor = SKColor.white
        label.name = name
        label.zPosition = 1
        
        buttonBackground.addChild(label)
        addChild(buttonBackground)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let node = atPoint(location)
        
        if node.name == "startButton" {
            run(SKAction.playSoundFileNamed("buttonClick.wav", waitForCompletion: false))
            // Transition to the game scene
            if let view = self.view {
                if let scene = SKScene(fileNamed: "GameScene") {
                    scene.scaleMode = .aspectFill
                    view.presentScene(scene, transition: SKTransition.fade(withDuration: 1.0))
                }
            }
        } else if node.name == "settingsButton" {
            run(SKAction.playSoundFileNamed("buttonClick.wav", waitForCompletion: false))
            // Transition to the settings view
            presentSettingsView()
        }
    }
    
    private func presentSettingsView() {
           guard let view = self.view else { return }
           let settingsView = SettingsView()
           let hostingController = UIHostingController(rootView: settingsView)
           hostingController.modalPresentationStyle = .overFullScreen
           view.window?.rootViewController?.present(hostingController, animated: true, completion: nil)
       }
}
