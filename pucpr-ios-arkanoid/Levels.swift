//
//  Levels.swift
//  pucpr-ios-arkanoid
//
//  Created by Joao Vitor on 10/29/14.
//  Copyright (c) 2014 pucpr. All rights reserved.
//

import Foundation
import SpriteKit

func getImageName(id: String) -> String {
    var color: String = ""
    switch id {
        case "b", "B":
            color = "blue"
            break
        case "g", "G":
            color = "green"
            break
        case "c", "C":
            color = "grey"
            break
        case "p", "P":
            color = "purple"
            break
        case "r", "R":
            color = "red"
            break
        case "y", "Y":
            color = "yellow"
            break
        default:
            break
    }
    if color.isEmpty {
        return color
    }
    var type = ""
    if id.lowercaseString != id {
        type = "_glossy"
    }
    return "element_" + color + "_rectangle" + type
}

class Level {
    let data: Array<Array<String>>
    
    init(data: Array<Array<String>>) {
        self.data = data
    }
    
    func load(view: SKNode) -> Array<SKNode> {
        var bricks: Array<SKNode> = []
        let frame = view.frame
        
        let brickWidth = frame.width / 10
        let brickHeight = frame.height / 10
        
        let minY = CGFloat(frame.height) - brickHeight / 2
        let minX = -brickWidth / 2
        let maxX = frame.width - brickWidth / 2
        
        let columns = self.data[0].count
        let columnsWidth = CGFloat(columns) * brickWidth
        let initialX = (CGFloat(frame.width) - CGFloat(columnsWidth - brickWidth)) / 2
        
        for row in 0...self.data.count - 1 {
            for col in 0...self.data[row].count - 1 {
                let x: CGFloat = initialX + CGFloat(col) * brickWidth
                let y: CGFloat = minY - brickHeight * CGFloat(row)
                let brick: String = self.data[row][col]
                let node = createBrick(view, x: x, y: y, color: brick)
                if node != nil {
                    node!.size = CGSize(width: brickWidth, height: brickHeight)
                    bricks.append(node!)
                }
            }
        }
        
        return bricks
    }
    
    func createBrick(view: SKNode, x: CGFloat, y: CGFloat, color: String) -> SKSpriteNode? {
        if color.isEmpty {
            return nil
        }
        
        var imageName = getImageName(color)
        if imageName.isEmpty {
            return nil
        }
        
        let brick = SKSpriteNode(imageNamed: imageName)
        brick.position = CGPoint(x: x, y: y)
        
        let body = SKPhysicsBody(rectangleOfSize: brick.size)
        body.dynamic = false
        body.categoryBitMask = Category.Brick
        brick.physicsBody = body
        
        brick.userData = NSMutableDictionary()
        brick.userData!["color"] = color
        
        let shadow = SKSpriteNode(imageNamed: "element_rectangle_shadow")
        shadow.zPosition = -1
        shadow.position = CGPoint(x: 2, y: -4)
        brick.addChild(shadow)
        
        view.addChild(brick)
        return brick
    }
}

class Levels {
    let levelList: Array<Level> = []
    
    init() {
        levelList.append(Level(data: [
            ["B", "b", "B", "b", "B"],
            ["g", "G", "g", "G", "g"],
        ]))
        
        levelList.append(Level(data: [
            ["B", "B", " ", "B", "B"],
            ["p", " ", "p", " ", "p"],
            ["G", "G", " ", "G", "G"],
        ]))
        
        levelList.append(Level(data: [
            [" ", " ", "G", "G", "G", " ", " "],
            [" ", " ", " ", "b" ," ", " ", " "],
            [" ", " ", "b", " ", "b", " ", " "],
            ["b", "b", " ", " ", " ", "b", "b"],
        ]))
        
        levelList.append(Level(data: [
            [" ", " ", " ", "b", " ", " ", " "],
            [" ", " ", "b", "C", "b", " ", " "],
            [" ", "b", "C", "C", "C", "b", " "],
            ["b", "C", "C", "C", "C", "C", "b"],
        ]))
        
        levelList.append(Level(data: [
            ["p", " ", " ", " ", " ", "b", " ", " ", "B"],
            ["p", " ", " ", " ", " ", " ", " ", "p", "p"],
            ["p", " ", "P", "P", "P", "P", "P", "P", "P"],
            ["p", " ", " ", " ", " ", " ", " ", " ", " "],
            ["p", " ", " ", " ", " ", " ", " ", " ", " "],
            ["P", "P", "P", "P", "P", "P", "P", " "],
        ]))
    }
    
    func loadLevel(view: SKNode, number: Int) -> Array<SKNode> {
        return self.levelList[number].load(view)
    }
}