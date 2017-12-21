//
//  AuthManager.swift
//  SwiftyRest
//
//  Created by Song, Michyo on 12/21/17.
//  Copyright © 2017 EMC. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

open class AuthManager {
    private static let AUTHORIZATION: String = "Authorization"
    
    fileprivate static var userName: String?
    fileprivate static var password: String?
    fileprivate static var accessToken: String?
    
    open static func getAuthHeader() -> [String : String] {
        if let name = userName, let pwd = password {
            return setBasicAuth(username: name, password: pwd)
        } else if let token = accessToken {
            return setOAuthHeader(token)
        } else {
            printLog("No authentication info, using anonymous login.")
            return [:]
        }
    }
    
    open static func setUserName(_ userName: String) {
        self.userName = userName
    }
    
    open static func setPassword(_ password: String) {
        self.password = password
    }
    
    open static func setAccessToken(_ accessToken: String) {
        self.accessToken = accessToken
    }
    
    private static func setBasicAuth(username: String, password: String) -> [String : String] {
        let plainText = "\(username):\(password)" as NSString
        let plainData = plainText.data(using: String.Encoding.utf8.rawValue)
        let base64String = plainData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        let basicHeader = [AUTHORIZATION : "Basic " + base64String!]
        Alamofire.SessionManager.default.session.configuration.httpAdditionalHeaders = basicHeader
        return basicHeader
    }
    
    private static func setOAuthHeader(_ accessToken: String) -> [String: String] {
        let bearerHeader = [AUTHORIZATION: "Bearer " + accessToken]
        Alamofire.SessionManager.default.session.configuration.httpAdditionalHeaders = bearerHeader
        return bearerHeader
    }
    
    /**
     Clear up login auth credential.
     */
    open static func clearCurrentLoginCredential() {
        userName = nil
        password = nil
        accessToken = nil
    }
    
    /**
     Get current login user name.
     */
    open static func getCurrentUserName() throws -> String {
        if let name = userName {
            return name
        } else {
            throw RestError(msg: "Username can not found in Context.")
        }
    }
}
