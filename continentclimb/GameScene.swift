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
import SAConfettiView

var cameraNode: SKCameraNode = SKCameraNode()

struct gameData {
    
    static var hasPopups: Bool = true
    static var gameIsOver: Bool = true
    static var levelNumeral: Int = 0
    static var startingHeroPos: CGPoint = CGPoint(x: 0, y: 0)
    static var snowLevelOne: [Int] = [1, 1, 1, 0, 2, 2, 3, 1, 2, 3]
    static var snowLevelTwo: [Int] = [2, 3, 1, 0, 2, 1, 3, 3, 2, 1, 2, 1]
    static var snowLevelThree: [Int] = [2, 3, 3, 2, 1, 0, 3, 2, 2, 1, 2, 2, 2, 1, 3]
    static var desertLevelOne: [Int] = [4, 5, 4, 0, 5, 6, 4, 5, 6, 5]
    static var desertLevelTwo: [Int] = [6, 4, 5, 0, 4, 6, 5, 0, 4, 5, 4, 6]
    static var desertLevelThree: [Int] = [4, 5, 0, 6, 6, 6, 4, 6, 6, 4, 5, 6, 6, 5, 4]
    static var caveLevelOne: [Int] = [7, 8, 9, 0, 7, 9, 7, 7, 8, 7]
    static var caveLevelTwo: [Int] = [8, 0, 7, 9, 7, 7, 8, 9, 9, 8, 0, 9]
    static var caveLevelThree: [Int] = [8, 8, 0, 9, 8, 9, 8, 7, 7, 8, 9, 7, 8, 8, 9]
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    struct ColliderType {
        
        static let fallenSnowBall: UInt32 = 0
        static let hero: UInt32 = 1
        static let thrownSnowBall: UInt32 = 2
        static let yeti: UInt32 = 3
        static let coyote: UInt32 = 4
        static let snake: UInt32 = 5
        static let sandstorm: UInt32 = 6
        static let bat: UInt32 = 7
        static let spider: UInt32 = 8
        static let rock: UInt32 = 9
        static let coin: UInt32 = 10
    }
    
    private var percentageLabel: UILabel = UILabel()
    
    private var completedLabel: UILabel = UILabel()
    
    private let startValue: Int = 0
    private var current: Int = 0
    private let endValue: Int = 100
    private var resumedAngle: CGFloat = -CGFloat.pi / 2
    private var animationDuration: TimeInterval = TimeInterval()
    private var basicAnimation: CABasicAnimation?
    private var basicAnimation2: CABasicAnimation?
    
    private var startedProgress: Bool = false
    var displayLinkIsValid: Bool = false
    private var linkIsAdded: Bool = false
        
    private var coinDisplayLink: CADisplayLink = CADisplayLink()
    var progressDisplayLink: CADisplayLink?
    
    private var shapeLayer: CAShapeLayer = CAShapeLayer()
    private var trackLayer: CAShapeLayer = CAShapeLayer()
    
    private var swipeUp: UISwipeGestureRecognizer = UISwipeGestureRecognizer()
    private var swipeDown: UISwipeGestureRecognizer = UISwipeGestureRecognizer()
    
    private var swipeUpToJump: SKLabelNode = SKLabelNode()
    private var swipeDownToSlide: SKLabelNode = SKLabelNode()
    
    private var jumpIcon: SKSpriteNode = SKSpriteNode()
    private var slideIcon: SKSpriteNode = SKSpriteNode()
    
    private var confetti: SAConfettiView = SAConfettiView()
    var levelLoader: Timer?
    private var objNum: Int = 0
    private var schedule: [Int] = []
    private var levelLiteral: String = ""
    
    private let characterSpeed: TimeInterval = 0.25
    private let realCharSpeed: TimeInterval = 0.1
    private var levelSpeed: TimeInterval = 0
    
    private var recordedTime: Int = 0
    private var initialYPos: CGFloat = 0
    
    private var levelDuration: TimeInterval = 0
    
    static let defaults = UserDefaults.standard

    private var heroRunAction: SKAction = SKAction()
    private var yetiRunAction: SKAction = SKAction()
    private var coyoteDashAction: SKAction = SKAction()
    private var icyBackground: SKSpriteNode = SKSpriteNode()
    private var icyBackground2: SKSpriteNode = SKSpriteNode()
    private var icePlatform: SKSpriteNode = SKSpriteNode()
    private var hero: SKSpriteNode = SKSpriteNode()
    private var evilSnowman: SKSpriteNode = SKSpriteNode()
    private var snowYeti: SKSpriteNode = SKSpriteNode()
    private var thrownSnowball: SKSpriteNode = SKSpriteNode()
    private var fallenSnowball: SKSpriteNode = SKSpriteNode()
    private var coyote: SKSpriteNode = SKSpriteNode()
    private var snake: SKSpriteNode = SKSpriteNode()
    private var sandstorm: SKSpriteNode = SKSpriteNode()
    private var batSprite: SKSpriteNode = SKSpriteNode()
    private var spider: SKSpriteNode = SKSpriteNode()
    private var golem: SKSpriteNode = SKSpriteNode()
    private var rock: SKSpriteNode = SKSpriteNode()
    private var coin: SKSpriteNode = SKSpriteNode()
    private var chatBubble: SKSpriteNode = SKSpriteNode()
    
    var coinIcon: SKSpriteNode = SKSpriteNode()
    
    private var rain: SKEmitterNode = SKEmitterNode()
    private var snow: SKEmitterNode = SKEmitterNode()
    
    private var difficultyBox: SKShapeNode = SKShapeNode()
    private var difficultyText: SKLabelNode = SKLabelNode()
    private var difficultySubBox1: SKShapeNode = SKShapeNode()
    private var difficultySubText1: SKLabelNode = SKLabelNode()
    private var difficultySubBox2: SKShapeNode = SKShapeNode()
    private var difficultySubText2: SKLabelNode = SKLabelNode()
    private var difficultySubBox3: SKShapeNode = SKShapeNode()
    private var difficultySubText3: SKLabelNode = SKLabelNode()
    private var gameOverDisplay: SKShapeNode = SKShapeNode()
    private var levelAlert: SKLabelNode = SKLabelNode()
    private var levelStatusAlert: SKLabelNode = SKLabelNode()
    private var scoreBox: SKShapeNode = SKShapeNode()
    private var scoreLabel: SKLabelNode = SKLabelNode()
    private var levelPopup: SKShapeNode = SKShapeNode()
    private var levelText: SKLabelNode = SKLabelNode()
    private var miniHero: SKSpriteNode = SKSpriteNode()
    private var livesText: SKLabelNode = SKLabelNode()
    private var scoreBonus: SKLabelNode = SKLabelNode()
    
    private var checkMark1: SKSpriteNode = SKSpriteNode()
    private  var checkMark2: SKSpriteNode = SKSpriteNode()
    private var checkMark3: SKSpriteNode = SKSpriteNode()
    
    private var lock1: SKSpriteNode = SKSpriteNode()
    private var lock2: SKSpriteNode = SKSpriteNode()
    private var lock3: SKSpriteNode = SKSpriteNode()
    
    
    private var oneStar: SKSpriteNode = SKSpriteNode()
    private var twoStar: SKSpriteNode = SKSpriteNode()
    private var threeStar: SKSpriteNode = SKSpriteNode()
    
    private var platName: String = String()
    private var backgName: String = String()
    private var levelNames: [String] = [String]()
    
    private var backButton: SKSpriteNode = SKSpriteNode()
    private var nextButton: SKSpriteNode = SKSpriteNode()
    private var replayButton: SKSpriteNode = SKSpriteNode()
    
    private var returnButton: SKSpriteNode = SKSpriteNode()

    var isLevelPassed: Bool = true
    private var bonusCoinAmount: Int = 0
    private var levelIdentifier: Int = 0
    private var oldCoinCount: Int = 0
    
