//
//  ServiceHelper.swift
//  SwiftyRest
//
//  Created by Song, Michyo on 11/24/16.
//  Copyright © 2016 Song, Michyo. All rights reserved.
//

import Alamofire

class ServiceHelper {
    // MARK: - Util
    
    internal func setPreAuth(plainString: NSString = UriBuilder.getCurrentLoginAuthString()) -> [String : String] {
        let plainData = plainString.dataUsingEncoding(NSUTF8StringEncoding)
        let base64String = plainData?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders = [
            "Authorization": "Basic " + base64String!
        ]
        return ["Authorization": "Basic " + base64String!]
    }
    
    internal func getPostRequestHeaders() -> [String: String] {
        var headers = self.setPreAuth()
        headers["Content-Type"] = ServiceConstants.MIME_JSON
        return headers
    }
    
    internal func getUploadRequestHeaders() -> [String: String] {
        var headers = self.setPreAuth()
        headers["Content-Type"] = ServiceConstants.MIME_MULTIPART
        return headers
    }
    
    internal func getDownloadRequestHeaders() -> [String: String] {
        let headers = self.setPreAuth()
        return headers
    }

}
