//
//  GameScene.swift
//  pucpr-ios-arkanoid
//
//  Created by pucpr on 25/10/14.
//  Copyright (c) 2014 pucpr. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {

    let levels = Levels()
    
    let colors = ["element_blue_rectangle", "element_grey_rectangle"]
    
    let startMessage: SKLabelNode
    let bar: SKSpriteNode
    
    var balls: Array<SKSpriteNode>
    var moveTouch: UITouch?
    
    var waitingToBegin: Bool
    
    required init?(coder aDecoder: NSCoder) {
        self.bar = SKSpriteNode(imageNamed: "paddleBlue")
        self.startMessage = SKLabelNode(text: "Posicione a barra para iniciar")
        self.balls = []
        self.waitingToBegin = true
        
        super.init(coder: aDecoder)
        
        self.addChild(bar)
    }
    
    func setupWorld() {
        self.physicsWorld.gravity = CGVector.zeroVector
        self.physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: frame)
        self.physicsBody!.categoryBitMask = Category.World
        createBricks()
    }
    
    func setupBar() {
        let body = SKPhysicsBody(rectangleOfSize: self.bar.size)
        body.friction = 0
        body.restitution = 1
        body.dynamic = false
        body.categoryBitMask = Category.Bar
        body.collisionBitMask = Category.None
        body.contactTestBitMask = Category.Ball
        self.bar.physicsBody = body
    }
    
    func createBall() -> SKSpriteNode {
        let ball = SKSpriteNode(imageNamed: "ballBlue")
        let body = SKPhysicsBody(circleOfRadius: ball.size.height / 2)
        body.dynamic = true
        body.allowsRotation = false
        body.restitution = 1.0
        body.friction = 0.0
        body.linearDamping = 0.0
        body.categoryBitMask = Category.Ball
        body.collisionBitMask = Category.None
        body.contactTestBitMask = Category.World | Category.Bar | Category.Brick
        ball.physicsBody = body
        return ball
    }
    
    func createBricks() {
        self.levels.loadLevel(self, number: 0)
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
    
    func beginMove() {
        self.removeChildrenInArray([self.startMessage])
        waitingToBegin = false
        
        let ball = self.balls[0]
        
        let range = Float(60)
        let initialAngle = randomFloat() * range + 270 - range / 2
        var direction = CGVector(distance: self.bar.position - ball.position)
        direction = direction + CGVector(dx: 0, dy: ball.size.height)
        direction = direction.normalize()
        
        ball.physicsBody?.applyImpulse(direction * 6)
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func randomFloat() -> Float {
        return Float(arc4random()) /  Float(UInt32.max)
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        if contact.bodyB.categoryBitMask & Category.World != 0 {
            reflectWalls(contact.bodyA)
            return
        }
        
        if contact.bodyA.categoryBitMask & Category.World != 0 {
            reflectWalls(contact.bodyB)
            return
        }
        
        if contact.bodyA.categoryBitMask & Category.Ball != 0 {
            reflectBall(contact.bodyA!, object: contact.bodyB!)
        }
        
        if contact.bodyB.categoryBitMask & Category.Ball != 0 {
            reflectBall(contact.bodyB!, object: contact.bodyA!)
        }
    }
    
    func reflectBall(ball: SKPhysicsBody, object: SKPhysicsBody) {
        let ballRect = ball.node!.frame
        let objRect = object.node!.frame
        let objNode = object.node! as SKSpriteNode
        
        if ballRect.maxX <= objRect.minX + ballRect.width / 2 {
            ball.velocity.dx = -abs(ball.velocity.dx)
        }
        else if ballRect.minX >= objRect.maxX - ballRect.width / 2 {
            ball.velocity.dx = abs(ball.velocity.dx)
        }
        else if ballRect.minY <= objRect.maxY - ballRect.height / 2 {
            ball.velocity.dy = -abs(ball.velocity.dy)
        }
        else if ballRect.maxY >= objRect.minY + ballRect.height / 2 {
            ball.velocity.dy = abs(ball.velocity.dy)
        }
        
        if objNode == self.bar && ballRect.minY >= objRect.midY {
            let speed = ball.velocity.length()
            var position = (ballRect.midX - objRect.minX) / objRect.width
            ball.velocity = directionFromAngle(degrees: 170 - position * 160) * CGFloat(speed)
        }
        else if object.categoryBitMask & Category.Brick != 0 {
            
            let color = objNode.userData!["color"] as String
            
            if color.lowercaseString == color {
                objNode.removeFromParent()
            }
            else {
                objNode.texture = SKTexture(imageNamed: getImageName(color.lowercaseString))
                objNode.userData!["color"] = color.lowercaseString
            }
        }
    }
    
    func reflectWalls(body: SKPhysicsBody) {
        let ball = body.node!
        let leaveSize = ball.frame.width
        if ball.position.x - leaveSize < 0 {
            body.velocity.dx = abs(body.velocity.dx)
        }
        else if ball.position.x + leaveSize > self.frame.width {
            body.velocity.dx = -abs(body.velocity.dx)
        }
        
        if ball.position.y - leaveSize < 0 {
            self.balls = self.balls.filter { $0 != ball }
            self.runAction(SKAction.runBlock({
                if self.balls.count == 0 {
                    self.restartBall()
                }
                ball.removeFromParent()
            }))
        }
        else if ball.position.y + leaveSize > self.frame.height {
            body.velocity.dy = -abs(body.velocity.dy)
        }
    }
}
