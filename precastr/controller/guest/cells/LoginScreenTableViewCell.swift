//
//  LoginScreenTableViewCell.swift
//  precastr
//
//  Created by Cenes_Dev on 04/06/2019.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import TwitterKit
import TwitterCore

class LoginScreenTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var facebookButton:UIButton!
    @IBOutlet weak var twitterButton:UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpBtn: UIButton!
    var loginViewControllerDelegate : LoginScreenViewController!;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Do any additional setup after loading the view.
        self.emailTextField.attributedPlaceholder = NSAttributedString(string: "Email Address", attributes: [NSAttributedStringKey.foregroundColor : UIColor.white ])
        self.passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedStringKey.foregroundColor : UIColor.white ])
        self.emailTextField.layer.borderColor = UIColor.white.cgColor
        self.emailTextField.layer.borderWidth = 0.5
        let imageView = UIImageView(frame: CGRect(x: 10, y: 0, width: 27, height: 30))
        let image = UIImage(named: "email");
        imageView.image = image;
        let iconContainerView: UIView = UIView(frame:
            CGRect(x: 30, y: 0, width: 30, height: 30))
        iconContainerView.addSubview(imageView)
        self.emailTextField.leftView = iconContainerView
        self.emailTextField.leftViewMode = .always

        let lineView = UIView(frame: CGRect(x: 0, y: self.signUpBtn.frame.size.height-6, width: self.signUpBtn.frame.size.width, height: 1))
        lineView.backgroundColor = UIColor.white
        self.signUpBtn.addSubview(lineView)
      
        
        
        // self.emailTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width:15, height: self.emailTextField.frame.height))
        self.passwordTextField.layer.borderColor = UIColor.white.cgColor
        self.passwordTextField.layer.borderWidth = 0.5
        self.passwordTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width:35, height: self.passwordTextField.frame.height))
        
        let imageViewP = UIImageView(frame: CGRect(x: 5, y: 0, width: 27, height: 30))
        let imageP = UIImage(named: "password");
        imageViewP.image = imageP;
        self.passwordTextField.leftView = imageViewP
        self.passwordTextField.leftViewMode = .always
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
                user.name = name
                user.isTwitter = 1;
                
                
                let loginURL = "user/login/format/json";
                
                print(user.toDictionary(user: user ))
                self.loginViewControllerDelegate.userManage(jsonURL:loginURL,user: user);
                
                
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
        fbloginManger.logIn(withReadPermissions: ["email"], from:loginViewControllerDelegate) {(result, error) -> Void in
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
                var profilePic :String = "";
                if let imageURL = ((Info["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String {
                    //Download image from imageURL
                    profilePic = imageURL
                    
                }
                if(error == nil){
                    let user = User();
                    print(FBSDKAccessToken.current().tokenString)
                    user.facebookAccessToken = String(FBSDKAccessToken.current().tokenString as! String);
                    user.facebookId = String(Info["id"] as! String)
                    user.username = String(Info["email"]as! String)
                    user.name = String(Info["name"] as! String)
                    user.profilePic =  profilePic
                    user.isFacebook = 1;
                    
                    let loginURL = "user/login/format/json";
                    
                    self.loginViewControllerDelegate.userManage(jsonURL:loginURL,user: user);
                }
                else{
                    
                    let alert = UIAlertController.init(title: "Error", message: error as! String, preferredStyle: .alert);
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil));
                    self.loginViewControllerDelegate.present(alert, animated: true)
                    
                }
            })
        }
    }
    
    @IBAction func emailSignupClicked(_ sender: Any) {
        let viewController: SignupScreenViewController = self.loginViewControllerDelegate.storyboard?.instantiateViewController(withIdentifier: "SignupScreenViewController") as! SignupScreenViewController;
        self.loginViewControllerDelegate.navigationController?.pushViewController(viewController, animated: true);
    }
    
    @IBAction func loginButtonClicked(_ sender: Any) {
        let user = User();
        let registerationURL = "user/login/format/json";
        user.username = emailTextField.text;
        user.password = passwordTextField.text;
        let isValid = self.loginViewControllerDelegate.validateLoginForm(user: user); //CALLING VALIDATION FUNCTION
        if(isValid==true){
            self.loginViewControllerDelegate.userManage(jsonURL: registerationURL,user: user);
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == emailTextField){
            passwordTextField.becomeFirstResponder()
        }else if(textField == passwordTextField){
            textField.resignFirstResponder()
        }
        return true
    }
}
