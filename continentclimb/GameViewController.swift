//
//  GameViewController.swift
//  continentclimb
//
//  Created by Brian Limaye on 7/13/20.
//  Copyright © 2020 Brian Limaye. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import AVKit
import AVFoundation

class GameViewController: UIViewController {
    
    static var gameScene: GameScene?
    private static var serialQueue: DispatchQueue = DispatchQueue(label: "backfor")
    static var dateInBackground: Date?
    static var timeInBackground: TimeInterval = 0
    static var prevTimeInBackground: TimeInterval = 0
    static var newTimeInBackground: TimeInterval = 0
    
    let isDebug: Bool = {
        
        var isDebug = false
        // function with a side effect and Bool return value that we can pass into assert()
        func set(debug: Bool) -> Bool {
            isDebug = debug
            return isDebug
        }
        // assert:
        // "Condition is only evaluated in playgrounds and -Onone builds."
        // so isDebug is never changed to true in Release builds
        assert(set(debug: true))
        return isDebug
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MusicHelper.sharedHelper.prepareToPlay()
        
        if let view = self.view as! SKView? {
            
            let scene = HomeScene(size: view.bounds.size)
            scene.scaleMode = .aspectFill
            view.presentScene(scene)
            
            let notificationCenter = NotificationCenter.default
            notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
            notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.didBecomeActiveNotification, object: nil)
            
            view.ignoresSiblingOrder = true
            //view.showsFPS = true
            //view.showsNodeCount = true
            //view.showsPhysics = true
        }
    }
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {

           guard let key = presses.first?.key else { return }

           switch key.keyCode {

           case .keyboardUpArrow:
               
               if isDebug
               {
                    GameViewController.gameScene?.jumpHero()
               }
            
           case .keyboardDownArrow:
               
               if isDebug
               {
                    GameViewController.gameScene?.slideHero()
               }
            
           case .keyboardO:
               
               if isDebug
               {
                    GameViewController.gameScene?.drawCoin()
               }
            
           case .keyboardG:
               
               if isDebug
               {
                    GameViewController.gameScene?.drawGolem()
               }
            
           case .keyboardS:
            
               if isDebug
               {
                    GameViewController.gameScene?.drawSnowman()
               }
            
           case .keyboardP:
               
               if isDebug
               {
                    GameViewController.gameScene?.drawSpider()
               }
            
           case .keyboardN:
              
               if isDebug
               {
                    GameViewController.gameScene?.drawSnake()
               }
            
           case .keyboardB:
               
               if isDebug
               {
                    GameViewController.gameScene?.drawFallenSnowball()
               }
            
           case .keyboardA:
            
               if isDebug
               {
                    GameViewController.gameScene?.drawBat()
               }
            
           case .keyboardY:
               
               if isDebug
               {
                    GameViewController.gameScene?.drawYeti()
               }
           case .keyboardC:
               
               if isDebug
               {
                    GameViewController.gameScene?.drawCoyote()
               }
    
           case .keyboardD:
               
               if isDebug
               {
                    GameViewController.gameScene?.drawSandstorm()
               }
            
           case .keyboardE:
               
               if isDebug
               {
                    GameViewController.gameScene?.endGame()
               }
            
           default:
                
               if isDebug
               {
               
               }

           super.pressesBegan(presses, with: event)
            
        }

    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .landscape
        } else {
            return .all
        }
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc func appMovedToBackground() {
        
        GameViewController.serialQueue.sync {
            
            GameViewController.gameScene?.needsOffset = true
            GameViewController.gameScene?.pauseAnimation(layer: GameViewController.gameScene?.shapeLayer ?? CAShapeLayer())
            //GameViewController.gameScene?.pauseAnimation(layer: GameViewController.gameScene?.trackLayer ?? CAShapeLayer())

            GameViewController.dateInBackground = Date()
            
            GameScene.defaults.set(savedData.completedLevels, forKey: "completedLevels")
            GameScene.defaults.set(savedData.coinCount, forKey: "coins")
            GameScene.defaults.set(savedData.hasCompletedHallow, forKey: "finishedHallow")
            GameScene.defaults.set(savedData.completedHallowEvent, forKey: "completedHallow")
            GameScene.defaults.set(savedData.hasPumpkinEquipped, forKey: "hasPumpkin")

            GameViewController.gameScene?.coinIcon.removeAllActions()
            
            if((GameViewController.gameScene?.levelLoader != nil) || ((GameViewController.gameScene?.levelLoader?.isValid) != nil)) {
                
                if(GameViewController.gameScene?.hasLevelStarted == true) {
                    
                    GameViewController.gameScene?.levelLoader?.invalidate()
                }
            }
            
            if(GameViewController.gameScene?.progressDisplayLink != nil) {
                
                if(GameViewController.gameScene?.hasLevelStarted == true) {
                    
                    print("removed display link.")
                    GameViewController.gameScene?.removeDisplayLink()
                }
            }
            
            if((MusicHelper.sharedHelper.audioPlayer?.isPlaying) != nil) {
                
                MusicHelper.sharedHelper.audioPlayer?.stop()
            }
           
            GameViewController.gameScene?.isPaused = true
        }
    }
    
    @objc func appMovedToForeground() {
        
        GameViewController.gameScene?.levelLoader?.invalidate()
        
        GameViewController.serialQueue.sync {
            
            GameViewController.gameScene?.isPaused = false
            MusicHelper.sharedHelper.audioPlayer?.play()
    
            if((GameViewController.gameScene?.progressDisplayLink != nil) || ((GameViewController.gameScene?.displayLinkIsValid == true))) {
                
                if(GameViewController.gameScene?.hasLevelStarted == true) {
                    
                    GameViewController.gameScene?.coinIcon.removeAllActions()
                    GameViewController.gameScene?.pauseProgressBar()
                }
            }
            
            if(!gameData.gameIsOver)
            {
                if(GameViewController.gameScene?.hasLevelStarted == true) {
        
                    GameViewController.gameScene?.startLevel()
                }
            }
            
            if(GameViewController.dateInBackground != nil) {
                
                GameViewController.prevTimeInBackground = GameViewController.newTimeInBackground
                
                if(GameViewController.prevTimeInBackground == 0.0) {
                    
                    GameViewController.prevTimeInBackground = 0.001
                }
                
                let now: Date = Date()
                
                GameViewController.newTimeInBackground = (GameViewController.dateInBackground?.timeIntervalSince(now))!
                
                GameViewController.timeInBackground += GameViewController.newTimeInBackground
            }
        }
    }
}
