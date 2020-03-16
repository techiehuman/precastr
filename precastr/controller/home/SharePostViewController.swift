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
    
    func scrollTableToPosition(indexPath: IndexPath, postsTableView : UITableView) {
        postsTableView.scrollToRow(at: indexPath, at: .top, animated: true);
    }
    func schemeAvailable(scheme: String) -> Bool {
        if let url = URL(string: scheme) {
            return UIApplication.shared.canOpenURL(url)
        }
        return false
    }
    func showFacebookFailAlert() {
        
        var refreshAlert = UIAlertController(title: "Facebook Not Installed", message: "It looks like the Facebook app is not installed on your iPhone. Click \"OK\" to download, after installing please \"LOG IN\" to the \"FB App\" and come back to the same screen on \"PreCastr\" and hit the \"Push to FB\" button", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            if let url = URL(string: "https://apps.apple.com/in/app/facebook/id284882215") {
                UIApplication.shared.open(url)
            }
        }));
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
            
            
        }));
        self.present(refreshAlert, animated: true, completion: nil)
        
    }
    
    func extractWebsiteFromText(text: String) -> String {
        //let input = "This is a test with the URL https://www.hackingwithswift.com to be detected."
        
        var websiteUrl = "";
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector.matches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count))

        var finalUrl = "";
        for match in matches {
            guard let range = Range(match.range, in: text) else { continue }
            websiteUrl = text.substring(with: range);
            print(websiteUrl)
        }
        return websiteUrl;
    }
}

class PostRows {
    static var Post_Status_Row: Int = 0;
    static var Post_Action_Row: Int = 1;
    static var Post_Description_Row: Int = 2;
    static var Post_WebsiteInfo_Row: Int = 3;
    static var Post_Gallery_Row: Int = 4;
}

class PostRowsHeight {
    static var Post_Status_Row_Height: Int = 40;
    static var Post_Action_Row_Height: Int = 40;
    static var Post_Description_Row_Height: Int = 25;
    static var Post_WebsiteInfo_Row_Height: Int = 100;
    static var Post_Gallery_Row_Height: Int = 418;
    static var Post_Moderator_Status_Row_Height: Int = 70;

}
