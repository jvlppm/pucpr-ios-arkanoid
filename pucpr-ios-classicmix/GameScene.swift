//
//  GameScene.swift
//  pucpr-ios-classicmix
//
//  Created by Joao Vitor on 11/3/14.
//  Copyright (c) 2014 Joao Vitor. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

class GameScene : SKScene, SKPhysicsContactDelegate {
    
    var navigation : UINavigationController {
        get {
            return self.view?.window?.rootViewController as UINavigationController
        }
    }
    
    let levels = Levels()
    var currentLevel = -1
    
    let backgroundContainer: SKNode
    let startMessage: SKSpriteNode
    let gameOverMessage: SKSpriteNode
    let bar: SKSpriteNode
    let scoreLabel: SKLabelNode
    let hiScoreLabel: SKLabelNode
    let blueBarTexture: SKTexture
    let redBarTexture: SKTexture
    let player: MusicPlayer
    let effects: SoundEffects
    
    var bricks: Array<SKNode>
    var balls: Array<SKSpriteNode>
    var lives: Array<SKSpriteNode>
    var moveTouch: UITouch?
    var waitingToBegin: Bool

    
    var score = 0
    
    required init?(coder aDecoder: NSCoder) {
        self.bar = SKSpriteNode(imageNamed: "paddleBlue")
        self.startMessage = SKSpriteNode(imageNamed: "TouchToBegin")
        self.gameOverMessage = SKSpriteNode(imageNamed: "GameOver")
        self.scoreLabel = SKLabelNode()
        self.hiScoreLabel = SKLabelNode()
        self.backgroundContainer = SKNode()
        self.balls = []
        self.bricks = []
        self.lives = []
        self.waitingToBegin = true
        self.blueBarTexture = SKTexture(imageNamed: "paddleBlue")
        self.redBarTexture = SKTexture(imageNamed: "paddleRed")
        self.player = MusicPlayer()
        self.effects = SoundEffects()
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.whiteColor()
    }
    
    override func didMoveToView(view: SKView) {
        self.setupMessages()
        self.setupBackground()
        self.setupBar()
        self.setupWorld()
        self.setupScore()
        self.resetLives()
    }
    
    func resetLives() {
        switch Game.Settings.difficulty {
            case 0: self.setLives(5); break;
            case 1: self.setLives(3); break;
            default: self.setLives(2); break;
        }
    }
    
    func setupWorld() {
        self.physicsWorld.gravity = CGVector.zeroVector
        self.physicsWorld.contactDelegate = self
        startLevel(0)
    }
    
    func setupBar() {
        bar.position = CGPoint(x: self.frame.width / 2, y: bar.size.height)
        let body = SKPhysicsBody(rectangleOfSize: self.bar.size)
        body.friction = 0
        body.restitution = 1
        body.dynamic = false
        body.categoryBitMask = Category.Bar
        body.collisionBitMask = Category.None
        body.contactTestBitMask = Category.Ball
        self.bar.physicsBody = body
        
        let shadow = SKSpriteNode(imageNamed: "bar_shadow")
        shadow.zPosition = -1
        shadow.position = CGPoint(x: 2, y: -4)
        bar.addChild(shadow)
        self.addChild(bar)
    }
    
    func setupBackground() {
        backgroundContainer.zPosition = -1
        backgroundContainer.alpha = CGFloat(Game.Settings.backgroundOpacity)
        if backgroundContainer.alpha > 0 {
            self.addChild(backgroundContainer)
        }
    }
    
    func setupScore() {
        self.scoreLabel.fontColor = UIColor.blackColor()
        self.hiScoreLabel.fontColor = UIColor.blackColor()
        self.scoreLabel.fontName = "GillSans-Bold"
        self.hiScoreLabel.fontName = self.scoreLabel.fontName
        self.scoreLabel.fontSize = 16
        self.hiScoreLabel.fontSize = 16
        self.scoreLabel.zPosition = 1
        self.hiScoreLabel.zPosition = 1
        self.addChild(scoreLabel)
        self.addChild(hiScoreLabel)
        let hiScore = NSUserDefaults.standardUserDefaults().integerForKey("highscore")
        setScore(0)
        setHighScore(hiScore)
    }
    
    func setScore(value: Int) {
        self.score = value
        scoreLabel.text = toString(value)
        if score >= NSUserDefaults.standardUserDefaults().integerForKey("highscore") {
            NSUserDefaults.standardUserDefaults().setInteger(score, forKey: "highscore")
            NSUserDefaults.standardUserDefaults().synchronize()
            setHighScore(value)
        }
        scoreLabel.position = CGPoint(
            x: hiScoreLabel.frame.width - scoreLabel.frame.width / 2,
            y: 0)
    }
    
