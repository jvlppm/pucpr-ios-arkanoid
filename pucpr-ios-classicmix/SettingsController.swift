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
    @IBOutlet weak var difficultySegmented: UISegmentedControl!
    @IBOutlet weak var backgroundAnimationsSwitch: UISwitch!
    @IBOutlet weak var backgroundOpacitySlider: UISlider!
    @IBOutlet weak var musicVolumeSlider: UISlider!
    @IBOutlet weak var effectsVolumeSlider: UISlider!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        backgroundAnimationsSwitch.on = Game.Settings.backgroundAnimations
        backgroundOpacitySlider.value = Game.Settings.backgroundOpacity
        difficultySegmented.selectedSegmentIndex = Game.Settings.difficulty
        musicVolumeSlider.value = Game.Settings.musicVolume
        effectsVolumeSlider.value = Game.Settings.effectsVolume
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        Game.hideNavigation()
    }
    
    override func viewWillAppear(animated: Bool) {
        Game.enableNavigation()
    }
    
    @IBAction func difficultyChanged(sender: AnyObject) {
        Game.Settings.difficulty = difficultySegmented.selectedSegmentIndex
    }
    
    @IBAction func backgroundAnimationsChanged(sender: AnyObject) {
        Game.Settings.backgroundAnimations = backgroundAnimationsSwitch.on
    }
    
    @IBAction func backgroundOpacityChanged(sender: AnyObject) {
        Game.Settings.backgroundOpacity = backgroundOpacitySlider.value
    }
    @IBAction func musicVolumeSliderChanged(sender: AnyObject) {
        Game.Settings.musicVolume = musicVolumeSlider.value
    }
    @IBAction func effectsVolumeChanged(sender: AnyObject) {
        Game.Settings.effectsVolume = effectsVolumeSlider.value
    }
}