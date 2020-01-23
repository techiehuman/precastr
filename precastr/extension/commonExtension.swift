//
//  commonExtension.swift
//  precastr
//
//  Created by mandeep singh on 25/06/19.
//  Copyright © 2019 Macbook. All rights reserved.
//

import Foundation

func loadPostStatus()->[PostStatus]{
    let jsonURL = "home/get_all_post_status/format/json"
    var postData = [PostStatus]();
    
    UserService().getDataMethod(jsonURL: jsonURL, complete: {(response) in
        print(response)
        let modeArray = response.value(forKey: "data") as! NSArray
        postData = PostStatus().loadPostStatusFromNSArray(postStatusArr: modeArray);
    });
    return postData;
}

func getNameInitials(name: String ) -> String {
    
    let nameArray = name.split(separator: " ");
    var initialString = "";
    for array in nameArray{
        initialString += String(array.prefix(1))
    }
    return initialString.uppercased();
}
