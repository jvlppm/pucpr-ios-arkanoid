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
        case "g", "G":
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
    
    func load(view: SKNode) {
        let frame = view.frame
        
        let minY = CGFloat(frame.height - 16)
        let minX = 32
        let maxX = frame.width - 32
        
        let columns = self.data[0].count
        let columnsWidth = columns * 64
        let initialX = (CGFloat(frame.width) - CGFloat(columnsWidth - 64)) / 2
        
        for row in 0...self.data.count - 1 {
            for col in 0...self.data[row].count - 1 {
                let x: CGFloat = initialX + CGFloat(col) * 64
                let y: CGFloat = minY - 32 * CGFloat(row)
                let brick: String = self.data[row][col]
                createBrick(view, x: x, y: y, color: brick)
            }
        }
    }
    
    func createBrick(view: SKNode, x: CGFloat, y: CGFloat, color: String) {
        if color.isEmpty {
            return
        }
        
        var imageName = getImageName(color)
        
        let brick = SKSpriteNode(imageNamed: imageName)
        brick.position = CGPoint(x: x, y: y)
        
        let body = SKPhysicsBody(rectangleOfSize: brick.size)
        body.dynamic = false
        body.categoryBitMask = Category.Brick
        brick.physicsBody = body
        
        brick.userData = NSMutableDictionary()
        brick.userData!["color"] = color
        
        view.addChild(brick)
    }
}

class Levels {
    let levelList: Array<Level> = []
    
    init() {
        levelList.append(Level(data: [
            ["b", "b", "b", "b"],
            ["p", "p", "p", "p"],
            ["g", "g", "g", "g"],
        ]))
    }
    
    func loadLevel(view: SKNode, number: Int) {
        self.levelList[number].load(view)
    }
}