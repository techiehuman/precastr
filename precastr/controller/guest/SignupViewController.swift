//
//  SignupViewController.swift
//  precastr
//
//  Created by Macbook on 07/05/19.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import TwitterKit
import TwitterCore

protocol ImageLibProtocol {
    func takePicture(viewC : UIViewController);
    func selectPicture(viewC : UIViewController, cameraView : UIImageView);
  
}

class SignupViewController: UIViewController,UITextFieldDelegate {

    
    @IBOutlet weak var nameTextField: UITextField!
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBOutlet weak var cameraUIView: UIView!
    
    @IBOutlet weak var agreecheckBoxBtn: UIButton!
    
    
    @IBOutlet weak var uploadImage: UIImageView!
    var agreeCheckBox = false
    var uploadImageStatus = false
    var imageDelegate : ImageLibProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      self.uploadImage.roundImageView()
        imageDelegate = Reusable()
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func imageUploadClicked(){
        // create an actionSheet
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // create an action
        let uploadPhotoAction: UIAlertAction = UIAlertAction(title: "Upload Photo", style: .default) { action -> Void in
            self.imageDelegate.selectPicture(viewC: self,cameraView: self.uploadImage);
            self.uploadImage.isHidden = false
            self.uploadImageStatus = true
        }
        //uploadPhotoAction.setValue(selectedColor, forKey: "titleTextColor")
        let takePhotoAction: UIAlertAction = UIAlertAction(title: "Take Photo", style: .default) { action -> Void in
            self.imageDelegate.takePicture(viewC: self);
        }
        //takePhotoAction.setValue(cenesLabelBlue, forKey: "titleTextColor")
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
        cancelAction.setValue(UIColor.black, forKey: "titleTextColor")
        
        actionSheetController.addAction(uploadPhotoAction)
        actionSheetController.addAction(takePhotoAction)
        actionSheetController.addAction(cancelAction)
        
        // present an actionSheet...
        present(actionSheetController, animated: true, completion: nil)
    }
    @IBAction func emailSignUpClicked(_ sender: Any) {
        
         let user = User();
         let registerationURL = "user/registration/format/json";
         user.username = emailTextField.text;
        user.name = nameTextField.text;
         user.password = passwordTextField.text;
         let isValid = self.validateSignupForm(user: user); //CALLING VALIDATION FUNCTION
        
         if(isValid==true && agreeCheckBox==true){
         self.userManage(jsonURL: registerationURL,user: user);
         }else if(agreeCheckBox==false){
            let alert = UIAlertController.init(title: "Error", message: "Please agree to terms and conditions", preferredStyle: .alert);
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil));
            self.present(alert, animated: true)
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
                self.userManage(jsonURL:loginURL,user: user);
                
                
            }else {
                print("error: \(String(describing: error?.localizedDescription))");
            }
        }
    }
    
    
    @IBAction func LoginBtnClicked(_ sender: Any) {
        let viewController: LoginStep1ViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginStep1ViewController") as! LoginStep1ViewController;
        self.navigationController?.pushViewController(viewController, animated: true);
    }
    func validateSignupForm(user: User) -> Bool{
        
        var isValid = true;
        var message = "";
        if (user.name == "") {
            message = "Name cannot be empty"
            isValid = false
        }
       else if (user.username == "") {
            message = "Username cannot be empty"
            isValid = false
        } else if (user.password == "") {
            message = "Password cannot be empty"
            isValid = false
        }
        else if(uploadImageStatus == false){
            message = "Please upload profile picture"
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
        
        UserService().postMultipartImageDataMethod(jsonURL: jsonURL,image : uploadImage.image!, postData:user.toDictionary(user: user),complete:{(response) in
            print(response);
            SocialPlatform().fetchSocialPlatformData();
            if (Int(response.value(forKey: "status") as! String)! == 1) {
                
                let message = response.value(forKey: "message") as! String;
                
                let alert = UIAlertController.init(title: "Success", message: message, preferredStyle: .alert);
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(resp) in
                    let userDict = response.value(forKey: "data") as! NSDictionary;
                    print(userDict)
                    let user = User().getUserData(userDataDict: userDict);
                    user.loadUserDefaults();
                   
                        
                        let viewController: UserTypeActionViewController = self.storyboard?.instantiateViewController(withIdentifier: "UserTypeActionViewController") as! UserTypeActionViewController;
                        self.navigationController?.pushViewController(viewController, animated: true);
                        print(self.navigationController);
                        
                    
                    
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
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
                    
                    self.userManage(jsonURL:loginURL,user: user);
                }
                else{
                    
                    let alert = UIAlertController.init(title: "Error", message: error as! String, preferredStyle: .alert);
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil));
                    self.present(alert, animated: true)
                    
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
}