    func setHighScore(value: Int) {
        hiScoreLabel.text = "HI: " + toString(value)
        hiScoreLabel.position = CGPoint(
            x: hiScoreLabel.frame.width / 2,
            y: scoreLabel.frame.height)
    }
    
    func setLives(count: Int) {
        while(self.lives.count > count) {
            let live = self.lives.last!
            self.removeChildrenInArray([live])
            self.lives.removeLast()
        }
        while(self.lives.count < count) {
            let live = SKSpriteNode(imageNamed: "paddleBlue")
            live.anchorPoint = CGPoint(x: 1, y: 0)
            live.size = CGSize(width: live.size.width / 3, height: live.size.height / 3)
            live.position = CGPoint(
                x: frame.width - 6,
                y: (live.size.height + 6) * CGFloat(self.lives.count) + 6)
            live.zPosition = 10
            self.lives.append(live)
            self.addChild(live)
        }
    }
    
    func changeBackground(name: String) {
        var initialAlpha: CGFloat = 1
        stopBackgroundAnimations(true)
        
        if self.backgroundContainer.children.count > 0 && Game.Settings.backgroundAnimations {
            initialAlpha = 0
        }
        
        let painting = SKSpriteNode(imageNamed: name)
        painting.alpha = initialAlpha
        let paintingSize = painting.size
        var scaleRatio: CGFloat? = nil
        var imageRatio = paintingSize.width / paintingSize.height
        if paintingSize.width / paintingSize.height < frame.width / frame.height {
            scaleRatio = frame.width / paintingSize.width
        }
        else {
            scaleRatio = frame.height / paintingSize.height
        }
        painting.size = CGSize(
            width: paintingSize.width * scaleRatio!,
            height: paintingSize.height * scaleRatio!)
        painting.position = CGPoint(x: frame.width / 2, y: frame.height / 2)
        
        if Game.Settings.backgroundAnimations {
            painting.runAction(SKAction.repeatActionForever(SKAction.sequence([
                SKAction.group([
                    SKAction.fadeAlphaTo(1, duration: 3),
                    SKAction.moveTo(CGPoint(x: frame.width / 2, y: frame.height / 2), duration: 30),
                    SKAction.scaleTo(2, duration: 30)
                    ]),
                SKAction.scaleTo(1, duration: 10),
                SKAction.moveBy(CGVector(dx: -(frame.width - painting.size.width) / 2, dy: 0), duration: 30),
                SKAction.moveBy(CGVector(dx: (frame.width - painting.size.width), dy: 0), duration: 30),
            ])), withKey: "animations")
        }
        
        self.backgroundContainer.addChild(painting)
    }
    
    func stopBackgroundAnimations(removeBackground: Bool) {
        for child in self.backgroundContainer.children {
            let image = child as? SKSpriteNode
            if image != nil {
                image!.removeActionForKey("animations")
                if removeBackground {
                    let remove = SKAction.runBlock({ image!.removeFromParent() })
                    if Game.Settings.backgroundAnimations {
                        image!.runAction(
                            SKAction.sequence([
                                SKAction.fadeAlphaTo(0, duration: 3),
                                remove
                            ]))
                    }
                    else {
                        image!.runAction(remove)
                    }
                }
            }
        }
    }
    
    func createBall() -> SKSpriteNode {
        let ball = SKSpriteNode(imageNamed: "ballBlue")
        ball.zPosition = 9
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
        
        let shadow = SKSpriteNode(imageNamed: "ball_shadow")
        shadow.zPosition = -1
        shadow.position = CGPoint(x: 2, y: -4)
        ball.addChild(shadow)
        return ball
    }
    
    func startLevel(level: Int) {
        self.restartBall()
        if self.currentLevel != level {
            self.currentLevel = level
            var resourceNumber = String(level % 7 + 1)
            self.changeBackground("painting" + resourceNumber)
            self.player.play("music" + resourceNumber)
        }
        self.createBricks()
    }
    
    func createBricks() {
        if self.currentLevel >= self.levels.levelList.count {
            self.currentLevel = 0
        }
        self.removeChildrenInArray(self.bricks)
        self.bricks = self.levels.loadLevel(self, number: self.currentLevel)
    }
    
