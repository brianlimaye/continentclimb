//
//  MenuScene.swift
//  continentclimb
//
//  Created by Brian Limaye on 7/13/20.
//  Copyright © 2020 Brian Limaye. All rights reserved.
//

import Foundation
import WebKit
import SpriteKit
import AVFoundation
import StoreKit

class MenuScene: SKScene {
    
    var worldMap: SKSpriteNode = SKSpriteNode()
    var charID: SKSpriteNode = SKSpriteNode()
    var naTarget: SKSpriteNode = SKSpriteNode()
    var saTarget: SKSpriteNode = SKSpriteNode()
    var antTarget: SKSpriteNode = SKSpriteNode()
    var afTarget: SKSpriteNode = SKSpriteNode()
    var euroTarget: SKSpriteNode = SKSpriteNode()
    var asiaTarget: SKSpriteNode = SKSpriteNode()
    var austTarget: SKSpriteNode = SKSpriteNode()
    var binary: SKSpriteNode = SKSpriteNode()
    var idText: SKLabelNode = SKLabelNode()
    var color: UIColor = UIColor()
    var lock2: SKSpriteNode = SKSpriteNode()
    var lock3: SKSpriteNode = SKSpriteNode()
    var lock4: SKSpriteNode = SKSpriteNode()
    var lock5: SKSpriteNode = SKSpriteNode()
    var lock6: SKSpriteNode = SKSpriteNode()
    var lock7: SKSpriteNode = SKSpriteNode()
    
    
    override func didMove(to view: SKView) {
        
        scene?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scene?.backgroundColor = .black
        loadMap()
        addTargets()
        displayID()
    }
    
    func addTargets() {
        
        //North America
        naTarget = SKSpriteNode(imageNamed: "target.png")
        if(UIDevice.current.userInterfaceIdiom == .phone)
        {
            naTarget.size = CGSize(width: naTarget.size.width / 12, height: naTarget.size.height / 12)
            naTarget.position = CGPoint(x: -170, y: 100)
        }
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            naTarget.size = CGSize(width: naTarget.size.width / 6, height: naTarget.size.height / 6)
            naTarget.position = CGPoint(x: -325, y: 195)
        }
        worldMap.addChild(naTarget)
        
        naTarget.zPosition = 1
        
        //South America
        saTarget = SKSpriteNode(imageNamed: "target.png")
        lock2 = SKSpriteNode(imageNamed: "lock.png")
        
