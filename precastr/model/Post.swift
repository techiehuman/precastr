//
//  Post.swift
//  precastr
//
//  Created by Cenes_Dev on 15/06/2019.
//  Copyright © 2019 Macbook. All rights reserved.
//

import Foundation
class Post {
    
    var postId: Int = 0;
    var postDescription: String = "";
    var postImages: [String] = [String]();
    var socialMediaIds: [Int] = [Int]();
    var status: String = "";
    var createdOn:String = "";
    var username: String = "";
    var profilePic: String = "";
    var name: String = "";
    var postStatusId: Int = 0;
    var postCommunications = [PostCommunication]();
    var castModerators = [User]();
    var postUserId : Int = 0;
    
    func loadPostFromDict(postDict: NSDictionary) -> Post {
        
        let post = Post();
        
        post.postId = Int(postDict.value(forKey: "id") as! String)!;
        post.postDescription = postDict.value(forKey: "post_description") as! String;
        
        post.postImages = [String]();
        let postImages = postDict.value(forKey: "post_images") as! NSArray
        if (postImages.count > 0) {
            for postImg in postImages {
                let postImageURL = postImg as! NSDictionary;
                let imgUrl: String = postImageURL.value(forKey: "image") as! String;
                post.postImages.append(imgUrl);
            }
        }
        
        post.socialMediaIds = [Int]();
        let sourcePlatformArray = postDict.value(forKey: "social_media") as! NSArray
        if (sourcePlatformArray.count > 0) {
            for sourcePlatform in sourcePlatformArray {
                let sourcePlatformDict = sourcePlatform as! NSDictionary;
                
                let sourcePlatformId = Int(((sourcePlatformDict.value(forKey: "id") as? NSString)?.doubleValue)!)
                post.socialMediaIds.append(sourcePlatformId);
            }
        }
        
        post.status = postDict.value(forKey: "status") as? String ?? "";
        post.createdOn = postDict.value(forKey: "created_on") as? String ?? "";
        post.username = postDict.value(forKey: "username") as? String ?? "";
        post.profilePic = postDict.value(forKey: "profile_pic") as? String ?? "";
        post.name = postDict.value(forKey: "name") as? String ?? "";
        post.postStatusId = Int(postDict.value(forKey: "post_status_id") as! String)!;
        post.postUserId = Int(postDict.value(forKey: "caster_user_id") as! String)!;
        
        if let castModerators = postDict.value(forKey: "cast_moderators") as?  NSArray {
            
            for castModerator in castModerators {
                let castModeratorDict = castModerator as! NSDictionary;
                post.castModerators.append(User().loadCastModeratorsFromDict(castModeratorDict: castModeratorDict));
            }
        }
        return post;
    }
    
    func loadPostsFromNSArray(postsArr: NSArray) -> [Post] {
    
        var posts = [Post]();
        
        for post in postsArr {
         
            let postDict = post as! NSDictionary;
            
            posts.append(loadPostFromDict(postDict: postDict));
        }
        return posts;
    }
}
