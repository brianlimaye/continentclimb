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
    
    private var scrollView: ScrollView!
    private let moveableNode = SKNode()
    
    var returnButton: SKSpriteNode = SKSpriteNode()
    
    var icyTerrainShape: SKShapeNode = SKShapeNode()
    var icyTerrainText: SKLabelNode = SKLabelNode()
    
    var sunnyTerrainShape: SKShapeNode = SKShapeNode()
    var sunnyTerrainText: SKLabelNode = SKLabelNode()
    
    var caveTerrainShape: SKShapeNode = SKShapeNode()
    var caveTerrainText: SKLabelNode = SKLabelNode()
    
    var hallowEventShape: SKShapeNode = SKShapeNode()
    var hallowEventText: SKLabelNode = SKLabelNode()
    
    var background: SKSpriteNode = SKSpriteNode()
    var mainText: SKLabelNode = SKLabelNode()
    
    override func didMove(to view: SKView) {
        
        scene?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        drawTitle()
        drawBackground(image: "starry.jpg")
        drawNorthAmerica()
        initReturnButton()
        initScrollView()
    }
    
    private func initScrollView() {
        
        moveableNode.isUserInteractionEnabled = false
        addChild(moveableNode)
        
        scrollView = ScrollView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height), moveableNode: moveableNode, direction: .vertical)
        scrollView.contentSize = CGSize(width: self.frame.size.width, height: self.frame.size.height * 2)
        view?.addSubview(scrollView)
    }
    
    func initReturnButton() {
       
        var buttonMultiplier: CGFloat = self.frame.size.width * 0.0006
                
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            buttonMultiplier = self.frame.size.width * 0.0007
        }
        
        returnButton = SKSpriteNode(imageNamed: "redback")
        returnButton.size = CGSize(width: returnButton.size.width * buttonMultiplier, height: returnButton.size.height * buttonMultiplier)
        returnButton.position = CGPoint(x: -self.frame.size.width / 2.25, y: -self.frame.size.height / 2.5)
        returnButton.zPosition = 3
        returnButton.isUserInteractionEnabled = false
        returnButton.name = "return"
        
        self.addChild(returnButton)
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
        moveableNode.addChild(mainText)
    }
    
    func drawBackground(image: String) {
        
        background = SKSpriteNode(imageNamed: image)
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
        icyTerrainText.text = "Snow"
        
        icyTerrainShape.addChild(icyTerrainText)
        icyTerrainShape.zPosition = 3
        icyTerrainShape.isUserInteractionEnabled = false
        
        icyTerrainText.position.y = self.frame.size.height / 6.5
        
        moveableNode.addChild(icyTerrainShape)
        
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
        sunnyTerrainText.text = "Desert"
        
        sunnyTerrainShape.addChild(sunnyTerrainText)
        sunnyTerrainShape.zPosition = 3
        sunnyTerrainShape.isUserInteractionEnabled = false
        
        sunnyTerrainText.position.y = -self.frame.size.height / 14
        
        moveableNode.addChild(sunnyTerrainShape)
        
        if(UIDevice.current.userInterfaceIdiom == .phone)
        {
            caveTerrainShape = SKShapeNode(rect: CGRect(x: -self.frame.size.width / 3, y: -self.frame.size.height / 3, width: 2 * (self.frame.size.width / 3), height: 75), cornerRadius: 30)
        }
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            caveTerrainShape = SKShapeNode(rect: CGRect(x: -self.frame.size.width / 3, y: -self.frame.size.height / 3, width: 2 * (self.frame.size.width / 3), height: 150), cornerRadius: 30)
        }
        caveTerrainShape.fillTexture = SKTexture(imageNamed: "cave.jpg")
        caveTerrainShape.fillColor = .white
        caveTerrainShape.name = "Caveshape"
        
        caveTerrainText = SKLabelNode(fontNamed: "NationalPark-Heavy")
        caveTerrainText.fontSize = caveTerrainShape.frame.size.width / 11
        caveTerrainText.fontColor = .white
        caveTerrainShape.name = "Cave"
        caveTerrainText.text = "Cave"
        
        caveTerrainShape.zPosition = 3
        caveTerrainShape.addChild(caveTerrainText)
        caveTerrainShape.isUserInteractionEnabled = false
        
        caveTerrainText.position.y = -self.frame.size.height / 3.65

        moveableNode.addChild(caveTerrainShape)
        
        //Halloween Event
        
        /*
        if(UIDevice.current.userInterfaceIdiom == .phone)
        {
            hallowEventShape = SKShapeNode(rect: CGRect(x: -self.frame.size.width / 3, y: -self.frame.size.height / 1.85, width: 2 * (self.frame.size.width / 3), height: 75), cornerRadius: 30)
        }
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            hallowEventShape = SKShapeNode(rect: CGRect(x: -self.frame.size.width / 3, y: -self.frame.size.height / 2.5, width: 2 * (self.frame.size.width / 3), height: 150), cornerRadius: 30)
        }
        hallowEventShape.fillTexture = SKTexture(imageNamed: "hallowbackg.jpg")
        hallowEventShape.fillColor = .white
        hallowEventShape.name = "Hallowshape"
        hallowEventShape.zPosition = 7
        
        hallowEventText = SKLabelNode(fontNamed: "NationalPark-Heavy")
        hallowEventText.fontSize = hallowEventShape.frame.size.width / 11
        hallowEventText.fontColor = .white
        hallowEventText.name = "Hallow"
        hallowEventText.text = "Halloween Event"
        
        hallowEventText.zPosition = 7
        hallowEventShape.addChild(hallowEventText)
        hallowEventShape.isUserInteractionEnabled = false
        
        hallowEventText.position.y = -self.frame.size.height / 2.05

        moveableNode.addChild(hallowEventShape)*/
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
                  
          if let touch = touches.first {
          
          var doesExist: Bool = false
          let location = touch.previousLocation(in: self)
          let node = self.nodes(at: location).first
          
            if(node?.name == "return")
            {
                let menuScene = MenuScene(size: (view?.bounds.size)!)
                scrollView.removeFromSuperview()
                menuScene.scaleMode = .aspectFill
                view?.presentScene(menuScene)
            }
            
          else if((node?.name == "Alaskashape") || (node?.name == "Alaska"))
          {
              terrainKeyword = "snow"
              doesExist = true
          }
          else if((node?.name == "Arizonashape") || (node?.name == "Arizona"))
          {
              terrainKeyword = "desert"
              doesExist = true
          }
        
          else if((node?.name == "Caveshape") || (node?.name == "Cave"))
          {
               terrainKeyword = "cave"
               doesExist = true
          }
          else if((node?.name == "Hallowshape") || (node?.name == "Hallow")) {
            
                terrainKeyword = "halloween"
                doesExist = true
          }
            
          if(doesExist)
          {
              if(terrainKeyword != "halloween") {
                  
                  MusicHelper.sharedHelper.stopPlaying()
                  MusicHelper.sharedHelper.prepareToPlay()
                  MusicHelper.sharedHelper.audioPlayer?.play()
              }
            
              let gameScene = GameScene(size: view!.bounds.size)
              gameScene.scaleMode = .aspectFill
              scrollView.removeFromSuperview()
              view?.presentScene(gameScene)
          }
      }
    }
}
