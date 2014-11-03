//
//  Game.swift
//  pucpr-ios-classicmix
//
//  Created by Joao Vitor on 11/3/14.
//  Copyright (c) 2014 Joao Vitor. All rights reserved.
//

import Foundation
import SpriteKit

struct Game {
    static var navigation: UINavigationController?
    
    static func enableNavigation() {
        Game.navigation?.navigationBarHidden = false
    }
    
    static func hideNavigation() {
        Game.navigation?.navigationBarHidden = true
    }
    
    static func toggleNavigation() {
        Game.navigation?.navigationBarHidden = !Game.navigation!.navigationBarHidden
    }
    
    struct Settings {
        static var highScore: Int {
            get {
                return NSUserDefaults.standardUserDefaults()
                        .integerForKey("highscore")
            }
            set(value) {
                NSUserDefaults.standardUserDefaults()
                    .setInteger(value, forKey: "highscore")
            }
        }
        
        static var backgroundOpacity: Float {
            get {
                let value: AnyObject? = NSUserDefaults.standardUserDefaults()
                    .objectForKey("backgroundOpacity")
                if value == nil {
                    return 0.6
                }
                return value as Float
            }
            set(value) {
                NSUserDefaults.standardUserDefaults()
                    .setFloat(value, forKey: "backgroundOpacity")
            }
        }
        
        static var musicVolume: Float {
            get {
                let value: AnyObject? = NSUserDefaults.standardUserDefaults()
                    .objectForKey("musicVolume")
                if value == nil {
                    return 0.5
                }
                return value as Float
            }
            set(value) {
                NSUserDefaults.standardUserDefaults()
                    .setFloat(value, forKey: "musicVolume")
            }
        }
        
        static var effectsVolume: Float {
            get {
                let value: AnyObject? = NSUserDefaults.standardUserDefaults()
                    .objectForKey("effectsVolume")
                if value == nil {
                    return 0.5
                }
                return value as Float
            }
            set(value) {
                NSUserDefaults.standardUserDefaults()
                    .setFloat(value, forKey: "effectsVolume")
            }
        }
        
        static var backgroundAnimations: Bool {
            get {
                let value: AnyObject? = NSUserDefaults.standardUserDefaults()
                    .objectForKey("backgroundAnimations")
                if value == nil {
                    return true
                }
                return value as Bool
            }
            set(value) {
                NSUserDefaults.standardUserDefaults()
                    .setBool(value, forKey: "backgroundAnimations")
            }
        }
        
        static var difficulty: Int {
            get {
                let value: AnyObject? = NSUserDefaults.standardUserDefaults()
                .objectForKey("difficulty")
                if value == nil {
                    return 1
                }
                return value as Int
            }
            set(value) {
                NSUserDefaults.standardUserDefaults()
                    .setInteger(value, forKey: "difficulty")
            }
        }
    }
}
