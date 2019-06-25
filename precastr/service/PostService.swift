//
//  PostService.swift
//  precastr
//
//  Created by Cenes_Dev on 26/06/2019.
//  Copyright © 2019 Macbook. All rights reserved.
//

import Foundation

class PostService {
    
    func postDataMethod(jsonURL : String,postData: [String : Any], complete: @escaping(NSDictionary)->Void) {
        
        let url = "\(ApiUrl)\(jsonURL)";
        print("API Url : \(url)")
        
        HttpService().postMethod(url: url,postData: postData, complete: { (response ) in
            complete(response);
        });
    };
    
}
