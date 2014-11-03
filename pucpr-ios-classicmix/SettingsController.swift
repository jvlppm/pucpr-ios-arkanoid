//
//  SettingsController.swift
//  pucpr-ios-classicmix
//
//  Created by Joao Vitor on 11/3/14.
//  Copyright (c) 2014 Joao Vitor. All rights reserved.
//

import Foundation
import SpriteKit

class SettingsController : UIViewController {
    override func viewDidAppear(animated: Bool) {
        Game.enableNavigation()
    }
}