//
//  UserSocialMedia.swift
//  precastr
//
//  Created by Cenes_Dev on 10/03/2020.
//  Copyright © 2020 Macbook. All rights reserved.
//

import Foundation

class UserSocialMedia {
    
    var userSocialMediaId: Int!;
    var userId: Int!;
    var type: String!;
    var token: String!;
    var email: String!;
    
    func populationUserSocialMediaFromArray(socialMediaArr: NSArray) -> [UserSocialMedia] {
        
        var userSocialMedias = [UserSocialMedia]();
        
        for tokenObj in socialMediaArr {
            let tokenDict = tokenObj as! NSDictionary;
            do {
                var tokenVlaue = tokenDict.value(forKey: "token") as! String;
                let con = try JSONSerialization.jsonObject(with: tokenVlaue.data(using: .utf8)!, options: []) as! [String:Any];

                if let fbAccessToken = con["facebook_access_token"] as? String {
                    let userSocialMedia = UserSocialMedia();
                    userSocialMedia.token = fbAccessToken;
                    userSocialMedia.type = "Facebook";
                    if let fbEmail = con["email"] as? String {
                        userSocialMedia.email = fbEmail;
                    }
                    userSocialMedias.append(userSocialMedia);
                }
                if let twAccessToken = con["twitter_access_token"] as? String {
                    if let twEmail = con["email"] as? String {
                        
                        let userSocialMedia = UserSocialMedia();
                        userSocialMedia.token = twAccessToken;
                        userSocialMedia.type = "Twitter";
                        if let fbEmail = con["email"] as? String {
                            userSocialMedia.email = twEmail;
                        }
                        userSocialMedias.append(userSocialMedia);
                    }
                }
            } catch {
                print(error)
            }
        }
        
        return userSocialMedias;
    }
}
