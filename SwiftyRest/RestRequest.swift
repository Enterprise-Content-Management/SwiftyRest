//
//  RestRequest.swift
//  SwiftyRest
//
//  Created by Song, Michyo on 11/24/16.
//  Copyright © 2016 EMC. All rights reserved.
//

import Alamofire
import SwiftyJSON

open class RestRequest: RequestBase {
        
    /**
     Get raw json response for certain request.
     - parameter    method: String              The http method for rest service.
     - parameter    url:String                  The url to request.
     - parameter    headers:[String : String]   Headers along with this request.
     - parameter    params:[String : String]    Parameters along with this request.
     - parameter    completionHandler:(JSON?, Error?)->()
                    Handler after getting response.
                    If success, Error will be nil. Json stores raw respone.
                    Otherwise, Json will be nil.
     */
    open static func getRawJson(
        _ method: HttpMethod = .GET,
        url: String,
        params: [String : Any]? = nil,
        headers: [String: String]? = AuthManager.getAuthHeader(),
        encoding: ParameterEncoding = URLEncoding.default,
        completionHandler: @escaping (JSON?, RestError?) -> ()) {
        sendRequest(method.method(), url: url, params: params, headers: headers, encoding: encoding,
            onSuccess: { json in
                completionHandler(json, nil)
            }, onFailure: { json in
                let error = RestError(json: json)
                completionHandler(nil, error)
            }
        )
    }

    // MARK: - Entity Collection request

    /**
     Get Rest collection response with parameters and authentication.
     - parameter    url:String                  The url to request.
     - parameter    headers:[String : String]   Headers along with this request.
     - parameter    params:[String : String]    Parameters along with this request.
     - parameter    completionHandler:(NSArray?, Error?)->()
                    Handler after getting response.
                    If success, Error will be nil. NSArray stores entries of respone.
                    Otherwise, NSArray will be nil.
     */
    open static func getRestObjectCollection(
        _ url: String,
        params: [String : Any]? = nil,
        headers: [String: String]? = AuthManager.getAuthHeader(),
        completionHandler: @escaping (Array<RestObject>?, RestError?) -> ()) {
        getCollection(url, params: params, headers: headers, completionHandler: completionHandler)
    }
    
    // MARK: - Get Single Object
    
    /**
     Get single Rest object with parameters and authentication.
     - parameter    url:String                  The url to request.
     - parameter    params:[String : String]    Parameters along with this request.
     - parameter    headers:[String : String]   Headers along with this request.
     - parameter    completionHandler:(NSDictionary?, Error?)->()
     Handler after getting response.
     If success, Error will be nil. NSDictionary stores information for objec.
     Otherwise, NSDictionary will be nil.
     */
    open static func getRestObject(
        _ url: String,
        params: [String : Any]? = nil,
        headers: [String: String]? = AuthManager.getAuthHeader(),
        completionHandler: @escaping (RestObject?, RestError?) -> ()) {
        getSingle(url, params: params, headers: headers, completionHandler: completionHandler)
    }
    
    // MARK: - CRUD control requests
    
    /**
     Delete an object with parameters and authentication.
     - parameter    url:String                  The url to request.
     - parameter    params:[String : String]    Parameters along with this request.
     - parameter    headers:[String : String]   Headers along with this request.
     - parameter    completionHandler:(NSDictionary?, Error?)->()
                    Handler after getting response.
                    If success, Error will be nil. NSDictionary is response of request.
                    Otherwise, NSDictionary will be nil.
     */
    open static func deleteWithAuth(
        _ url: String,
        params: [String : Any]? = nil,
        headers: [String: String]? = AuthManager.getAuthHeader(),
        completionHandler: @escaping (Bool, RestError?) -> ()) {
        sendRequest(.delete, url: url, headers: headers,
                    onSuccess: { json in
                        noContentOnSuccess(completionHandler)
            },
                    onFailure: { json in
                        processNoContentFailure(json, completionHandler: completionHandler)
        })
    }
    
