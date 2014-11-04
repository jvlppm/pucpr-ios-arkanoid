//
//  MusicPlayer.swift
//  pucpr-ios-classicmix
//
//  Created by Joao Vitor on 11/3/14.
//  Copyright (c) 2014 Joao Vitor. All rights reserved.
//

import Foundation
import AVFoundation

class MusicPlayer {
    var lastUpdateTimeInterval: CFTimeInterval? = nil
    
    var fadeInMusic: Array<AVAudioPlayer> = []
    var fadeOutMusic: Array<AVAudioPlayer> = []
    var playing: Array<AVAudioPlayer> = []
    
    var volume: Float = Game.Settings.musicVolume
    
    func update(currentTime: CFTimeInterval) {
        var delta: CFTimeInterval = 0
        if let last = lastUpdateTimeInterval {
            delta = currentTime - last
        }
        
        lastUpdateTimeInterval = currentTime
        
        if delta <= 0 {
            return
        }
        
        for player in fadeInMusic {
            player.volume += Float(delta / 3) * volume
            if player.volume >= volume {
                player.volume = volume
                playing.append(player)
            }
        }
        
        fadeInMusic = fadeInMusic.filter { $0.volume < self.volume }
        
        for player in fadeOutMusic {
            player.volume -= Float(delta / 3) * volume
            if player.volume <= 0 {
                player.stop()
            }
        }
        
        fadeOutMusic = fadeOutMusic.filter { $0.playing }
    }
    
    func play(file: String) {
        var fileUrl: NSURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(file, ofType: "mp3")!)!
        var error: NSError?
        let player = AVAudioPlayer(contentsOfURL: fileUrl, error: &error)
        player.numberOfLoops = -1
        player.volume = 0
        player.prepareToPlay()
        player.play()
        
        for current in self.fadeInMusic {
            self.fadeOutMusic.append(current)
        }
        for current in self.playing {
            self.fadeOutMusic.append(current)
        }
        
        self.playing = []
        self.fadeInMusic = [player]
    }
}