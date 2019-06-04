//
//  LoginScreenViewController.swift
//  precastr
//
//  Created by Cenes_Dev on 04/06/2019.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit

class LoginScreenViewController: UIViewController {

    
    @IBOutlet weak var loginTableView: UITableView!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView();
    
    class func MainViewController() -> UINavigationController{
        
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "navLogin") as! UINavigationController
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loginTableView.register(UINib.init(nibName: "LoginScreenTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "LoginScreenTableViewCell");
        self.hideKeyboadOnTapOutside();
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func validateLoginForm(user: User) -> Bool{
        
        var isValid = true;
        var message = "";
        if (user.username == "") {
            message = "Username cannot be empty"
            isValid = false
        } else if (user.password == "") {
            message = "Password cannot be empty"
            isValid = false
        }
        if(isValid==false){
            let alert = UIAlertController.init(title: "Error", message: message, preferredStyle: .alert);
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil));
            self.present(alert, animated: true)
        }
        return isValid;
        
    }
    func userManage(jsonURL:String,user : User)->Void{
        //iPhone or iPad
        //let model = UIDevice.current.model;
        user.userDevice = 2;//
        let userDefaults = UserDefaults.standard
        if let tokenDataStr = userDefaults.value(forKey: "tokenData") as? String {
            user.deviceToken = tokenDataStr;
        } else {
            user.deviceToken = "test";
        }
        
        activityIndicator.startAnimating();
        
        UserService().postDataMethod(jsonURL: jsonURL,postData:user.toDictionary(user: user),complete:{(response) in
            print(response);
            self.activityIndicator.stopAnimating();
            
            if (Int(response.value(forKey: "status") as! String)! == 1) {
                
                let message = response.value(forKey: "message") as! String;
                let data = response.value(forKey: "data") as! NSDictionary;
                let allStepsDone = Int32(data.value(forKey: "user_cast_setting_id") as! String)
                let userDefaultRole = Int8((data.value(forKey: "default_role") as? String)!) ?? nil
                print(allStepsDone)
                SocialPlatform().fetchSocialPlatformData();
                
                let userDict = response.value(forKey: "data") as! NSDictionary;
                print(userDict)
                let user = User().getUserData(userDataDict: userDict);
                user.loadUserDefaults();
                //If is the First Time user then we will send him to complete the steps.
                if (userDefaultRole == 0) {
                    
                    let viewController: UserTypeActionViewController = self.storyboard?.instantiateViewController(withIdentifier: "UserTypeActionViewController") as! UserTypeActionViewController;
                    self.navigationController?.pushViewController(viewController, animated: true);
                    print(self.navigationController);
                    
                } else if(userDefaultRole == 1){//If user type is casetr then we will let him choose the
                    // Posts cast type
                    if (allStepsDone == 0) {
                        let viewController: PrecastTypeSectionViewController = self.storyboard?.instantiateViewController(withIdentifier: "PrecastTypeSectionViewController") as! PrecastTypeSectionViewController;
                        self.navigationController?.pushViewController(viewController, animated: true);
                    } else {
                        UIApplication.shared.keyWindow?.rootViewController = HomeViewController.MainViewController()
                    }
                    
                } else if (userDefaultRole == 2){//If user is moderator
                    //Then we will be sending him to home screen.
                    UIApplication.shared.keyWindow?.rootViewController = HomeViewController.MainViewController()
                }
                
            } else {
                let message = response.value(forKey: "message") as! String;
                
                let alert = UIAlertController.init(title: "Error", message: message, preferredStyle: .alert);
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil));
                self.present(alert, animated: true)
            }
        })
    }

}

extension LoginScreenViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: LoginScreenTableViewCell = tableView.dequeueReusableCell(withIdentifier: "LoginScreenTableViewCell") as! LoginScreenTableViewCell;
        
        cell.loginViewControllerDelegate = self;
        
        activityIndicator.center = cell.center;
        activityIndicator.hidesWhenStopped = true;
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge;
        cell.addSubview(activityIndicator);
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (self.view.frame.height + 120);
    }
}

