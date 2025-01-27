//
//  User.swift
//  precastr
//
//  Created by Macbook on 02/04/19.
//  Copyright © 2019 Macbook. All rights reserved.
//

import Foundation
class User  {
    var userId              : Int32!
    var username            : String!
    var name                : String!
    var password            : String!
    var facebookId          : String!
    var facebookAccessToken : String!
    var isFacebook          : Int8!
    var twitterId           : String!
    var twitterAccessToken  : String!
    var twitterAccessSecret : String!
    var isTwitter           : Int8!
    var isActive            : Bool!
    var isDeleted           : Bool!
    var createdOn           : String!
    var isCastr             : Int8!
    var userCastSettingId   : Int32!
    var userDevice          : Int8!
    var deviceToken         : String!
    var profilePic          : String!
    var miscStatus          : Int!
    var casterReferalCode   : String!
    var countryCode         : String!
    var phoneNumber         : String!
    var tokens              : NSArray!;
    var status              : Int8!;
    var moderatorStatus     : Int8!;
    var categoryId              : Int!;

    func getUserData(userDataDict: NSDictionary)->User {
        let user = User();
        user.userId = Int32(userDataDict.value(forKey: "user_id") as! String);
        user.username = userDataDict.value(forKey: "username") as? String;
        user.name = userDataDict.value(forKey: "name") as? String;
        user.facebookId = userDataDict.value(forKey: "facebook_id") as? String;
        user.facebookAccessToken = userDataDict.value(forKey: "facebook_access_token") as? String;
        user.isFacebook = userDataDict.value(forKey: "is_facebook")as? Int8;
        user.twitterId = userDataDict.value(forKey: "twitter_id") as? String;
        user.twitterAccessToken = userDataDict.value(forKey: "twitter_access_token") as? String;
        user.twitterAccessSecret = userDataDict.value(forKey: "twitter_access_secret") as? String;
        user.isTwitter = userDataDict.value(forKey: "is_twiter")as? Int8;
        user.isActive = userDataDict.value(forKey: "is_active") as? Bool;
        user.profilePic = userDataDict.value(forKey: "profile_pic") as? String;
        user.isDeleted = userDataDict.value(forKey: "is_deleted") as? Bool;
        user.createdOn = userDataDict.value(forKey: "created_on") as? String;
        user.isCastr = Int8(userDataDict.value(forKey: "default_role") as! String);
        user.userCastSettingId = Int32(userDataDict.value(forKey: "user_cast_setting_id") as! String);
        user.userDevice = userDataDict.value(forKey: "device_registered_from")as? Int8;
        user.deviceToken = userDataDict.value(forKey: "device_token")as? String;
        user.casterReferalCode = userDataDict.value(forKey: "caster_referral_code")as? String;
        user.countryCode = userDataDict.value(forKey: "country_code")as? String;
        user.phoneNumber = userDataDict.value(forKey: "phone_number")as? String;
        user.tokens = userDataDict.value(forKey: "tokens")as? NSArray;
        
        if let status = userDataDict.value(forKey: "status") as? String {
            user.status = Int8(status);
        }
        
        if let moderatorStatus = userDataDict.value(forKey: "moderator_status") as? String {
            user.moderatorStatus = Int8(moderatorStatus);
        }
        
        if let categoryId = userDataDict.value(forKey: "category_id") as? String {
            user.categoryId = Int(categoryId);
        }

        return user;
    }
    
    
    func toDictionary(user:User)->[String:Any]{
        var userJson: [String: Any] = [:];
        userJson["user_id"] = user.userId;
        userJson["username"] = user.username;
        userJson["name"] = user.name
        userJson["password"] = user.password;
        userJson["facebook_id"] = user.facebookId;
        userJson["is_facebook"] = user.isFacebook
        userJson["facebook_access_token"] = user.facebookAccessToken
        userJson["twitter_id"] = user.twitterId;
        userJson["twitter_access_token"] = user.twitterAccessToken
        userJson["twitter_access_secret"] = user.twitterAccessSecret
        userJson["is_twiter"] = user.isTwitter;
        userJson["country_code"] = user.countryCode;
        userJson["phone_number"] = user.phoneNumber
        if (user.isTwitter == 1) {
            var token = "";
            token = token + "{\"twitter_access_token\":\"\(user.twitterAccessToken!)\"";
            token = token + ",\"twitter_access_secret\":\"\(user.twitterAccessSecret!)\"";
            token = token + ",\"email\":\"\(user.username!)\"";
            token = token + ",\"twitter_id\":\"\(user.twitterId!)\"}";
            userJson["token"] = "\(token)";
        } else if (user.isFacebook == 1) {
            var token = "";
            
            token = token + "{\"facebook_access_token\":\"\(user.facebookAccessToken!)\"";
            token = token + ",\"email\":\"\(user.username!)\"";
            token = token + ",\"facebook_id\":\"\(user.facebookId!)\"}";
            userJson["token"] = token;
        }
       
        userJson["is_active"] = user.isActive;
        userJson["is_deleted"] = user.isDeleted;
        userJson["created_on"] = user.createdOn;
        userJson["default_role"] = user.isCastr;
        userJson["user_cast_setting_id"] = user.userCastSettingId;
        userJson["device_registered_from"] = user.userDevice
        userJson["device_token"] = user.deviceToken
        userJson["profile_pic"] = user.profilePic
        return userJson;
    }

