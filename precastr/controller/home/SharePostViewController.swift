//
//  SharePostViewController.swift
//  precastr
//
//  Created by Cenes_Dev on 12/02/2020.
//  Copyright © 2020 Macbook. All rights reserved.
//

import UIKit

class SharePostViewController: UIViewController {
    
    func adapterCasterGetPostStatusImage(status: String) -> String {
        
        var imageStatus = "";
        if (status == "Pending") {
            imageStatus = "pending-review"
        } else if (status == "Approved") {
            imageStatus = "approved"
        } else if (status == "Rejected") {
            imageStatus = "rejected"
        } else if(status == "Published") {
            imageStatus = "published"
        } else if(status == ""){
            imageStatus = ""
        }
        return imageStatus;
    }
}

class PostRows {
    static var Post_Status_Row: Int = 0;
    static var Post_Action_Row: Int = 1;
    static var Post_Description_Row: Int = 2;
    static var Post_Gallery_Row: Int = 3;
}

class PostRowsHeight {
    static var Post_Status_Row_Height: Int = 40;
    static var Post_Action_Row_Height: Int = 40;
    static var Post_Description_Row_Height: Int = 10;
    static var Post_Gallery_Row_Height: Int = 418;
}
