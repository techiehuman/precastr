//
//  SocialPlatform.swift
//  precastr
//
//  Created by Macbook on 17/05/19.
//  Copyright © 2019 Macbook. All rights reserved.
//

import Foundation
class SocialPlatform {
    var socialPlatformId  = [String:Int]()
    
    
    func loadSocialDefaults()->Void{
        setting.setValue(self.socialPlatformId, forKey: "socialPlatform")
    }
    
    func fetchSocialPlatformData() {
       let jsonURL = "home/get_all_social_media_platform/format/json";
        let postData = [String : Any]()
        UserService().postDataMethod(jsonURL: jsonURL,postData:postData,complete:{(response) in
            print(response)
            let status = Int(response.value(forKey: "status") as! String)!
            if(status == 1){
            let data = response.value(forKey: "data") as! NSArray;
            for social in data{
                
                let socialDict = social as! NSDictionary;
                self.socialPlatformId[(socialDict.value(forKey: "title") as! String)] = Int(((socialDict.value(forKey: "id") as? NSString)?.doubleValue)!);
               // Int(((((sourcePlatformArray![0]) as! NSDictionary).value(forKey: "id") as? NSString)?.doubleValue)!)
            }
            /*self.fbId = (data[0] as! NSDictionary).value(forKey: "id") as! Int32
            self.fbTitle = (data[0] as! NSDictionary).value(forKey: "title") as! String
            self.twitterId = (data[1] as! NSDictionary).value(forKey: "id") as! Int32
            self.twitterTitle = (data[1] as! NSDictionary).value(forKey: "title") as! String*/
            self.loadSocialDefaults();
        }else{
           // let message = response.value(forKey: "message") as! String;
            //self.showAlert(title: "Error", message: message);
        }
            })
    }
    func loadSocialDataFromUserDefaults() -> SocialPlatform {
        
        let social = SocialPlatform();
        if let socialPlatformId = (setting.value(forKey: "socialPlatform") as? [String: Int]) {
            social.socialPlatformId = socialPlatformId;
        }
        return social;
    }
}