    func loadUserDataFromUserDefaults(userDataDict: UserDefaults) -> User {
        let user = User();
        user.userId = userDataDict.value(forKey: "user_id") as? Int32;
        user.username = userDataDict.value(forKey: "username") as? String;
        user.name = userDataDict.value(forKey: "name") as? String;
        user.password = userDataDict.value(forKey: "password") as? String;
        user.facebookId = userDataDict.value(forKey: "facebook_id") as? String;
        user.isFacebook = userDataDict.value(forKey: "is_facebook")as? Int8;
        user.twitterAccessToken = userDataDict.value(forKey: "facebook_access_token") as? String;
        user.twitterId = userDataDict.value(forKey: "twitter_id") as? String;
        user.twitterAccessToken = userDataDict.value(forKey: "twitter_access_token") as? String;
        user.twitterAccessSecret = userDataDict.value(forKey: "twitter_access_secret") as? String;
        user.isTwitter = userDataDict.value(forKey: "is_twiter")as? Int8;
        user.isActive = userDataDict.value(forKey: "is_active") as? Bool;
        
        user.isDeleted = userDataDict.value(forKey: "is_deleted") as? Bool;
        user.createdOn = userDataDict.value(forKey: "created_on") as? String;
        user.isCastr = userDataDict.value(forKey: "default_role") as? Int8;
        user.userCastSettingId = userDataDict.value(forKey: "user_cast_setting_id") as? Int32;
        user.userDevice = userDataDict.value(forKey: "device_registered_from")as? Int8;
        user.deviceToken = userDataDict.value(forKey: "device_token")as? String;
        user.profilePic = userDataDict.value(forKey: "profile_pic")as? String;
        user.casterReferalCode = userDataDict.value(forKey: "caster_referral_code")as? String;
        user.countryCode = userDataDict.value(forKey: "country_code")as? String;
        user.phoneNumber = userDataDict.value(forKey: "phone_number")as? String;
        user.tokens = userDataDict.value(forKey: "tokens")as? NSArray;

        return user;
    }
    func loadUserDefaults()->Void{
       
        setting.setValue(self.userId!, forKey: "user_id")
        setting.setValue(self.username!, forKey: "username")
        setting.setValue(self.name!, forKey: "name")
        setting.setValue(self.facebookId!, forKey: "facebook_id")
        setting.setValue(self.isFacebook, forKey: "is_facebook")
        setting.setValue(self.facebookAccessToken, forKey: "facebook_access_token")
        setting.setValue(self.twitterId!, forKey: "twitter_id")
        setting.setValue(self.twitterAccessToken, forKey: "twitter_access_token")
        setting.setValue(self.twitterAccessSecret, forKey: "twitter_access_secret")
        setting.setValue(self.isTwitter, forKey: "is_twiter")
        //setting.setValue(self.isActive!, forKey: "is_active")
        setting.setValue(self.isCastr, forKey: "default_role")
        setting.setValue(self.userCastSettingId!, forKey: "user_cast_setting_id")
        setting.setValue(self.profilePic, forKey: "profile_pic")
        setting.setValue(self.casterReferalCode, forKey: "caster_referral_code");
        setting.setValue(self.countryCode, forKey: "country_code");
        setting.setValue(self.phoneNumber, forKey: "phone_number");
        setting.setValue(self.tokens, forKey: "tokens");
        //setting.setValue(self.userDevice!, forKey: "device_registered_from")
        //setting.setValue(self.deviceToken, forKey: "device_token")
    }
    
    func loadCastModeratorsFromDict(castModeratorDict: NSDictionary) -> User {
        
        let user = User();
        user.name = castModeratorDict.value(forKey: "name") as! String;
        
        user.userId = Int32(castModeratorDict.value(forKey: "user_id") as! String);

        if let photo = castModeratorDict.value(forKey: "profile_pic") as? String {
            user.profilePic = photo;
        }
        
        if let phoneNumber = castModeratorDict.value(forKey: "phone_number") as? String {
            user.phoneNumber = phoneNumber;
        }
        if let countryCode = castModeratorDict.value(forKey: "country_code") as? String {
            user.countryCode = countryCode;
        }
        
        if let username = castModeratorDict.value(forKey: "username") as? String {
            user.username = username;
        }
        return user;
    }
    
    func updateUserData(userData: [String: String]) {
        
        if (userData["name"] != nil) {
            setting.setValue(userData["name"], forKey: "name")
        }
        if (userData["username"] != nil) {
            setting.setValue(userData["username"], forKey: "username")
        }
        if (userData["profile_pic"] != nil) {
            setting.setValue(userData["profile_pic"], forKey: "profile_pic")
        }
        if (userData["country_code"] != nil) {
            setting.setValue(userData["country_code"], forKey: "country_code")
        }
        if (userData["phone_number"] != nil) {
            setting.setValue(userData["phone_number"], forKey: "phone_number")
        }
        if (userData["facebook_id"] != nil) {
            setting.setValue(userData["facebook_id"], forKey: "facebook_id")
        }
    }
    
    func updateUserRole(roleId: Int8) {
            setting.setValue(roleId, forKey: "default_role")
    }
}
