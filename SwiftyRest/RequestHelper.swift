//
//  RequestHelper.swift
//  SwiftyRest
//
//  Created by Song, Michyo on 12/5/16.
//  Copyright © 2016 EMC. All rights reserved.
//

import SwiftyJSON

open class RequestHelper {
    /**
     Build a single operation dictionary of batch request.
     - parameter    id:String                   The operation id for this operation.
     - parameter    description:String          Description for this operation.
     - parameter    method:String               Http method for request this operation.
     - parameter    uri:String                  The uri for this operation request for.
     - parameter    headers:NSArray             Headers sending along with this operation.
     - parameter    entity:String               Entity body sending along with this operation.
     - returns:     NSDictionary                Dictionary of this single operation inside a batch request's operations.
     */
    open static func buildSingleBatchOperation(
        _ id: String,
        description: String,
        method: String,
        uri: String,
        headers: NSArray,
        entity: String) -> NSDictionary {
        let requestDic: NSDictionary = ["method": method, "uri": uri, "headers": headers, "entity": entity]
        let batchOpDic: NSDictionary = ["id": id, "description": description, "request": requestDic]
        return batchOpDic
    }
    
    /**
     Build request dictionary for batch.
     - parameter    transactional: Bool         Whether this batch request should be transactional. Default is true.
     - parameter    sequential:Bool             Whether this batch request should be sequential. Default is false.
     - parameter    onError:String              Whether this batch request should stop on error. Default is CONTINUE.
     - parameter    returnRequest               Whether this batch request return request. Default is true.
     - parameter    operations:NSArray          Operations would be executed in this batch request. 
                                                May invoke buildSingleBatchOperation several times to build up operation array.
     - returns:     NSDictionary                Request dictionary of batch request.
     */
    open static func buildBatchRequest(
        _ transactional: Bool = true,
        sequential: Bool = false,
        onError: String = "CONTINUE",
        returnRequest: Bool = true,
        operations: NSArray) -> NSDictionary {
        let batchDic: NSDictionary = [
            "transactional" : transactional,
            "sequential"    : sequential,
            "on-error"      : onError,
            "return-request": returnRequest,
            "operations"    : operations
        ]
        return batchDic
    }
    
    /**
     Build request body for update kind of operations.
     - parameter    rootName:String                 Root name of request body. Default is object.
     - parameter    type:String                     Type value of request body. Default is object.
     - parameter    properties:[String:AnyObject]   Properties dictionary to update.
     - returns:     [String: AnyObject]             The request body as requested.
     */
    open static func buildUpdateRequestBody(
        _ rootName: String = "object",
        type: String = "object",
        properties: [String: AnyObject]) -> [String: AnyObject] {
        let dic = ["name": rootName, "type": type, "properties": properties] as [String : Any]
        return dic as [String : AnyObject]
    }
    
    /**
     Build Json with content for upload.
     - parameter    properties:[String:AnyObject]   Properties dictionary to write in content.
     - returns:     JSON                            Content with properties in JSON format.
     */
    open static func buildUploadJSONContent(_ properties: [String: AnyObject]) -> JSON {
        let dic = ["properties": properties]
        return JSON(dic)
    }
}
