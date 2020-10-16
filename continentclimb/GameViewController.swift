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
        
        if let view = self.view as! SKView? {
            
            let scene = HomeScene(size: view.bounds.size)
            scene.scaleMode = .aspectFill
            view.presentScene(scene)
            
            let notificationCenter = NotificationCenter.default
            notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
            notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.didBecomeActiveNotification, object: nil)
            
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
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

        GameViewController.gameScene?.levelLoader.invalidate()
        GameViewController.gameScene?.progressDisplayLink.invalidate()
        GameViewController.gameScene?.pauseAnimation(layer: GameViewController.gameScene?.shapeLayer ?? CAShapeLayer())
        GameViewController.gameScene?.pauseAnimation(layer: GameViewController.gameScene?.trackLayer ?? CAShapeLayer())
        MusicHelper.sharedHelper.audioPlayer?.pause()
        GameViewController.gameScene?.isPaused = true
    }
    
    @objc func appMovedToForeground() {
        
        GameViewController.gameScene?.isPaused = false
        MusicHelper.sharedHelper.prepareToPlay()
        MusicHelper.sharedHelper.audioPlayer?.play()
        GameViewController.gameScene?.resumeAnimation(layer: GameViewController.gameScene?.shapeLayer ?? CAShapeLayer())
        GameViewController.gameScene?.resumeAnimation(layer: GameViewController.gameScene?.trackLayer ?? CAShapeLayer())
        GameViewController.gameScene?.levelLoader.invalidate()
        
        if((!gameData.gameIsOver) && (!gameData.hasPopups))
        {
            GameViewController.gameScene?.startLevel()
        }
    }
    
    
}
