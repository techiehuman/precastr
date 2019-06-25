//
//  PostStatus.swift
//  precastr
//
//  Created by mandeep singh on 25/06/19.
//  Copyright © 2019 Macbook. All rights reserved.
//

import Foundation

class PostStatus {
    
    var postStatusId: Int = 0;
    var title: String = "";
    
    func loadPostStatusFromDict(postStatusDict: NSDictionary) -> PostStatus{
        
        let postStatus = PostStatus();
        postStatus.postStatusId = Int(postStatusDict.value(forKey: "id") as! String)!;
        postStatus.title = postStatusDict.value(forKey: "title") as! String;
        
        return postStatus;
    }
    
    func loadPostStatusFromNSArray(postStatusArr: NSArray) -> [PostStatus] {
        
        var postStatuses = [PostStatus]();
        
        for postStatus in postStatusArr {
            let postStatusDict = postStatus as! NSDictionary;
            postStatuses.append(loadPostStatusFromDict(postStatusDict: postStatusDict));
        }
        
        return postStatuses;
    }
    
    
}
