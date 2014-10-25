//
//  CGVector.swift
//  pucpr-ios-arkanoid
//
//  Created by pucpr on 25/10/14.
//  Copyright (c) 2014 pucpr. All rights reserved.
//

import Foundation
import SpriteKit

func -(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func +(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
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
