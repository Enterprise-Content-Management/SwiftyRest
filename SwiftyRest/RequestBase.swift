//
//  RequestBase.swift
//  SwiftyRest
//
//  Created by Song, Michyo on 12/1/16.
//  Copyright © 2016 EMC. All rights reserved.
//

import Alamofire
import SwiftyJSON

open class RequestBase : ServiceHelper {
    
    // Set disable evaluation for public ecd site.
    static let manager: SessionManager = {
        let serverTrustPolicies: [String: ServerTrustPolicy] = ["pbrst.getecdcontent.com": .disableEvaluation]
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        return SessionManager(configuration: configuration,  serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies))
    }()
    
    // MARK: - Basic request
    
    internal static func sendRequest(
        _ method: HTTPMethod,
        url: String,
        params: [String: Any]? = nil,
        headers: [String: String]? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        onSuccess: @escaping (JSON) -> (),
        onFailure: @escaping (JSON) -> ()
        ) {
        manager.request(url, method: method, parameters: params, encoding: encoding, headers: headers)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    printLog("Success request to \(url)")
                    if let value = response.result.value {
                        let json = JSON(value)
                        onSuccess(json)
                    }
                case .failure:
                    let json = try! JSON(data: response.data!)
                    printError("error: \(json)")
                    onFailure(json)
                }
        }
    }
    
    // Handler for empty response
    internal static func sendRequestForResponse(
        _ method: HTTPMethod,
        url: String,
        params: [String: Any]? = nil,
        headers: [String: String]? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        onResponse: @escaping (Bool, RestError?) -> ()
        ) {
        manager.request(url, method: method, parameters: params, encoding: encoding, headers: headers)
            .validate()
            .response { response in
                debugPrint(response)
        }
    }
    
    // MARK: - Get Collection
    
    internal static func getCollection(
        _ url: String,
        params: [String : Any]? = nil,
        headers: [String: String]? = AuthManager.getAuthHeader(),
        completionHandler: @escaping (Array<RestObject>?, RestError?) -> ()) {
        sendRequest(.get, url: url, params: params, headers: headers,
                    onSuccess: { json in
                        getEntriesOnSuccess(json, completionHandler: completionHandler)
            },
                    onFailure: { json in
                        processFailureJson(json, completionHandler: completionHandler)
        })
    }
    
    internal static func getEntriesOnSuccess(_ json: JSON, completionHandler: (Array<RestObject>?, RestError?) -> ()) {
        let dictionary = json.object as! Dictionary<String, AnyObject>
        let array = dictionary[ServiceConstants.ENTRIES] as? NSArray
        let objects = parseEntries(array)
        completionHandler(objects, nil)
    }
    
    internal static func processFailureJson(_ json: JSON, completionHandler: (Array<RestObject>?, RestError?) -> ()) {
        let error = RestError(json: json)
        completionHandler(nil, error)
    }
    
    // MARK: - Get Single

    internal static func getSingle(
        _ url: String,
        params: [String : Any]? = nil,
        headers: [String: String]? = AuthManager.getAuthHeader(),
        completionHandler: @escaping (RestObject?, RestError?) -> ()) {
        sendRequest(.get, url: url, params: params, headers: headers,
                    onSuccess: { json in
                        getEntityOnSuccess(json, completionHandler: completionHandler)
            },
                    onFailure: { json in
                        processFailureJson(json, completionHandler: completionHandler)
        })
    }

    internal static func getEntityOnSuccess(_ json: JSON, completionHandler: (RestObject?, RestError?) -> ()) {
        let dictionary = json.object as! Dictionary<String, AnyObject>
        let object = parseSingle(dictionary as NSDictionary)
        completionHandler(object, nil)
    }
    
    internal static func processFailureJson(_ json: JSON, completionHandler: (RestObject?, RestError?) -> ()) {
        let error = RestError(json: json)
        completionHandler(nil, error)
    }
    
    // MARK: - Parser for modeling Rest Object
    
    internal static func parseEntries(_ entries: NSArray?) -> Array<RestObject> {
        var array: Array<RestObject> = []
        if let entries = entries {
            for entry in entries {
                let object = RestObject(entry: entry as! NSDictionary)
                array.append(object)
            }
        }
        return array
    }
    
    internal static func parseSingle(_ entry: NSDictionary) -> RestObject {
        return RestObject(entry: entry)
    }
    
    // MARK: - CRUD helper
    
    internal static func noContentOnSuccess(_ completionHandler: (Bool, RestError?) -> ()) {
        completionHandler(true, nil)
    }
    
    internal static func processNoContentFailure(_ json: JSON, completionHandler: (Bool, RestError?) -> ()) {
        let error = RestError(json: json)
        completionHandler(false, error)
    }
    
    // MARK: - Properties Url helper
    
    internal static func getRepositoriesUrlOnSuccess(_ json: JSON, completionHandler: (String?, RestError?) -> ()) {
        let resources = json["resources"].dictionary!
        let repositories = resources[LinkRel.repositories.rawValue]?.dictionary
        let url = repositories!["href"]?.stringValue
        let about = resources["about"]?.dictionary
        UriBuilder.productInfoUrl = about!["href"]?.stringValue
        completionHandler(url, nil)
    }
    
    internal static func processFailureJson(_ json: JSON, completionHandler: (String?, RestError?) -> ()) {
        let error = RestError(json: json)
        completionHandler(nil, error)
    }
    
    // MARK: - Batch helper
    
    internal static func getBatchResponseOnSuccess(_ json: JSON, completionHandler: ([Bool], RestError?) -> ()) {
        let dic = json.dictionaryObject
        var results: [Bool] = []
        if let response = dic {
            let operations = response["operations"] as! NSArray
            for operation in operations {
                let op = operation as! NSDictionary
                let description = op["description"] as! String
                let opResponse = op["response"] as! NSDictionary
                if opResponse["status"] as! Int == 201 {
                    printLog("Successfully \(description)")
                    results.append(true)
                } else {
                    printError("Fail to \(description)")
                    results.append(false)
                }
            }
        }
        completionHandler(results, nil)
    }
    
    internal static func processFailureBatch(_ json: JSON, completionHandler: ([Bool], RestError?) -> ()) {
        let error = RestError(json: json)
        completionHandler([], error)
    }
    
    // MARK: - Helper
    
    internal static func getNSDataFromNSDictionary(_ dic: NSDictionary) -> Data {
        let data = NSKeyedArchiver.archivedData(withRootObject: dic)
        return data
    }
    
    internal static func getNSDataFromJSON(_ json: JSON) -> Data {
        let data: Data?
        do {
            data = try json.rawData()
        } catch _ {
            data = nil
        }
        return data!
    }
}

public enum HttpMethod : String {
    case OPTIONS, GET, HEAD, POST, PUT, PATCH, DELETE, TRACE, CONNECT
    
    /**
     Get method for this HttpMethod enum.
     return:    Alamofire.Method    The real method accepted for request.
    */
    public func method() -> Alamofire.HTTPMethod {
        switch self {
        case .OPTIONS:
            return Alamofire.HTTPMethod.options
        case .GET:
            return .get
        case .HEAD:
            return Alamofire.HTTPMethod.head
        case .POST:
            return Alamofire.HTTPMethod.post
        case .PUT:
            return Alamofire.HTTPMethod.put
        case .PATCH:
            return Alamofire.HTTPMethod.patch
        case .DELETE:
            return Alamofire.HTTPMethod.delete
        case .TRACE:
            return Alamofire.HTTPMethod.trace
        case .CONNECT:
            return Alamofire.HTTPMethod.connect
        }
    }
}