    /**
     Update an object using POST by request body with parameters and authentication.
     - parameter    url:String                  The url to request.
     - parameter    requestBody:Dictionary<String, AnyObject>    RequestBody to update object.
     - parameter    headers:[String : String]   Headers along with this request.
     - parameter    completionHandler:(NSDictionary?, Error?)->()
                    Handler after getting response.
                    If success, Error will be nil. NSDictionary is response of request.
                    Otherwise, NSDictionary will be nil.
     */
    open static func updateWithAuth(
        _ url: String,
        requestBody: [String: Any]? = nil,
        headers: [String: String]? = AuthManager.getAuthHeader(),
        completionHandler: @escaping (RestObject?, RestError?) -> ()) {
        sendRequest(.post, url: url, params: requestBody, headers: getPostRequestHeaders(), encoding: JSONEncoding.default,
                    onSuccess:{ json in
                        getEntityOnSuccess(json,  completionHandler: completionHandler)
            },
                    onFailure: { json in
                        processFailureJson(json, completionHandler: completionHandler)
        })
    }
    
    /**
     Update an object using PUT with parameters and authentication.
     - parameter    url:String                  The url to request.
     - parameter    headers:[String : String]   Headers along with this request.
     - parameter    completionHandler:(NSDictionary?, Error?)->()
                    Handler after getting response.
                    If success, Error will be nil. NSDictionary is response of request.
                    Otherwise, NSDictionary will be nil.
     */
    open static func updateWithAuthByPut(
        _ url: String,
        headers: [String: String]? = AuthManager.getAuthHeader(),
        completionHandler: @escaping (RestObject?, RestError?) -> ()
        ) {
        sendRequest(.put, url: url, headers: getPostRequestHeaders(), encoding: JSONEncoding.default,
                    onSuccess:{ json in
                        getEntityOnSuccess(json,  completionHandler: completionHandler)
            },
                    onFailure: { json in
                        processFailureJson(json, completionHandler: completionHandler)
        })
    }
    
    /**
     Create an object by request body with parameters and authentication.
     - parameter    url:String                  The url to request.
     - parameter    requestBody:Dictionary<String, AnyObject>    RequestBody to create object.
     - parameter    headers:[String : String]   Headers along with this request.
     - parameter    completionHandler:(NSDictionary?, Error?)->()
                    Handler after getting response.
                    If success, Error will be nil. NSDictionary contains information of created object.
                    Otherwise, NSDictionary will be nil.
     */
    open static func createWithAuth(
        _ url: String,
        requestBody: [String: Any],
        headers: [String: String]? = AuthManager.getAuthHeader(),
        completionHandler: @escaping (RestObject?, RestError?) -> ()) {
        sendRequest(.post, url: url, params: requestBody, headers: getPostRequestHeaders(), encoding: JSONEncoding.default,
                    onSuccess: { json in
                        getEntityOnSuccess(json, completionHandler: completionHandler)
            },
                    onFailure: { json in
                        processFailureJson(json, completionHandler: completionHandler)
        })
    }
    
    /**
     Get repository url for current Rest services.
     - parameter    rootUrl:String                  The root url for REST Service.
     - parameter    serviceContext: String          The service context for REST Service.
     - parameter    completionHandler:(String?, Error?)->()
                    Handler after getting response.
                    If success, Error will be nil. String is repositories url for REST service.
                    Otherwise, String will be nil.
     */
    open static func getRepositoriesUrl(
        _ rootUrl: String,
        serviceContext: String,
        completionHandler: @escaping (String?, RestError?) -> ()) {
        let uriBuilder = UriBuilder(rootUrl: rootUrl, context: serviceContext)
        sendRequest(.get, url: uriBuilder.getServicesUrl(),
                    onSuccess: { json in
                        getRepositoriesUrlOnSuccess(json, completionHandler: completionHandler)
                 }, onFailure: { json in
                        processFailureJson(json, completionHandler: completionHandler)
        })
    }
    
    /**
     Get product info for current Rest services.
     - parameter    rootUrl:String                  The root url for REST Service.
     - parameter    serviceContext: String          The service context for REST Service.
     - parameter    completionHandler:(NSDictionary?, Error?)->()
                    Handler after getting response.
                    If success, Error will be nil. NSDictionary is properties of product info.
                    Otherwise, NSDictionary will be nil.
     */
    open static func getProductInfo(_ rootUrl: String, context: String, completionHandler: @escaping (NSDictionary?, RestError?) -> ()){
        if UriBuilder.productInfoUrl.isEmpty {
            let uriBuilder = UriBuilder(rootUrl: rootUrl, context: context)
            UriBuilder.productInfoUrl = uriBuilder.getProductInfo()
        }
        getRawJson(url: UriBuilder.productInfoUrl) { json, error in
            if let json = json {
                let productInfo = json.dictionary![ObjectProperties.PROPERTIES.rawValue]!.dictionaryObject!
                completionHandler(productInfo as NSDictionary, nil)
            } else {
                completionHandler(nil, error!)
            }
        }
    }
    
