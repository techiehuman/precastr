//
//  HttpService.swift
//  precastr
//
//  Created by Macbook on 02/04/19.
//  Copyright © 2019 Macbook. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
class HttpService {
    
    func getMethod(url: String,complete: @escaping(NSDictionary)->Void) {
        
       
        let Auth_header    = ["X-API-KEY" : ApiToken]

        Alamofire.request("\(url)", method: .get , parameters: nil, encoding: JSONEncoding.default,headers: Auth_header).validate(statusCode: 200..<300).responseJSON { (response ) in
            var returnDict = NSDictionary();
            
            switch response.result {
            case .success:
                returnDict = response.result.value as! NSDictionary;
            case .failure(let error):
                print(error.localizedDescription)
                var responseDict: [String: Any] = [:]
                responseDict["success"] = false;
                responseDict["message"] = error.localizedDescription;
                returnDict = responseDict as NSDictionary;
            }
            complete(returnDict)
        }
    }
    func postMethod(url: String, postData: [String: Any], complete: @escaping(NSDictionary)->Void) {
        
        let Auth_header = [ "X-API-KEY" : ApiToken ]
        
        Alamofire.request("\(url)", method: .post , parameters: postData, encoding: JSONEncoding.default,headers: Auth_header).validate(statusCode: 200..<300).responseJSON { (response ) in
            
            var returnDict = NSDictionary();
            
            switch response.result {
            case .success:
                returnDict = response.result.value as! NSDictionary;
            case .failure(let error):
                print(error.localizedDescription)
                var responseDict: [String: Any] = [:]
                responseDict["success"] = false;
                responseDict["message"] = error.localizedDescription;
                returnDict = responseDict as NSDictionary;
            }
            complete(returnDict)
        }
    }
}
