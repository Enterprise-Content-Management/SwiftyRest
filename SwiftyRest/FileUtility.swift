//
//  FileUtility.swift
//  SwiftyRest
//
//  Created by Song, Michyo on 11/24/16.
//  Copyright © 2016 EMC. All rights reserved.
//

import Foundation

/**
 *  File management utility
 */
open class FileUtility {
    static let fileManager = FileManager.default
    
    /**
     Identify whether object content of given ID has been downloaded or not.
     - parameter    objectId:String The id of object to check.
     - returns:Bool     True if content of this object has been downloaded.
     */
    open static func isDownloaded(_ objectId: String) -> Bool {
        let path = getFilePathFromId(objectId)
        let flag = fileManager.fileExists(atPath: path)
        return flag
    }
    
    /**
     Delete content on device according to its object id.
     Print log for this operation.
     - parameter    objectId:String The id of object to delete.
     */
    open static func deleteFile(_ objectId: String) {
        let path = getFilePathFromId(objectId)
        if !isDownloaded(objectId) {
            return
        }
        do {
            try fileManager.removeItem(atPath: path)
            printLog("Removed file at path of \(path)")
        } catch {
            printError("Error to remove file which id is \(objectId) on this device")
        }
    }

    /**
     Get object content file local url by its id.
     - parameter    objectId:String The id of object to get.
     - returns:NSURL    The url path for this content on device.
     */
    open static func getFileUrlFromId(_ objectId: String) -> URL {
        let directoryUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let pathComponent = objectId
        let fileUrl = directoryUrl.appendingPathComponent(pathComponent)
        return fileUrl
    }
    
    fileprivate static func getFilePathFromId(_ objectId: String) -> String {
        let url = getFileUrlFromId(objectId)
        return url.path
    }
    
    /**
     Save object content on device.
     - parameter    objectId:String The id of object to save.
     - returns:NSURL    The url path saved this content on device.
     */
    open static func getSaveToUrl(_ objectId: String) -> URL {
        let directoryUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let pathComponent = objectId
        return directoryUrl.appendingPathComponent(pathComponent)
    }
}
