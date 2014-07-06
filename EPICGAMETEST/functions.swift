//
//  functions.swift
//  EPICSWIFTGAME
//
//  Created by zephyz on 05/07/14.
//  Copyright (c) 2014 zephyz. All rights reserved.
//

import Foundation


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