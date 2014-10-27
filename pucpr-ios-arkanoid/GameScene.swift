//
//  GameScene.swift
//  pucpr-ios-arkanoid
//
//  Created by pucpr on 25/10/14.
//  Copyright (c) 2014 pucpr. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    let startMessage: SKLabelNode
    let bar: SKSpriteNode
    
    var balls: Array<SKSpriteNode>
    var moveTouch: UITouch?
    
    var waitingToBegin: Bool
    
    
    required init?(coder aDecoder: NSCoder) {
        self.bar = SKSpriteNode(color: UIColor.greenColor(), size: CGSize(width: 64, height: 8))
        self.bar.anchorPoint = CGPoint(x: 0.5, y: 0)
        self.startMessage = SKLabelNode(text: "Mova a barra para iniciar")
        self.balls = []
        waitingToBegin = true
        super.init(coder: aDecoder)
    }
    
    override func didMoveToView(view: SKView) {
        bar.position = CGPoint(x: self.frame.width / 2, y: bar.size.height)
        self.addChild(bar)
        startMessage.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        restartBall()
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touchObj: AnyObject in touches {
            let touch = touchObj as UITouch
            let location = touch.locationInNode(self)

            if grab(location, location: self.bar.position) {
                self.moveTouch = touch
                if waitingToBegin {
                    self.beginMove()
                }
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
    
    func restartBall() {
        self.removeChildrenInArray(self.balls)
        
        let ball = SKSpriteNode(color: UIColor.blueColor(), size: CGSize(width: 8, height: 8))
        ball.position = CGPoint(x: self.frame.width / 2, y: self.frame.height * 0.3)
        self.addChild(ball)
        self.balls.append(ball)
        waitingToBegin = true
        self.addChild(startMessage)
    }
    
    func beginMove() {
        self.removeChildrenInArray([self.startMessage])
        waitingToBegin = false
        
        let range = Float(60)
        let initialAngle = Float(270)//randomCGFloat() * range + 270 - range / 2
        var direction = directionFromAngle(degrees: initialAngle)
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func randomCGFloat() -> Float {
        return Float(arc4random()) /  Float(UInt32.max)
    }
}