    // MARK: - Upload and Downlad files
    /**
     Upload a content file for certain object.
     - parameter    url:String                  The url to request.
     - parameter    headers:[String : String]   Headers along with this request.
     - parameter    metadata:JSON               Meta data for object content in JSON format.
     - parameter    file:NSData                 Content file in NSData format.
     - parameter    type:String                 MIME type for this content file.
     - parameter    completionHandler:(NSDictionary?, Error?)->()
                    Handler after getting response.
                    If success, Error will be nil. NSDictionary is response of Rest service.
                    Otherwise, NSDictionary will be nil.
     */
    open static func uploadFile(
        _ url: String,
        headers: [String: String]? = AuthManager.getAuthHeader(),
        metadata: JSON,
        file: Data,
        type: String,
        completionHandler: @escaping (NSDictionary?, RestError?) -> ()
        ) {
        Alamofire.upload(
            multipartFormData: { (multipart) in
                multipart.append(self.getNSDataFromJSON(metadata), withName: "metadata", mimeType: ServiceConstants.MIME_JSON)
                multipart.append(file, withName: "binary", mimeType: type)
            },
            usingThreshold: UInt64.init(),
            to: url, method: .post,
            headers: getUploadRequestHeaders(),
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.validate()
                    upload.responseJSON  { response in
                        switch response.result {
                        case .success:
                            let value = response.result.value!
                            let json = JSON(value)
                            let dic = json.object as! Dictionary<String, AnyObject>
                            completionHandler(dic as NSDictionary, nil)
                        case .failure:
                            let json = try! JSON(data: response.data!)
                            printError("error: \(json)")
                            completionHandler(nil, RestError(json: json))
                        }
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
            })
        
//        Alamofire.upload(
//            multipartFormData: { multipartFormData in
//                multipartFormData.append(self.getNSDataFromJSON(metadata), withName: "metadata", mimeType: ServiceConstants.MIME_JSON)
//                multipartFormData.append(file, withName: "binary", mimeType: type)
//            },
//            usingThreshold: UInt64.init(),
//            method: .post,
////            headers: ServiceHelper.getUploadRequestHeaders(auth) as [String: String],
//            
//            to: url,
//            encodingCompletion: { encodingResult in
//                switch encodingResult {
//                case .success(let upload, _, _):
//                    upload.validate()
//                    upload.responseJSON  { response in
//                        switch response.result {
//                        case .success:
//                            let value = response.result.value!
//                            let json = JSON(value)
//                            let dic = json.object as! Dictionary<String, AnyObject>
//                            completionHandler(dic as NSDictionary, nil)
//                        case .failure:
//                            let json = JSON(data: response.data!)
//                            printError("error: \(json)")
//                            completionHandler(nil, Error(json: json))
//                        }
//                    }
//                case .failure(let encodingError):
//                    print(encodingError)
//                }
//        })
    }
    
    /**
     Download from url for content of object.
     - parameter    url:String                  The url to request.
     - parameter    headers:[String : String]   Headers along with this request.
     - parameter    objectId:String             The object id for object of this content to identify it.
     - parameter    completionHandler:(NSData?, Error?)->()
                    Handler after getting response.
                    If success, Error will be nil. NSData is data source of this content.
                    Otherwise, NSData will be nil.
     */
    open static func downloadFile(
        _ url: String,
        objectId: String,
        completionHandler: @escaping (Data?, RestError?) -> ()
        ) {
        let destination: DownloadRequest.DownloadFileDestination = {_, _ in
            let fileUrl = FileUtility.getSaveToUrl(objectId)
            return (fileUrl, [.removePreviousFile, .createIntermediateDirectories])
        }
        Alamofire.download(url, method: .get, headers: getDownloadRequestHeaders(), to: destination)
            .response { response in
                debugPrint(response)
        }
    }
    
    // MARK: - Misc control
    /**
     Move an object by request body with parameters and authentication.
     - parameter    url:String                  The url to request.
     - parameter    requestBody:Dictionary<String, AnyObject>    RequestBody to create object.
     - parameter    headers:[String : String]   Headers along with this request.
     - parameter    completionHandler:(NSDictionary?, Error?)->()
                    Handler after getting response.
                    If success, Error will be nil. NSDictionary contains information of moved object.
                    Otherwise, NSDictionary will be nil.
     */
    open static func moveObject(
        _ url: String,
        requestBody: Dictionary<String, AnyObject>,
        headers: [String: String]? = AuthManager.getAuthHeader(),
        completionHandler: @escaping (RestObject?, RestError?) -> ()) {
        sendRequest(.put, url: url, params: requestBody, headers: getPostRequestHeaders(), encoding: JSONEncoding.default,
                    onSuccess: { json in
                         getEntityOnSuccess(json, completionHandler: completionHandler)
                        },
                    onFailure: { json in
                        processFailureJson(json, completionHandler: completionHandler)
            })
    }
    
