//
//  MusicHelper.swift
//  continentclimb
//
//  Created by Brian Limaye on 8/24/20.
//  Copyright © 2020 Brian Limaye. All rights reserved.
//

import Foundation
import AVFoundation

class MusicHelper {
    static let sharedHelper = MusicHelper()
    var audioPlayer: AVAudioPlayer?

    func prepareToPlay() {
        
        var resourceKeyword: String?
        
        switch(terrainKeyword) {
        
            
            case "snow":
                resourceKeyword = "snowtheme"
                break;
            case "desert":
                resourceKeyword = "desertheme"
                break;
            case "cave":
                resourceKeyword = "cavetheme"
                break;
            default:
                resourceKeyword = "sax"
                break;
        }
        
        let aSound = NSURL(fileURLWithPath: Bundle.main.path(forResource: resourceKeyword, ofType: "mp3")!)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: aSound as URL)
            audioPlayer!.numberOfLoops = -1
            audioPlayer!.prepareToPlay()
        } catch {
            print("Cannot play the file")
        }
    }
    
    func stopPlaying() {
        
        audioPlayer?.stop()
    }
}
