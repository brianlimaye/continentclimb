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

var terrainKeyword: String = ""

struct savedData {
    
    static var coinCount: Int = 0
    static var completedLevels: [Bool] = [false, false, false, false, false, false, false, false, false]
    static var completedHallowEvent: [Bool] = [false, false, false]
    static var hasCompletedHallow: Bool = false
    static var hasPumpkinEquipped: Bool = false
}

class HomeScene: SKScene {
    
    private let heroSpeed = 0.25
    
    private var touchedHero: Bool = false
    
    private var clickToStart: SKLabelNode = SKLabelNode()
    private var clickToStart2: SKLabelNode = SKLabelNode()
    private var iconHolder: SKShapeNode = SKShapeNode()
    private var rateButton: SKSpriteNode = SKSpriteNode()
    private var rateButtonShape: SKShapeNode = SKShapeNode()
    private var tutorialButton: SKSpriteNode = SKSpriteNode()
    private var tutorialButtonShape: SKShapeNode = SKShapeNode()
    private var soundButton: SKSpriteNode = SKSpriteNode()
    private var soundButtonShape: SKShapeNode = SKShapeNode()
    private var menuButton: SKSpriteNode = SKSpriteNode()
    private var menuButtonShape: SKShapeNode = SKShapeNode()
    private var mainTitleScreen: SKLabelNode = SKLabelNode()
    private var galaxy: SKSpriteNode = SKSpriteNode()
    private var spookyBackg: SKSpriteNode = SKSpriteNode()
    private var hero: SKSpriteNode = SKSpriteNode()
    private var earth: SKSpriteNode = SKSpriteNode()
    
    override func didMove(to view: SKView) {
                
        scene?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        pullSavedData()
        drawMainText()
        initHero()
        initEarth()
        initGalaxy()
        //initSpooky()
        initClickToStart()
    }
    
    func wipeData() {
        
        GameScene.defaults.removeObject(forKey: "coins")
        GameScene.defaults.removeObject(forKey: "completedLevels")
    }
    
    func pullSavedData() {
        
        let coins = GameScene.defaults.integer(forKey: "coins")
        let completedLevels = GameScene.defaults.array(forKey: "completedLevels") as? [Bool]
        let completedHallow = GameScene.defaults.array(forKey: "completedHallow") as? [Bool]
        
        if(coins > 0)
        {
            savedData.coinCount = coins
        }
        
        if(completedLevels != nil)
        {
            savedData.completedLevels = completedLevels ?? [false, false, false, false, false, false, false, false, false]
        }
        
        if(completedHallow != nil)
        {
            savedData.completedHallowEvent = completedHallow ?? [false, false, false]
        }
        
        savedData.hasCompletedHallow = GameScene.defaults.bool(forKey: "finishedHallow")
        savedData.hasPumpkinEquipped = GameScene.defaults.bool(forKey: "hasPumpkin")
    }
    
    private func initClickToStart() {
        
        let fadeOut = SKAction.fadeOut(withDuration: 1)
        let fadeIn = SKAction.fadeIn(withDuration: 1)
        
        let fadeSeq = SKAction.sequence([fadeOut, fadeIn])
        
        let fadeRepeater = SKAction.repeatForever(fadeSeq)
        
        clickToStart = SKLabelNode(fontNamed: "BitPap")
        clickToStart.text = "Tap to start"
        clickToStart.fontColor = .white
        clickToStart.fontSize = self.frame.size.width * 0.05
        clickToStart.position = CGPoint(x: 0, y: -self.frame.size.height / 2.5)
        clickToStart.zPosition = 1
        
        clickToStart.run(fadeRepeater)
        self.addChild(clickToStart)
    }
    
    private func initSpooky() {
        
        spookyBackg = SKSpriteNode(imageNamed: "spooky.jpg")
        spookyBackg.size.width = CGFloat((scene?.view?.bounds.width)!)
        spookyBackg.size.height = CGFloat((scene?.view?.bounds.height)!)
        spookyBackg.zPosition = -1
        self.addChild(spookyBackg)
    }
    
