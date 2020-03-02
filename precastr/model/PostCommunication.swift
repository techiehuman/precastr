//
//  PostCommunication.swift
//  precastr
//
//  Created by Cenes_Dev on 23/06/2019.
//  Copyright © 2019 Macbook. All rights reserved.
//

import Foundation
class PostCommunication {
    
    var postCommunicationId: Int = 0;
    var postId: Int = 0;
    var communicatedByUserId: Int = 0;
    var commentedOn: String = "";
    var commentedOnTimestamp: Int = 0;
    var postCommunicationDescription: String = "";
    var postStatusId: Int = 0;
    var commentStatus: String = "";
    var communicatedUsername: String = "";
    var communicatedProfilePic: String = "";
    var communicatedName: String = "";
    var attachments = [PostCommunicationAttachment]();
    
    func loadCommmunicationDataFromDictionary(commDict: NSDictionary) -> PostCommunication {
        
        var postCommunication = PostCommunication();
        postCommunication.postCommunicationId = Int(commDict.value(forKey: "id") as! String)!;
        postCommunication.postId = Int(commDict.value(forKey: "post_id") as! String)!;
        postCommunication.communicatedByUserId = Int(commDict.value(forKey: "communicated_by_user_id") as! String)!;
        postCommunication.postCommunicationDescription = commDict.value(forKey: "post_communication_description") as! String;
        //postCommunication.commentStatus = commDict.value(forKey: "status") as! String;
        postCommunication.communicatedUsername = commDict.value(forKey: "communicated_username") as! String;
        postCommunication.communicatedProfilePic = commDict.value(forKey: "communicated_profile_pic") as! String;
        postCommunication.communicatedName = commDict.value(forKey: "communicated_name") as! String;
        postCommunication.commentedOn = commDict.value(forKey: "created_on") as! String;
        let createdTimestamp = commDict.value(forKey: "created_on_timestamp") as! String;
        if (createdTimestamp == "") {
            postCommunication.commentedOnTimestamp = 0;
        } else {
            postCommunication.commentedOnTimestamp = Int(createdTimestamp)!;
        }
        postCommunication.attachments = loadCommunicationAttachmentsFromNSArray(attachmentsArr: commDict.value(forKey: "attachments") as!NSArray)
        
        return postCommunication;
    }
    
    func loadCommunicationsFromNsArray(commArray: NSArray) -> [PostCommunication]{
        var postAttachments = [PostCommunication]();
        
        for comm in commArray {
            let commDict = comm as! NSDictionary;
            
            postAttachments.append(loadCommmunicationDataFromDictionary(commDict: commDict));
        }
        
        return postAttachments;
    }
    
    func loadCommunicationAttachmentsFromNSArray(attachmentsArr: NSArray) -> [PostCommunicationAttachment]{
        
        var postAttachments = [PostCommunicationAttachment]();
        
        for attachment in attachmentsArr {
            let attachmentDict = attachment as! NSDictionary;
            
            var postCommAttachment = PostCommunicationAttachment();
            postCommAttachment.postCommunicationId = Int(attachmentDict.value(forKey: "post_communication_id") as! String)!;
            postCommAttachment.image = attachmentDict.value(forKey: "image") as! String;
            
            postAttachments.append(postCommAttachment);
        }
        return postAttachments;
    }
}

class PostCommunicationAttachment {
    var postCommunicationId: Int = 0;
    var image: String = "";
}


