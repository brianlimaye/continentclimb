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
    
    var snow: SKEmitterNode = SKEmitterNode()
    
    override func didMove(to view: SKView) {
        
        GameViewController.gameScene = self
        scene?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        initObjects()
        drawBackground()
        drawPlatform()
        //addSnow()
        drawCharacter()
        //drawSnake()
    }
    
    func addSnow() {
        
        snow = SKEmitterNode(fileNamed: "snowEffect.sks")!
        snow.position.y = self.frame.size.height
        self.addChild(snow)
    }
    
    func resumeRunning() {
        
        hero.run(heroRunAction)
    }
    
    func drawPlatform() {
        
        var lowerBound: CGFloat = 0
        var upperBound: CGFloat = 0
                
        let platTexture = SKTexture(imageNamed: PlistParser.getKeyFromValue(forKey: "Platforms"))
            
        var platAnimation: SKAction = SKAction()
        
        if(UIDevice.current.userInterfaceIdiom == .phone)
        {
            platAnimation = SKAction.move(by: CGVector(dx: -platTexture.size().width, dy: 0), duration: 2.25)
            lowerBound = 0
            upperBound = 2
        }
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            platAnimation = SKAction.move(by: CGVector(dx: -platTexture.size().width, dy: 0), duration: 1.125)
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
        
        let backgTexture = SKTexture(imageNamed: PlistParser.getKeyFromValue(forKey: "Backgrounds"))
                
        if(UIDevice.current.userInterfaceIdiom == .phone)
        {
            backgAnimation = SKAction.move(by: CGVector(dx: round(-backgTexture.size().width / 2.01), dy: 0), duration: 3)
            
            backgShift = SKAction.move(by: CGVector(dx: round(backgTexture.size().width / 2.01), dy: 0), duration: 0)
            lowerBound = -1
            upperBound = 3
        }
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            backgAnimation = SKAction.move(by: CGVector(dx: round(-backgTexture.size().width), dy: 0), duration: 1.5)
            
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
                icyBackground.position = CGPoint(x: round((backgTexture.size().width * lowerBound)), y: self.frame.midY)
                icyBackground.size.height = round(self.frame.size.height)
            }
            
            if(UIDevice.current.userInterfaceIdiom == .phone)
            {
                icyBackground.position = CGPoint(x: round((backgTexture.size().width * lowerBound) / 2.01), y: self.frame.midY)
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
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            hero.size = CGSize(width: round((hero.size.width + (self.frame.size.width * 0.25)) / 4), height: round(hero.size.height + (self.frame.size.width * 0.25)) / 4)
            hero.position = CGPoint(x: -self.frame.size.width / 3, y: -self.frame.size.height / 3.1)
        }
        
        if(UIDevice.current.userInterfaceIdiom == .phone)
        {
            hero.size = CGSize(width: (hero.size.width + (self.frame.size.width * 0.1)) / 4, height: (hero.size.height + (self.frame.size.width * 0.1)) / 4)
            hero.position = CGPoint(x: -self.frame.size.width / 3, y: -self.frame.size.height / 3.35)
        }
        hero.zPosition = 0

        
        self.heroRunAction = runForever
        hero.run(runForever)
        
        self.addChild(hero)
    }
    
    func slideHero() {
        
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
    
    func jumpHero() {
        
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
        
        if(UIDevice.current.userInterfaceIdiom == .phone)
        {
            landAnim = SKAction.moveTo(y: -self.frame.size.height / 3.35, duration: 0.5)
        }
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            landAnim = SKAction.moveTo(y: -self.frame.size.height / 3.1, duration: 0.5)
        }
        
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
        
        let coyoteFrames: [SKTexture] = [SKTexture(imageNamed: "coyote-1"), SKTexture(imageNamed: "coyote-2"), SKTexture(imageNamed: "coyote-3"), SKTexture(imageNamed: "coyote-4"), SKTexture(imageNamed: "coyote-5"), SKTexture(imageNamed: "coyote-6"), SKTexture(imageNamed: "coyote-7"), SKTexture(imageNamed: "coyote-8"), SKTexture(imageNamed: "coyote-9")]//, SKTexture(imageNamed: "coyote-10")]//, SKTexture(imageNamed: "coyote-11"), SKTexture(imageNamed: "coyote-12"), SKTexture(imageNamed: "coyote-13"), SKTexture(imageNamed: "coyote-14"), SKTexture(imageNamed: "coyote-15"), SKTexture(imageNamed: "coyote-16"), SKTexture(imageNamed: "coyote-17"), SKTexture(imageNamed: "coyote-18")]
        
        let coyoteAnimate = SKAction.animate(with: coyoteFrames, timePerFrame: characterSpeed / 4.25)
        self.coyoteDashAction = coyoteAnimate
        let coyoteShift = SKAction.moveTo(x: -self.frame.size.width, duration: 2)
        let coyoteRevert = SKAction.moveTo(x: self.frame.size.width, duration: 0)
        
        let shiftSeq = SKAction.sequence([coyoteShift, coyoteRevert])
        
        let shiftRepeater = SKAction.repeat(shiftSeq, count: 1)
        let coyoteAnimateRepeater = SKAction.repeat(coyoteAnimate, count: 2)
        
        coyote.run(shiftRepeater)
        coyote.run(coyoteAnimateRepeater, completion: coyoteAttackAnimation)
        
    }
    
    func coyoteAttackAnimation() {
        
        let attackFrames: [SKTexture] = [SKTexture(imageNamed: "coyote-11"), SKTexture(imageNamed: "coyote-12"), SKTexture(imageNamed: "coyote-13"), SKTexture(imageNamed: "coyote-14"), SKTexture(imageNamed: "coyote-15"), SKTexture(imageNamed: "coyote-16"), SKTexture(imageNamed: "coyote-17"), SKTexture(imageNamed: "coyote-18")]
        
        let attackAnimate = SKAction.animate(with: attackFrames, timePerFrame: characterSpeed / 1.5)
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
    
    func initObjects() {
        
        //Evil Snowman
        evilSnowman = SKSpriteNode(imageNamed: "evilsnowman-1")
        
        if(UIDevice.current.userInterfaceIdiom == .phone)
        {
            evilSnowman.size = CGSize(width: (evilSnowman.size.width + (self.frame.size.width * 0.5)) / 4, height: (evilSnowman.size.height + (self.frame.size.width * 0.5)) / 4)
            evilSnowman.position = CGPoint(x: self.frame.width, y: -self.frame.size.height / 4.4)
        }
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            evilSnowman.size = CGSize(width: (evilSnowman.size.width + (self.frame.size.width * 0.65)) / 4, height: (evilSnowman.size.height + (self.frame.size.width * 0.65)) / 4)
            evilSnowman.position = CGPoint(x: self.frame.width, y: -self.frame.size.height / 3.9)
         }
        evilSnowman.xScale = -1
        self.addChild(evilSnowman)
        
        //Snow Yeti
        snowYeti = SKSpriteNode(imageNamed: "snowyeti-1")
        
        if(UIDevice.current.userInterfaceIdiom == .phone)
        {
            snowYeti.size = CGSize(width: (snowYeti.size.width + (self.frame.size.width * 0.5)) / 4, height: (snowYeti.size.height + (self.frame.size.width * 0.5)) / 4)
            snowYeti.position = CGPoint(x: self.frame.width, y: -self.frame.size.height / 4.15)
        }
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            snowYeti.size = CGSize(width: (snowYeti.size.width + (self.frame.size.width * 0.65)) / 4, height: (snowYeti.size.height + (self.frame.size.width * 0.65)) / 4)
            snowYeti.position = CGPoint(x: self.frame.width, y: -self.frame.size.height / 3.65)
        }
        
        snowYeti.xScale = -1
        self.addChild(snowYeti)
        
        //Snowball (Falling and Thrown)
        snowball = SKSpriteNode(imageNamed: "snowbol-1")
        snowball.position = CGPoint(x: evilSnowman.position.x, y: -self.frame.size.height / 4.75)
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            snowball.size = CGSize(width: snowball.size.width * 1.5, height: snowball.size.height * 1.5)
        }
        
        self.addChild(snowball)
        
        //Cayote
        
        coyote = SKSpriteNode(imageNamed: "coyote-1")
        
        if(UIDevice.current.userInterfaceIdiom == .phone)
        {
            coyote.size = CGSize(width: (coyote.size.width + (self.frame.size.width * 0.5)) / 4, height: (coyote.size.height + (self.frame.size.width * 0.5)) / 4)
            coyote.size = CGSize(width: coyote.size.width / 1.25, height: coyote.size.height / 1.25)
            coyote.position = CGPoint(x: self.frame.size.width, y: -self.frame.size.height / 3.65)//-self.frame.size.height / 4.15)
        }
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            coyote.size = CGSize(width: (coyote.size.width + (self.frame.size.width * 0.65)) / 4, height: (coyote.size.height + (self.frame.size.width * 0.65)) / 4)
            coyote.position = CGPoint(x: self.frame.size.width, y: 0)//-self.frame.size.height / 3.65)
        }
        
        coyote.xScale = -1
        self.addChild(coyote)
        
        //Snake
        
        snake = SKSpriteNode(imageNamed: "snake-1")
        
        if(UIDevice.current.userInterfaceIdiom == .phone)
        {
            snake.position = CGPoint(x: self.frame.size.width, y: -self.frame.size.height / 2.5)
        }
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            //coyote.size = CGSize(width: (coyote.size.width + (self.frame.size.width * 0.65)) / 4, height: (coyote.size.height + (self.frame.size.width * 0.65)) / 4)
            snake.position = CGPoint(x: 0, y: 0)//-self.frame.size.height / 3.65)
        }
        //snake.position = CGPoint(x: self.frame.width, y: -self.frame.size.height / 4.4)
        snake.xScale = -1
        self.addChild(snake)
    }
}
