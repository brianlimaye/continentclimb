//
//  GameScene.swift
//  continentclimb
//
//  Created by Brian Limaye on 7/13/20.
//  Copyright © 2020 Brian Limaye. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation
import StoreKit

var cameraNode: SKCameraNode = SKCameraNode()

struct gameData {
    
    static var startingHeroPos: CGPoint = CGPoint(x: 0, y: 0)
}

struct savedData {
    
    static var coinCount: Int = 0
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    struct ColliderType {
        
        static let hero: UInt32 = 1
        static let snowBall: UInt32 = 2
        static let yeti: UInt32 = 3
        static let coyote: UInt32 = 4
        static let snake: UInt32 = 5
        static let sandstorm: UInt32 = 6
        static let bat: UInt32 = 7
        static let spider: UInt32 = 8
        static let rock: UInt32 = 9
        static let coin: UInt32 = 10
    }
    
    let characterSpeed: TimeInterval = 0.25
    let realCharSpeed: TimeInterval = 0.1
    
    var recordedTime: Int = 0
    var initialYPos: CGFloat = 0

    var heroRunAction: SKAction = SKAction()
    var yetiRunAction: SKAction = SKAction()
    var coyoteDashAction: SKAction = SKAction()
    var icyBackground: SKSpriteNode = SKSpriteNode()
    var icyBackground2: SKSpriteNode = SKSpriteNode()
    var icePlatform: SKSpriteNode = SKSpriteNode()
    var hero: SKSpriteNode = SKSpriteNode()
    var evilSnowman: SKSpriteNode = SKSpriteNode()
    var snowYeti: SKSpriteNode = SKSpriteNode()
    var snowball: SKSpriteNode = SKSpriteNode()
    var coyote: SKSpriteNode = SKSpriteNode()
    var snake: SKSpriteNode = SKSpriteNode()
    var sandstorm: SKSpriteNode = SKSpriteNode()
    var batSprite: SKSpriteNode = SKSpriteNode()
    var spider: SKSpriteNode = SKSpriteNode()
    var golem: SKSpriteNode = SKSpriteNode()
    var rock: SKSpriteNode = SKSpriteNode()
    var coin: SKSpriteNode = SKSpriteNode()
    
    var rain: SKEmitterNode = SKEmitterNode()
    var snow: SKEmitterNode = SKEmitterNode()
    
    var difficultyBox: SKShapeNode = SKShapeNode()
    var difficultyText: SKLabelNode = SKLabelNode()
    var difficultySubBox1: SKShapeNode = SKShapeNode()
    var difficultySubText1: SKLabelNode = SKLabelNode()
    var difficultySubBox2: SKShapeNode = SKShapeNode()
    var difficultySubText2: SKLabelNode = SKLabelNode()
    var difficultySubBox3: SKShapeNode = SKShapeNode()
    var difficultySubText3: SKLabelNode = SKLabelNode()
    var gameOverDisplay: SKShapeNode = SKShapeNode()
    var levelAlert: SKLabelNode = SKLabelNode()
    var levelStatusAlert: SKLabelNode = SKLabelNode()
    
    
    var oneStar: SKSpriteNode = SKSpriteNode()
    var twoStar: SKSpriteNode = SKSpriteNode()
    var threeStar: SKSpriteNode = SKSpriteNode()
    
    var platName: String = String()
    var backgName: String = String()
    var levelNames: [String] = [String]()
    
    var backButton: SKSpriteNode = SKSpriteNode()
    var nextButton: SKSpriteNode = SKSpriteNode()
    var replayButton: SKSpriteNode = SKSpriteNode()
    
    var isLevelPassed: Bool = true
    
    var i: Int = 0
    
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        GameViewController.gameScene = self
        scene?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        (platName, backgName, levelNames) = PlistParser.getLayoutPackage(forKey: terrainKeyword, property1: "platform", property2: "background")
        selectDifficulty()
        drawBackground()
        drawPlatform()
        drawCharacter()
        
