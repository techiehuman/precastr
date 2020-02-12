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
