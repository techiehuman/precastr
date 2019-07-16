//
//  PostManager.swift
//  precastr
//
//  Created by Cenes_Dev on 15/07/2019.
//  Copyright © 2019 Macbook. All rights reserved.
//

import Foundation
class PostManager {
    
    func updatePostStatus(post: Post, postStatusId: Int, complete: @escaping(NSDictionary)->Void) {
        let jsonURL = "posts/update_post_status/format/json";
        
        var postData = [String: Any]();
        postData["post_id"] = post.postId;
        postData["user_id"] = User().loadUserDataFromUserDefaults(userDataDict: setting).userId;
        postData["post_status_id"] = postStatusId;
        PostService().postDataMethod(jsonURL: jsonURL, postData: postData, complete: {(response) in
            complete(response);
        });
    }
    
    
    func publishPostOnTwitter(post: Post, complete: @escaping(NSDictionary) -> Void) {
        var postDataTwitter = [String: Any]();
        postDataTwitter["post_id"] = post.postId;
        postDataTwitter["user_id"] = User().loadUserDataFromUserDefaults(userDataDict: setting).userId;
        let jsonPostURL = "posts/publish_post_on_twitter/format/json";
        PostService().postDataMethod(jsonURL: jsonPostURL, postData: postDataTwitter, complete: {(response) in
            print(response);
            
            let statusCode = Int(response.value(forKey: "status") as! String)!
            if(statusCode != 0) {
                
                post.postStatusId = HomePostPublishStatusId.PUBLISHSTATUSID;
                post.status = "Published";
                
                self.updatePostStatus(post: post, postStatusId: HomePostPublishStatusId.PUBLISHSTATUSID, complete: {(response) in
                    complete(response);
                });
            } else {
                complete(response);
            }
        });
    }
    
    func publishOnFacebook(post: Post, complete: @escaping(NSDictionary) -> Void) {
        
        var postDataTwitter = [String: Any]();
        postDataTwitter["post_id"] = post.postId;
        postDataTwitter["user_id"] = User().loadUserDataFromUserDefaults(userDataDict: setting).userId;
        let jsonPostURL = "posts/publish_post_on_facebook/format/json";
        PostService().postDataMethod(jsonURL: jsonPostURL, postData: postDataTwitter, complete: {(response) in
            print(response);
            
            let statusCode = Int(response.value(forKey: "status") as! String)!
            if(statusCode != 0) {
                
                post.postStatusId = HomePostPublishStatusId.PUBLISHSTATUSID;
                post.status = "Published";
                
                self.updatePostStatus(post: post, postStatusId: HomePostPublishStatusId.PUBLISHSTATUSID, complete: {(response) in
                    complete(response);
                });
            } else {
                complete(response);
            }
        });
    }
}
