//
//  Log.swift
//  AmityUIKit
//
//  Created by Nishan Niraula on 9/17/20.
//  Copyright © 2020 Amity. All rights reserved.
//

import Foundation

class Log {
    
    // Prints on console for Debug purpose. This log will not be printed on release build.
    // › [Amity]: [ViewController.methodName()] : My Log
    static func add(_ info: Any, fileName:String = #file, methodName:String = #function) {
        #if DEBUG
        print("› [AmityUIKit]: [\(fileName.components(separatedBy: "/").last!.components(separatedBy: ".").first!).\(methodName)] : \(info)")
        #endif
    }
    
    // Prints message on console. Use this if you want client to see the message on console.
    static func warn(_ info: Any) {
        print("› [AmityUIKit]: \(info)")
    }
}

