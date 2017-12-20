//
//  LogUitility.swift
//  SwiftyRest
//
//  Created by Song, Michyo on 11/24/16.
//  Copyright © 2016 EMC. All rights reserved.
//

import SwiftLog

class LogUtility {
    internal class var log: LogUtility {
        struct Static {
            static let instance: LogUtility = LogUtility.init()
        }
        return Static.instance
    }
    
    fileprivate init() {
        Log.logger.name = "SwiftyRest.log"
        Log.logger.maxFileSize = 2048
        Log.logger.maxFileCount = 8
    }
    
    
    static func print(_ message: String) {
        logw(message)
    }
}

/**
 *  Print log on console and log file.
 *  - parameter message:String  the message should be printed as LOG.
 */
public func printLog(_ message: String) {
    LogUtility.print("[LOG]\t\(message)")
}

/**
 *  Print log on console and log file.
 *  - parameter message:String  the message should be printed as ERR.
 */
public func printError(_ message: String) {
    LogUtility.print("[ERR] \t\(message)")
}
