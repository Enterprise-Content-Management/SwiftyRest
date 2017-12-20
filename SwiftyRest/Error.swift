//
//  Error.swift
//  SwiftyRest
//
//  Created by Song, Michyo on 11/24/16.
//  Copyright © 2016 EMC. All rights reserved.
//
import SwiftyJSON

/**
 *  The Error model in REST service.
 */
open class Error {
    /// Status code
    var status: NSInteger!
    /// Error code
    var errorCode: String!
    var message: String!
    var details: String!
    var id: String!
    
    /**
     Initialize an Error model from self defined message w/o detail.
     -  parameter   msg:String      The message want to show.
     -  parameter   detail: String  The detail information about this error. Default is "nothing".
     -  returns:    Error model
     */
    public init(msg: String, detail: String = "nothing") {
        status = 0
        errorCode = "E_ERROR"
        if msg == "" {
            message = "Lost connection. Please check if REST server is running."
        } else {
            message = msg
        }
        details = detail
        id = "ID"
    }
    
    /**
     Initialize an Error model from response of REST service in JSON format.
     -  parameter   json:JSON    The JSON format response given by REST.
     -  returns:    Error model
    */
    public init(json: JSON) {
        status = json["status"].intValue
        errorCode = json["code"].stringValue
        message = json["message"].stringValue
        if message == "" {
            message = "Lost connection. Please check if REST server is running."
        }
        details = json["details"].stringValue
        id = json["id"].stringValue
    }
    
    open func getStatus() -> Int {
        return status
    }
    
    open func getErrorCode() -> String {
        return errorCode
    }
    
    open func getMessage() -> String {
        return message
    }
    
    open func getDetails() -> String {
        return details
    }
    
    open func getId() -> String {
        return id
    }
}
