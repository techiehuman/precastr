//
//  PrecastTypeSectionViewController.swift
//  precastr
//
//  Created by Macbook on 12/04/19.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit

class PrecastTypeSectionViewController: UIViewController {

    var loggedInUser : User!
    override func viewDidLoad() {
        super.viewDidLoad()
        loggedInUser = User().loadUserDataFromUserDefaults(userDataDict : setting);
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func multipleButtonClicked(_ sender: AnyObject) {
        var cast_setting_id = 0;
        
        switch sender.tag {
        case 1: cast_setting_id = 1 //button1
        break;
        case 2: cast_setting_id = 2 //button2
        break;
        case 3: cast_setting_id = 3 //button3
        break;
       
        default: cast_setting_id = 1
        break;
        }
        
    
        
        var postData = [String : Any]()
        postData["user_id"] = loggedInUser.userId
        postData["cast_setting_id"] = cast_setting_id;
        let jsonURL = "user/update_precast_type/format/json";
        
        UserService().postDataMethod(jsonURL:jsonURL,postData: postData, complete:{(response) in
            let userDict = response.value(forKey: "data") as! NSDictionary;
            print(userDict)
            let user = User().getUserData(userDataDict: userDict);
            user.loadUserDefaults();
            let viewController: CastModeratorViewController = self.storyboard?.instantiateViewController(withIdentifier: "CastModeratorViewController") as! CastModeratorViewController;
            self.navigationController?.pushViewController(viewController, animated: true);
            
        });
    }
    
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