    func setupMessages() {
        startMessage.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        gameOverMessage.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        startMessage.zPosition = 10
        gameOverMessage.zPosition = 10
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touchObj: AnyObject in touches {
            let touch = touchObj as UITouch
            let location = touch.locationInNode(self)
            
            if gameOverMessage.parent == nil && grab(location, location: self.bar.position) {
                self.moveTouch = touch
                
                self.bar.texture = self.redBarTexture
                
                self.bar.runAction(SKAction.repeatActionForever(SKAction.sequence([
                    SKAction.runBlock({ self.setScore(max(self.score - 1, 0)) }),
                    SKAction.waitForDuration(0.15)
                    ])), withKey: "dropPoints")
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
                self.bar.texture = self.blueBarTexture
                self.bar.removeActionForKey("dropPoints")
                
                if waitingToBegin {
                    self.beginMove()
                }
            }
            let location = touch.locationInNode(self)
            
            if gameOverMessage.parent != nil && gameOverMessage.containsPoint(location) {
                
                gameOverMessage.removeFromParent()
                setScore(0)
                resetLives()
                startLevel(0)
            }
            else if waitingToBegin && startMessage.containsPoint(location) {
                Game.toggleNavigation()
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
        self.balls = [ball]
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
        
        var speed: CGFloat
        switch Game.Settings.difficulty {
            case 0: speed = 3; break;
            case 1: speed = 6; break;
            default: speed = 8; break;
        }
        
        ball.physicsBody?.applyImpulse(direction * speed)
        
        Game.hideNavigation()
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        for ball in self.balls {
            bounceWalls(ball.physicsBody!)
        }
        
        if self.bricks.count == 0 {
            self.startLevel(self.currentLevel + 1)
        }
        
        self.player.update(currentTime)
    }
    
    func randomFloat() -> Float {
        return Float(arc4random()) /  Float(UInt32.max)
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask & Category.Ball != 0 {
            bounceBrick(contact.bodyA!, object: contact.bodyB!)
        }
        
        if contact.bodyB.categoryBitMask & Category.Ball != 0 {
            bounceBrick(contact.bodyB!, object: contact.bodyA!)
        }
    }
    
    func bounceBrick(ball: SKPhysicsBody, object: SKPhysicsBody) {
        let ballRect = ball.node!.frame
        let objRect = object.node!.frame
        let objNode = object.node! as SKSpriteNode
        
        if ballRect.maxX <= objRect.minX + ballRect.width / 2 {
            ball.velocity.dx = -abs(ball.velocity.dx)
            effects.bounce()
        }
        else if ballRect.minX >= objRect.maxX - ballRect.width / 2 {
            ball.velocity.dx = abs(ball.velocity.dx)
            effects.bounce()
        }
        else if ballRect.minY <= objRect.maxY - ballRect.height / 2 {
            ball.velocity.dy = -abs(ball.velocity.dy)
            effects.bounce()
        }
        else if ballRect.maxY >= objRect.minY + ballRect.height / 2 {
            ball.velocity.dy = abs(ball.velocity.dy)
            effects.bounce()
        }
        
        if objNode == self.bar && ballRect.minY >= objRect.midY {
            let speed = ball.velocity.length()
            let position = (ballRect.midX - objRect.minX) / objRect.width
            let variation = CGFloat(randomFloat() * 0.1 - 0.05)
            ball.velocity = directionFromAngle(degrees: 170 - (position * 0.95 + variation) * 160) * CGFloat(speed)
            effects.bounce()
        }
        else if object.categoryBitMask & Category.Brick != 0 {
            self.hitBrick(objNode)
        }
    }
    
    func bounceWalls(body: SKPhysicsBody) {
        let ball = body.node!
        let leaveSize = ball.frame.width / 2
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
                    if self.lives.count > 0 {
                        self.setLives(self.lives.count - 1)
                        self.restartBall()
                    }
                    else {
                        self.gameOver()
                    }
                    self.effects.death()
                }
                ball.removeFromParent()
            }))
        }
        else if ball.position.y + leaveSize > self.frame.height {
            body.velocity.dy = -abs(body.velocity.dy)
        }
    }
    
    func hitBrick(brick: SKSpriteNode) {
        let color = brick.userData!["color"] as String
        
        if color.lowercaseString == color {
            setScore(score + 100)
            brick.removeFromParent()
            self.bricks = self.bricks.filter { $0 != brick }
            effects.destroyBrick()
        }
        else {
            setScore(score + 30)
            brick.texture = SKTexture(imageNamed: getImageName(color.lowercaseString))
            brick.userData!["color"] = color.lowercaseString
            effects.hitBrick()
        }
    }
    
    func gameOver() {
        Game.enableNavigation()
        self.addChild(self.gameOverMessage)
        self.stopBackgroundAnimations(false)
    }
}