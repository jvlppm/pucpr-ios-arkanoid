//
//  Category.swift
//  pucpr-ios-arkanoid
//
//  Created by Joao Vitor on 10/29/14.
//  Copyright (c) 2014 pucpr. All rights reserved.
//

import Foundation

 struct Category {
    static let None: UInt32 = 0
    static let World: UInt32 = 1 << 0
    static let Bar: UInt32 = 1 << 1
    static let Ball: UInt32 = 1 << 2
    static let Brick: UInt32 = 1 << 3
}