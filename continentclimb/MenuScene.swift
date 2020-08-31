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
    
    var scrollView: ScrollView!
    let moveableNode = SKNode()
    
    var returnButton: SKSpriteNode = SKSpriteNode()
    
    
    var background: SKSpriteNode = SKSpriteNode()
    var mainText: SKLabelNode = SKLabelNode()
    var chapterOneShape: SKShapeNode = SKShapeNode()
    var chapterOneText: SKLabelNode = SKLabelNode()
    var chapterTwoShape: SKShapeNode = SKShapeNode()
    var chapterTwoText: SKLabelNode = SKLabelNode()
    var chapterThreeShape: SKShapeNode = SKShapeNode()
    var chapterThreeText: SKLabelNode = SKLabelNode()
    var chapterFourShape: SKShapeNode = SKShapeNode()
    var chapterFourText: SKLabelNode = SKLabelNode()
    var chapterFiveShape: SKShapeNode = SKShapeNode()
    var chapterFiveText: SKLabelNode = SKLabelNode()
    var chapterSixShape: SKShapeNode = SKShapeNode()
    var chapterSixText: SKLabelNode = SKLabelNode()
    var chapterSevenShape: SKShapeNode = SKShapeNode()
    var chapterSevenText: SKLabelNode = SKLabelNode()
    
    
    
    var worldMap: SKSpriteNode = SKSpriteNode()
    var lockOn: SKSpriteNode = SKSpriteNode()
    var matrices: SKSpriteNode = SKSpriteNode()
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
        addBackground()
        addMainText()
        initScrollView()
        initReturnButton()
        addChapters()
    }
    
    func addBackground() {
        
        background = SKSpriteNode(imageNamed: "starry.jpg")
        background.size = (view?.bounds.size)!
        
        self.addChild(background)
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
    
    func addMainText() {
        
        mainText = SKLabelNode(fontNamed: "MaassslicerItalic")
        mainText.fontColor = .white
        mainText.text = "Chapters"
        
        mainText.position = CGPoint(x: self.frame.midX, y: self.frame.height / 2.9)
        mainText.zPosition = 3
        
        if(UIDevice.current.userInterfaceIdiom == .phone)
        {
            mainText.fontSize = 60
        }
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            mainText.fontSize = 90
        }
    
        moveableNode.addChild(mainText)
    }
    
    func initScrollView() {
        
        moveableNode.isUserInteractionEnabled = false
        addChild(moveableNode)
        
        scrollView = ScrollView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height), moveableNode: moveableNode, direction: .vertical)
        scrollView.contentSize = CGSize(width: self.frame.size.width, height: self.frame.size.height * 2)
        view?.addSubview(scrollView)
    }
    
    func addChapters() {
        
        if(UIDevice.current.userInterfaceIdiom == .phone)
        {
            chapterOneShape = SKShapeNode(rect: CGRect(x: -self.frame.size.width / 3, y: self.frame.size.height / 12, width: 2 * (self.frame.size.width / 3), height: 75), cornerRadius: 30)
        }
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            chapterOneShape = SKShapeNode(rect: CGRect(x: -self.frame.size.width / 3, y: self.frame.size.height / 12, width: 2 * (self.frame.size.width / 3), height: 150), cornerRadius: 30)
        }
        let naBackg = SKTexture(imageNamed: "purpleskies.jpg")
        chapterOneShape.fillTexture = naBackg
        chapterOneShape.fillColor = .white
        chapterOneShape.name = "Northamericashape"
        
        
        chapterOneText = SKLabelNode(fontNamed: "NationalPark-Heavy")
        chapterOneText.fontSize = chapterOneShape.frame.size.width / 11
        chapterOneText.fontColor = .white
        chapterOneText.horizontalAlignmentMode = .center
        chapterOneText.name = "Northamerica"
        chapterOneText.text = "Chapter 1: North America"
        
        chapterOneShape.zPosition = 3
        chapterOneShape.addChild(chapterOneText)
        chapterOneShape.isUserInteractionEnabled = false
        
        chapterOneText.position.y = self.frame.size.height / 6.85
        
        moveableNode.addChild(chapterOneShape)
        
        /*
        if(UIDevice.current.userInterfaceIdiom == .phone)
        {
            chapterTwoShape = SKShapeNode(rect: CGRect(x: -self.frame.size.width / 3, y: -self.frame.size.height / 8, width: 2 * (self.frame.size.width / 3), height: 75), cornerRadius: 30)
        }
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            chapterTwoShape = SKShapeNode(rect: CGRect(x: -self.frame.size.width / 3, y: -self.frame.size.height / 8, width: 2 * (self.frame.size.width / 3), height: 150), cornerRadius: 30)
        }
        chapterTwoShape.fillTexture = SKTexture(imageNamed: "junglebackg.jpg")
        chapterTwoShape.fillColor = .white
        chapterTwoShape.name = "Southamericashape"
        
        chapterTwoText = SKLabelNode(fontNamed: "NationalPark-Heavy")
        chapterTwoText.fontSize = chapterTwoShape.frame.size.width / 11
        chapterTwoText.fontColor = .white
        chapterTwoText.name = "Southamerica"
        chapterTwoText.text = "Chapter 2: South America"
        
        chapterTwoShape.zPosition = 3
        chapterTwoShape.addChild(chapterTwoText)
        chapterTwoShape.isUserInteractionEnabled = false
        
        chapterTwoText.position = CGPoint(x: 8, y: -self.frame.size.height / 14)

        moveableNode.addChild(chapterTwoShape)
        
        if(UIDevice.current.userInterfaceIdiom == .phone)
        {
            chapterThreeShape = SKShapeNode(rect: CGRect(x: -self.frame.size.width / 3, y: -self.frame.size.height / 3, width: 2 * (self.frame.size.width / 3), height: 75), cornerRadius: 30)
        }
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            chapterThreeShape = SKShapeNode(rect: CGRect(x: -self.frame.size.width / 3, y: -self.frame.size.height / 3, width: 2 * (self.frame.size.width / 3), height: 150), cornerRadius: 30)
        }
        chapterThreeShape.fillTexture = SKTexture(imageNamed: "aurorabackg.jpg")
        chapterThreeShape.fillColor = .white
        chapterThreeShape.name = "Antarcticashape"
        
        chapterThreeText = SKLabelNode(fontNamed: "NationalPark-Heavy")
        chapterThreeText.fontSize = chapterTwoShape.frame.size.width / 11
        chapterThreeText.fontColor = .white
        chapterThreeText.name = "Antarctica"
        chapterThreeText.text = "Chapter 3: Antarctica"
        
        chapterThreeShape.zPosition = 3
        chapterThreeShape.addChild(chapterThreeText)
        chapterThreeShape.isUserInteractionEnabled = false
        
        chapterThreeText.position = CGPoint(x: -self.frame.size.width / 24, y: -self.frame.size.height / 3.65)

        moveableNode.addChild(chapterThreeShape)
        
        if(UIDevice.current.userInterfaceIdiom == .phone)
        {
            chapterFourShape = SKShapeNode(rect: CGRect(x: -self.frame.size.width / 3, y: -self.frame.size.height / 1.85, width: 2 * (self.frame.size.width / 3), height: 75), cornerRadius: 30)
        }
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            chapterFourShape = SKShapeNode(rect: CGRect(x: -self.frame.size.width / 3, y: -self.frame.size.height / 1.85, width: 2 * (self.frame.size.width / 3), height: 150), cornerRadius: 30)
        }
        chapterFourShape.fillTexture = SKTexture(imageNamed: "leopardbackg.jpg")
        chapterFourShape.fillColor = .white
        chapterFourShape.name = "Africashape"
        
        chapterFourText = SKLabelNode(fontNamed: "NationalPark-Heavy")
        chapterFourText.fontSize = chapterTwoShape.frame.size.width / 11
        chapterFourText.fontColor = .white
        chapterFourText.name = "Africa"
        chapterFourText.text = "Chapter 4: Africa"
        
        chapterFourShape.zPosition = 3
        chapterFourShape.addChild(chapterFourText)
        chapterFourShape.isUserInteractionEnabled = false
        
        chapterFourText.position = CGPoint(x: -self.frame.size.width / 11, y: -self.frame.size.height / 2.1)
        
        moveableNode.addChild(chapterFourShape)
        
        if(UIDevice.current.userInterfaceIdiom == .phone)
        {
            chapterFiveShape = SKShapeNode(rect: CGRect(x: -self.frame.size.width / 3, y: -self.frame.size.height / 1.335, width: 2 * (self.frame.size.width / 3), height: 75), cornerRadius: 30)
        }
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            chapterFiveShape = SKShapeNode(rect: CGRect(x: -self.frame.size.width / 3, y: -self.frame.size.height / 1.335, width: 2 * (self.frame.size.width / 3), height: 150), cornerRadius: 30)
        }
        chapterFiveShape.fillTexture = SKTexture(imageNamed: "greecebackg.jpg")
        chapterFiveShape.fillColor = .white
        chapterFiveShape.name = "Europeshape"
        
        chapterFiveText = SKLabelNode(fontNamed: "NationalPark-Heavy")
        chapterFiveText.fontSize = chapterTwoShape.frame.size.width / 11
        chapterFiveText.fontColor = .white
        chapterFiveText.name = "Europe"
        chapterFiveText.text = "Chapter 5: Europe"
        
        chapterFiveShape.zPosition = 3
        chapterFiveShape.addChild(chapterFiveText)
        chapterFiveShape.isUserInteractionEnabled = false
        
        chapterFiveText.position = CGPoint(x: -self.frame.size.width / 13, y: -self.frame.size.height / 1.47)
        
        moveableNode.addChild(chapterFiveShape)
        
        if(UIDevice.current.userInterfaceIdiom == .phone)
        {
            chapterSixShape = SKShapeNode(rect: CGRect(x: -self.frame.size.width / 3, y: -self.frame.size.height / 1.05, width: 2 * (self.frame.size.width / 3), height: 75), cornerRadius: 30)
        }
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            chapterSixShape = SKShapeNode(rect: CGRect(x: -self.frame.size.width / 3, y: -self.frame.size.height / 1.05, width: 2 * (self.frame.size.width / 3), height: 150), cornerRadius: 30)
        }
        chapterSixShape.fillTexture = SKTexture(imageNamed: "fugibackg.jpg")
        chapterSixShape.fillColor = .white
        chapterSixShape.name = "Asiashape"
        
        chapterSixText = SKLabelNode(fontNamed: "NationalPark-Heavy")
        chapterSixText.fontSize = chapterTwoShape.frame.size.width / 11
        chapterSixText.fontColor = .white
        chapterSixText.name = "Asia"
        chapterSixText.text = "Chapter 6: Asia"
        
        chapterSixShape.zPosition = 3
        chapterSixShape.addChild(chapterSixText)
        chapterSixShape.isUserInteractionEnabled = false
        
        chapterSixText.position = CGPoint(x: -self.frame.size.width / 9, y: -self.frame.size.height / 1.13)
        
        moveableNode.addChild(chapterSixShape)
        
        if(UIDevice.current.userInterfaceIdiom == .phone)
        {
            chapterSevenShape = SKShapeNode(rect: CGRect(x: -self.frame.size.width / 3, y: -self.frame.size.height * 1.16, width: 2 * (self.frame.size.width / 3), height: 75), cornerRadius: 30)
        }
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            chapterSevenShape = SKShapeNode(rect: CGRect(x: -self.frame.size.width / 3, y: -self.frame.size.height * 1.16, width: 2 * (self.frame.size.width / 3), height: 150), cornerRadius: 30)
        }
        chapterSevenShape.fillTexture = SKTexture(imageNamed: "sydneybackg.jpg")
        chapterSevenShape.fillColor = .white
        chapterSevenShape.name = "Australiashape"
        
        chapterSevenText = SKLabelNode(fontNamed: "NationalPark-Heavy")
        chapterSevenText.fontSize = chapterTwoShape.frame.size.width / 11
        chapterSevenText.fontColor = .white
        chapterSevenText.name = "Australia"
        chapterSevenText.text = "Chapter 7: Australia"
        
        chapterSevenShape.zPosition = 3
        chapterSevenShape.addChild(chapterSevenText)
        chapterSevenShape.isUserInteractionEnabled = false
        
        chapterSevenText.position = CGPoint(x: -self.frame.size.width / 17, y: -self.frame.size.height * 1.1)
        
        moveableNode.addChild(chapterSevenShape)
 */
        
    }

    func addMatrices() {
        
        let matrixTexture = SKTexture(imageNamed: "matrices.jpg")
        
        let matrixAnimation = SKAction.move(by: CGVector(dx: 0, dy: -matrixTexture.size().height), duration: 9)
        let matrixShift = SKAction.move(by: CGVector(dx: 0, dy: matrixTexture.size().height), duration: 0)
        
        let matrixSeq = SKAction.sequence([matrixAnimation, matrixShift])
        
        let matrixRepeater = SKAction.repeatForever(matrixSeq)
        
        var i: CGFloat = 0
        
        while i < 2 {
            
            matrices = SKSpriteNode(texture: matrixTexture)
            matrices.position = CGPoint(x: 0, y: matrixTexture.size().height * i)
            
            matrices.run(matrixRepeater)

            self.addChild(matrices)
            i += 1

            // Set background first
            matrices.zPosition = -1
        }
        
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
            worldMap.size = CGSize(width: worldMap.size.width + (self.frame.width * 0.05), height: worldMap.size.height + (self.frame.width * 0.05))
            worldMap.position = CGPoint(x: 0, y: 0)
        }

        worldMap.zPosition = 0
        self.addChild(worldMap)
    }
    
    func addLockOn() {
        
        lockOn = SKSpriteNode(imageNamed: "sniper")
        lockOn.size = CGSize(width: worldMap.size.width * 1.1, height: worldMap.size.height * 1.1)
        lockOn.alpha = 0.5
        worldMap.addChild(lockOn)
        
        worldMap.zPosition = 1
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
            charID.position = CGPoint(x: -self.frame.width / 2.6, y: self.frame.height / 2.3)
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
                
        if let touch = touches.first {
            
            let location = touch.previousLocation(in: self)
            let node = self.nodes(at: location).first
                        
            if((node?.name == "Northamericashape") || (node?.name == "Northamerica"))
            {
                let terrainScene = ContinentLoader(size: (view?.bounds.size)!)
                terrainScene.scaleMode = .aspectFill
                view?.presentScene(terrainScene)
                scrollView.removeFromSuperview()
            }
            
            else if(node?.name == "return")
            {
                let homeScene = HomeScene(size: (view?.bounds.size)!)
                homeScene.scaleMode = .aspectFill
                view?.presentScene(homeScene)
                scrollView.removeFromSuperview()
            }
       }
}

}

