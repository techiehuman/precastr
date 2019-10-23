//
//  UserTypeActionViewController.swift
//  precastr
//
//  Created by Macbook on 12/04/19.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit

class UserTypeActionViewController: UIViewController {

    @IBOutlet weak var casterButton: UIButton!
    
    @IBOutlet weak var moderatorButton: UIButton!
    
    var loggedInUser : User!
    
    var userRoleVar = 0;
    
    @IBOutlet weak var loggedInNameUser: UILabel!
    
    @IBOutlet weak var userProfilePic: UIImageView!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView();

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loggedInUser = User().loadUserDataFromUserDefaults(userDataDict : setting);
        userProfilePic.roundImageView();
        userProfilePic.layer.borderWidth = 2
        userProfilePic.layer.borderColor = UIColor.white.cgColor
        
        //userProfilePic.image = UIImage(url:URL(string: "\(siteURL)\(loggedInUser.profilePic!)"))
        loggedInNameUser.text = String(loggedInUser.name)
        print(loggedInUser.name)
        if(String(loggedInUser.profilePic) != ""){
        userProfilePic.sd_setImage(with: URL(string: loggedInUser.profilePic!), placeholderImage: UIImage.init(named: "Profile 1"));
            // Do any additional setup after loading the view.
        }
        
        activityIndicator.center = view.center;
        activityIndicator.hidesWhenStopped = true;
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge;
        view.addSubview(activityIndicator);

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func casterButtonAction(_ sender: Any) {
        self.userRoleVar = 1
       self.updateUserType(userRole: 1)
        /*let viewController: UINavigationController = self.storyboard?.instantiateViewController(withIdentifier: "precastTypeNav") as! UINavigationController;
        UIApplication.shared.keyWindow?.rootViewController = viewController;*/

    }
    
    @IBAction func moderatorButtonAction(_ sender: Any) {
        self.userRoleVar = 2
        self.updateUserType(userRole: 2)
        let viewController: VerificationModeratorViewController = self.storyboard?.instantiateViewController(withIdentifier: "VerificationModeratorViewController") as! VerificationModeratorViewController;
        self.navigationController?.pushViewController(viewController, animated: true);
    }
    
    func updateUserType(userRole : Int8) {
        
        activityIndicator.startAnimating();
        UIApplication.shared.beginIgnoringInteractionEvents();
        
        var postData = [String: Any]();
        postData["user_id"] = self.loggedInUser.userId
        postData["role_id"] = userRole
        let jsonURL = "user/add_user_role/format/json";
        UserService().postDataMethod(jsonURL: jsonURL,postData:postData,complete:{(response) in
            print(response)
            
            if (Int(response.value(forKey: "status") as! String)! == 1) {
                self.loggedInUser.isCastr  = userRole
                self.loggedInUser.loadUserDefaults();
                
                
                    self.castType();
                
            }
            
        });
    }
    
    func castType() {
        var postData = [String : Any]()
        postData["user_id"] = loggedInUser.userId
        postData["cast_setting_id"] = 1;//zCommentates
        let jsonURL = "user/update_precast_type/format/json";
        
        UserService().postDataMethod(jsonURL:jsonURL,postData: postData, complete:{(response) in
            let status = Int(response.value(forKey: "status") as! String)!
            if (status == 0) {
                let message = response.value(forKey: "message") as! String;
                self.showAlert(title: "Error", message: message);
                
            } else {
                self.activityIndicator.stopAnimating();
                UIApplication.shared.endIgnoringInteractionEvents();
                
                let userDict = response.value(forKey: "data") as! NSDictionary;
                print(userDict)
                let user = User().getUserData(userDataDict: userDict);
                user.loadUserDefaults();
                if(self.userRoleVar == 1){
                UIApplication.shared.keyWindow?.rootViewController = HomeViewController.MainViewController();
                }
            }
        });
    }
   
}
