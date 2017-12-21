//
//  UriBuilder.swift
//  SwiftyRest
//
//  Created by Song, Michyo on 11/24/16.
//  Copyright © 2016 EMC. All rights reserved.
//

/**
 Uri builder for Rest services.
 */
open class UriBuilder {
    static let services = "/services"
    static let repositories = "/repositories"
    static let productInfo = "/product-info"
    
    static var productInfoUrl: String!
    
    var rootUrl: String
    var context: String
    
    /**
     Initiate UriBuilder with root url and context of current using Rest services.
     - parameter    rootUrl:String      The root url of Rest services.
     - parameter    context:String      The context of Rest services.
     */
    public init(rootUrl: String, context: String) {
        self.rootUrl = rootUrl
        self.context = context
    }
    
    /**
     Get root services url for Rest services.
     - returns:     url for services.
     */
    open func getServicesUrl() -> String {
        return rootUrl + context + UriBuilder.services
    }
    
    /**
     Get product info url for Rest services.
     - returns:     url for product info.
     */
    open func getProductInfo() -> String {
        return rootUrl + context + UriBuilder.productInfo
    }
    
    /**
     Get inline parameters for request.
     - returns:     inline parameter in [String: String]
     */
    open static func inlineParam() -> [String : String] {
        let param = ["inline": "true"]
        return param
    }
    
    /**
     Get page parameters for request. Items per page should be set in ServiceConstants.
     - parameter    pageNo:NSInteger    The page number.
     - returns:     page parameter in [String: String]
     */
    open static func pageParam(_ pageNo: NSInteger) -> [String : String] {
        let param = ["items-per-page": String(ServiceConstants.getItemsPerPage()), "page": String(pageNo)]
        return param
    }
    
    fileprivate static func convertCabinetsToFolders(_ id: String) -> String {
        return id.replacingOccurrences(of: "cabinets", with: "folders")
    }
    
    /**
     Get object id from object url.
     - parameter    objectUr:String    The object url.
     - returns:     raw object id extracted from this url.
     */
    open static func getObjectId(_ objectUrl: String) -> String {
        let array = objectUrl.components(separatedBy: "/")
        return array[array.count - 1]
    }
}