    private func initGalaxy() {
        
        galaxy = SKSpriteNode(imageNamed: "starry.jpg")
        galaxy.size.width = CGFloat((scene?.view?.bounds.width)!)
        galaxy.size.height = CGFloat((scene?.view?.bounds.height)!)
        galaxy.zPosition = -1
        self.addChild(galaxy)
    }
    
    private func initEarth() {
        
        earth = SKSpriteNode(imageNamed: "globe")
        earth.size = CGSize(width: earth.size.width * (self.frame.size.width * 0.0004), height: earth.size.height * (self.frame.size.width * 0.0004))
        earth.position = CGPoint(x: 0, y: 0)
        earth.zPosition = 0
        self.addChild(earth)
    }
    
    private func initHero() {
        
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
    
    private func drawMainText() {
        
        mainTitleScreen = SKLabelNode(fontNamed: "MaassslicerItalic")
        mainTitleScreen.position = CGPoint(x: self.frame.midX, y: self.frame.height / 2.9)
        mainTitleScreen.fontSize = self.frame.size.width * 0.07
        mainTitleScreen.fontColor = .white
        mainTitleScreen.text = "Continent Climb"
        mainTitleScreen.zPosition = 2
        
        self.addChild(mainTitleScreen)
    }
    
    private func drawIconRect() {
        
        iconHolder = SKShapeNode(rect: CGRect(x: -self.frame.width, y: self.frame.minY, width: (2 * self.frame.width), height: 2 * (self.frame.height / 13)))
        
        iconHolder.fillColor = .clear
        iconHolder.lineWidth = 5
        iconHolder.isAntialiased = true
        iconHolder.strokeColor = .black
        
        self.addChild(iconHolder)
    }
    
    private func drawLikeButton() {
        
        rateButton = SKSpriteNode(imageNamed: "like-icon.png")
        rateButton.name = "ratebutton"
        rateButton.isUserInteractionEnabled = false
        rateButton.size = CGSize(width: rateButton.size.width * (self.frame.size.width * 0.00001), height: rateButton.size.height * (self.frame.size.width * 0.00001))
        
        rateButton.position = CGPoint(x: 0, y: 0)
        
        rateButtonShape = SKShapeNode(circleOfRadius: self.frame.size.width * 0.06)
        rateButtonShape.name = "rateshape"
        rateButtonShape.isUserInteractionEnabled = false
        rateButtonShape.fillColor = .white
        rateButtonShape.isAntialiased = true
        rateButtonShape.isUserInteractionEnabled = false
        rateButtonShape.lineWidth = 5
        rateButtonShape.strokeColor = .black
        rateButtonShape.addChild(rateButton)
        
        iconHolder.addChild(rateButtonShape)
        
        rateButtonShape.position.x = -self.size.width / 4
        rateButtonShape.position.y = -self.frame.height / 2.5
    }
    
    private func drawTutorialButton() {
        
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
    
    private func drawSoundButton() {
        
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
        
        soundButtonShape.position.x = self.frame.size.width / 4
        soundButtonShape.position.y = -self.frame.height / 2.5
    }
    
    private func drawMenuButton() {
        
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
        
        menuButtonShape.position.x = 0
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
    
    private func sinkHero() {
        
        iconHolder.isHidden = true
        mainTitleScreen.isHidden = true
        clickToStart.removeFromParent()
        clickToStart2.removeFromParent()
        
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
    
    private func fadeBlack() {
        
        scene?.backgroundColor = .black
        let fadeOut = SKAction.fadeOut(withDuration: 0.3)
        
        let fadeRepeater = SKAction.repeat(fadeOut, count: 1)
        
        self.run(fadeRepeater, completion: goToMenuScene)
    }
    
    private func goToMenuScene() {
        
        let menuScene = MenuScene(size: (view?.bounds.size)!)
        menuScene.scaleMode = .aspectFill
        view?.presentScene(menuScene)
    }
    
    private func rateApp() {
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
            if(!touchedHero) {
                
                sinkHero()
                touchedHero = true
            }
        }
    }
  }
}
