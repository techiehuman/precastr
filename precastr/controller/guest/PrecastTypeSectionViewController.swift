//
//  PrecastTypeSectionViewController.swift
//  precastr
//
//  Created by Macbook on 12/04/19.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit

class PrecastTypeSectionViewController: UIViewController {

    
    @IBOutlet weak var handView: UIView!
    
    @IBOutlet weak var commentView: UIView!
    
    @IBOutlet weak var timeView: UIView!
    
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var moderateCheckBoxBtn: UIButton!
    
    @IBOutlet weak var commentateCheckBoxBtn: UIButton!
    
    
    @IBOutlet weak var setIntervalCheckBoxBtn: UIButton!
    var cast_setting_id = 0;
    
    @IBAction func submitBtnClicked(_ sender: Any) {
        var postData = [String : Any]()
        postData["user_id"] = loggedInUser.userId
        postData["cast_setting_id"] = self.cast_setting_id;
        let jsonURL = "user/update_precast_type/format/json";
        
        UserService().postDataMethod(jsonURL:jsonURL,postData: postData, complete:{(response) in
            let userDict = response.value(forKey: "data") as! NSDictionary;
            print(userDict)
            let user = User().getUserData(userDataDict: userDict);
            user.loadUserDefaults();
            
            UIApplication.shared.keyWindow?.rootViewController = HomeViewController.MainViewController();
        });
    }
    var loggedInUser : User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        handView.roundView()
        commentView.roundView();
        timeView.roundView();
        
        profilePic.roundImageView()
        
        loggedInUser = User().loadUserDataFromUserDefaults(userDataDict : setting);
        
        self.moderateCheckBoxBtn.blueBorderWrap()
        self.commentateCheckBoxBtn.blueBorderWrap()
        self.setIntervalCheckBoxBtn.blueBorderWrap()
        // Do any additional setup after loading the view.
        if(String(loggedInUser.profilePic) != ""){
            profilePic.sd_setImage(with: URL(string: loggedInUser.profilePic!), placeholderImage: UIImage.init(named: "my-account-black"));
            // Do any additional setup after loading the view.
        }else{
            let profileImage: UIImage = UIImage(named: "my-account-black")!
            profilePic.image = profileImage
        }
        
        self.setupNavigationBarItems();

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setupNavigationBarItems();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupNavigationBarItems() {
        
        self.navigationController?.navigationBar.isHidden = false;
        self.navigationItem.title = "How would you like to preCast?";
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil);
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil);
        
    }
    
    @IBAction func multipleButtonClicked(_ sender: AnyObject) {
       
        switch sender.tag {
        case 1: self.cast_setting_id = 1 //button1
        self.moderateCheckBoxBtn.checkedBtnState()
        self.commentateCheckBoxBtn.blueBorderWrap()
        self.setIntervalCheckBoxBtn.blueBorderWrap()
        break;
        case 2: self.cast_setting_id = 2 //button2
        self.moderateCheckBoxBtn.blueBorderWrap()
        self.commentateCheckBoxBtn.checkedBtnState()
        self.setIntervalCheckBoxBtn.blueBorderWrap()
        break;
        case 3: self.cast_setting_id = 3 //button3
        self.moderateCheckBoxBtn.blueBorderWrap()
        self.commentateCheckBoxBtn.blueBorderWrap()
        self.setIntervalCheckBoxBtn.checkedBtnState()
        break;
       
        default: self.cast_setting_id = 1
        break;
        }
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
