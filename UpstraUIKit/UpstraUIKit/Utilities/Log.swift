//
//  Log.swift
//  UpstraUIKit
//
//  Created by Nishan Niraula on 9/17/20.
//  Copyright © 2020 Upstra. All rights reserved.
//

import Foundation

class Log {
    
    // Prints on console for Debug purpose. This log will not be printed on release build.
    // › [Upstra]: [ViewController.methodName()] : My Log
    static func add(_ info: Any, fileName:String = #file, methodName:String = #function) {
        #if DEBUG
        print("› [UpstraUIKit]: [\(fileName.components(separatedBy: "/").last!.components(separatedBy: ".").first!).\(methodName)] : \(info)")
        #endif
    }
    
    // Prints message on console. Use this if you want client to see the message on console.
    static func warn(_ info: Any) {
        print("› [UpstraUIKit]: \(info)")
    }
}

