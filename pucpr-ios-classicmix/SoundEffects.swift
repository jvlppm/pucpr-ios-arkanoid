//
//  SoundEffects.swift
//  pucpr-ios-classicmix
//
//  Created by Joao Vitor on 11/3/14.
//  Copyright (c) 2014 Joao Vitor. All rights reserved.
//

import Foundation
import AVFoundation

class SoundEffects {
    var player: AVAudioPlayer? = nil
   
    func bounce() {
        play("Bounce")
    }
    
    func hitBrick() {
        play("Hit_Hurt")
    }
    
    func destroyBrick() {
        play("Hit_Destroy")
    }
    
    func death() {
        play("Explosion")
    }
    
    func play(sound: String) {
        var fileUrl: NSURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(sound, ofType: "wav")!)!
        var error: NSError?
        player = AVAudioPlayer(contentsOfURL: fileUrl, error: &error)
        player?.numberOfLoops = 0
        player?.volume = Game.Settings.effectsVolume
        player?.prepareToPlay()
        player?.play()
    }
}