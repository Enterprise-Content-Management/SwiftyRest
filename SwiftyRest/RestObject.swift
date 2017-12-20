//
//  RestObject.swift
//  SwiftyRest
//
//  Created by Song, Michyo on 12/1/16.
//  Copyright © 2016 EMC. All rights reserved.
//

/**
 Model for Rest object in Rest services.
 */
open class RestObject {
    fileprivate let rawDic: NSDictionary
    
    fileprivate var basicInfos: [String : AnyObject] = [:]
    fileprivate var content: [String: AnyObject] = [:]
    fileprivate var links: [String: AnyObject] = [:]
    
    /**
     Initiate Rest object by entry
     */
    public init(entry: NSDictionary) {
        rawDic = entry
        
        for item in entry {
            let key = item.key as! String
            switch key {
            case ObjectProperties.CONTENT.rawValue:
                content = item.value as! [String : AnyObject]
            case ObjectProperties.LINKS.rawValue:
                let linkArray = item.value as! NSArray
                constructLinks(linkArray)
            default:
                basicInfos[key] = item.value as AnyObject
            }
        }
        
        if let linkArray = getContentInfo(ObjectProperties.LINKS.rawValue) {
            constructLinks(linkArray as! NSArray)
        }
    }
    
    /**
     Get raw dictionary of this rest object to enable custom parse.
     returns:   NSDictionary        The raw dictionary of this rest object.
     */
    open func getRawDictionary() -> NSDictionary {
        return rawDic
    }
    
    /**
     Construct links into pairs.
    */
    internal func constructLinks(_ linksArray: NSArray) {
        for linkItem in linksArray {
            let linkItemDic = linkItem as! Dictionary<String, String>
            if linkItemDic["href"] != nil {
                links[linkItemDic["rel"]!] = linkItemDic["href"]! as AnyObject
            } else if linkItemDic["hreftemplate"] != nil {
                links[linkItemDic["rel"]!] = linkItemDic["hreftemplate"]! as AnyObject
            }
        }
    }
    
    /**
     Set link url with relation.
     - parameters   relation:String         Link relation for this url.
     - parameters   url: String             Url for this relation.
     */
    open func setLink(_ relation: String, url: String) {
        links[relation] = url as AnyObject
    }
    
    /**
     Set link url with relation by LinkRel.
     - parameters   relation:LinkRel        Link relation for this url.
     - parameters   url: String             Url for this relation.
     */
    open func setLink(_ relation: LinkRel, url: String) {
        setLink(relation.rawValue, url: url)
    }
    
    /**
     Get link url by LinkRel.
     - parameters   relation:LinkRel    Key for links in LinkRel.
     - returns:     String?             Link url for this key if exist or nil if not exist.
     */
    open func getLink(_ relation: LinkRel) -> String? {
        return getLink(relation.rawValue)
    }
    
    open func getLinksCount() -> Int {
        return links.count
    }
    
    open func getLinksKeys() -> [String] {
        return links.keys.sorted()
    }
    
    /**
     Get link url by raw string.
     - parameters   relation:String     Key for links in String.
     - returns:     String?             Link url for this key if exist or nil if not exist.
     */
    open func getLink(_ relation: String) -> String? {
        return links[relation] as? String
    }
    
    /**
     Set basic info by key and value.
     - parameters   key: String         Key for basic infos, i.e, any infomation except links and content.
     - parameters   value: AnyObject    Value for basic infos.
     */
    open func setBasicInfo(_ key: String, value: AnyObject) {
        basicInfos[key] = value
    }
    
    /**
     Get basic info by key.
     - parameters   key: String     Key for basic infos, i.e, any infomation except links and content.
     - returns:     AnyObject?      The value for the key.
     */
    open func getBasicInfo(_ key: String) -> AnyObject? {
        return basicInfos[key]
    }
    
    /**
     Get basic information' entries number.
     - returns:     Int     The number of basic infomation entries.
     */
    open func getBasicInfosCount() -> Int {
        return basicInfos.count
    }
    
    /**
     Get all keys for entries in basic information dictionary.
     - returns:     [String]    The keys for basic information dictionary.
     */
    open func getBasicInfosKeys() -> [String] {
        return basicInfos.keys.sorted()
    }
    
    open func getName() -> String? {
        if let name = getProperty(ObjectProperties.OBJECT_NAME.rawValue) as? String {
            return name
        } else if let name = getBasicInfo(ObjectProperties.NAME.rawValue) as? String {
            return name
        }
        return basicInfos[ObjectProperties.TITLE.rawValue] as? String
    }
    
    open func getId() -> String? {
        return basicInfos[ObjectProperties.ID.rawValue] as? String
    }
    
    open func getType() -> String? {
        return basicInfos[ObjectProperties.TYPE.rawValue] as? String
    }
    
    open func getPublished() -> String? {
        return basicInfos[ObjectProperties.PUBLISHED.rawValue] as? String
    }
    
    open func getUpdated() -> String? {
        return basicInfos[ObjectProperties.UPDATED.rawValue] as? String
    }
    
    /**
     Get readable published infomation from rest object. 
     Parsing date string into NSDateFormat with help of Utility.getReadbleDate(String)
     - parameter    locale:String   The locale identifier for parsing.
     - returns:     String?         The readable format for published date string.
    */
    open func getReadablePublished(_ locale: String) -> String? {
        if let published = getPublished() {
            return Utility.getReadableDate(published)
        }
        return nil
    }
    
    /**
     Get readable updated infomation from rest object.
     - Parsing date string into NSDateFormat with help of Utility.getReadbleDate(String)
     - parameter    locale:String   The locale identifier for parsing.
     - returns:     String?         The readable format for updated date string.
     */
    open func getReadableUpdated(_ locale: String) -> String? {
        if let updated = getUpdated() {
            return Utility.getReadableDate(updated)
        }
        return nil
    }
    
    /**
     Get content info by key.
     - parameters   key: String     Key for content.
     - returns:     AnyObject?      The value for the key.
     */
    open func getContentInfo(_ key: String) -> AnyObject? {
        return content[key]
    }
    
    /**
     Set content info by key and value.
     - parameters   key: String         Key for content infos.
     - parameters   value: AnyObject    Value for content infos.
     */
    open func setContentInfo(_ key: String, value: AnyObject) {
        content[key] = value
    }
    
    /**
     Get contents' entries number.
     - returns:     Int     The number of contents entries.
     */
    open func getContentInfosCount() -> Int {
        return content.count
    }
    
    /**
     Get all keys for entries in content dictionary.
     - returns:     [String]    The keys for content dictionary.
     */
    open func getContentInfosKeys() -> [String] {
        return content.keys.sorted()
    }
    
    /**
     Extract property dictionary from content dictionary.
     - returns:     NSDictionary?   The dictionary of properties.
     */
    open func getProperties() -> NSDictionary? {
        if let properties = basicInfos[ObjectProperties.PROPERTIES.rawValue] as? NSDictionary {
            return properties
        }
        return content[ObjectProperties.PROPERTIES.rawValue] as? NSDictionary
    }
    
    /**
     Get properties' entries number.
     - returns:     Int     The number of properties entries.
     */
    open func getPropertiesCount() -> Int {
        if let properties = getProperties() {
            return properties.count
        }
        return 0
    }
    
    /**
     Get proprety by key.
     - parameters   key: String     Key for property, i.e., property name.
     - returns:     AnyObject?      The value for the property.
     */
    open func getProperty(_ key: String) -> AnyObject? {
        if let dic = getProperties() {
            return dic.value(forKey: key) as AnyObject
        }
        return nil
    }
}
