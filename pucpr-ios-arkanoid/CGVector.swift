//
//  CGVector.swift
//  pucpr-ios-arkanoid
//
//  Created by pucpr on 25/10/14.
//  Copyright (c) 2014 pucpr. All rights reserved.
//

import Foundation
import SpriteKit

func degreesToRadians (value: CGFloat) -> CGFloat {
    return value * CGFloat(M_PI) / 180.0
}

func radiansToDegrees (value: CGFloat) -> CGFloat {
    return value * 180.0 / CGFloat(M_PI)
}

func -(left: CGVector, right: CGVector) -> CGVector {
    return CGVector(dx: left.dx - right.dx, dy: left.dy - right.dy)
}

func +(left: CGVector, right: CGVector) -> CGVector {
    return CGVector(dx: left.dx + right.dx, dy: left.dy + right.dy)
}

func -(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func +(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func *(left: CGVector, right: CGFloat) -> CGVector {
    return CGVector(dx: left.dx * right, dy: left.dy * right)
}

func directionFromAngle(#radians: CGFloat) -> CGVector {
    return CGVector(
        dx: cos(radians),
        dy: sin(radians))
}

func directionFromAngle(#degrees: CGFloat) -> CGVector {
    return directionFromAngle(radians: degreesToRadians(degrees))
}

public extension CGVector {
    func length() -> Float {
        return sqrt(Float(self.dx*self.dx) + Float(self.dy*self.dy))
    }

    func normalize() -> CGVector {
        let len = self.length()
        return CGVector(dx: self.dx / CGFloat(len), dy: self.dy / CGFloat(len))
    }
    
    func angleInDegrees() -> CGFloat {
        let angle = atan2(self.dy, self.dx)
        return radiansToDegrees(angle)
    }
    
    func rotate(degrees: CGFloat) -> CGVector {
        let len = length()
        let currentAngleDegrees = self.angleInDegrees()
        let direction = directionFromAngle(degrees: currentAngleDegrees + degrees)
        return direction * CGFloat(len)
    }
    
    init(distance: CGPoint) {
        self.init(dx: distance.x, dy: distance.y)
    }
}
