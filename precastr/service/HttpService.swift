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
    func postMultipartImage(url: String, image: UIImage, postData: [String:Any], complete: @escaping(NSDictionary)->Void) {
        
        let imgData = UIImageJPEGRepresentation(image, 0.2)!
        
        let Auth_header =  [ "X-API-KEY" : ApiToken ]
        
        Alamofire.upload(multipartFormData: { (MultipartFormData) in
            MultipartFormData.append(imgData, withName: "profile_pic", fileName: "file.jpg", mimeType: "image/jpg")
            MultipartFormData.append( "\(String(describing: postData["name"]!))".data(using: .utf8)!, withName: "name")
            MultipartFormData.append( "\(String(describing: postData["username"]!))".data(using: .utf8)!, withName: "username")
            MultipartFormData.append( "\(String(describing: postData["password"]!))".data(using: .utf8)!, withName: "password")
            MultipartFormData.append( "\(String(describing: postData["device_registered_from"]!))".data(using: .utf8)!, withName: "device_registered_from")
            MultipartFormData.append( "\(String(describing: postData["device_token"]!))".data(using: .utf8)!, withName: "device_token")
            
        }, usingThreshold: UInt64.init(), to: "\(url)", method: .post, headers:Auth_header ) { (result) in
            
            var returnDict = NSDictionary();
            
            switch result {
            case .success(let upload,_,_):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    
                    print("Suceess:\(String(describing: response.result.value ))")
                    /////let json = response.result.value as! NSDictionary
                    returnDict = response.result.value as! NSDictionary;
                    //returnDict.setValue(true, forKey: "success");
                    //returnDict.setValue(response.result.value, forKey: "resp");
                    complete(returnDict)
                    
                }
            case .failure(let encodingError):
                print(encodingError)
                var responseDict: [String: Any] = [:]
                responseDict["success"] = false;
                responseDict["message"] = encodingError.localizedDescription;
                returnDict = responseDict as NSDictionary;
                complete(returnDict)
                
            }
        }
    }
    func postMultipartImageSocial(url: String, image: UIImage, postData: [String:Any], complete: @escaping(NSDictionary)->Void) {
        
        let imgData = UIImageJPEGRepresentation(image, 0.2)!
        
        let Auth_header =  [ "X-API-KEY" : ApiToken ]
        
        Alamofire.upload(multipartFormData: { (MultipartFormData) in
            MultipartFormData.append(imgData, withName: "post_imgs", fileName: "file.jpg", mimeType: "image/jpg")
            MultipartFormData.append( "\(String(describing: postData["post_description"]!))".data(using: .utf8)!, withName: "post_description")
            MultipartFormData.append( "\(String(describing: postData["social_media_id"]!))".data(using: .utf8)!, withName: "social_media_id")
          
            
            
        }, usingThreshold: UInt64.init(), to: "\(url)", method: .post, headers:Auth_header ) { (result) in
            
            var returnDict = NSDictionary();
            
            switch result {
            case .success(let upload,_,_):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    
                    print("Suceess:\(String(describing: response.result.value ))")
                    /////let json = response.result.value as! NSDictionary
                    returnDict = response.result.value as! NSDictionary;
                    //returnDict.setValue(true, forKey: "success");
                    //returnDict.setValue(response.result.value, forKey: "resp");
                    complete(returnDict)
                    
                }
            case .failure(let encodingError):
                print(encodingError)
                var responseDict: [String: Any] = [:]
                responseDict["success"] = false;
                responseDict["message"] = encodingError.localizedDescription;
                returnDict = responseDict as NSDictionary;
                complete(returnDict)
                
            }
        }
    }
}
