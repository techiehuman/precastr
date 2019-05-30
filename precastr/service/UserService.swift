//
//  UserService.swift
//  precastr
//
//  Created by Macbook on 11/04/19.
//  Copyright © 2019 Macbook. All rights reserved.
//

import Foundation
import UIKit


class UserService{
    
    
    
    func postDataMethod(jsonURL : String,postData: [String : Any], complete: @escaping(NSDictionary)->Void) {
        
        let url = "\(ApiUrl)\(jsonURL)";
        print("API Url : \(url)")
        
        HttpService().postMethod(url: url,postData: postData, complete: { (response ) in
            complete(response);
        });
    };
    
    func getDataMethod(jsonURL : String, complete: @escaping(NSDictionary)->Void) {
        
        let url = "\(ApiUrl)\(jsonURL)";
        print("API Url : \(url)")
        
        HttpService().getMethod(url: url, complete: { (response ) in
            complete(response);
        });
    };
    
    func postMultipartImageDataMethod(jsonURL : String,image: UIImage,postData: [String : Any], complete: @escaping(NSDictionary)->Void) {
        
        let url = "\(ApiUrl)\(jsonURL)";
        print("API Url : \(url)")
        
        HttpService().postMultipartImage(url: url,image: image,postData: postData, complete: { (response ) in
            complete(response);
        });
    };
  
    func postMultipartImageDataSocialMethod(jsonURL : String,image: [UIImage],postData: [String : Any], complete: @escaping(NSDictionary)->Void) {
        
        let url = "\(ApiUrl)\(jsonURL)";
        print("API Url : \(url)")
        
        HttpService().postMultipartImageSocial(url: url,image: image,postData: postData, complete: { (response ) in
            complete(response);
        });
    };
    
}
