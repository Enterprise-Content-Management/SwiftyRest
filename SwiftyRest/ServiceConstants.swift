//
//  ServiceConstants.swift
//  SwiftyRest
//
//  Created by Song, Michyo on 11/24/16.
//  Copyright © 2016 EMC. All rights reserved.
//

open class ServiceConstants {
    static let ENTRIES = "entries"
    static let PROPERTIES = "properties"
    static let LINKS = "links"
    
    open static let MIME_JSON = "application/vnd.emc.documentum+json"
    open static let MIME_MULTIPART = "multipart/form-data"
    open static let MIME_JPEG = "image/jpeg"
    open static let MIME_TEXT = "text/plain"
    
    // Properties for dramatical load data
    static var itemsPerPage = 20
    
    /**
     Get items per page for rest services.
     - returns: Int     The count of items per page.
     */
    open static func getItemsPerPage() -> Int {
        return ServiceConstants.itemsPerPage;
    }
    
    /**
     Set items per page number for rest services. Default is 20.
     - parameters:  items: Int  The items count for per page.
     */
    open static func setItemsPerPage(_ items: Int) {
        ServiceConstants.itemsPerPage = items
    }
}
