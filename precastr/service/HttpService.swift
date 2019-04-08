//
//  HttpService.swift
//  precastr
//
//  Created by Macbook on 02/04/19.
//  Copyright © 2019 Macbook. All rights reserved.
//

import Foundation
import Alamofire
class HttpService {
    
    func getMethod(url: String,complete: @escaping(NSDictionary)->Void) {
        
       
        
        Alamofire.request("\(url)", method: .get , parameters: nil, encoding: JSONEncoding.default,headers: nil).validate(statusCode: 200..<300).responseJSON { (response ) in
            
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
