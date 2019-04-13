//
//  UserService.swift
//  precastr
//
//  Created by Macbook on 11/04/19.
//  Copyright © 2019 Macbook. All rights reserved.
//

import Foundation



class UserService{
    
    let registeration = "user/registration/format/json";
    let login = "user/login/format/json";
    let update_caster_type_api = "user/update_precast_type/format/json";
    
    func postUser(jsonURL : String,postData: [String : Any], complete: @escaping(NSDictionary)->Void) {
        
        let url = "\(ApiUrl)\(jsonURL)";
        print("API Url : \(url)")
        
        HttpService().postMethod(url: url,postData: postData, complete: { (response ) in
            complete(response);
        });
    };
    
    func updateCasterType(postData: [String: Any], complete: @escaping(NSDictionary)->Void) {
        
        let url = "\(ApiUrl)\(update_caster_type_api)";
        print("API Url : \(url)")
        
        HttpService().postMethod(url: url,postData: postData, complete: { (response ) in
            complete(response);
        });
    }
    
}
