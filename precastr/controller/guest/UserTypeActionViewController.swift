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
    
    @IBOutlet weak var loggedInNameUser: UILabel!
    
    @IBOutlet weak var userProfilePic: UIImageView!
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
        userProfilePic.sd_setImage(with: URL(string: loggedInUser.profilePic!), placeholderImage: UIImage.init(named: "my-account-black"));
        // Do any additional setup after loading the view.
        }else{
            let profileImage: UIImage = UIImage(named: "my-account-black")!
            userProfilePic.image = profileImage
        }
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
       self.updateUserType(userRole: 1)
        let viewController: UINavigationController = self.storyboard?.instantiateViewController(withIdentifier: "precastTypeNav") as! UINavigationController;
        UIApplication.shared.keyWindow?.rootViewController = viewController;
    }
    
    @IBAction func moderatorButtonAction(_ sender: Any) {
        self.updateUserType(userRole: 2)
        let viewController: VerificationModeratorViewController = self.storyboard?.instantiateViewController(withIdentifier: "VerificationModeratorViewController") as! VerificationModeratorViewController;
        self.navigationController?.pushViewController(viewController, animated: true);
    }
    func updateUserType(userRole : Int8) {
        var postData = [String: Any]();
        postData["user_id"] = self.loggedInUser.userId
        postData["role_id"] = userRole
        let jsonURL = "user/add_user_role/format/json";
        UserService().postDataMethod(jsonURL: jsonURL,postData:postData,complete:{(response) in
            print(response)
            if (Int(response.value(forKey: "status") as! String)! == 1) {
                self.loggedInUser.isCastr  = userRole
                self.loggedInUser.loadUserDefaults()
            }
            
        });
    }
   
}
