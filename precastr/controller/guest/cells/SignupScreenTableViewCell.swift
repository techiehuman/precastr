//
//  SignupScreenTableViewCell.swift
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

class SignupScreenTableViewCell: UITableViewCell, UITextFieldDelegate, SignupCellProtocol {
    

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var cameraUIView: UIView!
    @IBOutlet weak var agreecheckBoxBtn: UIButton!
    @IBOutlet weak var uploadImage: UIImageView!
    @IBOutlet weak var cameraImage: UIImageView!
    
    var signupScreenViewDelegate: SignupScreenViewController!;
    var agreeCheckBox = false

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.uploadImage.roundImageView();
        self.agreecheckBoxBtn.layer.borderWidth = 1
        self.agreecheckBoxBtn.layer.borderColor = UIColor.white.cgColor
        self.cameraUIView.layer.cornerRadius = self.cameraUIView.frame.height/2
        self.nameTextField.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSAttributedStringKey.foregroundColor : UIColor.white ])
        
        self.nameTextField.layer.borderColor = UIColor.white.cgColor
        self.nameTextField.layer.borderWidth = 0.5
        let imageViewN = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        let imageN = UIImage(named: "profile");
        imageViewN.image = imageN;
        self.nameTextField.leftView = imageViewN
        self.nameTextField.leftViewMode = .always
        // self.nameTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width:35, height: self.nameTextField.frame.height))
        
        self.emailTextField.attributedPlaceholder = NSAttributedString(string: "Email Address", attributes: [NSAttributedStringKey.foregroundColor : UIColor.white ])
        
        self.emailTextField.layer.borderColor = UIColor.white.cgColor
        self.emailTextField.layer.borderWidth = 0.5
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        let image = UIImage(named: "email");
        imageView.image = image;
        self.emailTextField.leftView = imageView
        self.emailTextField.leftViewMode = .always
        // self.emailTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width:15, height: self.emailTextField.frame.height))
        
        self.passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedStringKey.foregroundColor : UIColor.white ])
        self.passwordTextField.layer.borderColor = UIColor.white.cgColor
        self.passwordTextField.layer.borderWidth = 0.5
        self.passwordTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width:35, height: self.passwordTextField.frame.height))
        
        let imageViewP = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        let imageP = UIImage(named: "password");
        imageViewP.image = imageP;
        self.passwordTextField.leftView = imageViewP
        self.passwordTextField.leftViewMode = .always
        
        let imageTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(imageUploadClicked))
        cameraUIView.addGestureRecognizer(imageTapGesture);
        // Do any additional setup after loading the view.
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func imageUploadClicked() {
        signupScreenViewDelegate.imageUploadClicked();
    }
    
    @IBAction func emailSignUpClicked(_ sender: Any) {
        
        let user = User();
        let registerationURL = "user/registration/format/json";
        user.username = emailTextField.text;
        user.name = nameTextField.text;
        user.password = passwordTextField.text;
        let isValid = self.signupScreenViewDelegate.validateSignupForm(user: user); //CALLING VALIDATION FUNCTION
        
        if(isValid==true && agreeCheckBox==true){
            self.signupScreenViewDelegate.userManage(jsonURL: registerationURL,user: user);
        }else if(agreeCheckBox==false){
            let alert = UIAlertController.init(title: "Error", message: "Please agree to terms and conditions", preferredStyle: .alert);
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil));
            self.signupScreenViewDelegate.present(alert, animated: true)
        }
    }
    
    
    @IBAction func agreeCheckboxBtnClicked(_ sender: Any) {
        if(agreeCheckBox==false){
            agreeCheckBox = true
            let image = UIImage(named: "checkbox")
            self.agreecheckBoxBtn.setImage(image, for : .normal)
        }else{
            agreeCheckBox = false
            self.agreecheckBoxBtn.setImage(nil, for: .normal)
            
        }
        
    }
    @IBAction func facebookSignupClicked(_ sender: Any) {
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
        fbloginManger.logIn(withReadPermissions: ["email"], from:self.signupScreenViewDelegate) {(result, error) -> Void in
            if(error == nil){
                let fbLoginResult: FBSDKLoginManagerLoginResult  = result!
                
                if( result?.isCancelled)!{
                    return }
                
                
                if(fbLoginResult .grantedPermissions.contains("email")){
                    self.getFbId()
                    
                }
            }  }
    }
    
    
    @IBAction func twitterSignupClicked(_ sender: Any) {
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
                self.signupScreenViewDelegate.userManage(jsonURL:loginURL,user: user);
                
                
            }else {
                print("error: \(String(describing: error?.localizedDescription))");
            }
        }
    }
    
    
    @IBAction func LoginBtnClicked(_ sender: Any) {
        let viewController: LoginScreenViewController = self.signupScreenViewDelegate.storyboard?.instantiateViewController(withIdentifier: "LoginScreenViewController") as! LoginScreenViewController;
        self.signupScreenViewDelegate.navigationController?.pushViewController(viewController, animated: true);
    }
    
    func getFbId()->Void{
        if(FBSDKAccessToken.current() != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id,name , first_name, last_name , email,picture.type(large)"]).start(completionHandler: { (connection, result, error) in
                guard let Info = result as? [String: Any] else { return }
                print("FacebookID : ")
                var profilePic :String = "";
                print(Info["id"]!)
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
                    
                    self.signupScreenViewDelegate.userManage(jsonURL:loginURL,user: user);
                }
                else{
                    
                    let alert = UIAlertController.init(title: "Error", message: error as! String, preferredStyle: .alert);
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil));
                    self.signupScreenViewDelegate.present(alert, animated: true)
                    
                }
            })
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if (textField == nameTextField){
            emailTextField.becomeFirstResponder()
        }
        else if (textField == emailTextField){
            passwordTextField.becomeFirstResponder()
        }else if(textField == passwordTextField){
            textField.resignFirstResponder()
        }
        return true
    }
    
    func pictureSelected(selectedImage: UIImage) {
        uploadImage.isHidden = false;
        DispatchQueue.main.async {
            self.uploadImage.image = selectedImage;
            self.uploadImage.setNeedsDisplay();
        }
    }
}