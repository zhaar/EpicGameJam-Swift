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
    var possibleContent = String.stringWithContentsOfFile(path, encoding: NSUTF8StringEncoding, error: nil)
    var array : String[]?
    if let content = possibleContent {
        array = content.componentsSeparatedByString("\n")
    }
    return array
}