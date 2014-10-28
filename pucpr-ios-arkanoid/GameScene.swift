//
//  GameScene.swift
//  pucpr-ios-arkanoid
//
//  Created by pucpr on 25/10/14.
//  Copyright (c) 2014 pucpr. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    let noCategory: UInt32 = 0
    let worldCategory: UInt32 = 1 << 0
    let barCategory: UInt32 = 1 << 1
    let ballCategory: UInt32 = 1 << 2
    let brickCategory: UInt32 = 1 << 3
    
    let startMessage: SKLabelNode
    let bar: SKSpriteNode
    
    var balls: Array<SKSpriteNode>
    var moveTouch: UITouch?
    
    var waitingToBegin: Bool
    
    required init?(coder aDecoder: NSCoder) {
        self.bar = SKSpriteNode(color: UIColor.greenColor(), size: CGSize(width: 64, height: 16))
        self.startMessage = SKLabelNode(text: "Posicione a barra para iniciar")
        self.balls = []
        self.waitingToBegin = true
        
        super.init(coder: aDecoder)
        
        self.addChild(bar)
    }
    
    func setupWorld() {
        self.physicsWorld.gravity = CGVector.zeroVector
        self.physicsWorld.contactDelegate = self
        createBricks()
    }
    
    func createBricks() {
        
    }
    
    func setupBar() {
        let body = SKPhysicsBody(rectangleOfSize: self.bar.size)
        body.friction = 0
        body.restitution = 1
        body.dynamic = false
        body.categoryBitMask = barCategory
        body.collisionBitMask = noCategory
        body.contactTestBitMask = ballCategory
        self.bar.physicsBody = body
    }
    
    func createBrick(x: Float, y: Float) {
        let brick = SKSpriteNode(color: UIColor.yellowColor(), size: CGSize(width: 16, height: 8))
        brick.position = CGPoint(x: CGFloat(x), y: CGFloat(y))
        let body = SKPhysicsBody(rectangleOfSize: brick.size)
        body.dynamic = false
        body.contactTestBitMask = brickCategory
        brick.physicsBody = body
        self.addChild(brick)
    }
    
    override func didMoveToView(view: SKView) {
        bar.position = CGPoint(x: self.frame.width / 2, y: bar.size.height)
        startMessage.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        
        self.setupBar()
        self.setupWorld()
        restartBall()
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
                //bar.position.y = location.y
                break
            }
        }
    }

    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        for touchObj: AnyObject in touches {
            let touch = touchObj as UITouch
            if touch == self.moveTouch {
                self.moveTouch = nil
                
                if waitingToBegin {
                    self.beginMove()
                }
            }
        }
    }

    func grab(touchLocation: CGPoint, location: CGPoint) -> Bool {

        var dist = CGVector(distance: touchLocation - location)
        dist.normalize()

        return dist.length() <= 50
    }
    
    func restartBall() {
        self.removeChildrenInArray(self.balls)
        
        let ball = createBall()
        ball.position = CGPoint(x: self.frame.width / 2, y: self.frame.height * 0.3)
        self.addChild(ball)
        self.balls.append(ball)
        waitingToBegin = true
        self.addChild(startMessage)
    }
    
    func createBall() -> SKSpriteNode {
        let ball = SKSpriteNode(imageNamed: "ballBlue")
        let body = SKPhysicsBody(circleOfRadius: ball.size.height / 2)
        body.dynamic = true
        body.allowsRotation = false
        body.restitution = 1.0
        body.friction = 0.0
        body.linearDamping = 0.0
        body.categoryBitMask = ballCategory
        body.collisionBitMask = noCategory
        body.contactTestBitMask = worldCategory | barCategory | brickCategory
        ball.physicsBody = body
        return ball
    }
    
    func beginMove() {
        self.removeChildrenInArray([self.startMessage])
        waitingToBegin = false
        
        let range = Float(60)
        let initialAngle = randomCGFloat() * range + 270 - range / 2
        var direction = directionFromAngle(degrees: initialAngle)
        
        self.balls[0].physicsBody?.applyImpulse(direction * 1.2)
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        for ball in self.balls {
            let body = ball.physicsBody!
            if ball.position.x < 0 {
                body.velocity.dx = abs(body.velocity.dx)
            }
            else if ball.position.x > self.frame.width {
                body.velocity.dx = -abs(body.velocity.dx)
            }
            
            if ball.position.y < 0 {
                self.balls = self.balls.filter { $0 != ball }
                ball.removeFromParent()
                if self.balls.count == 0 {
                    self.restartBall()
                }
            }
            else if ball.position.y > self.frame.height {
                body.velocity.dy = -abs(body.velocity.dy)
            }
        }
    }
    
    func randomCGFloat() -> Float {
        return Float(arc4random()) /  Float(UInt32.max)
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        if contact.bodyA.categoryBitMask & ballCategory != 0 {
            reflectBall(contact.bodyA!, object: contact.bodyB!)
        }
        
        if contact.bodyB.categoryBitMask & ballCategory != 0 {
            reflectBall(contact.bodyB!, object: contact.bodyA!)
        }
    }
    
    func reflectBall(ball: SKPhysicsBody, object: SKPhysicsBody) {
        let ballRect = ball.node!.frame
        let objRect = object.node!.frame
        
        if ballRect.maxX <= objRect.minX + ballRect.width {
            ball.velocity.dx = -abs(ball.velocity.dx)
        }
        else if ballRect.minX >= objRect.maxX - ballRect.width {
            ball.velocity.dx = abs(ball.velocity.dx)
        }
        if ballRect.minY <= objRect.maxY - ballRect.height {
            ball.velocity.dy = -abs(ball.velocity.dy)
        }
        else if ballRect.maxY >= objRect.minY + ballRect.height {
            ball.velocity.dy = abs(ball.velocity.dy)
        }
        
        if object.node == self.bar {
            let speed = ball.velocity.length()
            ball.velocity = directionFromAngle(degrees: 90 + randomCGFloat() * 160 - 80) * CGFloat(speed)
        }
    }
}
