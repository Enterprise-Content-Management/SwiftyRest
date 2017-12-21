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
    
    static func getPostRequestHeaders() -> [String: String] {
        var headers = AuthManager.getAuthHeader()
        headers["Content-Type"] = ServiceConstants.MIME_JSON
        return headers
    }
    
    static func getUploadRequestHeaders() -> [String: String] {
        var headers = AuthManager.getAuthHeader()
        headers["Content-Type"] = ServiceConstants.MIME_MULTIPART
        return headers
    }
    
    static func getDownloadRequestHeaders() -> [String: String] {
        let headers = AuthManager.getAuthHeader()
        return headers
    }

}
