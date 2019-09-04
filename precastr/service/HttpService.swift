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
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 500;

        let Auth_header    = ["X-API-KEY" : ApiToken, "Connection": "Close"]

        manager.request("\(url)", method: .get , parameters: nil, encoding: JSONEncoding.default,headers: Auth_header).validate(statusCode: 200..<300).responseJSON { (response ) in
            var returnDict = NSDictionary();
            
            switch response.result {
            case .success:
                if (response.result.value == nil) {
                    var responseDict: [String: Any] = [:]
                    responseDict["status"] = "0";
                    responseDict["message"] = "Connection timeout";
                    returnDict = responseDict as NSDictionary;
                } else {
                    returnDict = response.result.value as! NSDictionary;
                }
            case .failure(let error):
                print(error.localizedDescription)
                var responseDict: [String: Any] = [:]
                responseDict["status"] = "0";
                responseDict["message"] = error.localizedDescription;
                returnDict = responseDict as NSDictionary;
            }
            complete(returnDict)
        }
    }
    func postMethod(url: String, postData: [String: Any], complete: @escaping(NSDictionary)->Void) {
        
        let Auth_header = [ "X-API-KEY" : ApiToken , "Connection": "Close"]
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 500

        manager.request("\(url)", method: .post , parameters: postData, encoding: JSONEncoding.default,headers: Auth_header).validate(statusCode: 200..<300).responseJSON { (response ) in
            
            var returnDict = NSDictionary();
            
            switch response.result {
            case .success:
                if (response.result.value == nil) {
                    var responseDict: [String: Any] = [:]
                    responseDict["status"] = "0";
                    responseDict["message"] = "Connection timeout";
                    returnDict = responseDict as NSDictionary;
                } else {
                    returnDict = response.result.value as! NSDictionary;
                }
            case .failure(let error):
                print(error.localizedDescription)
                var responseDict: [String: Any] = [:]
                responseDict["status"] = "0";
                responseDict["message"] = error.localizedDescription;
                returnDict = responseDict as NSDictionary;
            }
            complete(returnDict)
        }
    }
    func postMultipartImage(url: String, image: UIImage, postData: [String:Any], complete: @escaping(NSDictionary)->Void) {
        
        let imgData = UIImageJPEGRepresentation(image, 0.2)!
        
        let Auth_header =  [ "X-API-KEY" : ApiToken , "Connection": "Close"]
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 500

        manager.upload(multipartFormData: { (MultipartFormData) in
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
                    if (response.result.value == nil) {
                        var responseDict: [String: Any] = [:]
                        responseDict["status"] = "0";
                        responseDict["message"] = "Connection timeout";
                        returnDict = responseDict as NSDictionary;
                    } else {
                        returnDict = response.result.value as! NSDictionary;
                    }
                    //returnDict.setValue(true, forKey: "success");
                    //returnDict.setValue(response.result.value, forKey: "resp");
                    complete(returnDict)
                    
                }
            case .failure(let encodingError):
                print(encodingError)
                var responseDict: [String: Any] = [:]
                responseDict["status"] = "0";
                responseDict["message"] = encodingError.localizedDescription;
                returnDict = responseDict as NSDictionary;
                complete(returnDict)
                
            }
        }
    }
    func postMultipartImageSocial(url: String, image: [UIImage], postData: [String:Any], complete: @escaping(NSDictionary)->Void) {
        
        
        
        let Auth_header =  [ "X-API-KEY" : ApiToken , "Connection": "Close"]
        var key = 0
      
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 500

        manager.upload(multipartFormData: { (MultipartFormData) in
            for img in image{
                let imgData = UIImageJPEGRepresentation(img, 0.2)!
                MultipartFormData.append(imgData, withName: "post_imgs[]", fileName: "file\(key).jpg", mimeType: "image/jpg")
                key = key + 1 ;
            }
            
            MultipartFormData.append( "\(String(describing: postData["post_description"]!))".data(using: .utf8)!, withName: "post_description")
            //MultipartFormData.append( "\(String(describing: postData["social_media_id"]!))".data(using: .utf8)!, withName: "social_media_id")
            MultipartFormData.append( "\(String(describing: postData["user_id"]!))".data(using: .utf8)!, withName: "user_id")
            
            if (postData["post_id"] != nil) {
                MultipartFormData.append( "\(String(describing: postData["post_id"]!))".data(using: .utf8)!, withName: "post_id")

            }
            
            if (postData["old_image_path"] != nil) {
                MultipartFormData.append( "\(String(describing: postData["old_image_path"]!))".data(using: .utf8)!, withName: "old_image_path")
                
            }
            
            if (postData["post_status_id"] != nil) {
                MultipartFormData.append( "\(String(describing: postData["post_status_id"]!))".data(using: .utf8)!, withName: "post_status_id")
                
            }
            
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
                    if (response.result.value == nil) {
                        var responseDict: [String: Any] = [:]
                        responseDict["status"] = "0";
                        responseDict["message"] = "Connection timeout";
                        returnDict = responseDict as NSDictionary;
                    } else {
                        returnDict = response.result.value as! NSDictionary;
                    }
                    //returnDict.setValue(true, forKey: "success");
                    //returnDict.setValue(response.result.value, forKey: "resp");
                    complete(returnDict)
                    
                }
            case .failure(let encodingError):
                print(encodingError)
                var responseDict: [String: Any] = [:]
                responseDict["status"] = "0";
                responseDict["message"] = encodingError.localizedDescription;
                returnDict = responseDict as NSDictionary;
                complete(returnDict)
                
            }
        }
    }
    
    func postMultipartImageForPostCommunication(url: String, image: [UIImage], postData: [String:Any], complete: @escaping(NSDictionary)->Void) {

        let Auth_header =  [ "X-API-KEY" : ApiToken , "Connection": "Close"]
        var key = 0
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = TimeInterval(10)

        manager.upload(multipartFormData: { (MultipartFormData) in
            for img in image{
                let imgData = UIImageJPEGRepresentation(img, 0.2)!
                MultipartFormData.append(imgData, withName: "attachment[]", fileName: "file\(key).jpg", mimeType: "image/jpg")
                key = key + 1 ;
            }
            
            MultipartFormData.append( "\(String(describing: postData["post_communication_description"]!))".data(using: .utf8)!, withName: "post_communication_description")
            MultipartFormData.append( "\(String(describing: postData["post_id"]!))".data(using: .utf8)!, withName: "post_id")
            MultipartFormData.append( "\(String(describing: postData["user_id"]!))".data(using: .utf8)!, withName: "user_id")
            
            
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
                    if (response.result.value == nil) {
                        var responseDict: [String: Any] = [:]
                        responseDict["status"] = "0";
                        responseDict["message"] = "Connection timeout";
                        returnDict = responseDict as NSDictionary;
                    } else {
                        returnDict = response.result.value as! NSDictionary;
                    }
                    //returnDict.setValue(true, forKey: "success");
                    //returnDict.setValue(response.result.value, forKey: "resp");
                    complete(returnDict)
                    
                }
            case .failure(let encodingError):
                print(encodingError)
                var responseDict: [String: Any] = [:]
                responseDict["status"] = "0";
                responseDict["message"] = encodingError.localizedDescription;
                returnDict = responseDict as NSDictionary;
                complete(returnDict)
                
            }
        }
    }
    
    func postMultipartImageForUpdateProfile(url: String, image: UIImage, postData: [String:Any], complete: @escaping(NSDictionary)->Void) {
        
        let imgData = UIImageJPEGRepresentation(image, 0.2)!
        
        let Auth_header =  [ "X-API-KEY" : ApiToken , "Connection": "Close"]
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 500

        manager.upload(multipartFormData: { (MultipartFormData) in
            MultipartFormData.append(imgData, withName: "profile_pic", fileName: "file.jpg", mimeType: "image/jpg")
            MultipartFormData.append( "\(String(describing: postData["name"]!))".data(using: .utf8)!, withName: "name")
            MultipartFormData.append( "\(String(describing: postData["user_id"]!))".data(using: .utf8)!, withName: "user_id")

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
                    if (response.result.value == nil) {
                        var responseDict: [String: Any] = [:]
                        responseDict["status"] = "0";
                        responseDict["message"] = "Connection timeout";
                        returnDict = responseDict as NSDictionary;
                    } else {
                        returnDict = response.result.value as! NSDictionary;
                    }
                    //returnDict.setValue(true, forKey: "success");
                    //returnDict.setValue(response.result.value, forKey: "resp");
                    complete(returnDict)
                    
                }
            case .failure(let encodingError):
                print(encodingError)
                var responseDict: [String: Any] = [:]
                responseDict["status"] = "0";
                responseDict["message"] = encodingError.localizedDescription;
                returnDict = responseDict as NSDictionary;
                complete(returnDict)
                
            }
        }
    }
}
