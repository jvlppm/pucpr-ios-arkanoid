//
//  CGVector.swift
//  pucpr-ios-arkanoid
//
//  Created by pucpr on 25/10/14.
//  Copyright (c) 2014 pucpr. All rights reserved.
//

import Foundation
import SpriteKit

func degreesToRadians (value: Float) -> Float {
    return value * Float(M_PI) / 180.0
}

func radiansToDegrees (value: Float) -> Float {
    return value * 180.0 / Float(M_PI)
}

func -(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func +(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func directionFromAngle(#radians: Float) -> CGPoint {
    return CGPoint(
        x: CGFloat(cos(radians)),
        y: CGFloat(sin(radians)))
}

func directionFromAngle(#degrees: Float) -> CGPoint {
    return directionFromAngle(radians: degreesToRadians(degrees))
}

public extension CGPoint {
    func length() -> Float {
        return sqrt(Float(self.x*self.x) + Float(self.y*self.y))
    }

    func normalize() -> CGPoint {
        let len = self.length()
        return CGPoint(x: self.x / CGFloat(len), y: self.y / CGFloat(len))
    }
}
