//
//  ServiceHelper.swift
//  SwiftyRest
//
//  Created by Song, Michyo on 11/24/16.
//  Copyright © 2016 EMC. All rights reserved.
//

import Alamofire

open class ServiceHelper {
    // MARK: - Util
    
    static func setBasicAuth(_ plainString: NSString = UriBuilder.getCurrentLoginAuthString()) -> [String : String] {
        let plainData = plainString.data(using: String.Encoding.utf8.rawValue)
        let base64String = plainData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        Alamofire.SessionManager.default.session.configuration.httpAdditionalHeaders = [
            "Authorization": "Basic " + base64String!
        ]
        return ["Authorization": "Basic " + base64String!]
    }
    
    static func getPostRequestHeaders(_ plainString: NSString = UriBuilder.getCurrentLoginAuthString()) -> [String: String] {
        var headers = self.setBasicAuth(plainString)
        headers["Content-Type"] = ServiceConstants.MIME_JSON
        return headers
    }
    
    static func getUploadRequestHeaders(_ plainString: NSString = UriBuilder.getCurrentLoginAuthString()) -> [String: String] {
        var headers = self.setBasicAuth(plainString)
        headers["Content-Type"] = ServiceConstants.MIME_MULTIPART
        return headers
    }
    
    static func getDownloadRequestHeaders(_ plainString: NSString = UriBuilder.getCurrentLoginAuthString()) -> [String: String] {
        let headers = self.setBasicAuth(plainString)
        return headers
    }

}
