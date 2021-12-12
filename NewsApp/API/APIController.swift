//
//  APIController.swift
//  NewsApp
//
//  Created by melike ertaş on 8.12.2021.
//

import UIKit
import Alamofire
import SwiftyJSON
import FirebaseAnalytics
import Reachability

struct APIError: LocalizedError {

    public let type: ErrorMessage
    public var message:String = ""
    
    public enum ErrorMessage:String {
        case general = "Api Error"
        case connectionFail = "Connection Fail"
        case apiResponse = "Sorry, API don't have response."

    }
    
    init(type:ErrorMessage, message:String = "") {
        self.type = type
        self.message = message
        if message == "" {
            self.message = self.type.rawValue
        }
    }
    
}

public enum APIResult<Value, APIError> {
    case success(Value)
    case failure(APIError)

    public var isSuccess: Bool {
        switch self {
        case .success:
            return true
        case .failure:
            return false
        }
    }

    public var isFailure: Bool {
        return !isSuccess
    }
    
    public var value: Value? {
        switch self {
        case .success(let value):
            return value
        case .failure:
            return nil
        }
    }
    
    public var error: APIError? {
        switch self {
        case .success:
            return nil
        case .failure(let error):
            return error
        }
    }
}

class ApiController {
    
   public static let baseURL = "https://newsapi.org/v2/everything?sortBy=publishedAt&apiKey=\(API_KEY)&q="

   static var headers:HTTPHeaders = ["Accept": "application/json","Content-Type": "application/json"]

    class func performRequest(endpoint:String,parameters:[String:Any]?, method:HTTPMethod = .get ,completion:@escaping (_ response:APIResult<JSON, APIError>)->Void) {
            
        if !self.checkConnection() {
            Analytics.logEvent("Connection_Error", parameters: nil)
            completion(.failure(APIError(type: .connectionFail, message: "You don't have an internet connection!")))
            return
        }

        let encoding:ParameterEncoding = JSONEncoding.default
        var manager:SessionManager?
        
        if manager == nil {
            manager = Alamofire.SessionManager.default
        }

        manager!.request(baseURL+endpoint, method: method, parameters: parameters, encoding: encoding, headers: headers)
            .responseJSON { (response:DataResponse<Any>) in
                switch response.result{
                case .success( _):
                    let json = JSON(response.result.value as Any)
                    print("serviceForNewsFeed response \(json)")
                    completion(.success(json))
                case .failure(let error):
                    print("error \(error)")
                    completion(.failure(APIError(type:.apiResponse)))
                    Analytics.logEvent("BaseApi_Error", parameters: nil)
                }
        }
    }
    
    // Connection
    class func hasConnectivity() -> Bool {
        let reachability = try? Reachability()
        
        switch reachability!.connection {
        case .wifi:
            //debugPrint("Reachable via WiFi")
            return true
        case .cellular:
            //debugPrint("Reachable via Cellular")
            return true
        case .none:
            //debugPrint("Network not reachable")
            return false
        case .unavailable:
            return false
        }
    }
    class func checkConnection() -> Bool{
        if  !self.hasConnectivity() {
            return false
        }
        return true
    }
    
}
