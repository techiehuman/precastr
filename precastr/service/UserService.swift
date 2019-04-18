//
//  UserService.swift
//  precastr
//
//  Created by Macbook on 11/04/19.
//  Copyright © 2019 Macbook. All rights reserved.
//

import Foundation



class UserService{
    
    
    
    func postDataMethod(jsonURL : String,postData: [String : Any], complete: @escaping(NSDictionary)->Void) {
        
        let url = "\(ApiUrl)\(jsonURL)";
        print("API Url : \(url)")
        
        HttpService().postMethod(url: url,postData: postData, complete: { (response ) in
            complete(response);
        });
    };
    
  
    
}
