//
//  LoginStep1ViewController.swift
//  precastr
//
//  Created by Macbook on 02/04/19.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import TwitterKit
import TwitterCore

class LoginStep1ViewController: UIViewController {
    
    
    class func MainViewController() -> UINavigationController{
        
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "navLogin") as! UINavigationController
        
    }
    
    @IBOutlet weak var facebookButton:UIButton!
    @IBOutlet weak var twitterButton:UIButton!
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = UIColor(red: 12/255, green: 111/255, blue: 233/255, alpha: 1)
        self.emailTextField.attributedPlaceholder = NSAttributedString(string: "Email Address", attributes: [NSAttributedStringKey.foregroundColor : UIColor.white ])
        self.passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedStringKey.foregroundColor : UIColor.white ])
        self.emailTextField.layer.borderColor = UIColor.white.cgColor
        self.emailTextField.layer.borderWidth = 0.5
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        let image = UIImage(named: "email");
        imageView.image = image;
        self.emailTextField.leftView = imageView
        self.emailTextField.leftViewMode = .always

        
       // self.emailTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width:15, height: self.emailTextField.frame.height))
        self.passwordTextField.layer.borderColor = UIColor.white.cgColor
        self.passwordTextField.layer.borderWidth = 0.5
        self.passwordTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width:35, height: self.passwordTextField.frame.height))
        
        let imageViewP = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        let imageP = UIImage(named: "password");
        imageViewP.image = imageP;
        self.passwordTextField.leftView = imageViewP
        self.passwordTextField.leftViewMode = .always
        
    }
        
    
    override func viewWillAppear(_ animated: Bool) {
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func twitterButtonClicked(_ sender: Any) {
        // Swift
        // Get the current userID. This value should be managed by the developer but can be retrieved from the TWTRSessionStore.
        let store = TWTRTwitter.sharedInstance().sessionStore
        if let userID = store.session()?.userID {
            store.logOutUserID(userID)
        }
        
        TWTRTwitter.sharedInstance().logIn { (session, error) in
            if (session != nil) {
                let user = User();
                let name = session?.userName ?? ""
               
                print(session?.userID  ?? "")
                print(session?.authToken  ?? "")
                print(session?.authTokenSecret  ?? "")
                
                
                user.twitterAccessToken = session?.authToken
                user.twitterAccessSecret = session?.authTokenSecret
                user.twitterId = session?.userID
                user.username = name
                user.isTwitter = 1;
                
                let loginURL = "user/login/format/json";
                
                print(user.toDictionary(user: user ))
                self.userManage(jsonURL:loginURL,user: user,requestType: "");
                
                
            }else {
                print("error: \(String(describing: error?.localizedDescription))");
            }
        }
    }
    
    @IBAction func facebookButtonClicked(_ sender: Any) {
        let fbloginManger: FBSDKLoginManager = FBSDKLoginManager()
    /*CODE FOR LOGOUT */
        FBSDKAccessToken.setCurrent(nil)
        FBSDKProfile.setCurrent(nil)

        FBSDKLoginManager().logOut()
        let cookies = HTTPCookieStorage.shared
        let facebookCookies = cookies.cookies(for: URL(string: "https://facebook.com/")!)
        for cookie in facebookCookies! {
            cookies.deleteCookie(cookie )
        }
        /* CODE FOR LOGOUT */
        fbloginManger.logIn(withReadPermissions: ["email"], from:self) {(result, error) -> Void in
            if(error == nil){
                let fbLoginResult: FBSDKLoginManagerLoginResult  = result!
                
                if( result?.isCancelled)!{
                    return }
                
                
                if(fbLoginResult .grantedPermissions.contains("email")){
                   self.getFbId()
                    
                }
            }  }
    }
    func getFbId()->Void{
        if(FBSDKAccessToken.current() != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id,name , first_name, last_name , email,picture.type(large)"]).start(completionHandler: { (connection, result, error) in
                guard let Info = result as? [String: Any] else { return }
                print("FacebookID : ")
                print(Info["id"]!)
                if let imageURL = ((Info["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String {
                    //Download image from imageURL
                    
                }
                if(error == nil){
                    let user = User();
                    print(FBSDKAccessToken.current().tokenString)
                    user.facebookAccessToken = String(FBSDKAccessToken.current().tokenString as! String);
                    user.facebookId = String(Info["id"] as! String)
                    user.username = String(Info["email"]as! String)
                    user.isFacebook = 1;
                    
                   let loginURL = "user/login/format/json";
                    
                    self.userManage(jsonURL:loginURL,user: user,requestType: "");
                }
                else{
                    
                    let alert = UIAlertController.init(title: "Error", message: error as! String, preferredStyle: .alert);
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil));
                    self.present(alert, animated: true)
                    
                }
            })
        }
    }
    
    @IBAction func emailSignupClicked(_ sender: Any) {
    
        
        let viewController: SignupViewController = self.storyboard?.instantiateViewController(withIdentifier: "SignupViewController") as! SignupViewController;
        self.navigationController?.pushViewController(viewController, animated: true);
        /*
        let user = User();
        let registerationURL = "user/registration/format/json";
        user.username = emailTextField.text;
        user.password = passwordTextField.text;
        let isValid = self.validateSignupForm(user: user); //CALLING VALIDATION FUNCTION
        if(isValid==true){
            self.userManage(jsonURL: registerationURL,user: user,requestType: "");
        } */
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
   
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
    func userManage(jsonURL:String,user : User, requestType : String)->Void{
        //iPhone or iPad
        //let model = UIDevice.current.model;
        user.userDevice = 2;//
        let userDefaults = UserDefaults.standard
        if let tokenDataStr = userDefaults.value(forKey: "tokenData") as? String {
            user.deviceToken = tokenDataStr;
        } else {
            user.deviceToken = "test";
        }
        
        UserService().postDataMethod(jsonURL: jsonURL,postData:user.toDictionary(user: user),complete:{(response) in
            print(response);
            if (Int(response.value(forKey: "status") as! String)! == 1) {
                
                let message = response.value(forKey: "message") as! String;
                
                let alert = UIAlertController.init(title: "Success", message: message, preferredStyle: .alert);
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(resp) in
                    let userDict = response.value(forKey: "data") as! NSDictionary;
                    print(userDict)
                    let user = User().getUserData(userDataDict: userDict);
                    user.loadUserDefaults();
                    if(requestType == ""){
                        
                    let viewController: UserTypeActionViewController = self.storyboard?.instantiateViewController(withIdentifier: "UserTypeActionViewController") as! UserTypeActionViewController;
                    self.navigationController?.pushViewController(viewController, animated: true);
                        print(self.navigationController);
                        
                    }else if(requestType == "login"){
                        UIApplication.shared.keyWindow?.rootViewController = HomeViewController.MainViewController()
                        //let viewController: HomeViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController;
                        //self.navigationController?.pushViewController(viewController, animated: true);
                    }
                    
                    //let vc = UserTypeActionViewController(nibName: "UserTypeActionViewController", bundle: nil)
                    //self.navigationController?.pushViewController(vc, animated: true )
                    
                }));
                self.present(alert, animated: true)
                
                
                
            } else {
                let message = response.value(forKey: "message") as! String;
                
                let alert = UIAlertController.init(title: "Error", message: message, preferredStyle: .alert);
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil));
                self.present(alert, animated: true)
            }
        })
    }
    
    @IBAction func loginButtonClicked(_ sender: Any) {
        let user = User();
        let registerationURL = "user/login/format/json";
        user.username = emailTextField.text;
        user.password = passwordTextField.text;
        let isValid = self.validateLoginForm(user: user); //CALLING VALIDATION FUNCTION
        if(isValid==true){
            self.userManage(jsonURL: registerationURL,user: user,requestType: "login");
        }
    }
}
