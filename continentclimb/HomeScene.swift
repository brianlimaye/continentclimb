//
//  HomeScene.swift
//  continentclimb
//
//  Created by Brian Limaye on 7/13/20.
//  Copyright © 2020 Brian Limaye. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation
import StoreKit

var terrainKeyword: String = "snow"
class HomeScene: SKScene {
    
    let heroSpeed = 0.25
    
    var clickToStart: SKLabelNode = SKLabelNode()
    var iconHolder: SKShapeNode = SKShapeNode()
    var rateButton: SKSpriteNode = SKSpriteNode()
    var rateButtonShape: SKShapeNode = SKShapeNode()
    var tutorialButton: SKSpriteNode = SKSpriteNode()
    var tutorialButtonShape: SKShapeNode = SKShapeNode()
    var soundButton: SKSpriteNode = SKSpriteNode()
    var soundButtonShape: SKShapeNode = SKShapeNode()
    var menuButton: SKSpriteNode = SKSpriteNode()
    var menuButtonShape: SKShapeNode = SKShapeNode()
    var mainTitleScreen: SKLabelNode = SKLabelNode()
    var galaxy: SKSpriteNode = SKSpriteNode()
    var hero: SKSpriteNode = SKSpriteNode()
    var earth: SKSpriteNode = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        
        scene?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        drawMainText()
        initHero()
        initEarth()
        initGalaxy()
        drawIconRect()
        drawLikeButton()
        drawMenuButton()
        drawTutorialButton()
        drawSoundButton()
        //initClickToStart()
    }
    
    func initClickToStart() {
        
        let fadeOut = SKAction.fadeOut(withDuration: 1)
        let fadeIn = SKAction.fadeIn(withDuration: 1)
        
        let fadeSeq = SKAction.sequence([fadeOut, fadeIn])
        
        let fadeRepeater = SKAction.repeatForever(fadeSeq)
        
        clickToStart = SKLabelNode(fontNamed: "BitPap")
        clickToStart.text = "Click to start"
        clickToStart.fontColor = .white
        if(UIDevice.current.userInterfaceIdiom == .phone)
        {
            clickToStart.fontSize = 30
        }
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            clickToStart.fontSize = 40
        }
        clickToStart.position = CGPoint(x: self.frame.width / 4, y: -self.frame.height / 3.5)
        
        clickToStart.run(fadeRepeater)
        self.addChild(clickToStart)
    }
    
    func initGalaxy() {
        
        galaxy = SKSpriteNode(imageNamed: "starry.jpg")
        galaxy.size.width = CGFloat((scene?.view?.bounds.width)!)
        galaxy.size.height = CGFloat((scene?.view?.bounds.height)!)
        galaxy.zPosition = -1
        self.addChild(galaxy)
    }
    
    func initEarth() {
        
        earth = SKSpriteNode(imageNamed: "globe")
        if(UIDevice.current.userInterfaceIdiom == .phone)
        {
            earth.size = CGSize(width: earth.size.width / 2.5, height: earth.size.height / 2.5)
        }
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            earth.size = CGSize(width: earth.size.width / 1.25, height: earth.size.height / 1.25)
        }
        earth.position = CGPoint(x: 0, y: -15)
        earth.zPosition = 0
        self.addChild(earth)
    }
    
    func initHero() {
        
        let runFrames: [SKTexture] = [SKTexture(imageNamed: "idle-1"), SKTexture(imageNamed: "idle-1"), SKTexture(imageNamed: "idle-2"), SKTexture(imageNamed: "idle-4")]
        
        let animate = SKAction.animate(with: runFrames, timePerFrame: heroSpeed)
        let animateRepeater = SKAction.repeatForever(animate)
        
        
        hero = SKSpriteNode(imageNamed: "idle-1")
        if(UIDevice.current.userInterfaceIdiom == .phone)
        {
            hero.size = CGSize(width: hero.size.width / 3, height: hero.size.height / 3)
        }
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            hero.size = CGSize(width: hero.size.width / 2, height: hero.size.height / 2)
        }
        hero.position = CGPoint(x: 0, y: self.frame.height / 6)
        hero.zPosition = 1
        
        hero.run(animateRepeater)
        self.addChild(hero)
    }
    
    func drawMainText() {
        
        mainTitleScreen = SKLabelNode(fontNamed: "MaassslicerItalic")
        
        mainTitleScreen.position = CGPoint(x: self.frame.midX, y: self.frame.height / 2.9)
        
        mainTitleScreen.fontColor = .white
        
        if(UIDevice.current.userInterfaceIdiom == .phone)
        {
            mainTitleScreen.fontSize = 60
        }
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            mainTitleScreen.fontSize = 90
        }
        mainTitleScreen.numberOfLines = 1
        mainTitleScreen.text = "Continent Climb"
        mainTitleScreen.zPosition = 2
        
        self.addChild(mainTitleScreen)
    }
    
    func drawIconRect() {
        
        iconHolder = SKShapeNode(rect: CGRect(x: -self.frame.width, y: self.frame.minY, width: (2 * self.frame.width), height: 2 * (self.frame.height / 13)))
        
        iconHolder.fillColor = .clear
        iconHolder.lineWidth = 5
        iconHolder.isAntialiased = true
        iconHolder.strokeColor = .black
        
        self.addChild(iconHolder)
    }
    
    func drawLikeButton() {
        
        rateButton = SKSpriteNode(imageNamed: "like-icon.png")
        rateButton.name = "ratebutton"
        rateButton.isUserInteractionEnabled = false
        if(UIDevice.current.userInterfaceIdiom == .phone)
        {
            rateButton.size = CGSize(width: rateButton.size.width / 29, height: rateButton.size.height / 29)
        }
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            rateButton.size = CGSize(width: rateButton.size.width / 15, height: rateButton.size.height / 15)
        }
        rateButton.position = CGPoint(x: 0, y: 0)
        
        rateButtonShape = SKShapeNode(circleOfRadius: self.size.height * 0.09)
        rateButtonShape.name = "rateshape"
        rateButtonShape.isUserInteractionEnabled = false
        rateButtonShape.fillColor = .white
        rateButtonShape.isAntialiased = true
        rateButtonShape.isUserInteractionEnabled = false
        rateButtonShape.lineWidth = 5
        rateButtonShape.strokeColor = .black
        rateButtonShape.addChild(rateButton)
        
        iconHolder.addChild(rateButtonShape)
        
        rateButtonShape.position.x = -self.size.width / 3
        rateButtonShape.position.y = -self.frame.height / 2.5
    }
    
    func drawTutorialButton() {
        
        tutorialButton = SKSpriteNode(imageNamed: "question-mark.png")
        tutorialButton.name = "tutorialbutton"
        if(UIDevice.current.userInterfaceIdiom == .phone)
        {
            tutorialButton.size = CGSize(width: tutorialButton.size.width / 10 , height: tutorialButton.size.height / 10)
        }
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            tutorialButton.size = CGSize(width: tutorialButton.size.width / 5 , height: tutorialButton.size.height / 5)
        }
        tutorialButton.isUserInteractionEnabled = false
        tutorialButton.position = CGPoint(x: 0, y: 0)
        
        tutorialButtonShape = SKShapeNode(circleOfRadius: self.size.height * 0.09)
        tutorialButtonShape.isUserInteractionEnabled = false
        tutorialButtonShape.name = "tutorialshape"
        tutorialButtonShape.fillColor = .white
        tutorialButtonShape.isAntialiased = true
        tutorialButtonShape.isUserInteractionEnabled = false
        tutorialButtonShape.lineWidth = 5
        tutorialButtonShape.strokeColor = .black
        tutorialButtonShape.addChild(tutorialButton)
        
        iconHolder.addChild(tutorialButtonShape)
        
        tutorialButtonShape.position.x = -self.size.width / 9
        tutorialButtonShape.position.y = -self.frame.height / 2.5
    }
    
    func drawSoundButton() {
        
        soundButton = SKSpriteNode(imageNamed: "volume-off.png")
        soundButton.name = "soundbutton"
        if(UIDevice.current.userInterfaceIdiom == .phone)
        {
            soundButton.size = CGSize(width: soundButton.size.width / 9 , height: soundButton.size.height / 9)
        }
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            soundButton.size = CGSize(width: soundButton.size.width / 4.5, height: soundButton.size.height / 4.5)
        }
        soundButton.isUserInteractionEnabled = false
        soundButton.position = CGPoint(x: 0, y: 0)
        
        soundButtonShape = SKShapeNode(circleOfRadius: self.size.height * 0.09)
        soundButton.name = "soundshape"
        soundButtonShape.fillColor = .white
        soundButtonShape.isAntialiased = true
        soundButtonShape.isUserInteractionEnabled = false
        soundButtonShape.lineWidth = 5
        soundButtonShape.strokeColor = .black
        soundButtonShape.addChild(soundButton)
        
        iconHolder.addChild(soundButtonShape)
        
        soundButtonShape.position.x = self.size.width / 3
        soundButtonShape.position.y = -self.frame.height / 2.5
    }
    
    func drawMenuButton() {
        
        menuButton = SKSpriteNode(imageNamed: "menu-icon.png")
        if(UIDevice.current.userInterfaceIdiom == .phone)
        {
            menuButton.size = CGSize(width: menuButton.size.width / 8 , height: menuButton.size.height / 8)
        }
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            menuButton.size = CGSize(width: menuButton.size.width / 4, height: menuButton.size.height / 4)
        }
        
        menuButton.name = "menuicon"
        menuButton.isUserInteractionEnabled = false
        
        menuButtonShape = SKShapeNode(circleOfRadius: self.size.height * 0.09)
        menuButtonShape.fillColor = .white
        menuButtonShape.name = "menubutton"
        menuButtonShape.isAntialiased = true
        menuButtonShape.isUserInteractionEnabled = false
        menuButtonShape.lineWidth = 5
        menuButtonShape.strokeColor = .black
        menuButtonShape.addChild(menuButton)
        
        iconHolder.addChild(menuButtonShape)
        
        menuButtonShape.position.x = self.size.width / 9
        menuButtonShape.position.y = -self.frame.height / 2.5
        
        if(UIDevice.current.userInterfaceIdiom == .phone)
        {
            menuButton.position = CGPoint(x: 10, y: 0)
        }
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            menuButton.position = CGPoint(x: 15, y: 0)
        }
    }
    
    func sinkHero() {
        
        iconHolder.isHidden = true
        mainTitleScreen.isHidden = true
        
        hero.removeAllActions()
        hero.texture = SKTexture(imageNamed: "bobby-15")
        
        let rotation = SKAction.rotate(byAngle: 2 * CGFloat.pi, duration: 0.5)
        let minimize = SKAction.resize(toWidth: 0, height: 0, duration: 0.5)
        let moveDown = SKAction.moveTo(y: self.frame.height / 8, duration: 0.5)
        
        let rotationRepeater = SKAction.repeat(rotation, count: 1)
        let minimizeRepeater = SKAction.repeat(minimize, count: 1)
        let moveRepeater = SKAction.repeat(moveDown, count: 1)
        
        hero.run(rotationRepeater)
        hero.run(minimizeRepeater)
        hero.run(moveRepeater, completion: goToMenuScene)
    }
    
    func fadeBlack() {
        
        scene?.backgroundColor = .black
        let fadeOut = SKAction.fadeOut(withDuration: 0.3)
        
        let fadeRepeater = SKAction.repeat(fadeOut, count: 1)
        
        self.run(fadeRepeater, completion: goToMenuScene)
    }
    
    func goToMenuScene() {
        
        let menuScene = MenuScene(size: self.size)
        menuScene.scaleMode = .aspectFill
        view?.presentScene(menuScene)
    }
    
    func rateApp() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()

        } else if let url = URL(string: "itms-apps://itunes.apple.com/app/" + "id1523181046") {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)

            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
        
        let location = touch.previousLocation(in: self)
        let node = self.nodes(at: location).first
        
        if((node?.name == "ratebutton") || (node?.name == "rateshape"))
        {
            rateApp()
        }
        else
        {
            sinkHero()
        }
    }
  }
}
