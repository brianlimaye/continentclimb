//
//  ContinentLoader.swift
//  continentclimb
//
//  Created by Brian Limaye on 7/30/20.
//  Copyright © 2020 Brian Limaye. All rights reserved.
//

import Foundation
import SpriteKit

class ContinentLoader: SKScene {
    
    var icyTerrainShape: SKShapeNode = SKShapeNode()
    var icyTerrainText: SKLabelNode = SKLabelNode()
    
    var sunnyTerrainShape: SKShapeNode = SKShapeNode()
    var sunnyTerrainText: SKLabelNode = SKLabelNode()
    
    var tempestTerrainShape: SKShapeNode = SKShapeNode()
    var tempestTerrainText: SKLabelNode = SKLabelNode()
    
    var background: SKSpriteNode = SKSpriteNode()
    var mainText: SKLabelNode = SKLabelNode()
    
    override func didMove(to view: SKView) {
        
        scene?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        drawTitle()
        drawBackground()
        drawNorthAmerica()
    }
    
    func drawTitle() {
        
        mainText = SKLabelNode(fontNamed: "MaassslicerItalic")
        mainText.fontColor = .white
        mainText.text = "Terrains"
        
        mainText.position = CGPoint(x: self.frame.midX, y: self.frame.height / 2.9)
        
        if(UIDevice.current.userInterfaceIdiom == .phone)
        {
            mainText.fontSize = 60
        }
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            mainText.fontSize = 90
        }
        
        mainText.zPosition = 1
        self.addChild(mainText)
    }
    
    func drawBackground() {
        
        background = SKSpriteNode(imageNamed: "starry.jpg")
        background.zPosition = 0
        background.size = (view?.bounds.size)!
        self.addChild(background)
    }
    
    func drawNorthAmerica() {
        
        if(UIDevice.current.userInterfaceIdiom == .phone)
        {
            icyTerrainShape = SKShapeNode(rect: CGRect(x: -self.frame.size.width / 3, y: self.frame.size.height / 12, width: 2 * (self.frame.size.width / 3), height: 75), cornerRadius: 30)
        }
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            icyTerrainShape = SKShapeNode(rect: CGRect(x: -self.frame.size.width / 3, y: self.frame.size.height / 12, width: 2 * (self.frame.size.width / 3), height: 150), cornerRadius: 30)
        }
        let icybackground = SKTexture(imageNamed: "icybackground.png")
        icyTerrainShape.fillTexture = icybackground
        icyTerrainShape.fillColor = .white
        icyTerrainShape.name = "Alaskashape"
        
        
        icyTerrainText = SKLabelNode(fontNamed: "NationalPark-Heavy")
        icyTerrainText.fontSize = icyTerrainShape.frame.size.width / 11
        icyTerrainText.fontColor = .white
        icyTerrainText.horizontalAlignmentMode = .center
        icyTerrainText.name = "Alaska"
        icyTerrainText.text = "Alaska"
        
        icyTerrainShape.addChild(icyTerrainText)
        icyTerrainShape.isUserInteractionEnabled = false
        
        icyTerrainText.position.y = self.frame.size.height / 6.5
        
        self.addChild(icyTerrainShape)
        
        if(UIDevice.current.userInterfaceIdiom == .phone)
        {
            sunnyTerrainShape = SKShapeNode(rect: CGRect(x: -self.frame.size.width / 3, y: -self.frame.size.height / 8, width: 2 * (self.frame.size.width / 3), height: 75), cornerRadius: 30)
        }
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            sunnyTerrainShape = SKShapeNode(rect: CGRect(x: -self.frame.size.width / 3, y: -self.frame.size.height / 8, width: 2 * (self.frame.size.width / 3), height: 150), cornerRadius: 30)
        }
        let sunnybackground = SKTexture(imageNamed: "desert.png")
        sunnyTerrainShape.fillTexture = sunnybackground
        sunnyTerrainShape.fillColor = .white
        sunnyTerrainShape.name = "Arizonashape"
        
        
        sunnyTerrainText = SKLabelNode(fontNamed: "NationalPark-Heavy")
        sunnyTerrainText.fontSize = sunnyTerrainShape.frame.size.width / 11
        sunnyTerrainText.fontColor = .white
        sunnyTerrainText.horizontalAlignmentMode = .center
        sunnyTerrainText.name = "Arizona"
        sunnyTerrainText.text = "Arizona"
        
        sunnyTerrainShape.addChild(sunnyTerrainText)
        sunnyTerrainShape.isUserInteractionEnabled = false
        
        sunnyTerrainText.position.y = -self.frame.size.height / 14
        
        self.addChild(sunnyTerrainShape)
        
        if(UIDevice.current.userInterfaceIdiom == .phone)
        {
            tempestTerrainShape = SKShapeNode(rect: CGRect(x: -self.frame.size.width / 3, y: -self.frame.size.height / 3, width: 2 * (self.frame.size.width / 3), height: 75), cornerRadius: 30)
        }
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            tempestTerrainShape = SKShapeNode(rect: CGRect(x: -self.frame.size.width / 3, y: -self.frame.size.height / 3, width: 2 * (self.frame.size.width / 3), height: 150), cornerRadius: 30)
        }
        tempestTerrainShape.fillTexture = SKTexture(imageNamed: "aurorabackg.jpg")
        tempestTerrainShape.fillColor = .white
        tempestTerrainShape.name = "Caveshape"
        
        tempestTerrainText = SKLabelNode(fontNamed: "NationalPark-Heavy")
        tempestTerrainText.fontSize = tempestTerrainShape.frame.size.width / 11
        tempestTerrainText.fontColor = .white
        tempestTerrainShape.name = "Cave"
        tempestTerrainText.text = "Caves"
        
        tempestTerrainShape.addChild(tempestTerrainText)
        tempestTerrainShape.isUserInteractionEnabled = false
        
        tempestTerrainText.position.y = -self.frame.size.height / 3.65

        self.addChild(tempestTerrainShape)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
                  
          if let touch = touches.first {
          
          var doesExist: Bool = false
          let location = touch.previousLocation(in: self)
          let node = self.nodes(at: location).first
          
          if((node?.name == "Alaskashape") || (node?.name == "Alaska"))
          {
              terrainKeyword = "snow"
              doesExist = true
          }
          else if((node?.name == "Arizonashape") || (node?.name == "Arizona"))
          {
              terrainKeyword = "desert"
              doesExist = true
          }
            
          if(doesExist)
          {
              let gameScene = GameScene(size: view!.bounds.size)
              gameScene.scaleMode = .aspectFill
              view?.presentScene(gameScene)
          }
      }
    }
}
