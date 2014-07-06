//
//  functions.swift
//  EPICSWIFTGAME
//
//  Created by zephyz on 05/07/14.
//  Copyright (c) 2014 zephyz. All rights reserved.
//

import Foundation
import SpriteKit

func loadText(fileName: String) -> String[]? {
    let path = NSBundle.mainBundle().pathForResource(fileName, ofType: "txt")
    var maybe = String.stringWithContentsOfFile(path, encoding: NSUTF8StringEncoding, error: nil)
    var arr:String[]?
    if let content = maybe {
        arr = content.componentsSeparatedByString("\n")
    }
    return arr
}

func swapTwoValues<T>(inout a: T, inout b: T) {
    let temporaryA = a
    a = b
    b = temporaryA
}

@infix func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPointMake(left.x - right.x,
        left.y - right.y)
}

@infix func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPointMake(left.x + right.x,
        left.y + right.y)
}

@infix func * (left: CGSize, right: CGFloat) -> CGSize {
    var size = CGSize.zeroSize
    size.width = left.width * right
    size.height = left.height * right
    return size
}

@prefix func - (point: CGPoint) -> CGPoint {
    return CGPointMake(-point.x, -point.y)
}

func sizeToPoint(size: CGSize) -> CGPoint {
    return CGPointMake(size.width, size.height)
}