//
//  LogUitility.swift
//  SwiftyRest
//
//  Created by Song, Michyo on 11/24/16.
//  Copyright © 2016 Song, Michyo. All rights reserved.
//

import SwiftLog

class LogUtility {
    internal class var log: LogUtility {
        struct Static {
            static let instance: LogUtility = LogUtility.init()
        }
        return Static.instance
    }
    
    private init() {
        Log.logger.name = "SwiftyRest.log"
        Log.logger.maxFileSize = 2048
        Log.logger.maxFileCount = 8
    }
    
    
    static func print(message: String) {
        logw(message)
    }
}

public func printLog(message: String) {
    LogUtility.print("[LOG]\t\(message)")
}

public func printError(message: String) {
    LogUtility.print("[ERR] \t\(message)")
}