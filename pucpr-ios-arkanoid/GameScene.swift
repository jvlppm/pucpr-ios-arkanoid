//
//  GameScene.swift
//  pucpr-ios-arkanoid
//
//  Created by pucpr on 25/10/14.
//  Copyright (c) 2014 pucpr. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    let bar: SKSpriteNode
    var moveTouch: UITouch?
    
    required init(coder aDecoder: NSCoder) {
        self.bar = SKSpriteNode(color: UIColor.greenColor(), size: CGSize(width: 64, height: 8))
        self.bar.anchorPoint = CGPoint(x: 0.5, y: 0)
        super.init(coder: aDecoder)
    }
    
    override func didMoveToView(view: SKView) {
        bar.position = CGPoint(x: self.frame.width / 2, y: bar.size.height)
        self.addChild(bar)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touchObj: AnyObject in touches {
            let touch = touchObj as UITouch
            let location = touch.locationInNode(self)

            if grab(location, location: self.bar.position) {
                self.moveTouch = touch
                break
            }
        }
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        for touchObj: AnyObject in touches {
            let touch = touchObj as UITouch
            let location = touch.locationInNode(self)

            if touch == self.moveTouch {
                bar.position.x = location.x
                break
            }
        }
    }

    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        for touchObj: AnyObject in touches {
            let touch = touchObj as UITouch
            if touch == self.moveTouch {
                self.moveTouch = nil
            }
        }
    }

    func grab(touchLocation: CGPoint, location: CGPoint) -> Bool {

        var dist = touchLocation - location
        dist.normalize()

        return dist.length() <= 50
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