        self.addChild(cameraNode)
    }
    
    func initializeGame() {
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(jumpHero))
        swipeUp.direction = .up
        self.view?.addGestureRecognizer(swipeUp)

        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(slideHero))
        swipeDown.direction = .down
        self.view?.addGestureRecognizer(swipeDown)
        
        //selectDifficulty()
        initObjects()
    
        //addSnow()
        i += 1
    }
    
    func initButtons() {
        
        var buttonMultiplier: CGFloat = self.frame.size.width * 0.0006
        
        backButton = SKSpriteNode(imageNamed: "bluehome")
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            buttonMultiplier = self.frame.size.width * 0.0007
        }
        
        backButton.size = CGSize(width: backButton.size.width * buttonMultiplier, height: backButton.size.height * buttonMultiplier)
        backButton.position = CGPoint(x: -self.frame.size.width / 8, y: self.frame.size.height / 32)
        backButton.zPosition = 3
        backButton.isUserInteractionEnabled = false
        backButton.name = "back"
        
        nextButton = SKSpriteNode(imageNamed: "bluenext")
        nextButton.size = CGSize(width: nextButton.size.width * buttonMultiplier, height: nextButton.size.height * buttonMultiplier)
        nextButton.position = CGPoint(x: self.frame.size.width / 8, y: self.frame.size.height / 32)
        nextButton.zPosition = 3
        nextButton.isUserInteractionEnabled = false
        nextButton.name = "next"
        
        replayButton = SKSpriteNode(imageNamed: "bluereplay")
        replayButton.size = CGSize(width: replayButton.size.width * buttonMultiplier, height: replayButton.size.height * buttonMultiplier)
        replayButton.position = CGPoint(x: 0, y: self.frame.size.height / 32)
        replayButton.zPosition = 3
        replayButton.isUserInteractionEnabled = false
        replayButton.name = "replay"
        
        self.addChild(backButton)
        self.addChild(nextButton)
        self.addChild(replayButton)
        
    }
    
    func selectDifficulty() {
        
        difficultyBox.isHidden = false
        
        difficultyBox = SKShapeNode(rectOf: CGSize(width: self.frame.size.width / 1.5, height: self.frame.size.width / 5))
        difficultyBox.fillTexture = SKTexture(imageNamed: "difficultybackg.jpg")
        difficultyBox.fillColor = .white
        difficultyBox.strokeColor = .white
        difficultyBox.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        difficultyBox.lineWidth = 2
        
        self.addChild(difficultyBox)
        
        difficultyText = SKLabelNode(fontNamed: "NationalPark-Heavy")
        difficultyText.fontColor = .white
        difficultyText.fontSize = self.frame.width / 24
        difficultyText.text = "Level Difficulty"
        difficultyText.position = CGPoint(x: self.frame.midX, y: self.frame.size.height / 9.5)
        
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            difficultyText.position.y = self.frame.size.height / 14
        }
        
        difficultyBox.addChild(difficultyText)
        
        
        
        difficultySubBox1 = SKShapeNode(rectOf: CGSize(width: self.frame.size.width / 8, height: self.frame.size.width / 8))
        difficultySubBox1.fillColor = .yellow
        difficultySubBox1.strokeColor = .black
        difficultySubBox1.position = CGPoint(x: 0, y: -self.frame.height / 20)
        difficultySubBox1.lineWidth = 2
        difficultySubBox1.name = "level-1"
        difficultySubBox1.isUserInteractionEnabled = false
        
        difficultyBox.addChild(difficultySubBox1)
        
        difficultySubText1 = SKLabelNode(fontNamed: "GemunuLibre-ExtraBold")
        difficultySubText1.fontColor = .black
        difficultySubText1.fontSize = self.frame.size.width / 45
        difficultySubText1.text = levelNames[1]
        difficultySubText1.position = CGPoint(x: 0, y: 0)
        difficultySubText1.name = "level-1text"
        difficultySubText1.isUserInteractionEnabled = false

        difficultyBox.addChild(difficultySubText1)
        
        twoStar = SKSpriteNode(imageNamed: "two-star")
        twoStar.size = CGSize(width: self.frame.size.width / 9, height: self.frame.size.width / 9)
        twoStar.position = CGPoint(x: 0, y: 0)
        twoStar.name = "twostar"
        twoStar.isUserInteractionEnabled = false
        
        difficultyBox.addChild(twoStar)
        
        twoStar.position.y = -self.frame.size.height / 9.25
        
        difficultySubBox2 = SKShapeNode(rectOf: CGSize(width: self.frame.size.width / 8, height: self.frame.size.width / 8))
        difficultySubBox2.fillColor = .green
        difficultySubBox2.strokeColor = .black
        difficultySubBox2.position = CGPoint(x: -self.frame.size.width / 4, y: -self.frame.height / 20)
        difficultySubBox2.lineWidth = 2
        difficultySubBox2.name = "level-2"
        difficultySubBox2.isUserInteractionEnabled = false
        
        difficultyBox.addChild(difficultySubBox2)
        
        difficultySubText2 = SKLabelNode(fontNamed: "GemunuLibre-ExtraBold")
        difficultySubText2.fontColor = .black
        difficultySubText2.fontSize = self.frame.size.width / 45
        difficultySubText2.text = levelNames[0]
        difficultySubText2.position = CGPoint(x: -self.frame.size.width / 4, y: 0)
        difficultySubText2.name = "level-2text"
        difficultySubText2.isUserInteractionEnabled = false

        
        difficultyBox.addChild(difficultySubText2)
        
        oneStar = SKSpriteNode(imageNamed: "one-star")
        
        oneStar.size = CGSize(width: self.frame.size.width / 15, height: self.frame.size.width / 15)
        oneStar.position = CGPoint(x: -self.frame.size.width / 3.95, y: -self.frame.size.height / 8.75)
        oneStar.name = "onestar"
        oneStar.isUserInteractionEnabled = false
        
        difficultyBox.addChild(oneStar)
        
        difficultySubBox3 = SKShapeNode(rectOf: CGSize(width: self.frame.size.width / 8, height: self.frame.size.width / 8))
        difficultySubBox3.fillColor = .red
        difficultySubBox3.strokeColor = .black
        difficultySubBox3.position = CGPoint(x: self.frame.size.width / 4, y: -self.frame.height / 20)
        difficultySubBox3.lineWidth = 2
        difficultySubBox3.name = "level-3"
        difficultySubBox3.isUserInteractionEnabled = false
        
        difficultyBox.addChild(difficultySubBox3)
        
        difficultySubText3 = SKLabelNode(fontNamed: "GemunuLibre-ExtraBold")
        difficultySubText3.fontColor = .black
        difficultySubText3.fontSize = self.frame.size.width / 45
        difficultySubText3.text = levelNames[2]
        difficultySubText3.position = CGPoint(x: self.frame.size.width / 4, y: 0)
        difficultySubText3.name = "level-3text"
        difficultySubText3.isUserInteractionEnabled = false

        difficultyBox.addChild(difficultySubText3)
        
        threeStar = SKSpriteNode(imageNamed: "three-star")
        threeStar.size = CGSize(width: self.frame.size.width / 6, height: self.frame.size.width / 6)
        threeStar.position = CGPoint(x: self.frame.size.width / 3.8, y: -self.frame.size.height / 8.5)
        threeStar.name = "threestar"
        threeStar.isUserInteractionEnabled = false
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            oneStar.position.y = -self.frame.size.height / 9.75
            twoStar.position.y = -self.frame.size.height / 10
            threeStar.position.y = -self.frame.size.height / 9.5
        }
        
        difficultyBox.addChild(threeStar)
        
    }

    func addSnow() {
        
        snow = SKEmitterNode(fileNamed: "snowEffect.sks")!
        snow.position.y = self.frame.size.height
        self.addChild(snow)
    }
    
    func addRain() {
        
        rain = SKEmitterNode(fileNamed: "rainEffect.sks")!
        rain.position.y = self.frame.size.height
        self.addChild(rain)
        
    }
    
    func drawSandstorm() {
        
        var sandstormShift: SKAction = SKAction()
        
        let sandstormFrames: [SKTexture] = [SKTexture(imageNamed: "sandtwister-1"), SKTexture(imageNamed: "sandtwister-2"), SKTexture(imageNamed: "sandtwister-3"), SKTexture(imageNamed: "sandtwister-4")]
        
        let sandstormAnim = SKAction.animate(with: sandstormFrames, timePerFrame: characterSpeed / 3)
        
        if(UIDevice.current.userInterfaceIdiom == .phone)
        {
            sandstormShift = SKAction.moveTo(x: self.size.width / 3, duration: 0.3)
        }
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            sandstormShift = SKAction.moveTo(x: self.size.width / 2.5, duration: 0.2)
        }
        
        let sandstormRepeater = SKAction.repeatForever(sandstormAnim)
        let shiftRepeater = SKAction.repeat(sandstormShift, count: 1)
        
        sandstorm.run(shiftRepeater, completion: determineSandstormDirection)
        sandstorm.run(sandstormRepeater)
    }
    
    func determineSandstormDirection() {
        
        let rand = Int.random(in: 1 ... 2)
        var riseAction: SKAction = SKAction()
        var riseRepeater: SKAction = SKAction()
        
        let secondShift = SKAction.moveTo(x: -self.frame.size.width, duration: 0.9)
        
        let shiftRepeater = SKAction.repeat(secondShift, count: 1)
        
        if(rand == 1)
        {
            riseAction = SKAction.moveTo(y: 0, duration: 0.2)
            riseRepeater = SKAction.repeat(riseAction, count: 1)
            
            sandstorm.run(riseRepeater)
            
        }
        sandstorm.run(shiftRepeater, completion: sandstormRevert)
    }
    
    
    func sandstormRevert() {
        
        sandstorm.position.x = self.frame.size.width
        
        if(UIDevice.current.userInterfaceIdiom == .phone)
        {
            sandstorm.position.y = -self.frame.size.height / 4
        }
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            sandstorm.position.y = -self.frame.size.height / 4
        }
    }
    
    func resumeRunning() {
        
        hero.run(heroRunAction)
    }
    
    func pauseRunning() {
        
        hero.removeAllActions()
    }
    
    func drawPlatform() {
        
        var lowerBound: CGFloat = 0
        var upperBound: CGFloat = 0
                
        if(platName == "none")
        {
            return
        }

        let platTexture = SKTexture(imageNamed: platName)
            
        var platAnimation: SKAction = SKAction()
        
        if(UIDevice.current.userInterfaceIdiom == .phone)
        {
            platAnimation = SKAction.move(by: CGVector(dx: -platTexture.size().width, dy: 0), duration: 2.25)
            lowerBound = 0
            upperBound = 2
        }
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            platAnimation = SKAction.move(by: CGVector(dx: -platTexture.size().width, dy: 0), duration: 2)
            lowerBound = -1
            upperBound = 3
        }
        
        let platShift = SKAction.move(by: CGVector(dx: platTexture.size().width, dy: 0), duration: 0)
        let pAnimation = SKAction.sequence([platAnimation, platShift])
        let infinitePlat = SKAction.repeatForever(pAnimation)

        while lowerBound < upperBound {
            
            icePlatform = SKSpriteNode(texture: platTexture)
            icePlatform.position = CGPoint(x: platTexture.size().width * lowerBound, y: -self.frame.size.height / 2.25)
            
            
            if(UIDevice.current.userInterfaceIdiom == .phone)
            {
                icePlatform.size.width = icePlatform.size.width * 1.01
                icePlatform.size.height = 50
            }
            
            if(UIDevice.current.userInterfaceIdiom == .pad)
            {
                icePlatform.size.width = icePlatform.size.width * 1.01
                icePlatform.size.height = 200
            }
            icePlatform.run(infinitePlat)

            icePlatform.name = "platform" + lowerBound.description
            cameraNode.addChild(icePlatform)
            lowerBound += 1

            // Set background first
            icePlatform.zPosition = -1
        }
        
    }
    
    func drawBackground() {
        
        var lowerBound: CGFloat = 0
        var upperBound: CGFloat = 0
        var backgAnimation: SKAction = SKAction()
        var backgShift: SKAction = SKAction()
        
        let backgTexture = SKTexture(imageNamed: backgName)
                
        if(UIDevice.current.userInterfaceIdiom == .phone)
        {
            backgAnimation = SKAction.move(by: CGVector(dx: round(-backgTexture.size().width / 2), dy: 0), duration: 3)
            
            backgShift = SKAction.move(by: CGVector(dx: round(backgTexture.size().width / 2), dy: 0), duration: 0)
            lowerBound = -1
            upperBound = 3
        }
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            backgAnimation = SKAction.move(by: CGVector(dx: round(-backgTexture.size().width), dy: 0), duration: 2.67)
            
            backgShift = SKAction.move(by: CGVector(dx: round(backgTexture.size().width), dy: 0), duration: 0)
            lowerBound = 0
            upperBound = 2
        }
        
        let bgAnimation = SKAction.sequence([backgAnimation, backgShift])
        let infiniteBackg = SKAction.repeatForever(bgAnimation)

        while lowerBound < upperBound {
            
            icyBackground = SKSpriteNode(texture: backgTexture)
            
            if(UIDevice.current.userInterfaceIdiom == .pad)
            {
                icyBackground.position = CGPoint(x: round((backgTexture.size().width * lowerBound) / 1.001), y: self.frame.midY)
                icyBackground.size.height = round(self.frame.size.height)
            }
            
            if(UIDevice.current.userInterfaceIdiom == .phone)
            {
                icyBackground.position = CGPoint(x: round((backgTexture.size().width * lowerBound) / 2.005), y: self.frame.midY)
                icyBackground.size = CGSize(width: icyBackground.size.width / 2, height: icyBackground.size.height / 2)
            }
            icyBackground.run(infiniteBackg)

            icyBackground.name = "background" + lowerBound.description
            cameraNode.addChild(icyBackground)
            lowerBound += 1

            // Set background first
            icyBackground.zPosition = -2
        }
    }
    
    func drawCharacter() {
        
        let runningFrames: [SKTexture] = [SKTexture(imageNamed: "bobby-6"), SKTexture(imageNamed: "bobby-7"), SKTexture(imageNamed: "bobby-8"), SKTexture(imageNamed: "bobby-9"), SKTexture(imageNamed: "bobby-10"), SKTexture(imageNamed: "bobby-11")]
        
        let animate = SKAction.animate(with: runningFrames, timePerFrame: realCharSpeed)
        
        let runForever = SKAction.repeatForever(animate)
        
        hero = SKSpriteNode(imageNamed: "bobby-6")
        
        hero.size = CGSize(width: hero.size.width * (self.frame.size.width * 0.00035), height: hero.size.height * (self.frame.size.width * 0.00035))
        
        hero.position = CGPoint(x: -self.frame.size.width / 3, y: -self.frame.size.height / 3.35)

        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            hero.position.y = -self.frame.size.height / 3.5
        }
        hero.name = "hero"
        
        gameData.startingHeroPos = hero.position
        hero.zPosition = 0

        
        self.heroRunAction = runForever
        hero.run(runForever)
        
        hero.physicsBody = SKPhysicsBody(circleOfRadius: hero.size.width / 3)
        hero.physicsBody?.affectedByGravity = false
        hero.physicsBody?.categoryBitMask = ColliderType.hero
        hero.physicsBody?.isDynamic = true
        
        self.addChild(hero)
    }
    
    func drawCoin() {
        
        let coinFrames: [SKTexture] = [SKTexture(imageNamed: "goldcoin-1"), SKTexture(imageNamed: "goldcoin-2"), SKTexture(imageNamed: "goldcoin-3"), SKTexture(imageNamed: "goldcoin-4"), SKTexture(imageNamed: "goldcoin-5"), SKTexture(imageNamed: "goldcoin-6"), SKTexture(imageNamed: "goldcoin-7"), SKTexture(imageNamed: "goldcoin-8"), SKTexture(imageNamed: "goldcoin-9")]
        
        let coinAnim = SKAction.animate(with: coinFrames, timePerFrame: realCharSpeed)
        let coinShift = SKAction.moveTo(x: -self.frame.size.width, duration: 2.5)
        let coinRevert = SKAction.moveTo(x: self.frame.size.width, duration: 0)
        
        let coinSeq = SKAction.sequence([coinShift, coinRevert])
        
        let coinAnimRepeater = SKAction.repeatForever(coinAnim)
        let shiftRepeater = SKAction.repeat(coinSeq, count: 1)
    
        coin.run(coinAnimRepeater)
        coin.run(shiftRepeater, completion: fadeInCoin)
    }
    
    func fadeInCoin() {
        
        coin.alpha = 1.0
    }
    
    func fadeOutCoin() {
        
        let fadeOut = SKAction.fadeOut(withDuration: 0.15)
        
        let fadeRepeater = SKAction.repeat(fadeOut, count: 1)
        
        coin.run(fadeRepeater)
    }
    
    @objc func slideHero() {
        
        if(!isReady())
        {
            print("in-motion")
            return
        }
        
        hero.removeAllActions()
        hero.texture = SKTexture(imageNamed: "bobby-5")
        
        var duckAnim: SKAction = SKAction()
        
        if(UIDevice.current.userInterfaceIdiom == .phone)
        {
            duckAnim = SKAction.moveBy(x: 250, y: -20, duration: 0.25)
        }
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            duckAnim = SKAction.moveBy(x: 300, y: -20, duration: 0.25)
        }
                
        let duckRepeater = SKAction.repeat(duckAnim, count: 1)
        
        hero.run(duckRepeater, completion: duckMoveUp)
        
    }
    
    func duckMoveUp() {
        
        var duckReversion: SKAction = SKAction()
        
        duckReversion = SKAction.moveTo(y: gameData.startingHeroPos.y, duration: 0.1)
        
        hero.run(duckReversion, completion: duckRevert)
        
    }
    
    func duckRevert() {
        
        var duckReversion: SKAction = SKAction()
        
        duckReversion = SKAction.move(to: CGPoint(x: -self.frame.size.width / 3, y: gameData.startingHeroPos.y), duration: 0.15)
        
        hero.run(duckReversion, completion: resumeRunning)
    }
    
    func currentTimeInMilliSeconds()-> Int {
        
        let currentDate = Date()
        let since1970 = currentDate.timeIntervalSince1970
        return Int(since1970 * 1000)
    }
    
    func isReady() -> Bool {
        
        let currentTime = currentTimeInMilliSeconds()
        
        if((recordedTime == 0) || (abs(currentTime - recordedTime) >= 500))
        {
            recordedTime = currentTime
            return true
        }
        
        return false
    }
    
    
    @objc func jumpHero() {
        
        if(!isReady())
        {
            print("in-motion")
            return
        }
        
        hero.removeAllActions()
        hero.texture = SKTexture(imageNamed: "bobby-12")
        
        var jumpAnim: SKAction = SKAction()
        
        if(UIDevice.current.userInterfaceIdiom == .phone)
        {
            jumpAnim = SKAction.moveTo(y: self.frame.size.height / 6, duration: 0.25)
        }
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            jumpAnim = SKAction.moveTo(y: self.frame.size.height / 24, duration: 0.25)
        }
        
        let jumpRepeater = SKAction.repeat(jumpAnim, count: 1)
        
        hero.run(jumpRepeater, completion: jumpLanding)
    }
    
    func jumpLanding() {
        
        hero.texture = SKTexture(imageNamed: "bobby-13")
        
        var landAnim: SKAction = SKAction()
        
        landAnim = SKAction.moveTo(y: gameData.startingHeroPos.y, duration: 0.25)
        
        let landRepeater = SKAction.repeat(landAnim, count: 1)
        
        hero.run(landRepeater, completion: resumeRunning)
    }
    
    func drawSnowman() {
        
        evilSnowman.isHidden = false
        
        let snowmanFrames: [SKTexture] = [SKTexture(imageNamed: "evilsnowman-1"), SKTexture(imageNamed: "evilsnowman-2"), SKTexture(imageNamed: "evilsnowman-3"), SKTexture(imageNamed: "evilsnowman-4"), SKTexture(imageNamed: "evilsnowman-5"), SKTexture(imageNamed: "evilsnowman-6"), SKTexture(imageNamed: "evilsnowman-7"), SKTexture(imageNamed: "evilsnowman-8")]
 
        let snowmanAnimate = SKAction.animate(with: snowmanFrames, timePerFrame: characterSpeed / 2)
        let snowmanShift = SKAction.moveTo(x: -self.frame.size.width, duration: 2.75)
        let snowmanRevert = SKAction.moveTo(x: self.frame.size.width, duration: 0)
        
        let shiftSeq = SKAction.sequence([snowmanShift, snowmanRevert])
        
        let shiftRepeater = SKAction.repeat(shiftSeq, count: 1)
        let snowmanRepeater = SKAction.repeat(snowmanAnimate, count: 1)
        
        evilSnowman.run(snowmanRepeater, completion: drawThrownSnowball)
        evilSnowman.run(shiftRepeater)
    }
    
    func drawYeti() {
        
        let yetiFrames: [SKTexture] = [SKTexture(imageNamed: "snowyeti-1"), SKTexture(imageNamed: "snowyeti-2"), SKTexture(imageNamed: "snowyeti-3"), SKTexture(imageNamed: "snowyeti-4"), SKTexture(imageNamed: "snowyeti-5"), SKTexture(imageNamed: "snowyeti-6"), SKTexture(imageNamed: "snowyeti-7"), SKTexture(imageNamed: "snowyeti-8"), SKTexture(imageNamed: "snowyeti-9"), SKTexture(imageNamed: "snowyeti-10"), SKTexture(imageNamed: "snowyeti-11")]
        
        //let yetiFrames: [SKTexture] = [SKTexture(imageNamed: "snowyeti-12"), SKTexture(imageNamed: "snowyeti-13"), SKTexture(imageNamed: "snowyeti-14"), SKTexture(imageNamed: "snowyeti-15"), SKTexture(imageNamed: "snowyeti-16"), SKTexture(imageNamed: "snowyeti-17"), SKTexture(imageNamed: "snowyeti-18")]
        
        let yetiAnimate = SKAction.animate(with: yetiFrames, timePerFrame: characterSpeed / 7)
        self.yetiRunAction = yetiAnimate
        let yetiShift = SKAction.moveTo(x: -self.frame.size.width, duration: 2)
        let yetiRevert = SKAction.moveTo(x: self.frame.size.width, duration: 0)
        
        let shiftSeq = SKAction.sequence([yetiShift, yetiRevert])
        
        let shiftRepeater = SKAction.repeatForever(shiftSeq)
        let animateRepeater = SKAction.repeat(yetiAnimate, count: 2)
        
        snowYeti.run(animateRepeater, completion: yetiAttackAnimation)
        snowYeti.run(shiftRepeater)
    }
    
    func yetiAttackAnimation() {
        
        let attackFrames: [SKTexture] = [SKTexture(imageNamed: "snowyeti-12"), SKTexture(imageNamed: "snowyeti-13"), SKTexture(imageNamed: "snowyeti-14"), SKTexture(imageNamed: "snowyeti-15"), SKTexture(imageNamed: "snowyeti-16"), SKTexture(imageNamed: "snowyeti-17"), SKTexture(imageNamed: "snowyeti-18")]
        
        let attackAnimate = SKAction.animate(with: attackFrames, timePerFrame: characterSpeed / 3)
        
        let attackRepeater = SKAction.repeat(attackAnimate, count: 1)
        
        snowYeti.run(attackRepeater, completion: yetiResumeRunning)
    }
    
    func yetiResumeRunning() {
        
        let yetiRunRepeater = SKAction.repeat(yetiRunAction, count: 1)
        
        snowYeti.run(yetiRunRepeater, completion: revertYeti)
    }
    
    func revertYeti() {
        
        snowYeti.removeAllActions()
        snowYeti.position.x = self.frame.size.width
    }
    
    func disappearSnowman() {
        
        let vanish = SKAction.fadeOut(withDuration: 0.5)
        
        let vanishRepeater = SKAction.repeat(vanish, count: 1)
        
        evilSnowman.run(vanishRepeater, completion: revertSnowman)
    }
    
    func revertSnowman() {
        
        evilSnowman.isHidden = true
        evilSnowman.position.x = self.frame.size.width
        
        let fadeIn = SKAction.fadeIn(withDuration: 0)
        
        let fadeRepeater = SKAction.repeat(fadeIn, count: 1)
        
        evilSnowman.run(fadeRepeater)
    }
    
    func revertSnowball() {
        
        snowball.alpha = 1.0
        snowball.position = CGPoint(x: self.frame.width, y: -self.frame.size.height / 4.75)
    }
    
    func drawThrownSnowball() {
        
        let rand = Int.random(in: 1 ... 2)
        var extraAnim: [SKTexture]?
        
        evilSnowman.removeAllActions()
        evilSnowman.texture = SKTexture(imageNamed: "evilsnowman-9")
        
        if(rand == 2)
        {
            extraAnim = [SKTexture(imageNamed: "evilsnowman-9"), SKTexture(imageNamed: "evilsnowman-10")]
            
            let extraAnimation = SKAction.animate(with: extraAnim!, timePerFrame: characterSpeed / 2)
            
            let extraRepeater = SKAction.repeat(extraAnimation, count: 1)
            
            evilSnowman.run(extraRepeater)
        }
        
        let snowmanShift = SKAction.moveTo(x: self.frame.size.width, duration: characterSpeed * 4)
        
        let snowmanShiftRepeater = SKAction.repeat(snowmanShift, count: 1)
        
        evilSnowman.run(snowmanShiftRepeater)
        
        let snowBallFrames: [SKTexture] = [SKTexture(imageNamed: "snowbol-1"), SKTexture(imageNamed: "snowbol-2"), SKTexture(imageNamed: "snowbol-3"), SKTexture(imageNamed: "snowbol-4"), SKTexture(imageNamed: "snowbol-5"), SKTexture(imageNamed: "snowbol-6"), SKTexture(imageNamed: "snowbol-7"), SKTexture(imageNamed: "snowbol-8")]
        
        let animate = SKAction.animate(with: snowBallFrames, timePerFrame: characterSpeed / 2)
        let snowballShift = SKAction.moveTo(x: -self.frame.size.width, duration: 1.25)
        let snowballRevert = SKAction.moveTo(x: self.frame.size.width, duration: 0)
        
        let shiftSeq = SKAction.sequence([snowballShift, snowballRevert])
        
        let shiftRepeater = SKAction.repeat(shiftSeq, count: 1)
        let animateRepeater = SKAction.repeatForever(animate)
        
        snowball.position.x = evilSnowman.position.x
        
        if(rand == 1)
        {
            snowball.position.y = -self.frame.size.height / 8
        }
        
        if(rand == 2)
        {
            snowball.position.y = -self.frame.size.height / 3.5
        }

        snowball.run(shiftRepeater)
        snowball.run(animateRepeater)
    }
    
    func drawFallenSnowball() {
        
        let rand: Int = 1
        
        let startingY = matchSnowballX(rand: rand)
        
        snowball.position = CGPoint(x: startingY, y: self.frame.size.height)
        
        let snowballFall = SKAction.move(to: CGPoint(x: gameData.startingHeroPos.x, y: gameData.startingHeroPos.y - 25), duration: 1)
        
        let fallRepeater = SKAction.repeat(snowballFall, count: 1)
        
        snowball.run(fallRepeater, completion: fadeSnowball)
    }
    
    func fadeSnowball() {
        
        let fadeOut = SKAction.fadeOut(withDuration: 0.1)
        
        snowball.run(fadeOut, completion: revertSnowball)
    }
    
    func matchSnowballX(rand: Int) -> CGFloat {
        
        var startingX: CGFloat = CGFloat()
        
        switch(rand) {
            
            case 1:
                startingX = hero.position.x
            case 2:
                startingX = self.frame.size.width
                break
            default:
                print("other")
        }
        
        return startingX
    
    }
    
    func drawCoyote() {
        
        let coyoteFrames: [SKTexture] = [SKTexture(imageNamed: "coy-1"), SKTexture(imageNamed: "coy-2"), SKTexture(imageNamed: "coy-3"), SKTexture(imageNamed: "coy-4"), SKTexture(imageNamed: "coy-5"), SKTexture(imageNamed: "coy-6"), SKTexture(imageNamed: "coy-7"), SKTexture(imageNamed: "coy-8"), SKTexture(imageNamed: "coy-9")]//, SKTexture(imageNamed: "coyote-10")]//, SKTexture(imageNamed: "coyote-11"), SKTexture(imageNamed: "coyote-12"), SKTexture(imageNamed: "coyote-13"), SKTexture(imageNamed: "coyote-14"), SKTexture(imageNamed: "coyote-15"), SKTexture(imageNamed: "coyote-16"), SKTexture(imageNamed: "coyote-17"), SKTexture(imageNamed: "coyote-18")]
        
        let coyoteAnimate = SKAction.animate(with: coyoteFrames, timePerFrame: characterSpeed / 4)
        self.coyoteDashAction = coyoteAnimate
        let coyoteShift = SKAction.moveTo(x: -self.frame.size.width, duration: 1.25)
        let coyoteRevert = SKAction.moveTo(x: self.frame.size.width, duration: 0)
        
        let shiftSeq = SKAction.sequence([coyoteShift, coyoteRevert])
        
        let shiftRepeater = SKAction.repeat(shiftSeq, count: 1)
        let coyoteAnimateRepeater = SKAction.repeat(coyoteAnimate, count: 1)
        
        coyote.run(shiftRepeater)
        coyote.run(coyoteAnimateRepeater, completion: coyoteAttackAnimation)
        
    }
    
    func coyoteAttackAnimation() {
        
        let attackFrames: [SKTexture] = [SKTexture(imageNamed: "coy-11"), SKTexture(imageNamed: "coy-12"), SKTexture(imageNamed: "coy-13"), SKTexture(imageNamed: "coy-14"), SKTexture(imageNamed: "coy-15"), SKTexture(imageNamed: "coy-16"), SKTexture(imageNamed: "coy-17"), SKTexture(imageNamed: "coy-18")]
        
        let attackAnimate = SKAction.animate(with: attackFrames, timePerFrame: characterSpeed / 3)
        let rise = SKAction.moveTo(y: self.frame.size.height / 8, duration: characterSpeed / 1.5)
        let drop = SKAction.moveTo(y: -self.frame.size.height / 3.65, duration: characterSpeed / 1.5)
        
        let riseSeq = SKAction.sequence([rise, drop])
        
        let riseRepeater = SKAction.repeat(riseSeq, count: 1)
        let attackRepeater = SKAction.repeat(attackAnimate, count: 1)
        
        coyote.run(riseRepeater)
        coyote.run(attackRepeater, completion: coyoteResumeRunning)
    }
    
    func coyoteResumeRunning() {
        
        coyote.run(coyoteDashAction)
    }
    
    func drawSnake() {
        
        let snakeFrames: [SKTexture] = [SKTexture(imageNamed: "snake-1"), SKTexture(imageNamed: "snake-2"), SKTexture(imageNamed: "snake-3"), SKTexture(imageNamed: "snake-4"), SKTexture(imageNamed: "snake-5"), SKTexture(imageNamed: "snake-6"), SKTexture(imageNamed: "snake-7"), SKTexture(imageNamed: "snake-8"), SKTexture(imageNamed: "snake-9"), SKTexture(imageNamed: "snake-10"), SKTexture(imageNamed: "snake-11")]//, SKTexture(imageNamed: "snake-12")]//, SKTexture(imageNamed: "snake-13"), SKTexture(imageNamed: "snake-14"), SKTexture(imageNamed: "snake-15")]
        
        let snakeAnimate = SKAction.animate(with: snakeFrames, timePerFrame: 0.15)
        let snakeShift = SKAction.moveTo(x: -self.frame.size.width, duration: 1.5)
        let snakeRevert = SKAction.moveTo(x: self.frame.size.width, duration: 0)
        
        let snakeSeq = SKAction.sequence([snakeShift, snakeRevert])
        
        let shiftRepeater = SKAction.repeat(snakeSeq, count: 1)
        let snakeRepeater = SKAction.repeat(snakeAnimate, count: 1)
        
        snake.run(snakeRepeater)
        snake.run(shiftRepeater)
    }
    
    func drawBat() {
        
        let batFrames: [SKTexture] = [SKTexture(imageNamed: "bat-1"), SKTexture(imageNamed: "bat-2"), SKTexture(imageNamed: "bat-3"), SKTexture(imageNamed: "bat-4")]
        
        let batAnim = SKAction.animate(with: batFrames, timePerFrame: 0.2)
        let batAnimRepeater = SKAction.repeatForever(batAnim)
        let batShift = SKAction.moveTo(x: -self.frame.width, duration: 1.5)
        
        let batReversion = SKAction.moveTo(x: self.frame.width, duration: 0)
        let batSeq = SKAction.sequence([batShift, batReversion])
        let reversionRepeater = SKAction.repeat(batSeq, count: 1)
                
        batSprite.run(batAnimRepeater)
        batSprite.run(reversionRepeater)
    }
    
    func drawSpider() {
        
        let spiderFrames: [SKTexture] = [SKTexture(imageNamed: "spider-1"), SKTexture(imageNamed: "spider-2"), SKTexture(imageNamed: "spider-3"), SKTexture(imageNamed: "spider-4"), SKTexture(imageNamed: "spider-5"), SKTexture(imageNamed: "spider-6"), SKTexture(imageNamed: "spider-7")]//, SKTexture(imageNamed: "spider-8"), SKTexture(imageNamed: "spider-9"), SKTexture(imageNamed: "spider-10"), SKTexture(imageNamed: "spider-11"), SKTexture(imageNamed: "spider-12"), SKTexture(imageNamed: "spider-13")]
        
        let spiderAnimate = SKAction.animate(with: spiderFrames, timePerFrame: characterSpeed / 2)
        
        let spiderShift = SKAction.moveTo(x: -self.frame.size.width, duration: 1.5)
        
        let spiderRevert = SKAction.moveTo(x: self.frame.size.width, duration: 0)
        
        let spiderSeq = SKAction.sequence([spiderShift, spiderRevert])
        
        let animateRepeater = SKAction.repeatForever(spiderAnimate)
        let shiftRepeater = SKAction.repeat(spiderSeq, count: 1)
        
        spider.run(animateRepeater)
        spider.run(shiftRepeater)
    }
    
    func drawGolem() {
        
        let golemFrames: [SKTexture] = [SKTexture(imageNamed: "golem-1"), SKTexture(imageNamed: "golem-2"), SKTexture(imageNamed: "golem-3"), SKTexture(imageNamed: "golem-4"), SKTexture(imageNamed: "golem-5")]
        
        let golemAnimate = SKAction.animate(with: golemFrames, timePerFrame: characterSpeed / 1.5)
        
        let golemShift = SKAction.moveTo(x: -self.frame.size.width, duration: 2.75)
        let golemRevert = SKAction.moveTo(x: self.frame.size.width, duration: 0)
        
        let shiftSeq = SKAction.sequence([golemShift, golemRevert])
        
        let shiftRepeater = SKAction.repeat(shiftSeq, count: 1)
        let golemRepeater = SKAction.repeat(golemAnimate, count: 1)
        
        golem.run(golemRepeater, completion: drawThrownRock)
        golem.run(shiftRepeater)
    }
    
    func drawThrownRock() {
        
        let rand = Int.random(in: 1 ... 2)
        var extraAnim: [SKTexture]?
        
        golem.removeAllActions()
        golem.texture = SKTexture(imageNamed: "golem-5")
        
        if(rand == 2)
        {
            extraAnim = [SKTexture(imageNamed: "golem-6"), SKTexture(imageNamed: "golem-7")]
            
            let extraAnimation = SKAction.animate(with: extraAnim!, timePerFrame: characterSpeed / 2)
            
            let extraRepeater = SKAction.repeat(extraAnimation, count: 1)
            
            golem.run(extraRepeater)
        }
        
        let golemShift = SKAction.moveTo(x: self.frame.size.width, duration: characterSpeed * 4)
        
        let golemShiftRepeater = SKAction.repeat(golemShift, count: 1)
        
        golem.run(golemShiftRepeater)
        
        let rockFrames: [SKTexture] = [SKTexture(imageNamed: "roc-1"), SKTexture(imageNamed: "roc-2"), SKTexture(imageNamed: "roc-3"), SKTexture(imageNamed: "roc-4"), SKTexture(imageNamed: "roc-5"), SKTexture(imageNamed: "roc-6"), SKTexture(imageNamed: "roc-7")]
        
        let animate = SKAction.animate(with: rockFrames, timePerFrame: characterSpeed / 2)
        let rockShift = SKAction.moveTo(x: -self.frame.size.width, duration: 1.25)
        let rockRevert = SKAction.moveTo(x: self.frame.size.width, duration: 0)
        
        let shiftSeq = SKAction.sequence([rockShift, rockRevert])
        
        let shiftRepeater = SKAction.repeat(shiftSeq, count: 1)
        let animateRepeater = SKAction.repeatForever(animate)
        
        rock.position.x = golem.position.x
        
        if(rand == 1)
        {
            rock.position.y = -self.frame.size.height / 8
        }
        
        if(rand == 2)
        {
            rock.position.y = -self.frame.size.height / 3.5
        }

        rock.run(shiftRepeater)
        rock.run(animateRepeater)
    }
    
    func initObjects() {
        
        //Evil Snowman
        evilSnowman = SKSpriteNode(imageNamed: "evilsnowman-1")
        evilSnowman.size = CGSize(width: evilSnowman.size.width * (self.frame.size.width * 0.001), height: evilSnowman.size.height * (self.frame.size.width * 0.001))
        
        if(UIDevice.current.userInterfaceIdiom == .phone)
        {
            evilSnowman.position = CGPoint(x: self.frame.width, y: -self.frame.size.height / 4.6)
        }
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            evilSnowman.position = CGPoint(x: self.frame.width, y: -self.frame.size.height / 3.9)
         }
        evilSnowman.xScale = -1
        self.addChild(evilSnowman)
        
        //Snow Yeti
        snowYeti = SKSpriteNode(imageNamed: "snowyeti-1")
        snowYeti.size = CGSize(width: snowYeti.size.width * (self.frame.size.width * 0.001), height: snowYeti.size.height * (self.frame.size.width * 0.001))
        snowYeti.name = "yeti"
        
        if(UIDevice.current.userInterfaceIdiom == .phone)
        {
            snowYeti.position = CGPoint(x: self.frame.size.width, y: -self.frame.size.height / 3.8)// self.frame.width, y: -self.frame.size.height / 4.15)
        }
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            snowYeti.position = CGPoint(x: self.frame.width, y: -self.frame.size.height / 3.65)
        }
        
        snowYeti.xScale = -1
        
        snowYeti.physicsBody = SKPhysicsBody(circleOfRadius: snowYeti.size.width / 3)
        snowYeti.physicsBody?.affectedByGravity = false
        snowYeti.physicsBody?.categoryBitMask = ColliderType.yeti
        snowYeti.physicsBody?.collisionBitMask = ColliderType.hero
        snowYeti.physicsBody?.contactTestBitMask = ColliderType.hero
        snowYeti.physicsBody?.isDynamic = false
        
        self.addChild(snowYeti)
        
        //Snowball (Falling and Thrown)
        snowball = SKSpriteNode(imageNamed: "snowbol-1")
        snowball.position = CGPoint(x: evilSnowman.position.x, y: -self.frame.size.height / 4.75)
        snowball.name = "snowball"
        
        
        snowball.size = CGSize(width: snowball.size.width * (self.frame.size.width * 0.001), height: snowball.size.height * (self.frame.size.width * 0.001))
        
        snowball.physicsBody = SKPhysicsBody(circleOfRadius: snowball.size.width / 2)
        snowball.physicsBody?.affectedByGravity = false
        snowball.physicsBody?.categoryBitMask = ColliderType.snowBall
        snowball.physicsBody?.collisionBitMask = ColliderType.hero
        snowball.physicsBody?.contactTestBitMask = ColliderType.hero
        snowball.physicsBody?.isDynamic = false
        
        self.addChild(snowball)
        
        //Coyote
        
        coyote = SKSpriteNode(imageNamed: "coy-1")
        coyote.size = CGSize(width: coyote.size.width * (self.frame.size.width * 0.001), height: coyote.size.height * (self.frame.size.width * 0.001))
        coyote.name = "coyote"
        
        if(UIDevice.current.userInterfaceIdiom == .phone)
        {
            coyote.position = CGPoint(x: self.frame.size.width, y: -self.frame.size.height / 3.5)//-self.frame.size.height / 4.15)
        }
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            coyote.position = CGPoint(x: self.frame.size.width, y: -self.frame.size.height / 3.65)
        }
        
        coyote.xScale = -1
        
        coyote.physicsBody = SKPhysicsBody(circleOfRadius: coyote.size.width / 3.5, center: CGPoint(x: -20, y: 0))
        coyote.physicsBody?.affectedByGravity = false
        coyote.physicsBody?.categoryBitMask = ColliderType.coyote
        coyote.physicsBody?.collisionBitMask = ColliderType.hero
        coyote.physicsBody?.contactTestBitMask = ColliderType.hero
        coyote.physicsBody?.isDynamic = false
        
        self.addChild(coyote)
        
        //Snake
        
        snake = SKSpriteNode(imageNamed: "snake-1")
        snake.size = CGSize(width: snake.size.width * (self.frame.size.width * 0.001), height: snake.size.height * (self.frame.size.width * 0.001))
        snake.name = "snake"
        
        if(UIDevice.current.userInterfaceIdiom == .phone)
        {
            snake.position = CGPoint(x: self.frame.size.width, y: -self.frame.size.height / 2.6)
        }
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            snake.position = CGPoint(x: self.frame.size.width, y: -self.frame.size.height / 2.75)
        }
        snake.xScale = -1
        
        snake.physicsBody = SKPhysicsBody(circleOfRadius: snake.size.width / 3.25, center: CGPoint(x: -10, y: 10))
        snake.physicsBody?.affectedByGravity = false
        snake.physicsBody?.categoryBitMask = ColliderType.snake
        snake.physicsBody?.collisionBitMask = ColliderType.hero
        snake.physicsBody?.contactTestBitMask = ColliderType.hero
        snake.physicsBody?.isDynamic = false
        
        self.addChild(snake)
        
        //Sandstorm
        
        sandstorm = SKSpriteNode(imageNamed: "sandtwister-1")
        sandstorm.size = CGSize(width: sandstorm.size.width * (self.frame.size.width * 0.0004), height: sandstorm.size.height * (self.frame.size.width * 0.0004))
        sandstorm.name = "sandstorm"

        
        if(UIDevice.current.userInterfaceIdiom == .phone)
        {
            sandstorm.position = CGPoint(x: self.frame.size.width, y: -self.frame.size.height / 4)
        }
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            sandstorm.position = CGPoint(x: self.frame.size.width, y: -self.frame.size.height / 4)
        }
        
        sandstorm.physicsBody = SKPhysicsBody(circleOfRadius: sandstorm.size.width / 2.5)
        sandstorm.physicsBody?.affectedByGravity = false
        sandstorm.physicsBody?.categoryBitMask = ColliderType.sandstorm
        sandstorm.physicsBody?.collisionBitMask = ColliderType.hero
        sandstorm.physicsBody?.contactTestBitMask = ColliderType.hero
        sandstorm.physicsBody?.isDynamic = false
        
        self.addChild(sandstorm)
        
        //Bat
        
        batSprite = SKSpriteNode(imageNamed: "bat-1")
        batSprite.size = CGSize(width: batSprite.size.width * (self.frame.size.width * 0.0005), height: batSprite.size.height * (self.frame.size.width * 0.0005))
        batSprite.name = "bat"
        
        if(UIDevice.current.userInterfaceIdiom == .phone)
        {
            batSprite.position = CGPoint(x: self.frame.size.width, y: -self.frame.size.height / 5.8)
        }
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            batSprite.position = CGPoint(x: self.frame.size.width, y: -self.frame.size.height / 4.75)
        }
        
        batSprite.xScale = -1
        
        batSprite.physicsBody = SKPhysicsBody(circleOfRadius: batSprite.size.width / 3.3)
        batSprite.physicsBody?.affectedByGravity = false
        batSprite.physicsBody?.categoryBitMask = ColliderType.bat
        batSprite.physicsBody?.collisionBitMask = ColliderType.hero
        batSprite.physicsBody?.contactTestBitMask = ColliderType.hero
        batSprite.physicsBody?.isDynamic = false
        
        self.addChild(batSprite)
        
        //Spider
        
        spider = SKSpriteNode(imageNamed: "spider-1")
        spider.size = CGSize(width: spider.size.width * (self.frame.size.width * 0.0009), height: spider.size.height * (self.frame.size.width * 0.0009))
        spider.name = "spider"
        
        if(UIDevice.current.userInterfaceIdiom == .phone)
        {
            spider.position = CGPoint(x: self.frame.size.width, y: -self.frame.size.height / 3.65)
        }
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            spider.position = CGPoint(x: self.frame.size.width, y: -self.frame.size.height / 3.65)
        }
        
        spider.xScale = -1
        
        spider.physicsBody = SKPhysicsBody(circleOfRadius: spider.size.width / 2.75, center: CGPoint(x: 20, y: -20))
        spider.physicsBody?.affectedByGravity = false
        spider.physicsBody?.categoryBitMask = ColliderType.spider
        spider.physicsBody?.collisionBitMask = ColliderType.hero
        spider.physicsBody?.contactTestBitMask = ColliderType.hero
        spider.physicsBody?.isDynamic = false
        
        self.addChild(spider)
        
        //Cave Golem
        
        golem = SKSpriteNode(imageNamed: "golem-1")
        golem.size = CGSize(width: golem.size.width * (self.frame.size.width * 0.001), height: golem.size.height * (self.frame.size.width * 0.001))
        
        if(UIDevice.current.userInterfaceIdiom == .phone)
        {
            golem.position = CGPoint(x: self.frame.size.width, y: -self.frame.size.height / 4.3)
        }
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            golem.position = CGPoint(x: self.frame.size.width, y: -self.frame.size.height / 3.9)
        }
    
        golem.xScale = -1
        self.addChild(golem)
        
        //Rock
        
        rock = SKSpriteNode(imageNamed: "roc-1")
        rock.position = CGPoint(x: golem.position.x, y: -self.frame.size.height / 4.75)
    
        rock.size = CGSize(width: rock.size.width * (self.frame.size.width * 0.001), height: rock.size.height * (self.frame.size.width * 0.001))
        rock.name = "rock"
        
        rock.physicsBody = SKPhysicsBody(circleOfRadius: rock.size.width / 2)
        rock.physicsBody?.affectedByGravity = false
        rock.physicsBody?.categoryBitMask = ColliderType.rock
        rock.physicsBody?.collisionBitMask = ColliderType.hero
        rock.physicsBody?.contactTestBitMask = ColliderType.hero
        rock.physicsBody?.isDynamic = false
        
        self.addChild(rock)
        
        //Coin
        
        coin = SKSpriteNode(imageNamed: "goldcoin-1")
        coin.size = CGSize(width: coin.size.width * (self.frame.size.width * 0.00015), height: coin.size.height * (self.frame.size.width * 0.00015))
        coin.position = CGPoint(x: self.frame.size.width, y: gameData.startingHeroPos.y + 150)
        coin.name = "coin"
        
        coin.physicsBody = SKPhysicsBody(circleOfRadius: coin.size.width / 2)
        coin.physicsBody?.affectedByGravity = false
        coin.physicsBody?.categoryBitMask = ColliderType.coin
        coin.physicsBody?.collisionBitMask = ColliderType.hero
        coin.physicsBody?.contactTestBitMask = ColliderType.hero
        coin.physicsBody?.isDynamic = false
        
        self.addChild(coin)
    }
    
    func performDieAnimation() {
        
        self.view?.gestureRecognizers?.removeAll()
        //timer.invalidate()
        hero.removeAllActions()
        
        let rotation = SKAction.rotate(byAngle: ((3 * CGFloat.pi) / 2), duration: 0.3)
        
        let rotationAnim = SKAction.repeat(rotation, count: 1)
        
        hero.run(rotationAnim, completion: rotateBack)
    }
    
    func rotateBack() {
        
        let rotationBack = SKAction.rotate(byAngle: (-(3 * CGFloat.pi) / 2), duration: 0)
        let fall = SKAction.move(to: CGPoint(x: self.frame.minX / 2.35, y: self.frame.minY / 1.70), duration: 0.3)
        
        let rotationBackAnim = SKAction.repeat(rotationBack, count: 1)
        let fallAnim = SKAction.repeat(fall, count: 1)
        
        hero.texture = SKTexture(imageNamed: "bobby-16.png")
        hero.run(rotationBackAnim)
        hero.run(fallAnim, completion: endGame)
    }
    
    func pauseBackgAndPlatform() {
        
        for child in cameraNode.children
        {
            if((child.name == "background-1.0") || (child.name == "background0.0") || (child.name == "background1.0") || (child.name == "background2.0"))
            {
                child.speed = 0
            }
            
            if((child.name == "platform-1.0") || (child.name == "platform0.0") || (child.name == "platform1.0") || (child.name == "platform2.0"))
            {
                child.speed = 0
            }
        }
    }
    
    func resumeBackgAndPlatform() {
        
        for child in cameraNode.children
        {
            if((child.name == "background-1.0") || (child.name == "background0.0") || (child.name == "background1.0") || (child.name == "background2.0"))
            {
                child.speed = 1
            }
            
            if((child.name == "platform-1.0") || (child.name == "platform0.0") || (child.name == "platform1.0") || (child.name == "platform2.0"))
            {
                child.speed = 1
            }
        }
        
    }
    
    func performEndingAnimation() {
        
        let characterShift = SKAction.moveTo(x: self.frame.size.width / 2.5, duration: 2)
        
        let shiftRepeater = SKAction.repeat(characterShift, count: 1)
        
        hero.run(shiftRepeater, completion: pauseRunning)
    }
    
    func endGame() {
        
        pauseBackgAndPlatform()
        performEndingAnimation()
        showEndingMenu()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
                    
        if let touch = touches.first {
            
            let location = touch.previousLocation(in: self)
            let node = self.nodes(at: location).first
                        
            if(node?.name == "replay")
            {
                startGame()
            }
                
            else if((difficultySubBox1.contains(location)) || (difficultySubBox2.contains(location)) || (difficultySubBox3.contains(location)))
            {
                if((node?.name == "level-1") && (node?.name == "level-1text") || (node?.name == "level-2") || (node?.name == "level-2text") || (node?.name == "level-3") || (node?.name == "level-3text") ||  (node?.name == "onestar") || (node?.name == "twostar") || (node?.name == "threestar"))
                {
                    initializeGame()
                    difficultyBox.isHidden = true
                }
            }
            
            /*
            else if(((node?.name == "level-1") && (node?.name == "level-1text")) || ((node?.name == "level-1") && (node?.name == "onestar")))
            {
                print("hayo")
            }
             */
            
            
            else if((node?.name == "level-1") || (node?.name == "level-1text") || (node?.name == "level-2") || (node?.name == "level-2text") || (node?.name == "level-3") || (node?.name == "level-3text") || (node?.name == "onestar") || (node?.name == "twostar") || (node?.name == "threestar"))
            {
                print("sure")
            }
       }
    }
    
    func showEndingMenu() -> Void {
        
        var menuHeight: CGFloat = self.frame.size.height / 3.5
        var statusSize: CGFloat = self.frame.size.width * 0.05
        var statusXPos: CGFloat = self.frame.size.width / 10
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            menuHeight = self.frame.height / 4.15
            statusSize = self.frame.size.width * 0.06
            statusXPos = self.frame.size.width / 7
        }
        
        gameOverDisplay = SKShapeNode(rect: CGRect(x: -self.frame.width, y: self.frame.midY - 20, width: self.frame.width * 2, height: menuHeight))
        gameOverDisplay.fillColor = .black
        gameOverDisplay.alpha = 0.5
                
        levelAlert = SKLabelNode(fontNamed: "CarbonBl-Regular")
        levelAlert.fontColor = .white
        levelAlert.fontSize = statusSize
        levelAlert.position = CGPoint(x: -self.frame.size.width / 7.5, y: self.frame.size.height / 8)
        levelAlert.text = "Beta Run:"
        
        levelStatusAlert = SKLabelNode(fontNamed: "CarbonBl-Regular")
        levelStatusAlert.fontSize = statusSize
        levelStatusAlert.position = CGPoint(x: statusXPos, y: self.frame.size.height / 8)
        
        if(isLevelPassed)
        {
            levelStatusAlert.fontColor = .green
            levelStatusAlert.text = "COMPLETED"
        }

        else
        {
            levelStatusAlert.fontColor = .red
            levelStatusAlert.text = "INCOMPLETE"
        }
        
        //initReplayButton()
        //initHomeButton()
        
        initButtons()
        
        self.addChild(gameOverDisplay)
        self.addChild(levelAlert)
        self.addChild(levelStatusAlert)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        let nodeA = contact.bodyA.node
        let nodeB = contact.bodyB.node
        
        if(((nodeA?.name == "hero") && (nodeB?.name == "coin")) || ((nodeA?.name == "coin") && (nodeB?.name == "hero")))
        {
            fadeOutCoin()
            
            let fillerAction = SKAction.resize(toWidth: coin.size.width, duration: 1)

            hero.physicsBody?.isDynamic = false
            savedData.coinCount += 1
            
            coin.run(fillerAction, completion: makeHeroDynamic)
            return
        }
        else
        {
            hero.physicsBody?.isDynamic = false
            performDieAnimation()
        }
    }
    
    func makeHeroDynamic() {
        
        hero.physicsBody?.isDynamic = true
    }
    
    func cleanUp() {
        
        for child in self.children {
            
            if(!child.isEqual(to: cameraNode))
            {
                child.removeAllActions()
                child.removeFromParent()
            }
        }
   }
    
    func startGame() {
        
        cleanUp()
        resumeBackgAndPlatform()
        initializeGame()
    }
}
