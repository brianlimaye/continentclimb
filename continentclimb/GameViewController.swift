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
            
            let scene = GameScene(size: view.bounds.size)
            scene.scaleMode = .aspectFill
            view.presentScene(scene)
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
            
           case .keyboardS:
            
               if isDebug
               {
                    GameViewController.gameScene?.drawSnowman()
               }
            
           case .keyboardB:
               
               if isDebug
               {
                    GameViewController.gameScene?.drawFallenSnowball()
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
}