    override func didMove(to view: SKView) {
        
        //Progress Labels
        percentageLabel = UILabel()
        percentageLabel.text = "0%"
        percentageLabel.font = UIFont(name: "Antapani-ExtraBold", size: self.frame.size.width * 0.03)
        percentageLabel.textColor = .black
        percentageLabel.textAlignment = .center
        
        completedLabel = UILabel()
        completedLabel.text = "Completed"
        completedLabel.font = UIFont(name: "NationalPark-Heavy", size: self.frame.size.width * 0.012);
        completedLabel.textColor = .black
        completedLabel.textAlignment = .center
        
        physicsWorld.contactDelegate = self
        
        GameViewController.gameScene = self
        scene?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        (platName, backgName, levelNames) = PlistParser.getLayoutPackage(forKey: terrainKeyword, property1: "platform", property2: "background")
        initChecks()
        selectDifficulty()
        drawBackground()
        drawPlatform()

        if(!self.children.contains(cameraNode)) {
            
            self.addChild(cameraNode)
        }
    }
    
    func updateStars() {
        
        oneStar.alpha = 0.0
        twoStar.alpha = 0.0
        threeStar.alpha = 0.0
                
        difficultySubBox1.fillColor = .yellow
        difficultySubBox2.fillColor = .green
        difficultySubBox3.fillColor = .red
        
        difficultySubText1.fontColor = .black
        difficultySubText2.fontColor = .black
        difficultySubText3.fontColor = .black
        
        difficultyText.text = "Levels Completed: 0/3"
        difficultyText.fontColor = .white
        
        var startIndex: Int = 0
        var endIndex: Int = 0
        var completedLevels: Int = 0
        
        switch(terrainKeyword) {
            
            case "snow":
                lock1.isHidden = true
                startIndex = 0
                endIndex = 2
                break;
            case "desert":
                if(savedData.completedLevels[2]) {
                    
                    lock1.isHidden = true;
                }
                startIndex = 3
                endIndex = 5
                break;
            case "cave":
                if(savedData.completedLevels[5]) {
                    
                    lock1.isHidden = true;
                }
                startIndex = 6
                endIndex = 8
                break;
            default:
                print("keyword not detected")
                break;
          }
        
        for i in startIndex ... endIndex
        {
            if(savedData.completedLevels[i])
            {
                completedLevels += 1
                
                if(i % 3 == 0)
                {
                    oneStar.alpha = 1.0
                    lock2.alpha = 0.0
                }
                
                if(i % 3 == 1)
                {
                    twoStar.alpha = 1.0
                    lock3.alpha = 0.0
                }
                
                if(i % 3 == 2)
                {
                    threeStar.alpha = 1.0
                }
            }
        }
        
        if(completedLevels == 3)
        {
            difficultyText.text = "MAXED"
            difficultyText.fontColor = .green
            
        }
        else
        {
            difficultyText.text = "Levels Completed: " + String(completedLevels) + "/3"
        }
    }
    
    func initHelpers() {
        
        if((terrainKeyword != "snow") || (gameData.levelNumeral != 0))
        {
            return
        }
        
        swipeUpToJump = SKLabelNode(fontNamed: "LapsusPro-Bold")
        swipeUpToJump.fontSize = self.frame.size.width * 0.025
        swipeUpToJump.fontColor = .black
        swipeUpToJump.text = "Swipe up on screen to jump"
        swipeUpToJump.position = CGPoint(x: self.frame.size.width / 10, y: 75)
        
        jumpIcon = SKSpriteNode(imageNamed: "swipe-up")
        jumpIcon.size = CGSize(width: jumpIcon.size.width * (self.frame.size.width * 0.0001), height: jumpIcon.size.height * (self.frame.size.width * 0.0001))
        jumpIcon.position = CGPoint(x: self.frame.size.width / 3.5, y: 75)
        
        swipeDownToSlide = SKLabelNode(fontNamed: "LapsusPro-Bold")
        swipeDownToSlide.fontSize = self.frame.size.width * 0.025
        swipeDownToSlide.fontColor = .black
        swipeDownToSlide.text = "Swipe down on screen to slide"
        swipeDownToSlide.position = CGPoint(x: self.frame.size.width / 10, y: 0)
        
        slideIcon = SKSpriteNode(imageNamed: "swipe-below")
        slideIcon.size = CGSize(width: slideIcon.size.width * (self.frame.size.width * 0.0001), height: slideIcon.size.height * (self.frame.size.width * 0.0001))
        slideIcon.position = CGPoint(x: self.frame.size.width / 3.5, y: 0)
        
        self.addChild(jumpIcon)
        self.addChild(swipeUpToJump)
        self.addChild(slideIcon)
        self.addChild(swipeDownToSlide)
        
        let filler = SKAction.resize(toWidth: slideIcon.size.width, duration: 3)
        
        slideIcon.run(filler, completion: fadeOutHelpers)
    }
    
    func fadeOutHelpers() {
        
        let fadeOut = SKAction.fadeOut(withDuration: 1)
        
        let fadeRepeater = SKAction.repeat(fadeOut, count: 1)
        
        swipeUpToJump.run(fadeRepeater)
        swipeDownToSlide.run(fadeRepeater)
        jumpIcon.run(fadeRepeater)
        slideIcon.run(fadeRepeater)
    }
    
    func pauseProgressBar() {
        
        if(gameData.gameIsOver) {
            
            pauseAnimation(layer: shapeLayer)
            return
        }
        
        pauseAnimation(layer: shapeLayer)
        let fillerAnim = SKAction.resize(toWidth: coinIcon.size.width, duration: Double(levelSpeed) * 0.95)
        let fillerRepeater = SKAction.repeat(fillerAnim, count: 1)
        
        coinIcon.run(fillerRepeater, completion: resumeLayerAnim)
    }
    
    private func resumeLayerAnim() {
        
        resumeAnimation(layer: shapeLayer)
    }
    
    func initializeGame() {
        
        percentageLabel.text = "0%"
        
        gameData.gameIsOver = false
        
        swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(jumpHero))
        swipeUp.direction = .up
        self.view?.addGestureRecognizer(swipeUp)

        swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(slideHero))
        swipeDown.direction = .down
        self.view?.addGestureRecognizer(swipeDown)
    
        
        view?.addSubview(percentageLabel)
        view?.addSubview(completedLabel)
        
        let center = CGPoint(x: (view?.bounds.width)! / 2, y: (view?.bounds.height)! / 8)

        percentageLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        percentageLabel.center = center
        
        completedLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        completedLabel.center = CGPoint(x: (view?.bounds.width)! / 2, y: (view?.bounds.height)! / 5.8)
        
        shapeLayer = CAShapeLayer()
        
        //Track Layer
        
        trackLayer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: center, radius: self.frame.size.width * 0.05, startAngle: -CGFloat.pi / 2, endAngle: (3 * CGFloat.pi) / 2, clockwise: true)
        trackLayer.path = circularPath.cgPath
        
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.lineWidth = 10
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = CAShapeLayerLineCap.round
        trackLayer.zPosition = 6
        
        view?.layer.addSublayer(trackLayer)
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeEnd = 0
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.zPosition = 6
        
        view?.layer.addSublayer(shapeLayer)
        
        initDisplayLink()
                
        hideLocks()
        removeCheckMarks()
        showLevelPopup()
        drawCharacter()
        initObjects()
    }
    
    func initDisplayLink() {
        
        if(!displayLinkIsValid) {
            
            print("new display link")
            progressDisplayLink = CADisplayLink(target: self, selector: #selector(handleUpdate))
            progressDisplayLink?.preferredFramesPerSecond = 60
            displayLinkIsValid = true
        }
    }
    
    func updateStatusPercentage() {
        
        if(gameData.levelNumeral == 2) {
            
            current = 200
        }
        
        animationDuration = levelDuration
        initDisplayLink()
        progressDisplayLink?.add(to: .main, forMode: .default)
        linkIsAdded = true
        displayLinkIsValid = true
        
    }
    
    @objc func handleUpdate() {
        
        let percentage = current / endValue
        self.percentageLabel.text = "\(percentage)" + "%"
        current += Int(animationDuration / 5.01)
        
        if(percentage >= endValue) {
            
            self.percentageLabel.text = "\(endValue)" + "%"
        }
    }
    
    func pauseAnimation(layer: CAShapeLayer){
        
      let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
      layer.speed = 0.0
      layer.timeOffset = pausedTime
    }

    func resumeAnimation(layer: CAShapeLayer){
      let pausedTime = layer.timeOffset
      layer.speed = 1.0
      layer.timeOffset = 0.0
      layer.beginTime = 0.0
      let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
      layer.beginTime = timeSincePause
    }
    
    func redrawLayers() {
        
        shapeLayer.removeFromSuperlayer()
        trackLayer.removeFromSuperlayer()
        
        shapeLayer = CAShapeLayer()
        
        //Track Layer
        
        let center = CGPoint(x: (view?.bounds.width)! / 2, y: (view?.bounds.height)! / 8)

        trackLayer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: center, radius: self.frame.size.width * 0.05, startAngle: -CGFloat.pi / 2, endAngle: (3 * CGFloat.pi) / 2, clockwise: true)
        trackLayer.path = circularPath.cgPath
        
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.lineWidth = 10
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = CAShapeLayerLineCap.round
        trackLayer.zPosition = 6
        
        view?.layer.addSublayer(trackLayer)
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeEnd = 0
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.zPosition = 6
        
        view?.layer.addSublayer(shapeLayer)
    }
    
    private func startProgressBar() {
        
        startedProgress = true
        
        let percentageCompleted = CGFloat(current) / 10000
        
        basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation2 = CABasicAnimation(keyPath: "strokeEnd")
        
        basicAnimation2?.toValue = CGFloat(CGFloat(current) / 10000)
        basicAnimation2?.duration = 0
        basicAnimation2?.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation2?.isRemovedOnCompletion = true
        
        shapeLayer.add(basicAnimation2!, forKey: "basic2")
                        
        basicAnimation?.fromValue = CGFloat(CGFloat(current) / 10000)
        basicAnimation?.toValue = percentageCompleted + 1
        basicAnimation?.duration = (levelDuration * 1.14)
        basicAnimation?.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation?.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation!, forKey: "basic1")
        
        updateStatusPercentage()

    }
    
    func addBubbleMessage() {
    
        switch (terrainKeyword) {
            case "snow":
                addSnow()
                chatBubble = SKSpriteNode(imageNamed: "snowmessage")
                break
            case "desert":
                chatBubble = SKSpriteNode(imageNamed: "desertmessage")
                break
            case "cave":
                chatBubble = SKSpriteNode(imageNamed: "cavemessage")
                break
            default:
                break
        }
        
        chatBubble.size = CGSize(width: chatBubble.size.width * (self.frame.size.width * 0.001), height: chatBubble.size.height * (self.frame.size.width * 0.001))
        chatBubble.position = CGPoint(x: -self.frame.size.width / 3.25, y: self.frame.size.height / 3.25)
        
        self.addChild(chatBubble)
        
        let filler = SKAction.resize(toWidth: chatBubble.size.width, duration: 5)
        
        let fillerRepeater = SKAction.repeat(filler, count: 1)
        
        chatBubble.run(fillerRepeater, completion: removeBubble)
    }
    
    func removeBubble() {
        
        let fadeOut = SKAction.fadeOut(withDuration: 1.0)
        
        let fadeRepeater = SKAction.repeat(fadeOut, count: 1)
        
        chatBubble.run(fadeRepeater, completion: startLevel)
    }
    func startLevel() {
        
        gameData.hasPopups = false
        loadLevel(level: levelLiteral)
    }
    
    func showLevelPopup() {
        
        var menuHeight: CGFloat = self.frame.size.height / 3.5
        var fontSize: CGFloat = self.frame.size.width * 0.05
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            menuHeight = self.frame.height / 4.15
            fontSize = self.frame.size.width * 0.05
        }
        
        levelPopup = SKShapeNode(rect: CGRect(x: -self.frame.size.width, y: self.frame.midY - 20, width: self.frame.size.width * 2, height: menuHeight))
        levelPopup.fillColor = .black
        levelPopup.alpha = 0.5
        
        levelText = SKLabelNode(fontNamed: "CarbonBl-Regular")
        levelText.color = .white
        levelText.fontSize = fontSize
        levelText.position = CGPoint(x: 0, y: self.frame.size.height / 8)
        levelText.text = levelNames[gameData.levelNumeral] + ":"
        
        miniHero = SKSpriteNode(imageNamed: "idle-1")
        miniHero.size = CGSize(width: miniHero.size.width * (self.frame.size.width * 0.00025), height: miniHero.size.height * (self.frame.size.width * 0.00025))
        miniHero.position = CGPoint(x: -self.frame.size.width / 24, y: self.frame.midY + 15)
        
        livesText = SKLabelNode(fontNamed: "NationalPark-Heavy")
        livesText.color = .white
        livesText.fontSize = fontSize
        livesText.position = CGPoint(x: 15, y: 0)
        livesText.text = "x 1"
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            miniHero.position.y = self.frame.midY + 60
            livesText.position.y = 30
        }
        
        self.addChild(livesText)
        self.addChild(miniHero)
        self.addChild(levelText)
        self.addChild(levelPopup)
        
        let fadeBuffer = SKAction.resize(toHeight: miniHero.size.height, duration: 2)
        let fadeRepeater = SKAction.repeat(fadeBuffer, count: 1)
        
        addBubbleMessage()
        miniHero.run(fadeRepeater, completion: fadeLevelPopup)
    }
    
    func fadeLevelPopup() {
        
        let fadeOut = SKAction.fadeOut(withDuration: 1.0)
        
        let fadeRepeater = SKAction.repeat(fadeOut, count: 1)
        
        levelPopup.run(fadeRepeater, completion: initHelpers)
        levelText.run(fadeRepeater)
        miniHero.run(fadeRepeater)
        livesText.run(fadeRepeater)
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
        self.addChild(replayButton)
        
        if(isLevelPassed)
        {
            self.addChild(nextButton)
        }
        
    }
    
    func getCorrespondingSchedule(levelLiteral: String) -> [Int] {
        
        var arr: [Int]?
        
        switch(levelLiteral) {
            
            case "snowlevel1":
                arr = gameData.snowLevelOne
                bonusCoinAmount = 30
                levelIdentifier = 0
                break
            case "snowlevel2":
                arr = gameData.snowLevelTwo
                bonusCoinAmount = 40
                levelIdentifier = 1
                break
            case "snowlevel3":
                arr = gameData.snowLevelThree
                bonusCoinAmount = 50
                levelIdentifier = 2
            case "desertlevel1":
                arr = gameData.desertLevelOne
                bonusCoinAmount = 30
                levelIdentifier = 3
                break
            case "desertlevel2":
                arr = gameData.desertLevelTwo
                bonusCoinAmount = 40
                levelIdentifier = 4
                break
            case "desertlevel3":
                arr = gameData.desertLevelThree
                bonusCoinAmount = 50
                levelIdentifier = 5
                break
            case "cavelevel1":
                arr = gameData.caveLevelOne
                bonusCoinAmount = 10
                levelIdentifier = 6
                break
            case "cavelevel2":
                arr = gameData.caveLevelTwo
                bonusCoinAmount = 20
                levelIdentifier = 7
                break
            case "cavelevel3":
                arr = gameData.caveLevelThree
                bonusCoinAmount = 30
                levelIdentifier = 8
                break
            default:
                print("uh oh")
                break
        }
        
        return arr ?? []
    }
    
    func removeDisplayLink() {
        
        if(displayLinkIsValid) {
            
            print("invalidate!")
            if(linkIsAdded) {
                
                progressDisplayLink?.remove(from: .main, forMode: .default)
                linkIsAdded = false
            }
            progressDisplayLink?.invalidate()
            displayLinkIsValid = false
        }
    }
    
    func loadLevel(level: String) {
        
        schedule = getCorrespondingSchedule(levelLiteral: level)
        let levelNum = levelLiteral[levelLiteral.index(levelLiteral.startIndex, offsetBy: levelLiteral.count - 1)]
        
        var levelNo: Int = 0
        
        if let intValue = levelNum.wholeNumberValue {
            levelNo = intValue
        } else {
        }
        
        if(schedule.count == 0)
        {
            return
        }
        
        levelSpeed = TimeInterval((-0.5 * Double(levelNo)) + 3.5)
        levelDuration = (levelSpeed * Double(schedule.count))
        
        if(startedProgress) {
            
            performProgressPause()
        }
        else {
            
            startProgressBar()
        }
                
        levelLoader = Timer.scheduledTimer(timeInterval: levelSpeed, target: self, selector: #selector(runCorrespondingAction), userInfo: nil, repeats: true)
    }
    
    func performProgressPause() {
        
        let filler = SKAction.resize(toWidth: hero.size.width, duration: levelSpeed * 0.5)
        let fillerRepeater = SKAction.repeat(filler, count: 1)
        
        hero.run(fillerRepeater, completion: startProgressBar)
    }
    
    @objc func runCorrespondingAction() {
        
        if(objNum >= schedule.count)
        {
            levelLoader?.invalidate()
            performEndingAnimation()
            return
        }
        
        let num: Int = schedule[objNum]
        
        switch(num) {
            
            case 0:
                drawCoin()
                break
            case 1:
                drawFallenSnowball()
                break
            case 2:
                drawSnowman()
                break
            case 3:
                drawYeti()
                break
            case 4:
                drawCoyote()
                break
            case 5:
                drawSnake()
                break
            case 6:
                drawSandstorm()
                break
            case 7:
                drawGolem()
                break
            case 8:
                drawBat()
                break
            case 9:
                drawSpider()
                break
            default:
                break
        }
    }
    
    func selectDifficulty() {
        
        var difficultyHeight: CGFloat = self.frame.size.width / 5
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            difficultyHeight = self.frame.size.width / 4
        }
        
        removeCheckMarks()
        initChecks()
        addCheckMarks()
        difficultyBox.isHidden = false
        
        difficultyBox = SKShapeNode(rectOf: CGSize(width: self.frame.size.width / 1.5, height: difficultyHeight))
        difficultyBox.fillTexture = SKTexture(imageNamed: "starry.jpg")
        difficultyBox.fillColor = .white
        difficultyBox.strokeColor = .white
        difficultyBox.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        difficultyBox.lineWidth = 2
        
        self.addChild(difficultyBox)
        
        difficultyText = SKLabelNode(fontNamed: "NationalPark-Heavy")
        difficultyText.fontSize = self.frame.width / 24
        difficultyText.position = CGPoint(x: self.frame.midX, y: self.frame.size.height / 8.5)
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            difficultyText.position.y = self.frame.size.height / 14
        }
        
        difficultyBox.addChild(difficultyText)
        
        
        difficultySubBox1 = SKShapeNode(rectOf: CGSize(width: self.frame.size.width / 8, height: self.frame.size.width / 8))
        difficultySubBox1.strokeColor = .black
        difficultySubBox1.position = CGPoint(x: 0, y: -self.frame.height / 20)
        difficultySubBox1.lineWidth = 2
        difficultySubBox1.alpha = 1.0
        difficultySubBox1.name = "level-2"
        difficultySubBox1.isUserInteractionEnabled = false
        
        difficultyBox.addChild(difficultySubBox1)
        
        difficultySubText1 = SKLabelNode(fontNamed: "GemunuLibre-ExtraBold")
        difficultySubText1.fontSize = self.frame.size.width / 45
        difficultySubText1.text = levelNames[1]
        difficultySubText1.position = CGPoint(x: 0, y: 0)
        difficultySubText1.alpha = 1.0
        difficultySubText1.name = "level-2text"
        difficultySubText1.isUserInteractionEnabled = false
        difficultySubText1.zPosition = 3

        difficultyBox.addChild(difficultySubText1)
        
        twoStar = SKSpriteNode(imageNamed: "two-star")
        twoStar.size = CGSize(width: self.frame.size.width / 9, height: self.frame.size.width / 9)
        twoStar.position = CGPoint(x: 0, y: 0)
        twoStar.name = "twostar"
        twoStar.isUserInteractionEnabled = false
        
        difficultyBox.addChild(twoStar)
        
        twoStar.position.y = -self.frame.size.height / 9.25
        
        difficultySubBox2 = SKShapeNode(rectOf: CGSize(width: self.frame.size.width / 8, height: self.frame.size.width / 8))
        difficultySubBox2.strokeColor = .black
        difficultySubBox2.position = CGPoint(x: -self.frame.size.width / 4, y: -self.frame.height / 20)
        difficultySubBox2.lineWidth = 2
        difficultySubBox2.name = "level-1"
        difficultySubBox2.isUserInteractionEnabled = false
        
        difficultyBox.addChild(difficultySubBox2)
        
        difficultySubText2 = SKLabelNode(fontNamed: "GemunuLibre-ExtraBold")
        difficultySubText2.fontSize = self.frame.size.width / 45
        difficultySubText2.text = levelNames[0]
        difficultySubText2.position = CGPoint(x: -self.frame.size.width / 4, y: 0)
        difficultySubText2.name = "level-1text"
        difficultySubText2.isUserInteractionEnabled = false
        difficultySubText2.zPosition = 3

        
        difficultyBox.addChild(difficultySubText2)
        
        oneStar = SKSpriteNode(imageNamed: "one-star")
        
        oneStar.size = CGSize(width: self.frame.size.width / 15, height: self.frame.size.width / 15)
        oneStar.position = CGPoint(x: -self.frame.size.width / 3.95, y: -self.frame.size.height / 8.75)
        oneStar.name = "onestar"
        oneStar.isUserInteractionEnabled = false
        
        difficultyBox.addChild(oneStar)
                
        difficultySubBox3 = SKShapeNode(rectOf: CGSize(width: self.frame.size.width / 8, height: self.frame.size.width / 8))
        difficultySubBox3.strokeColor = .black
        difficultySubBox3.position = CGPoint(x: self.frame.size.width / 4, y: -self.frame.height / 20)
        difficultySubBox3.lineWidth = 2
        difficultySubBox3.name = "level-3"
        difficultySubBox3.isUserInteractionEnabled = false
        
        difficultyBox.addChild(difficultySubBox3)
        
        difficultySubText3 = SKLabelNode(fontNamed: "GemunuLibre-ExtraBold")
        difficultySubText3.fontSize = self.frame.size.width / 45
        difficultySubText3.text = levelNames[2]
        difficultySubText3.position = CGPoint(x: self.frame.size.width / 4, y: 0)
        difficultySubText3.name = "level-3text"
        difficultySubText3.alpha = 1.0
        difficultySubText3.isUserInteractionEnabled = false
        difficultySubText3.zPosition = 3

        difficultyBox.addChild(difficultySubText3)
        
        threeStar = SKSpriteNode(imageNamed: "three-star")
        threeStar.size = CGSize(width: self.frame.size.width / 6, height: self.frame.size.width / 6)
        threeStar.position = CGPoint(x: self.frame.size.width / 3.8, y: -self.frame.size.height / 8.5)
        threeStar.name = "threestar"
        threeStar.isUserInteractionEnabled = false
        
        lock1 = SKSpriteNode(imageNamed: "cartoonlock")
        lock1.size = CGSize(width: lock1.size.width * (self.frame.size.width * 0.0002), height: lock1.size.height * (self.frame.size.width * 0.0002))
        lock1.position = CGPoint(x: -self.frame.size.width / 4, y: -self.frame.size.height / 20)
        lock1.zPosition = 2
        
        self.addChild(lock1)
        
        lock2 = SKSpriteNode(imageNamed: "cartoonlock")
        lock2.size = CGSize(width: lock2.size.width * (self.frame.size.width * 0.0002), height: lock2.size.height * (self.frame.size.width * 0.0002))
        lock2.position = CGPoint(x: 0, y: -self.frame.size.height / 20)
        lock2.zPosition = 2
        
        self.addChild(lock2)
        
        lock3 = SKSpriteNode(imageNamed: "cartoonlock")
        lock3.size = CGSize(width: lock3.size.width * (self.frame.size.width * 0.0002), height: lock3.size.height * (self.frame.size.width * 0.0002))
        lock3.position = CGPoint(x: self.frame.size.width / 4, y: -self.frame.size.height / 20)
        lock3.zPosition = 2
        
        self.addChild(lock3)
        
        updateStars()
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            oneStar.position.y = -self.frame.size.height / 9.75
            twoStar.position.y = -self.frame.size.height / 10
            threeStar.position.y = -self.frame.size.height / 9.5
        }
        
        difficultyBox.addChild(threeStar)
        
        
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
    
    func hideLocks() {
        
        lock1.isHidden = true
        lock2.isHidden = true
        lock3.isHidden = true
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
        
        let speed: Double = 0.5
        
        var sandstormShift: SKAction = SKAction()
        var sandstormAnim: SKAction = SKAction()
        
        let sandstormFrames: [SKTexture] = [SKTexture(imageNamed: "sandtwister-1"), SKTexture(imageNamed: "sandtwister-2"), SKTexture(imageNamed: "sandtwister-3"), SKTexture(imageNamed: "sandtwister-4")]
        
        if(UIDevice.current.userInterfaceIdiom == .phone)
        {
            sandstormAnim = SKAction.animate(with: sandstormFrames, timePerFrame: characterSpeed / 3.6)
            sandstormShift = SKAction.moveTo(x: self.size.width / 3, duration: speed)
        }
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            sandstormAnim = SKAction.animate(with: sandstormFrames, timePerFrame: characterSpeed / 3.4)
            sandstormShift = SKAction.moveTo(x: self.size.width / 2.5, duration: speed - 0.1)
        }
        
        let sandstormRepeater = SKAction.repeatForever(sandstormAnim)
        let shiftRepeater = SKAction.repeat(sandstormShift, count: 1)
        
        sandstorm.run(shiftRepeater, completion: determineSandstormDirection)
        sandstorm.run(sandstormRepeater)
    }
    
    func determineSandstormDirection() {
        
        let rand = Int.random(in: 1 ... 2)
        let speed: Double = 1.5
        var riseAction: SKAction = SKAction()
        var riseRepeater: SKAction = SKAction()
        
        let secondShift = SKAction.moveTo(x: -self.frame.size.width, duration: speed)
        
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
        
        objNum += 1
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
    
    func updateCoins() {
        
        scoreLabel.text = String(savedData.coinCount)
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
        
        let coinAnim = SKAction.animate(with: coinFrames, timePerFrame: realCharSpeed / 2)
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
        objNum += 1
    }
    
    func fadeOutCoin() {
        
        let fadeOut = SKAction.fadeOut(withDuration: 0.15)
        
        let fadeRepeater = SKAction.repeat(fadeOut, count: 1)
        
        coin.run(fadeRepeater)
    }
    
    @objc func slideHero() {
        
        if(!isReady())
        {
            return
        }
        
        hero.removeAllActions()
        hero.texture = SKTexture(imageNamed: "bobby-5")
        
        var duckAnim: SKAction = SKAction()
        
        if(UIDevice.current.userInterfaceIdiom == .phone)
        {
            duckAnim = SKAction.moveBy(x: 250, y: -30, duration: 0.3)
        }
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            duckAnim = SKAction.moveBy(x: 300, y: -30, duration: 0.3)
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
        
        duckReversion = SKAction.move(to: CGPoint(x: -self.frame.size.width / 3, y: gameData.startingHeroPos.y), duration: 0.2)
        
        hero.run(duckReversion, completion: resumeRunning)
    }
    
    func currentTimeInMilliSeconds()-> Int {
        
        let currentDate = Date()
        let since1970 = currentDate.timeIntervalSince1970
        return Int(since1970 * 1000)
    }
    
    func isReady() -> Bool {
        
        let currentTime = currentTimeInMilliSeconds()
        
        if((recordedTime == 0) || (abs(currentTime - recordedTime) >= 600))
        {
            recordedTime = currentTime
            return true
        }
        
        return false
    }
    
    
    @objc func jumpHero() {
        
        if(!isReady())
        {
            return
        }
        
        hero.removeAllActions()
        hero.texture = SKTexture(imageNamed: "bobby-12")
        
        var jumpAnim: SKAction = SKAction()
        
        if(UIDevice.current.userInterfaceIdiom == .phone)
        {
            jumpAnim = SKAction.moveTo(y: self.frame.size.height / 6, duration: 0.3)
        }
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            jumpAnim = SKAction.moveTo(y: self.frame.size.height / 24, duration: 0.3)
        }
        
        let jumpRepeater = SKAction.repeat(jumpAnim, count: 1)
        
        hero.run(jumpRepeater, completion: jumpLanding)
    }
    
    func jumpLanding() {
        
        hero.texture = SKTexture(imageNamed: "bobby-13")
        
        var landAnim: SKAction = SKAction()
        
        landAnim = SKAction.moveTo(y: gameData.startingHeroPos.y, duration: 0.3)
        
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
        
        let randSpeed = Double.random(in: 1.9 ... 2.0)
        
        let yetiFrames: [SKTexture] = [SKTexture(imageNamed: "snowyeti-1"), SKTexture(imageNamed: "snowyeti-2"), SKTexture(imageNamed: "snowyeti-3"), SKTexture(imageNamed: "snowyeti-4"), SKTexture(imageNamed: "snowyeti-5"), SKTexture(imageNamed: "snowyeti-6"), SKTexture(imageNamed: "snowyeti-7"), SKTexture(imageNamed: "snowyeti-8"), SKTexture(imageNamed: "snowyeti-9"), SKTexture(imageNamed: "snowyeti-10"), SKTexture(imageNamed: "snowyeti-11")]
        
        //let yetiFrames: [SKTexture] = [SKTexture(imageNamed: "snowyeti-12"), SKTexture(imageNamed: "snowyeti-13"), SKTexture(imageNamed: "snowyeti-14"), SKTexture(imageNamed: "snowyeti-15"), SKTexture(imageNamed: "snowyeti-16"), SKTexture(imageNamed: "snowyeti-17"), SKTexture(imageNamed: "snowyeti-18")]
        
        let yetiAnimate = SKAction.animate(with: yetiFrames, timePerFrame: randSpeed / 56)
        self.yetiRunAction = yetiAnimate
        let yetiShift = SKAction.moveTo(x: -self.frame.size.width, duration: randSpeed)
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
        
        objNum += 1
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
        
        thrownSnowball.alpha = 1.0
        thrownSnowball.position = CGPoint(x: self.frame.width, y: -self.frame.size.height / 4.75)
        fallenSnowball.alpha = 1.0
        fallenSnowball.position = CGPoint(x: gameData.startingHeroPos.x, y: self.frame.size.height)
        objNum += 1
    }
    
    func drawThrownSnowball() {
        
        let rand = Double.random(in: 1.25 ... 1.9)
        let randSpeed = Double.random(in: 1.1 ... 1.5)
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
        let snowballShift = SKAction.moveTo(x: -self.frame.size.width, duration: randSpeed)
        let snowballRevert = SKAction.moveTo(x: self.frame.size.width, duration: 0)
        
        let shiftSeq = SKAction.sequence([snowballShift, snowballRevert])
        
        let shiftRepeater = SKAction.repeat(shiftSeq, count: 1)
        let animateRepeater = SKAction.repeatForever(animate)
        
        thrownSnowball.position.x = evilSnowman.position.x
        
        if(rand == 1)
        {
            thrownSnowball.position.y = gameData.startingHeroPos.y + 75
        }
        
        if(rand == 2)
        {
            thrownSnowball.position.y = gameData.startingHeroPos.y
        }

        thrownSnowball.run(shiftRepeater)
        thrownSnowball.run(animateRepeater)
        
        objNum += 1
    }
    
    func drawFallenSnowball() {
        
        let randSpeed = 1.3
        
        fallenSnowball.position = CGPoint(x: gameData.startingHeroPos.x, y: self.frame.size.height)
        
        let snowballFall = SKAction.move(to: CGPoint(x: gameData.startingHeroPos.x, y: gameData.startingHeroPos.y - 25), duration: randSpeed)
        
        let fallRepeater = SKAction.repeat(snowballFall, count: 1)
        
        fallenSnowball.run(fallRepeater, completion: fadeFallenSnowball)
    }
    
    func fadeFallenSnowball() {
        
        let fadeOut = SKAction.fadeOut(withDuration: 0.1)
        
        fallenSnowball.run(fadeOut, completion: revertSnowball)
    }
    
    func matchSnowballX(rand: Int) -> CGFloat {
        
        var startingX: CGFloat = CGFloat()
        
        switch(rand) {
            
            case 1:
                startingX = gameData.startingHeroPos.x
                break
            case 2:
                startingX = self.frame.size.width
                break
            default:
                break
        }
        
        return startingX
    
    }
    
    func drawCoyote() {
        
        let randSpeed = Double.random(in: 1.65 ... 2.00)
        
        let coyoteFrames: [SKTexture] = [SKTexture(imageNamed: "coy-1"), SKTexture(imageNamed: "coy-2"), SKTexture(imageNamed: "coy-3"), SKTexture(imageNamed: "coy-4"), SKTexture(imageNamed: "coy-5"), SKTexture(imageNamed: "coy-6"), SKTexture(imageNamed: "coy-7"), SKTexture(imageNamed: "coy-8"), SKTexture(imageNamed: "coy-9")]//, SKTexture(imageNamed: "coyote-10")]//, SKTexture(imageNamed: "coyote-11"), SKTexture(imageNamed: "coyote-12"), SKTexture(imageNamed: "coyote-13"), SKTexture(imageNamed: "coyote-14"), SKTexture(imageNamed: "coyote-15"), SKTexture(imageNamed: "coyote-16"), SKTexture(imageNamed: "coyote-17"), SKTexture(imageNamed: "coyote-18")]
        
        let coyoteAnimate = SKAction.animate(with: coyoteFrames, timePerFrame: randSpeed / 25)
        self.coyoteDashAction = coyoteAnimate
        let coyoteShift = SKAction.moveTo(x: -self.frame.size.width, duration: randSpeed * 0.9)
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
        let rise = SKAction.moveTo(y: self.frame.size.height / 8, duration: characterSpeed)
        let drop = SKAction.moveTo(y: -self.frame.size.height / 3.65, duration: characterSpeed)
        
        let riseSeq = SKAction.sequence([rise, drop])
        
        let riseRepeater = SKAction.repeat(riseSeq, count: 1)
        let attackRepeater = SKAction.repeat(attackAnimate, count: 1)
        
        coyote.run(riseRepeater)
        coyote.run(attackRepeater, completion: coyoteResumeRunning)
    }
    
    func coyoteResumeRunning() {
        
        coyote.run(coyoteDashAction)
        
        objNum += 1
    }
    
    func drawSnake() {
        
        let randSpeed = Double.random(in: 1.7 ... 1.9)
        
        let snakeFrames: [SKTexture] = [SKTexture(imageNamed: "snake-1"), SKTexture(imageNamed: "snake-2"), SKTexture(imageNamed: "snake-3"), SKTexture(imageNamed: "snake-4"), SKTexture(imageNamed: "snake-5"), SKTexture(imageNamed: "snake-6"), SKTexture(imageNamed: "snake-7"), SKTexture(imageNamed: "snake-8"), SKTexture(imageNamed: "snake-9"), SKTexture(imageNamed: "snake-10"), SKTexture(imageNamed: "snake-11")]//, SKTexture(imageNamed: "snake-12")]//, SKTexture(imageNamed: "snake-13"), SKTexture(imageNamed: "snake-14"), SKTexture(imageNamed: "snake-15")]
        
        let snakeAnimate = SKAction.animate(with: snakeFrames, timePerFrame: randSpeed / 10)
        let snakeShift = SKAction.moveTo(x: -self.frame.size.width, duration: randSpeed)
        let snakeRevert = SKAction.moveTo(x: self.frame.size.width, duration: 0)
        
        let snakeSeq = SKAction.sequence([snakeShift, snakeRevert])
        
        let shiftRepeater = SKAction.repeat(snakeSeq, count: 1)
        let snakeRepeater = SKAction.repeat(snakeAnimate, count: 1)
        
        snake.run(snakeRepeater)
        snake.run(shiftRepeater)
        
        objNum += 1
    }
    
    func drawBat() {
        
        let randSpeed = Double.random(in: 1.65 ... 1.9)
        
        let batFrames: [SKTexture] = [SKTexture(imageNamed: "bat-1"), SKTexture(imageNamed: "bat-2"), SKTexture(imageNamed: "bat-3"), SKTexture(imageNamed: "bat-4")]
        
        let batAnim = SKAction.animate(with: batFrames, timePerFrame: 0.2)
        let batAnimRepeater = SKAction.repeatForever(batAnim)
        let batShift = SKAction.moveTo(x: -self.frame.width, duration: randSpeed)
        
        let batReversion = SKAction.moveTo(x: self.frame.width, duration: 0)
        let batSeq = SKAction.sequence([batShift, batReversion])
        let reversionRepeater = SKAction.repeat(batSeq, count: 1)
                
        batSprite.run(batAnimRepeater)
        batSprite.run(reversionRepeater)
        
        objNum += 1
    }
    
    func drawSpider() {
        
        let randSpeed = Double.random(in: 1.5 ... 1.7)
        
        let spiderFrames: [SKTexture] = [SKTexture(imageNamed: "spider-1"), SKTexture(imageNamed: "spider-2"), SKTexture(imageNamed: "spider-3"), SKTexture(imageNamed: "spider-4"), SKTexture(imageNamed: "spider-5"), SKTexture(imageNamed: "spider-6"), SKTexture(imageNamed: "spider-7")]//, SKTexture(imageNamed: "spider-8"), SKTexture(imageNamed: "spider-9"), SKTexture(imageNamed: "spider-10"), SKTexture(imageNamed: "spider-11"), SKTexture(imageNamed: "spider-12"), SKTexture(imageNamed: "spider-13")]
        
        let spiderAnimate = SKAction.animate(with: spiderFrames, timePerFrame: characterSpeed / 2)
        
        let spiderShift = SKAction.moveTo(x: -self.frame.size.width, duration: randSpeed)
        
        let spiderRevert = SKAction.moveTo(x: self.frame.size.width, duration: 0)
        
        let spiderSeq = SKAction.sequence([spiderShift, spiderRevert])
        
        let animateRepeater = SKAction.repeatForever(spiderAnimate)
        let shiftRepeater = SKAction.repeat(spiderSeq, count: 1)
        
        spider.run(animateRepeater)
        spider.run(shiftRepeater)
        
        objNum += 1
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
        let randSpeed = Double.random(in: 1.00 ... 1.45)
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
        let rockShift = SKAction.moveTo(x: -self.frame.size.width, duration: randSpeed)
        let rockRevert = SKAction.moveTo(x: self.frame.size.width, duration: 0)
        
        let shiftSeq = SKAction.sequence([rockShift, rockRevert])
        
        let shiftRepeater = SKAction.repeat(shiftSeq, count: 1)
        let animateRepeater = SKAction.repeatForever(animate)
        
        rock.position.x = golem.position.x
        
        if(rand == 1)
        {
            rock.position.y = gameData.startingHeroPos.y + 75
        }
        
        if(rand == 2)
        {
            rock.position.y = gameData.startingHeroPos.y
        }

        rock.run(shiftRepeater)
        rock.run(animateRepeater)
        
        objNum += 1
    }
    
    func initChecks() {
        
        checkMark1 = SKSpriteNode(imageNamed: "checkmark")
        checkMark1.size = CGSize(width: checkMark1.size.width * (self.frame.size.width * 0.00025), height: checkMark1.size.height * (self.frame.size.width * 0.00025))
        checkMark1.position = CGPoint(x: -self.frame.size.width / 4, y: 0)
        checkMark1.zPosition = 5
        checkMark1.alpha = 0.0
        checkMark1.name = "check-1"
        checkMark1.isUserInteractionEnabled = false
        
        self.addChild(checkMark1)
        
        checkMark2 = SKSpriteNode(imageNamed: "checkmark")
        checkMark2.size = CGSize(width: checkMark2.size.width * (self.frame.size.width * 0.00025), height: checkMark2.size.height * (self.frame.size.width * 0.00025))
        checkMark2.position = CGPoint(x: 0, y: 0)
        checkMark2.zPosition = 5
        checkMark2.alpha = 0.0
        checkMark2.name = "check-2"
        checkMark2.isUserInteractionEnabled = false

        
        self.addChild(checkMark2)
        
        checkMark3 = SKSpriteNode(imageNamed: "checkmark")
        checkMark3.size = CGSize(width: checkMark3.size.width * (self.frame.size.width * 0.00025), height: checkMark3.size.height * (self.frame.size.width * 0.00025))
        checkMark3.position = CGPoint(x: self.frame.size.width / 4, y: 0)
        checkMark3.zPosition = 5
        checkMark3.alpha = 0.0
        checkMark3.name = "check-3"
        checkMark3.isUserInteractionEnabled = false
        
        
        self.addChild(checkMark3)
    }
    
    func initObjects() {
    
        //ScoreBox
        
        scoreBox = SKShapeNode(rect: CGRect(x: self.frame.size.width / 3.5, y: self.frame.size.height / 3, width: self.frame.size.width / 5, height: self.frame.size.height / 7), cornerRadius: 10)
        scoreBox.fillColor = .black
        scoreBox.strokeColor = .black
        scoreBox.lineWidth = 3
        
        //Coin Icon and Score Display
        
        coinIcon = SKSpriteNode(imageNamed: "goldcoin-1")
        coinIcon.size = CGSize(width: coinIcon.size.width * (self.frame.size.width * 0.0001), height: coinIcon.size.height * (self.frame.size.width * 0.0001))
        coinIcon.position = CGPoint(x: self.frame.size.width / 3, y: self.frame.size.height / 2.5)
        scoreBox.addChild(coinIcon)
        
        scoreLabel = SKLabelNode(fontNamed: "Antapani-ExtraBold")
        scoreLabel.fontColor = .white
        scoreLabel.fontSize = self.frame.size.width * 0.05
        scoreLabel.text = String(savedData.coinCount)
        scoreLabel.position = CGPoint(x: self.frame.size.width / 2.5, y: self.frame.size.height / 2.76)
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            scoreLabel.position.y = self.frame.size.height / 2.68
        }
        scoreLabel.zPosition = 5
        scoreBox.addChild(scoreLabel)
        
        self.addChild(scoreBox)
        
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
        thrownSnowball = SKSpriteNode(imageNamed: "snowbol-1")
        thrownSnowball.position = CGPoint(x: evilSnowman.position.x, y: -self.frame.size.height / 4.75)
        thrownSnowball.name = "thrownsnowball"
        
        thrownSnowball.size = CGSize(width: thrownSnowball.size.width * (self.frame.size.width * 0.001), height: thrownSnowball.size.height * (self.frame.size.width * 0.001))
        
        fallenSnowball = SKSpriteNode(imageNamed: "snowbol-1")
        fallenSnowball.position = CGPoint(x: gameData.startingHeroPos.x, y: self.frame.size.height)
        fallenSnowball.name = "fallensnowball"
        
        fallenSnowball.size = CGSize(width: thrownSnowball.size.width * (self.frame.size.width * 0.0012), height: thrownSnowball.size.height * (self.frame.size.width * 0.0012))
        
        thrownSnowball.physicsBody = SKPhysicsBody(circleOfRadius: thrownSnowball.size.width / 2)
        thrownSnowball.physicsBody?.affectedByGravity = false
        thrownSnowball.physicsBody?.categoryBitMask = ColliderType.thrownSnowBall
        thrownSnowball.physicsBody?.collisionBitMask = ColliderType.hero
        thrownSnowball.physicsBody?.contactTestBitMask = ColliderType.hero
        thrownSnowball.physicsBody?.isDynamic = false
        
        fallenSnowball.physicsBody = SKPhysicsBody(circleOfRadius: fallenSnowball.size.width / 2)
        fallenSnowball.physicsBody?.affectedByGravity = false
        fallenSnowball.physicsBody?.categoryBitMask = ColliderType.fallenSnowBall
        fallenSnowball.physicsBody?.collisionBitMask = ColliderType.hero
        fallenSnowball.physicsBody?.contactTestBitMask = ColliderType.hero
        fallenSnowball.physicsBody?.isDynamic = false
        
        self.addChild(thrownSnowball)
        self.addChild(fallenSnowball)
        
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
        sandstorm.size = CGSize(width: sandstorm.size.width * (self.frame.size.width * 0.0003), height: sandstorm.size.height * (self.frame.size.width * 0.0003))
        sandstorm.name = "sandstorm"
        sandstorm.position = CGPoint(x: self.frame.size.width, y: -self.frame.size.height / 4)
        
        
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
            batSprite.position = CGPoint(x: self.frame.size.width, y: -self.frame.size.height / 5.82)
        }
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            batSprite.position = CGPoint(x: self.frame.size.width, y: -self.frame.size.height / 4.75)
        }
        
        batSprite.xScale = -1
        
        batSprite.physicsBody = SKPhysicsBody(circleOfRadius: batSprite.size.width / 3.2)
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
        isLevelPassed = false
        levelLoader?.invalidate()
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
        
        isLevelPassed = true
        
        addCoinBonus()
        
        view?.removeGestureRecognizer(swipeUp)
        view?.removeGestureRecognizer(swipeDown)
        
        pauseBackgAndPlatform()
        let characterShift = SKAction.moveTo(x: self.frame.size.width / 2.5, duration: 1)
        
        let shiftRepeater = SKAction.repeat(characterShift, count: 1)
        
        hero.run(shiftRepeater, completion: endGame)
    }
    
    func makeCharIdle() {
        
        let idleFrames: [SKTexture] = [SKTexture(imageNamed: "idle-1"), SKTexture(imageNamed: "idle-2"), SKTexture(imageNamed: "idle-3"), SKTexture(imageNamed: "idle-4")]
        
        hero.removeAllActions()
        
        let idleAnim = SKAction.animate(with: idleFrames, timePerFrame: characterSpeed)
        
        let idleRepeater = SKAction.repeatForever(idleAnim)
        
        hero.run(idleRepeater)
    }
    
    func addCheckMarks() {
        
        var one: Bool = true
        var two: Bool = true
        var three: Bool = true
        
        switch(terrainKeyword) {
            
            case "snow":
                one = savedData.completedLevels[0]
                two = savedData.completedLevels[1]
                three = savedData.completedLevels[2]
                break
            case "desert":
                one = savedData.completedLevels[3]
                two = savedData.completedLevels[4]
                three = savedData.completedLevels[5]
                break
            case "cave":
                one = savedData.completedLevels[6]
                two = savedData.completedLevels[7]
                three = savedData.completedLevels[8]
                break
            default:
                break
        }
        
        if(one)
        {
            checkMark1.alpha = 1.0
        }
        
        if(two)
        {
            checkMark2.alpha = 1.0
        }
        
        if(three)
        {
            checkMark3.alpha = 1.0
        }
    }
    
    func updateCompletedLevel() {
        
        switch(terrainKeyword) {
            
            case "snow":
                if(levelLiteral.contains("1"))
                {
                    savedData.completedLevels[0] = true
                }
            
                if(levelLiteral.contains("2"))
                {
                    savedData.completedLevels[1] = true
                }
            
                if(levelLiteral.contains("3"))
                {
                    savedData.completedLevels[2] = true
                }
                break
            
            case "desert":
                if(levelLiteral.contains("1"))
                {
                    savedData.completedLevels[3] = true
                }
            
                if(levelLiteral.contains("2"))
                {
                    savedData.completedLevels[4] = true
                }
            
                if(levelLiteral.contains("3"))
                {
                    savedData.completedLevels[5] = true
                }
                break
            
            case "cave":
                if(levelLiteral.contains("1"))
                {
                    savedData.completedLevels[6] = true
                }
            
                if(levelLiteral.contains("2"))
                {
                    savedData.completedLevels[7] = true
                }
            
                if(levelLiteral.contains("3"))
                {
                    savedData.completedLevels[8] = true
                }
                break
            default:
                break
        }
        
        GameScene.defaults.set(savedData.completedLevels, forKey: "completedLevels")
    }
    
    func addCoinBonus() {
    
        if(!savedData.completedLevels[levelIdentifier]) {
            
            scoreBonus = SKLabelNode(fontNamed: "Antapani-ExtraBold")
            scoreBonus.fontColor = .white
            scoreBonus.fontSize = self.frame.size.width * 0.03
            scoreBonus.text = "+" + String(bonusCoinAmount)
            scoreBonus.position = CGPoint(x: self.frame.size.width / 2.165, y: self.frame.size.height / 2.76)
            
            if(UIDevice.current.userInterfaceIdiom == .pad)
            {
                scoreBonus.position.y = self.frame.size.height / 2.68
            }
            
            scoreBonus.zPosition = 5
            scoreBonus.alpha = 0.0
            scoreBox.addChild(scoreBonus)
            
            let fadeIn = SKAction.fadeIn(withDuration: 1)
            let fadeOut = SKAction.fadeOut(withDuration: 1)
            
            let fadeSequencer = SKAction.sequence([fadeIn, fadeOut])
            
            scoreBonus.run(fadeSequencer)
            
            performCoinAdjustion()
        }
            
    }
    
    func performCoinAdjustion() {
        
        oldCoinCount = savedData.coinCount
        coinDisplayLink = CADisplayLink(target: self, selector: #selector(incrementScore))
        coinDisplayLink.add(to: .main, forMode: .default)
    }
    
    @objc func incrementScore() {
        
        savedData.coinCount += 1
        scoreLabel.text = String(savedData.coinCount)
        
        if(savedData.coinCount >= oldCoinCount + bonusCoinAmount) {
            
            coinDisplayLink.invalidate()
        }
    }
    
    func endGame() {
    
        progressDisplayLink?.invalidate()
        pauseAnimation(layer: trackLayer)
        pauseAnimation(layer: shapeLayer)
        
        gameData.gameIsOver = true
        
        if(isLevelPassed)
        {
            if(current < 10000) {
                
                percentageLabel.text = "100%"
            }
            
            updateCompletedLevel()
            confetti = SAConfettiView(frame: (self.view?.bounds)!)
            confetti.type = .Diamond
            
            view?.addSubview(confetti)
            confetti.startConfetti()
            
            makeCharIdle()
        }
        
        resetModifiers()
        pauseBackgAndPlatform()
        showEndingMenu()
        
    }
    
    func resetModifiers() {
        
        basicAnimation = nil
        startedProgress = false
        displayLinkIsValid = false
        resumedAngle = (-CGFloat.pi / 2)
        animationDuration = 0
        current = 0
        objNum = 0
        levelIdentifier = 0
    }
    
    func getLevelIndex(index: Int) -> Int {
        
        switch(terrainKeyword) {
        
            case "snow":
                return index;
            case "desert":
                return index + 3;
            case "cave":
                return index + 6;
            default:
                print("Other terrain keyword...");
                return index;
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
                            
        if let touch = touches.first {
            
            let location = touch.previousLocation(in: self)
            let node = self.nodes(at: location).first
                        
            if(node?.name == "replay")
            {
                if(isLevelPassed)
                {
                    confetti.removeFromSuperview()
                }
                
                startGame()
            }
                
            else if(node?.name == "return")
            {
                terrainKeyword = ""
                MusicHelper.sharedHelper.stopPlaying()
                MusicHelper.sharedHelper.prepareToPlay()
                MusicHelper.sharedHelper.audioPlayer?.play()
                cleanUp()
                cleanCameraNode()
                let continentLoader = ContinentLoader(size: (view?.bounds.size)!)
                continentLoader.scaleMode = .aspectFill
                self.view?.presentScene(continentLoader)
            }
                
            else if(node?.name == "back")
            {
                if(isLevelPassed)
                {
                    confetti.removeFromSuperview()
                }
                
                cleanUp()
                resumeBackgAndPlatform()
                selectDifficulty()
            }
                
            else if(node?.name == "next")
            {
                cleanUp()
                resumeBackgAndPlatform()
                selectDifficulty()
                
                if(isLevelPassed)
                {
                    confetti.removeFromSuperview()
                }
            }
                
            else if((difficultySubBox1.contains(location)) || (difficultySubBox2.contains(location)) || (difficultySubBox3.contains(location)))
            {

                if((node?.name == "level-1") || (node?.name == "check-1") || (node?.name == "level-1text") || (node?.name == "onestar"))
                {
                    let levelIndex = getLevelIndex(index: 0)
                    
                    if(levelIndex != 0) {
                        
                        if(!savedData.completedLevels[levelIndex - 1]) {
                            
                            return
                        }
                    }
                    
                    returnButton.removeFromParent()
                    levelLiteral = terrainKeyword + "level1"
                    gameData.levelNumeral = 0
                    initializeGame()
                    difficultyBox.isHidden = true
                }
                
                else if((node?.name == "level-2")  || (node?.name == "check-2") || (node?.name == "level-2text") || (node?.name == "twostar"))
                {
                    let levelIndex = getLevelIndex(index: 1)
                    
                    if(!savedData.completedLevels[levelIndex - 1]) {
                        
                        return
                    }
                    
                    returnButton.removeFromParent()
                    levelLiteral = terrainKeyword + "level2"
                    gameData.levelNumeral = 1
                    initializeGame()
                    difficultyBox.isHidden = true
                }
                
                else if((node?.name == "level-3")  || (node?.name == "check-3") || (node?.name == "level-3text") || (node?.name == "threestar"))
                {
                    let levelIndex = getLevelIndex(index: 2)
                    
                    if(!savedData.completedLevels[levelIndex - 1]) {
                        
                        return
                    }
                    
                    returnButton.removeFromParent()
                    levelLiteral = terrainKeyword + "level3"
                    gameData.levelNumeral = 2
                    initializeGame()
                    difficultyBox.isHidden = true
                }
            }
       }
    }
    
    func getUIColor(literal: String) -> UIColor {
        
        if(literal == "green")
        {
            return UIColor.green
        }
        
        if(literal == "red")
        {
            return UIColor.red
        }
        
        return UIColor.black
    }
    
    func showEndingMenu() -> Void {
        
        levelLoader?.invalidate()
        
        var menuHeight: CGFloat = self.frame.size.height / 3.5
        var statusSize: CGFloat = self.frame.size.width * 0.05
        var statusText: String = ""
        var statusColor: String = ""
        let currentLevelName: String = levelNames[gameData.levelNumeral]
        
        if(UIDevice.current.userInterfaceIdiom == .pad)
        {
            menuHeight = self.frame.height / 4.15
            statusSize = self.frame.size.width * 0.06
        }
        
        gameOverDisplay = SKShapeNode(rect: CGRect(x: -self.frame.width, y: self.frame.midY - 20, width: self.frame.width * 2, height: menuHeight))
        gameOverDisplay.fillColor = .black
        gameOverDisplay.alpha = 0.5
        
        if(isLevelPassed)
        {
            statusColor = "green"
            statusText = "COMPLETED"
        }

        else
        {
            statusColor = "red"
            statusText = "INCOMPLETE"
        }
        
        let newString = currentLevelName + ": " + statusText
        let attributedText = NSMutableAttributedString(string: newString)
        attributedText.addAttribute(.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: currentLevelName.count + 2))
        attributedText.addAttribute(.foregroundColor, value: getUIColor(literal: statusColor), range: NSRange(location: currentLevelName.count + 2, length: statusText.count))
        attributedText.addAttribute(.font, value: UIFont(name: "CarbonBl-Regular", size: statusSize)!, range: NSRange(location: 0, length: newString.count))
    
        levelAlert = SKLabelNode(fontNamed: "CarbonBl-Regular")
        levelAlert.fontColor = .white
        levelAlert.fontSize = statusSize
        levelAlert.attributedText = attributedText
        levelAlert.position = CGPoint(x: 0, y: self.frame.size.height / 8)
    
        initButtons()
        
        self.addChild(gameOverDisplay)
        self.addChild(levelAlert)
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
            GameScene.defaults.set(savedData.coinCount, forKey: "coins")
            updateCoins()
            
            coin.run(fillerAction, completion: makeHeroDynamic)
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
        
        shapeLayer.removeFromSuperlayer()
        trackLayer.removeFromSuperlayer()
        percentageLabel.removeFromSuperview()
        completedLabel.removeFromSuperview()
    }
    
    func cleanCameraNode() {
        
        for child in cameraNode.children {
            
            child.removeFromParent()
        }
    
        cameraNode.removeFromParent()
    }
    
    func removeCheckMarks() {
        
        checkMark1.alpha = 0.0
        checkMark2.alpha = 0.0
        checkMark3.alpha = 0.0
    }
    
    func startGame() {
        
        gameData.gameIsOver = false
        gameData.hasPopups = true
        resetModifiers()
        cleanUp()
        resumeBackgAndPlatform()
        initializeGame()
    }
}