        if(UIDevice.current.userInterfaceIdiom == .phone)
        {
            saTarget.size = CGSize(width: saTarget.size.width / 12, height: saTarget.size.height / 12)
            lock2.size = CGSize(width: lock2.size.width / 12, height: lock2.size.height / 12)
            saTarget.position = CGPoint(x: -110, y: -20)
            lock2.position = CGPoint(x: -113, y: -20)
        }
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            saTarget.size = CGSize(width: saTarget.size.width / 6, height: saTarget.size.height / 6)
            lock2.size = CGSize(width: lock2.size.width / 6, height: lock2.size.height / 6)
            saTarget.position = CGPoint(x: -200, y: -30)
            lock2.position = CGPoint(x: -205, y: -30)
        }

        worldMap.addChild(saTarget)
        worldMap.addChild(lock2)
        
        lock2.zPosition = 2
        saTarget.zPosition = 1
        
        //Antartica
        antTarget = SKSpriteNode(imageNamed: "target.png")
        lock3 = SKSpriteNode(imageNamed: "lock.png")

        if(UIDevice.current.userInterfaceIdiom == .phone)
        {
            antTarget.size = CGSize(width: antTarget.size.width / 12, height: antTarget.size.height / 12)
            lock3.size = CGSize(width: lock3.size.width / 12, height: lock3.size.height / 12)
            antTarget.position = CGPoint(x: 20, y: -150)
            lock3.position = CGPoint(x: 17, y: -150)
        }
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            antTarget.size = CGSize(width: antTarget.size.width / 6, height: antTarget.size.height / 6)
            lock3.size = CGSize(width: lock3.size.width / 6, height: lock3.size.height / 6)
            antTarget.position = CGPoint(x: 30, y: -290)
            lock3.position = CGPoint(x: 27, y: -288)
        }

        worldMap.addChild(antTarget)
        worldMap.addChild(lock3)
        
        
        
        lock3.zPosition = 2
        antTarget.zPosition = 1
        
        //Africa
        afTarget = SKSpriteNode(imageNamed: "comingsoon")
        lock4 = SKSpriteNode(imageNamed: "lock.png")
        
       if(UIDevice.current.userInterfaceIdiom == .phone)
       {
            afTarget.size = CGSize(width: afTarget.size.width / 15, height: afTarget.size.height / 15)
            lock4.size = CGSize(width: lock4.size.width / 12, height: lock4.size.height / 12)
            afTarget.position = CGPoint(x: 25, y: 35)
            lock4.position = CGPoint(x: 22, y: 35)
       }
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            afTarget.size = CGSize(width: afTarget.size.width / 7.5, height: afTarget.size.height / 7.5)
            lock4.size = CGSize(width: lock4.size.width / 6, height: lock4.size.height / 6)
            afTarget.position = CGPoint(x: 50, y: 75)
            lock4.position = CGPoint(x: 47, y: 75)
        }
            
        
        worldMap.addChild(afTarget)
        worldMap.addChild(lock4)
        
        lock4.zPosition = 2
        afTarget.zPosition = 1
        
        //Europe
        euroTarget = SKSpriteNode(imageNamed: "comingsoon")
        lock5 = SKSpriteNode(imageNamed: "lock.png")
        
        if(UIDevice.current.userInterfaceIdiom == .phone)
        {
            euroTarget.size = CGSize(width: euroTarget.size.width / 15, height: euroTarget.size.height / 15)
            lock5.size = CGSize(width: lock5.size.width / 12, height: lock5.size.height / 12)
            euroTarget.position = CGPoint(x: 50, y: 125)
            lock5.position = CGPoint(x: 47, y: 125)
        }
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            euroTarget.size = CGSize(width: euroTarget.size.width / 7.5, height: euroTarget.size.height / 7.5)
            lock5.size = CGSize(width: lock5.size.width / 6, height: lock5.size.height / 6)
            euroTarget.position = CGPoint(x: 75, y: 250)
            lock5.position = CGPoint(x: 72, y: 250)
        }

        worldMap.addChild(euroTarget)
        worldMap.addChild(lock5)
        
        lock5.zPosition = 2
        euroTarget.zPosition = 1
        
        //Asia
        asiaTarget = SKSpriteNode(imageNamed: "comingsoon")
        lock6 = SKSpriteNode(imageNamed: "lock.png")
        
        if(UIDevice.current.userInterfaceIdiom == .phone)
        {
            asiaTarget.size = CGSize(width: asiaTarget.size.width / 15, height: asiaTarget.size.height / 15)
            lock6.size = CGSize(width: lock6.size.width / 12, height: lock6.size.height / 12)
            asiaTarget.position = CGPoint(x: 165, y: 100)
            lock6.position = CGPoint(x: 162, y: 100)
        }
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            asiaTarget.size = CGSize(width: asiaTarget.size.width / 7.5, height: asiaTarget.size.height / 7.5)
            lock6.size = CGSize(width: lock6.size.width / 6, height: lock6.size.height / 6)
            asiaTarget.position = CGPoint(x: 300, y: 200)
            lock6.position = CGPoint(x: 297, y: 200)
        }
        
        worldMap.addChild(asiaTarget)
        worldMap.addChild(lock6)
        
        lock6.zPosition = 2
        asiaTarget.zPosition = 1
        
        //Australia
        austTarget = SKSpriteNode(imageNamed: "comingsoon")
        lock7 = SKSpriteNode(imageNamed: "lock.png")
        
        if(UIDevice.current.userInterfaceIdiom == .phone)
        {
            austTarget.size = CGSize(width: austTarget.size.width / 15, height: austTarget.size.height / 15)
            lock7.size = CGSize(width: lock7.size.width / 12, height: lock7.size.height / 12)
            austTarget.position = CGPoint(x: 250, y: -50)
            lock7.position = CGPoint(x: 247, y: -50)
        }
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            austTarget.size = CGSize(width: austTarget.size.width / 7.5, height: austTarget.size.height / 7.5)
            lock7.size = CGSize(width: lock7.size.width / 6, height: lock7.size.height / 6)
            austTarget.position = CGPoint(x: 475, y: -100)
            lock7.position = CGPoint(x: 472, y: -100)
        }
            
        
        worldMap.addChild(austTarget)
        worldMap.addChild(lock7)
    
        lock7.zPosition = 2
        austTarget.zPosition = 1
    }
    
    func loadMap() {
        
        worldMap = SKSpriteNode(imageNamed: "mapp")
        if(UIDevice.current.userInterfaceIdiom == .phone)
        {
            worldMap.size = CGSize(width: worldMap.size.width / 1.75, height: worldMap.size.height / 1.75)
            worldMap.position = CGPoint(x: 0, y: 0)
        }
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            worldMap.size = CGSize(width: worldMap.size.width / 0.875, height: worldMap.size.height / 0.875)
            worldMap.position = CGPoint(x: 0, y: 0)
        }

        worldMap.zPosition = 0
        self.addChild(worldMap)
    }
    
    func displayID() {
        
        idText = SKLabelNode(fontNamed: "LazenbyComputer-Liquid")
        idText.position = CGPoint(x: -self.frame.width / 2.15, y: self.frame.height / 2.5)
        idText.fontColor = .green
        idText.text = "ID: "
        
        charID = SKSpriteNode(imageNamed: "idle-1")
        if(UIDevice.current.userInterfaceIdiom == .phone)
        {
            idText.fontSize = 30
            charID.size = CGSize(width: charID.size.width / 6, height: charID.size.height / 6)
            charID.position = CGPoint(x: -self.frame.width / 2.5, y: self.frame.height / 2.3)
        }
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            idText.fontSize = 60
            charID.size = CGSize(width: charID.size.width / 3, height: charID.size.height / 3)
            charID.position = CGPoint(x: -self.frame.width / 2.5, y: self.frame.height / 2.3)
        }
        
        self.addChild(charID)
        self.addChild(idText)
    }
}

