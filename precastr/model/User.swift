//
//  User.swift
//  precastr
//
//  Created by Macbook on 02/04/19.
//  Copyright © 2019 Macbook. All rights reserved.
//

import Foundation
class User  {
    var userId            : Int32!
    var email             : String!
    var facebookId        : String!
    var twitterId         : String!
    var isActive          : Bool!
    var isDeleted         : Bool!
    var createdOn         : String!
    var isCastr           : Int!
    var userCastSettingId : Int!
    
    func getUserData(userDataDict: NSDictionary)->User {
        let user = User();
        user.userId = userDataDict.value(forKey: "user_id") as? Int32;
        user.email = userDataDict.value(forKey: "username") as? String;
        user.facebookId = userDataDict.value(forKey: "facebook_id") as? String;
        user.twitterId = userDataDict.value(forKey: "twitter_id") as? String;
        user.isActive = userDataDict.value(forKey: "is_active") as? Bool;
        user.isDeleted = userDataDict.value(forKey: "is_deleted") as? Bool;
        user.createdOn = userDataDict.value(forKey: "created_on") as? String;
        user.isCastr = userDataDict.value(forKey: "is_caster") as? Int;
         user.userCastSettingId = userDataDict.value(forKey: "user_cast_setting_id") as? Int;
        return user;
    }
    
    
    func toDictionary(user:User)->[String:Any]{
        var userJson: [String: Any] = [:];
        userJson["user_id"] = user.userId;
        userJson["username"] = user.email;
        userJson["facebook_id"] = user.facebookId;
        userJson["twitter_id"] = user.twitterId;
        userJson["is_active"] = user.isActive;
        userJson["is_deleted"] = user.isDeleted;
        userJson["created_on"] = user.createdOn;
        userJson["is_caster"] = user.isCastr;
        userJson["user_cast_setting_id"] = user.userCastSettingId;
        return userJson;
    }
    func loadUserDataFromUserDefaults(userDataDict: UserDefaults) -> User {
        
        let user = User();
        user.userId = userDataDict.value(forKey: "user_id") as? Int32;
        user.email = userDataDict.value(forKey: "username") as? String;
        user.facebookId = userDataDict.value(forKey: "facebook_id") as? String;
        user.twitterId = userDataDict.value(forKey: "twitter_id") as? String;
        user.isActive = userDataDict.value(forKey: "is_active") as? Bool;
        user.isDeleted = userDataDict.value(forKey: "is_deleted") as? Bool;
        user.createdOn = userDataDict.value(forKey: "created_on") as? String;
        user.isCastr = userDataDict.value(forKey: "is_caster") as? Int;
        user.userCastSettingId = userDataDict.value(forKey: "user_cast_setting_id") as? Int;
        
        return user;
    }
    func loadUserDefaults(userDataDict:NSDictionary)->Void{
       
        setting.setValue(userId!, forKey: "user_id")
        setting.setValue(email!, forKey: "username")
        setting.setValue(facebookId!, forKey: "facebook_id")
        setting.setValue(twitterId!, forKey: "twitter_id")
        setting.setValue(isActive!, forKey: "is_active")
        setting.setValue(isDeleted!, forKey: "is_deleted")
        setting.setValue(createdOn!, forKey: "created_on")
        setting.setValue(isCastr!, forKey: "is_caster")
        setting.setValue(userCastSettingId!, forKey: "user_cast_setting_id")
        
    }
}
