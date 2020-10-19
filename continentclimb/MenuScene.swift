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
        
        if(UIDevice.current.userInterfaceIdiom == .phone)
        {
            chapterTwoShape = SKShapeNode(rect: CGRect(x: -self.frame.size.width / 3, y: -self.frame.size.height / 8, width: 2 * (self.frame.size.width / 3), height: 75), cornerRadius: 30)
        }
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            chapterTwoShape = SKShapeNode(rect: CGRect(x: -self.frame.size.width / 3, y: -self.frame.size.height / 8, width: 2 * (self.frame.size.width / 3), height: 150), cornerRadius: 30)
        }
        //chapterTwoShape.fillTexture = SKTexture(imageNamed: "junglebackg.jpg")
        chapterTwoShape.fillColor = .white
        chapterTwoShape.name = "Southamericashape"
        
        chapterTwoText = SKLabelNode(fontNamed: "NationalPark-Heavy")
        chapterTwoText.fontSize = chapterTwoShape.frame.size.width / 11
        chapterTwoText.fontColor = .black
        chapterTwoText.name = "Southamerica"
        chapterTwoText.text = "Chapter 2: Coming Soon"
        
        chapterTwoShape.zPosition = 3
        chapterTwoShape.addChild(chapterTwoText)
        chapterTwoShape.isUserInteractionEnabled = false
        
        chapterTwoText.position = CGPoint(x: -8, y: -self.frame.size.height / 14)

        moveableNode.addChild(chapterTwoShape)
        /*
        
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

