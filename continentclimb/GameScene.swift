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

class GameScene: SKScene {
    
    let characterSpeed: TimeInterval = 0.25
    
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
    
    var oneStar: SKSpriteNode = SKSpriteNode()
    var twoStar: SKSpriteNode = SKSpriteNode()
    var threeStar: SKSpriteNode = SKSpriteNode()
    
    var platName: String = String()
    var backgName: String = String()
    var levelNames: [String] = [String]()
    
    
    override func didMove(to view: SKView) {
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(jumpHero))
        swipeUp.direction = .up
        self.view?.addGestureRecognizer(swipeUp)

        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(slideHero))
        swipeDown.direction = .down
        self.view?.addGestureRecognizer(swipeDown)
        
        (platName, backgName, levelNames) = PlistParser.getLayoutPackage(forKey: terrainKeyword, property1: "platform", property2: "background")
        
        
        GameViewController.gameScene = self
        scene?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        //selectDifficulty()
        initObjects()
        drawBackground()
        drawPlatform()
        //addSnow()
        drawCharacter()
 
    }
    
    func selectDifficulty() {
        
        difficultyBox = SKShapeNode(rectOf: CGSize(width: self.frame.size.width / 1.5, height: self.frame.size.width / 5))
        difficultyBox.fillTexture = SKTexture(imageNamed: "gradient.jpg")
        difficultyBox.fillColor = .white
        difficultyBox.strokeColor = .white
        difficultyBox.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        difficultyBox.lineWidth = 5
        
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
        difficultySubBox1.lineWidth = 5
        
        difficultyBox.addChild(difficultySubBox1)
        
        difficultySubText1 = SKLabelNode(fontNamed: "GemunuLibre-ExtraBold")
        difficultySubText1.fontColor = .black
        difficultySubText1.fontSize = self.frame.size.width / 45
        difficultySubText1.text = levelNames[1]
        difficultySubText1.position = CGPoint(x: 0, y: 0)
        
        difficultyBox.addChild(difficultySubText1)
        
        twoStar = SKSpriteNode(imageNamed: "two-star")
        twoStar.size = CGSize(width: self.frame.size.width / 9, height: self.frame.size.width / 9)
        twoStar.position = CGPoint(x: 0, y: 0)
        
        self.addChild(twoStar)
        
        twoStar.position.y = -self.frame.size.height / 9.25
        
        difficultySubBox2 = SKShapeNode(rectOf: CGSize(width: self.frame.size.width / 8, height: self.frame.size.width / 8))
        difficultySubBox2.fillColor = .green
        difficultySubBox2.strokeColor = .black
        difficultySubBox2.position = CGPoint(x: -self.frame.size.width / 4, y: -self.frame.height / 20)
        difficultySubBox2.lineWidth = 5
        
        difficultyBox.addChild(difficultySubBox2)
        
        difficultySubText2 = SKLabelNode(fontNamed: "GemunuLibre-ExtraBold")
        difficultySubText2.fontColor = .black
        difficultySubText2.fontSize = self.frame.size.width / 45
        difficultySubText2.text = levelNames[0]
        difficultySubText2.position = CGPoint(x: -self.frame.size.width / 4, y: 0)
        difficultyBox.addChild(difficultySubText2)
        
        oneStar = SKSpriteNode(imageNamed: "one-star")
        
        oneStar.size = CGSize(width: self.frame.size.width / 15, height: self.frame.size.width / 15)
        print(oneStar.size)
        
        oneStar.position = CGPoint(x: -self.frame.size.width / 3.95, y: -self.frame.size.height / 8.75)
        
        self.addChild(oneStar)
        
        difficultySubBox3 = SKShapeNode(rectOf: CGSize(width: self.frame.size.width / 8, height: self.frame.size.width / 8))
        difficultySubBox3.fillColor = .red
        difficultySubBox3.strokeColor = .black
        difficultySubBox3.position = CGPoint(x: self.frame.size.width / 4, y: -self.frame.height / 20)
        difficultySubBox3.lineWidth = 5
        
        difficultyBox.addChild(difficultySubBox3)
        
        difficultySubText3 = SKLabelNode(fontNamed: "GemunuLibre-ExtraBold")
        difficultySubText3.fontColor = .black
        difficultySubText3.fontSize = self.frame.size.width / 45
        difficultySubText3.text = levelNames[2]
        difficultySubText3.position = CGPoint(x: self.frame.size.width / 4, y: 0)
        
        difficultyBox.addChild(difficultySubText3)
        
        threeStar = SKSpriteNode(imageNamed: "three-star")
        threeStar.size = CGSize(width: self.frame.size.width / 6, height: self.frame.size.width / 6)
        threeStar.position = CGPoint(x: self.frame.size.width / 3.8, y: -self.frame.size.height / 8.5)
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            oneStar.position.y = -self.frame.size.height / 9.75
            twoStar.position.y = -self.frame.size.height / 10
            threeStar.position.y = -self.frame.size.height / 9.5
        }
        
        self.addChild(threeStar)
        
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
            sandstormShift = SKAction.moveTo(x: self.size.width / 3, duration: 0.5)
        }
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            sandstormShift = SKAction.moveTo(x: self.size.width / 2.5, duration: 0.33)
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
        
        let secondShift = SKAction.moveTo(x: -self.frame.size.width, duration: 1.5)
        
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
                icePlatform.size.width = icePlatform.size.width * 1.1
                icePlatform.size.height = 50
            }
            
            if(UIDevice.current.userInterfaceIdiom == .pad)
            {
                icePlatform.size.width = icePlatform.size.width * 1.01
                icePlatform.size.height = 200
            }
            icePlatform.run(infinitePlat)

            self.addChild(icePlatform)
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

            self.addChild(icyBackground)
            lowerBound += 1

            // Set background first
            icyBackground.zPosition = -2
        }
    }
    
    func drawCharacter() {
        
        let runningFrames: [SKTexture] = [SKTexture(imageNamed: "bobby-6"), SKTexture(imageNamed: "bobby-7"), SKTexture(imageNamed: "bobby-8"), SKTexture(imageNamed: "bobby-9"), SKTexture(imageNamed: "bobby-10"), SKTexture(imageNamed: "bobby-11")]
        
        let animate = SKAction.animate(with: runningFrames, timePerFrame: characterSpeed)
        
        let runForever = SKAction.repeatForever(animate)
        
        hero = SKSpriteNode(imageNamed: "bobby-6")
        
        hero.size = CGSize(width: hero.size.width * (self.frame.size.width * 0.00035), height: hero.size.height * (self.frame.size.width * 0.00035))
        print(hero.size)
        hero.position = CGPoint(x: -self.frame.size.width / 3, y: -self.frame.size.height / 3.55)
        
        if(UIDevice.current.userInterfaceIdiom == .phone)
        {
            hero.position.y = -self.frame.size.height / 3.35
        }
        
        initialYPos = hero.position.y
        hero.zPosition = 0

        
        self.heroRunAction = runForever
        hero.run(runForever)
        
        self.addChild(hero)
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
            duckAnim = SKAction.moveBy(x: 250, y: 0, duration: 0.5)
        }
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            duckAnim = SKAction.moveBy(x: 300, y: 0, duration: 0.5)
        }
        
        let duckRepeater = SKAction.repeat(duckAnim, count: 1)
        
        hero.run(duckRepeater, completion: duckRevert)
    }
    
    func duckRevert() {
        
        var duckReversion: SKAction = SKAction()
        
        if(UIDevice.current.userInterfaceIdiom == .phone)
        {
            duckReversion = SKAction.moveTo(x: -self.frame.size.width / 3, duration: 0.5)
        }
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            duckReversion = SKAction.moveTo(x: -self.frame.width / 3.1, duration: 0.5)
        }
        
        hero.run(duckReversion, completion: resumeRunning)
    }
    
    func currentTimeInMilliSeconds()-> Int {
        
        let currentDate = Date()
        let since1970 = currentDate.timeIntervalSince1970
        return Int(since1970 * 1000)
    }
    
    func isReady() -> Bool {
        
        let currentTime = currentTimeInMilliSeconds()
        
        if((recordedTime == 0) || (abs(currentTime - recordedTime) >= 1000))
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
            jumpAnim = SKAction.moveTo(y: self.frame.size.height / 6, duration: 0.5)
        }
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            jumpAnim = SKAction.moveTo(y: self.frame.size.height / 24, duration: 0.5)
        }
        
        let jumpRepeater = SKAction.repeat(jumpAnim, count: 1)
        
        hero.run(jumpRepeater, completion: jumpLanding)
    }
    
    func jumpLanding() {
        
        hero.texture = SKTexture(imageNamed: "bobby-13")
        
        var landAnim: SKAction = SKAction()
        
        landAnim = SKAction.moveTo(y: initialYPos, duration: 0.5)
        
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
        
        let rand = Int.random(in: 1 ... 2)
        
        let startingY = matchSnowballX(rand: rand)
        
        snowball.position = CGPoint(x: startingY, y: self.frame.size.height)
        
        let snowballFall = SKAction.move(to: CGPoint(x: -self.frame.size.width / 3.5, y: hero.position.y), duration: 1)
        
        let fallRepeater = SKAction.repeat(snowballFall, count: 1)
        
        snowball.run(fallRepeater, completion: fadeSnowball)
    }
    
    func fadeSnowball() {
        
        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        
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
        
        let coyoteFrames: [SKTexture] = [SKTexture(imageNamed: "wolf-1"), SKTexture(imageNamed: "wolf-2"), SKTexture(imageNamed: "wolf-3"), SKTexture(imageNamed: "wolf-4"), SKTexture(imageNamed: "wolf-5"), SKTexture(imageNamed: "wolf-6"), SKTexture(imageNamed: "wolf-7"), SKTexture(imageNamed: "wolf-8"), SKTexture(imageNamed: "wolf-9")]//, SKTexture(imageNamed: "coyote-10")]//, SKTexture(imageNamed: "coyote-11"), SKTexture(imageNamed: "coyote-12"), SKTexture(imageNamed: "coyote-13"), SKTexture(imageNamed: "coyote-14"), SKTexture(imageNamed: "coyote-15"), SKTexture(imageNamed: "coyote-16"), SKTexture(imageNamed: "coyote-17"), SKTexture(imageNamed: "coyote-18")]
        
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
        
        let attackFrames: [SKTexture] = [SKTexture(imageNamed: "wolf-11"), SKTexture(imageNamed: "wolf-12"), SKTexture(imageNamed: "wolf-13"), SKTexture(imageNamed: "wolf-14"), SKTexture(imageNamed: "wolf-15"), SKTexture(imageNamed: "wolf-16"), SKTexture(imageNamed: "wolf-17"), SKTexture(imageNamed: "wolf-18")]
        
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
        let snakeRevert = SKAction.moveTo(x: self.frame.size.height, duration: 0)
        
        let snakeSeq = SKAction.sequence([snakeShift, snakeRevert])
        
        let shiftRepeater = SKAction.repeat(snakeSeq, count: 1)
        let snakeRepeater = SKAction.repeat(snakeAnimate, count: 1)
        
        snake.run(snakeRepeater)
        snake.run(shiftRepeater)
    }
    
    func drawBat() {
        
        let batFrames: [SKTexture] = [SKTexture(imageNamed: "batframe-1"), SKTexture(imageNamed: "batframe-2"), SKTexture(imageNamed: "batframe-3"), SKTexture(imageNamed: "batframe-4")]
        
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
        
        if(UIDevice.current.userInterfaceIdiom == .phone)
        {
            snowYeti.position = CGPoint(x: self.frame.width, y: -self.frame.size.height / 3.8)// self.frame.width, y: -self.frame.size.height / 4.15)
        }
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            snowYeti.position = CGPoint(x: self.frame.width, y: -self.frame.size.height / 3.65)
        }
        
        snowYeti.xScale = -1
        self.addChild(snowYeti)
        
        //Snowball (Falling and Thrown)
        snowball = SKSpriteNode(imageNamed: "snowbol-1")
        snowball.position = CGPoint(x: evilSnowman.position.x, y: -self.frame.size.height / 4.75)
        
        
        snowball.size = CGSize(width: snowball.size.width * (self.frame.size.width * 0.001), height: snowball.size.height * (self.frame.size.width * 0.001))
        
        self.addChild(snowball)
        
        //Coyote
        
        coyote = SKSpriteNode(imageNamed: "coy-1")
        coyote.size = CGSize(width: coyote.size.width * (self.frame.size.width * 0.001), height: coyote.size.height * (self.frame.size.width * 0.001))
        
        if(UIDevice.current.userInterfaceIdiom == .phone)
        {
            coyote.position = CGPoint(x: 0, y: -self.frame.size.height / 3.5)//-self.frame.size.height / 4.15)
        }
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            coyote.position = CGPoint(x: 0, y: -self.frame.size.height / 3.65)
        }
        
        coyote.xScale = -1
        self.addChild(coyote)
        
        //Snake
        
        snake = SKSpriteNode(imageNamed: "snake-1")
        snake.size = CGSize(width: snake.size.width * (self.frame.size.width * 0.001), height: snake.size.height * (self.frame.size.width * 0.001))
        
        if(UIDevice.current.userInterfaceIdiom == .phone)
        {
            snake.position = CGPoint(x: self.frame.size.width, y: -self.frame.size.height / 2.6)
        }
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            snake.position = CGPoint(x: self.frame.size.width, y: -self.frame.size.height / 2.75)
        }
        snake.xScale = -1
        self.addChild(snake)
        
        //Sandstorm
        
        sandstorm = SKSpriteNode(imageNamed: "sandtwister-1")
        sandstorm.size = CGSize(width: sandstorm.size.width * (self.frame.size.width * 0.0004), height: sandstorm.size.height * (self.frame.size.width * 0.0004))

        
        if(UIDevice.current.userInterfaceIdiom == .phone)
        {
            sandstorm.position = CGPoint(x: self.frame.size.width, y: -self.frame.size.height / 4)
        }
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            sandstorm.position = CGPoint(x: self.frame.size.width, y: -self.frame.size.height / 4)
        }
        
        self.addChild(sandstorm)
        
        //Bat
        
        batSprite = SKSpriteNode(imageNamed: "batframe-1")
        batSprite.size = CGSize(width: batSprite.size.width * (self.frame.size.width * 0.0005), height: batSprite.size.height * (self.frame.size.width * 0.0005))
        
        if(UIDevice.current.userInterfaceIdiom == .phone)
        {
            batSprite.position = CGPoint(x: self.frame.size.width, y: -self.frame.size.height / 6)
        }
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            batSprite.position = CGPoint(x: self.frame.size.width, y: -self.frame.size.height / 5.5)
        }
        
        batSprite.xScale = -1
        self.addChild(batSprite)
        
        //Spider
        
        spider = SKSpriteNode(imageNamed: "spider-1")
        spider.size = CGSize(width: spider.size.width * (self.frame.size.width * 0.001), height: spider.size.height * (self.frame.size.width * 0.001))
        
        if(UIDevice.current.userInterfaceIdiom == .phone)
        {
            spider.position = CGPoint(x: self.frame.size.width, y: -self.frame.size.height / 3.75)
        }
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            spider.position = CGPoint(x: self.frame.size.width, y: -self.frame.size.height / 3.8)
        }
        
        spider.xScale = -1
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
        
        self.addChild(rock)
        
    }
}
