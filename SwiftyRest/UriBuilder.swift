//
//  UriBuilder.swift
//  SwiftyRest
//
//  Created by Song, Michyo on 11/24/16.
//  Copyright © 2016 Song, Michyo. All rights reserved.
//

class UriBuilder {
    static let services = "/services"
    static let repositories = "/repositories"
    
    struct currentLoginCredential {
        static var userName: String!
        static var password: String!
    }
    
    static func getCurrentLoginAuthString() -> NSString {
        return "\(currentLoginCredential.userName!):\(currentLoginCredential.password!)" as NSString
    }
    
    static func getCurrentUserName() -> String {
        return currentLoginCredential.userName
    }
    
    static func getServicesUrl(rootUrl: String, serviceContext: String) -> String {
        return rootUrl + serviceContext + services
    }
    
    static func inlineParam() -> [String : String] {
        let param = ["inline": "true"]
        return param
    }
    
    static func pageParam(itemsPerPage: NSInteger, pageNo: NSInteger) -> [String : String] {
        let param = ["items-per-page": String(itemsPerPage), "page": String(pageNo)]
        return param
    }
    
    private static func convertCabinetsToFolders(id: String) -> String {
        return id.stringByReplacingOccurrencesOfString("cabinets", withString: "folders")
    }
    
    static func getObjectId(objectUrl: String) -> String {
        let array = objectUrl.componentsSeparatedByString("/")
        return array[array.count - 1]
    }
}