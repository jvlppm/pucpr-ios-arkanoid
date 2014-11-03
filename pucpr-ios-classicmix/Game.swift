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
}
