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
        var fileExtension: String?
        
        switch(terrainKeyword) {

            case "snow":
                resourceKeyword = "snowtheme"
                fileExtension = ".mp3"
                break;
            case "desert":
                resourceKeyword = "desertheme"
                fileExtension = ".mp3"
                break;
            case "cave":
                resourceKeyword = "cavetheme"
                fileExtension = ".mp3"
                break;
            default:
                resourceKeyword = "sax"
                fileExtension = ".mp3"
                break;
        }
        
        let aSound = NSURL(fileURLWithPath: Bundle.main.path(forResource: resourceKeyword, ofType: fileExtension)!)
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
