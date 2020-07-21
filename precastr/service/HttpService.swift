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
        
        let manager = Alamofire.Session.default
        manager.session.configuration.timeoutIntervalForRequest = 500;

        let headers: HTTPHeaders = [
          "X-API-KEY": ApiToken,
          "Connection": "Close"
        ]


        
        manager.request("\(url)", method: .get , parameters: nil, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<300).responseJSON { (response ) in
            var returnDict = NSDictionary();
            
            switch response.result {
            case .success:
                if (response.value == nil) {
                    var responseDict: [String: Any] = [:]
                    responseDict["status"] = "0";
                    responseDict["message"] = "Connection timeout";
                    returnDict = responseDict as NSDictionary;
                } else {
                    returnDict = response.value as! NSDictionary;
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
        
        let manager = Alamofire.Session.default
        manager.session.configuration.timeoutIntervalForRequest = 500;
        let headers: HTTPHeaders = [
          "X-API-KEY": ApiToken,
          "Connection": "Close"
        ]

        
        manager.request("\(url)", method: .post , parameters: postData, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<300).responseJSON { (response ) in
            
            var returnDict = NSDictionary();
            
            switch response.result {
            case .success:
                if (response.value == nil) {
                    var responseDict: [String: Any] = [:]
                    responseDict["status"] = "0";
                    responseDict["message"] = "Connection timeout";
                    returnDict = responseDict as NSDictionary;
                } else {
                    returnDict = response.value as! NSDictionary;
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
        
        let imgData = image.jpegData(compressionQuality: 0.2)!
        
        let manager = Alamofire.Session.default
        manager.session.configuration.timeoutIntervalForRequest = 500;
        let headers: HTTPHeaders = [
          "X-API-KEY": ApiToken,
          "Connection": "Close"
        ]

        manager.upload(multipartFormData: { (MultipartFormData) in
            MultipartFormData.append(imgData, withName: "profile_pic", fileName: "file.jpg", mimeType: "image/jpg")
            MultipartFormData.append( "\(String(describing: postData["name"]!))".data(using: .utf8)!, withName: "name")
            MultipartFormData.append( "\(String(describing: postData["username"]!))".data(using: .utf8)!, withName: "username")
            MultipartFormData.append( "\(String(describing: postData["password"]!))".data(using: .utf8)!, withName: "password")
            MultipartFormData.append( "\(String(describing: postData["device_registered_from"]!))".data(using: .utf8)!, withName: "device_registered_from")
            MultipartFormData.append( "\(String(describing: postData["device_token"]!))".data(using: .utf8)!, withName: "device_token")
            MultipartFormData.append( "\(String(describing: postData["country_code"]!))".data(using: .utf8)!, withName: "country_code")
            MultipartFormData.append( "\(String(describing: postData["phone_number"]!))".data(using: .utf8)!, withName: "phone_number")
            
        }, to: "\(url)", usingThreshold: UInt64.init(), method: .post, headers: headers ).responseJSON(completionHandler: {(response) in
            
            var returnDict = NSDictionary();
            
            switch response.result {
            case .success(let upload):
                    
                print("Suceess:\(String(describing: upload ))")
                /////let json = response.result.value as! NSDictionary
                if (upload == nil) {
                    var responseDict: [String: Any] = [:]
                    responseDict["status"] = "0";
                    responseDict["message"] = "Connection timeout";
                    returnDict = responseDict as NSDictionary;
                } else {
                    returnDict = upload as! NSDictionary;
                }
                //returnDict.setValue(true, forKey: "success");
                //returnDict.setValue(response.result.value, forKey: "resp");
                complete(returnDict)
                    
            case .failure(let encodingError):
                print(encodingError)
                var responseDict: [String: Any] = [:]
                responseDict["status"] = "0";
                responseDict["message"] = encodingError.localizedDescription;
                returnDict = responseDict as NSDictionary;
                complete(returnDict)
                
            }
        });
    }
    func postMultipartImageSocial(url: String, image: [UIImage], postData: [String:Any], complete: @escaping(NSDictionary)->Void) {
        
        var key = 0
      
        let manager = Alamofire.Session.default
        manager.session.configuration.timeoutIntervalForRequest = 500;
        let headers: HTTPHeaders = [
          "X-API-KEY": ApiToken,
          "Connection": "Close"
        ]

        manager.upload(multipartFormData: { (MultipartFormData) in
            for img in image{
                let imgData = img.jpegData(compressionQuality: 0.2)!
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
            
        }, to: "\(url)", usingThreshold: UInt64.init(), method: .post, headers: headers).responseJSON(completionHandler: {(response) in
            
            var returnDict = NSDictionary();
            
            switch response.result {
            case .success(let upload):
                
                print("Suceess:\(String(describing: upload ))")
                /////let json = response.result.value as! NSDictionary
                if (upload == nil) {
                    var responseDict: [String: Any] = [:]
                    responseDict["status"] = "0";
                    responseDict["message"] = "Connection timeout";
                    returnDict = responseDict as NSDictionary;
                } else {
                    returnDict = upload as! NSDictionary;
                }
                //returnDict.setValue(true, forKey: "success");
                //returnDict.setValue(response.result.value, forKey: "resp");
                complete(returnDict)
                
            case .failure(let encodingError):
                print(encodingError)
                var responseDict: [String: Any] = [:]
                responseDict["status"] = "0";
                responseDict["message"] = encodingError.localizedDescription;
                returnDict = responseDict as NSDictionary;
                complete(returnDict)
                
            }
        });
    }
    
    func postMultipartImageForPostCommunication(url: String, image: [UIImage], postData: [String:Any], complete: @escaping(NSDictionary)->Void) {

        var key = 0
        
        let manager = Alamofire.Session.default
        manager.session.configuration.timeoutIntervalForRequest = 500;
        let headers: HTTPHeaders = [
          "X-API-KEY": ApiToken,
          "Connection": "Close"
        ]

        manager.upload(multipartFormData: { (MultipartFormData) in
            for img in image{
                let imgData = img.jpegData(compressionQuality: 0.2)!
                MultipartFormData.append(imgData, withName: "attachment[]", fileName: "file\(key).jpg", mimeType: "image/jpg")
                key = key + 1 ;
            }
            
            MultipartFormData.append( "\(String(describing: postData["post_communication_description"]!))".data(using: .utf8)!, withName: "post_communication_description")
            MultipartFormData.append( "\(String(describing: postData["post_id"]!))".data(using: .utf8)!, withName: "post_id")
            MultipartFormData.append( "\(String(describing: postData["user_id"]!))".data(using: .utf8)!, withName: "user_id")
            
            
        }, to: "\(url)", usingThreshold: UInt64.init(), method: .post, headers: headers ).responseJSON(completionHandler: {(response) in
            
            var returnDict = NSDictionary();
            
            switch response.result {
            case .success(let upload):
                print("Suceess:\(String(describing: upload ))")
                /////let json = response.result.value as! NSDictionary
                if (upload == nil) {
                    var responseDict: [String: Any] = [:]
                    responseDict["status"] = "0";
                    responseDict["message"] = "Connection timeout";
                    returnDict = upload as! NSDictionary;
                } else {
                    returnDict = upload as! NSDictionary;
                }
                //returnDict.setValue(true, forKey: "success");
                //returnDict.setValue(response.result.value, forKey: "resp");
                complete(returnDict)
            case .failure(let encodingError):
                print(encodingError)
                var responseDict: [String: Any] = [:]
                responseDict["status"] = "0";
                responseDict["message"] = encodingError.localizedDescription;
                returnDict = responseDict as NSDictionary;
                complete(returnDict)
                
            }
        });
    }
    
    func postMultipartImageForUpdateProfile(url: String, image: UIImage, postData: [String:Any], complete: @escaping(NSDictionary)->Void) {
        
        let imgData = image.jpegData(compressionQuality: 0.2)!
                
        let manager = Alamofire.Session.default
        manager.session.configuration.timeoutIntervalForRequest = 500;
        let headers: HTTPHeaders = [
          "X-API-KEY": ApiToken,
          "Connection": "Close"
        ]

        manager.upload(multipartFormData: { (MultipartFormData) in
            MultipartFormData.append(imgData, withName: "profile_pic", fileName: "file.jpg", mimeType: "image/jpg")
            MultipartFormData.append( "\(String(describing: postData["name"]!))".data(using: .utf8)!, withName: "name")
            MultipartFormData.append( "\(String(describing: postData["user_id"]!))".data(using: .utf8)!, withName: "user_id")
            MultipartFormData.append( "\(String(describing: postData["country_code"]!))".data(using: .utf8)!, withName: "country_code")
             MultipartFormData.append( "\(String(describing: postData["phone_number"]!))".data(using: .utf8)!, withName: "phone_number")
        }, to: url, method: .post, headers: headers).responseJSON(completionHandler: {(response) in
            debugPrint("SUCCESS RESPONSE: \(response.result)")
            var returnDict = NSDictionary();

            switch response.result {
            case .success(let upload):
                if (upload == nil) {
                    var responseDict: [String: Any] = [:]
                    responseDict["status"] = "0";
                    responseDict["message"] = "Connection timeout";
                    returnDict = responseDict as NSDictionary;
                } else {
                    returnDict = upload as! NSDictionary;
                }
                complete(returnDict)
                    
            case .failure(let encodingError):
                print(encodingError)
                var responseDict: [String: Any] = [:]
                responseDict["status"] = "0";
                responseDict["message"] = encodingError.localizedDescription;
                returnDict = responseDict as NSDictionary;
                complete(returnDict)

            }
        });
    }
}