    // MARK: - Response with no content
    
    /**
     Add membership for a Group.
     - parameter    url:String                  The url to request.
     - parameter    headers:[String : String]   Headers along with this request.
     - parameter    requestBody:Dictionary<String, AnyObject>    RequestBody to add membership.
     - parameter    completionHandler:(Bool, Error?)->()
                    Handler after getting response.
                    If success, Error will be nil. Bool will be true.
                    Otherwise, Bool will be false.
     */
    open static func addMembership(
        _ url: String,
        headers: [String: String]? = AuthManager.getAuthHeader(),
        requestBody: Dictionary<String, AnyObject>,
        completionHandler: @escaping (Bool, RestError?) -> ()) {
        sendRequestForResponse(.post, url: url, params: requestBody, headers: getPostRequestHeaders(), encoding: JSONEncoding.default, onResponse: completionHandler)
    }
    
    // MARK: - Batch requests
    
    /**
     Post a batch request to batch url.
     - parameter    batchUrl:String             The url of batch relation.
     - parameter    headers:[String : String]   Headers along with this request.
     - parameter    requestBody:Dictionary<String, AnyObject>    RequestBody for this batch request.
     - parameter    completionHandler:([Bool], Error?)->()
                    Handler after getting response.
                    If success, Error will be nil. Array of Bool contains result of every request in batch.
                    True means this request is successful while False means failure.
     */
    open static func batchRequest(
        _ batchUrl: String,
        headers: [String: String]? = AuthManager.getAuthHeader(),
        requestBody: Dictionary<String, AnyObject>,
        completionHandler: @escaping ([Bool], RestError?) -> ()) {
        sendRequest(.post, url: batchUrl, params: requestBody, headers: getPostRequestHeaders(), encoding: JSONEncoding.default,
                    onSuccess: { json in
                        getBatchResponseOnSuccess(json, completionHandler: completionHandler)
            },
                    onFailure: { json in
                        processFailureBatch(json, completionHandler: completionHandler)
        })
        
    }
    
    // MARK: - More request
    
    /**
     Add membership for a Group.
     - parameter    searchUrl:String            The search url w/o template.
     - parameter    headers:[String : String]   Headers along with this request.
     - parameter    location:String             The location in folder path format to search from.
     - parameter    keyword:String              The keyword to search for.
     - parameter    inline:Bool                 To search with inline or not.
     - parameter    otherParams:[String: String]?   Other parameters to send along with request.
     - parameter    completionHandler:(Array<RestObject>?, Error?)->()
                    Handler after getting response.
                    If success, Error will be nil. Array will contain search results.
                    Otherwise, Array will be nil.
     */
    open static func fullTextSearch(
        _ searchUrl: String,
        headers: [String: String]? = AuthManager.getAuthHeader(),
        location: String? = nil,
        keyword: String,
        inline: Bool = false,
        otherParams: [String: String]? = nil,
        completionHandler: @escaping (Array<RestObject>?, RestError?) -> ()
        ) {
        let url = searchUrl.split(separator: "{").map(String.init)[0]
        var params = ["q": keyword, "inline": String(inline)] as [String: String]
        if let location = location {
            params["locations"] = location
        }
        if let others = otherParams {
            for param in others {
                params[param.0] = param.1
            }
        }
        getCollection(url, params: params, headers: headers, completionHandler: completionHandler)
    }
    
    /**
     Exchange OAuth2 code for access token
    */
    open static func exchangeCodeToToken(
        _ method: HttpMethod = .POST,
        url: String,
        code: String,
        completionHandler: @escaping (JSON?, RestError?) -> ()) {
        sendRequest(method.method(), url: url, params: ["code": code], headers: ["Content-Type": "application/x-www-form-urlencoded"],
                    onSuccess: { json in
                        completionHandler(json, nil)
                    }, onFailure: { json in
                        let error = RestError(json: json)
                        completionHandler(nil, error)
                    }
        )
    }
}
