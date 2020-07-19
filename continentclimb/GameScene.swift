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
    var icyBackground: SKSpriteNode = SKSpriteNode()
    var icyBackground2: SKSpriteNode = SKSpriteNode()
    var icePlatform: SKSpriteNode = SKSpriteNode()
    var hero: SKSpriteNode = SKSpriteNode()
    var evilSnowman: SKSpriteNode = SKSpriteNode()
    var snowball: SKSpriteNode = SKSpriteNode()
    var snow: SKEmitterNode = SKEmitterNode()
    
    override func didMove(to view: SKView) {
        
        GameViewController.gameScene = self
        scene?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        initObjects()
        drawBackground()
        drawPlatform()
        addSnow()
        drawCharacter()
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
        
        let platTexture = SKTexture(imageNamed: "snowgrounds")
            
        let platAnimation = SKAction.move(by: CGVector(dx: -platTexture.size().width, dy: 0), duration: 3)
        
        let platShift = SKAction.move(by: CGVector(dx: platTexture.size().width, dy: 0), duration: 0)
        let pAnimation = SKAction.sequence([platAnimation, platShift])
        let infinitePlat = SKAction.repeatForever(pAnimation)
        
        if(UIDevice.current.userInterfaceIdiom == .phone)
        {
            lowerBound = 0
            upperBound = 2
        }
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            lowerBound = -1
            upperBound = 3
        }

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
                icePlatform.size.height = 150
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
        
        let backgTexture = SKTexture(imageNamed: "icybackground")
                
        if(UIDevice.current.userInterfaceIdiom == .phone)
        {
            backgAnimation = SKAction.move(by: CGVector(dx: round(-backgTexture.size().width / 2.01), dy: 0), duration: 3)
            
            backgShift = SKAction.move(by: CGVector(dx: round(backgTexture.size().width / 2.01), dy: 0), duration: 0)
            lowerBound = -1
            upperBound = 3
        }
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            backgAnimation = SKAction.move(by: CGVector(dx: round(-backgTexture.size().width), dy: 0), duration: 3)
            
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
            hero.size = CGSize(width: (hero.size.width + (self.frame.size.width * 0.25)) / 4, height: (hero.size.height + (self.frame.size.width * 0.25)) / 4)
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
            duckAnim = SKAction.moveBy(x: 150, y: 0, duration: 0.5)
        }
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            duckAnim = SKAction.moveBy(x: 200, y: 0, duration: 0.5)
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
        
        snowball.position = CGPoint(x: hero.position.x, y: self.frame.size.height)
        
        let snowballFall = SKAction.moveTo(y: -self.frame.size.height, duration: 1.75)
        
        let fallRepeater = SKAction.repeat(snowballFall, count: 1)
        
        snowball.run(fallRepeater, completion: revertSnowball)
    }
    
    func initObjects() {
        
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
        
        snowball = SKSpriteNode(imageNamed: "snowbol-1")
        snowball.position = CGPoint(x: evilSnowman.position.x, y: -self.frame.size.height / 4.75)
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            snowball.size = CGSize(width: snowball.size.width * 1.5, height: snowball.size.height * 1.5)
        }
        self.addChild(snowball)
    }
}
