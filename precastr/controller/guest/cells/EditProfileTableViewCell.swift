//
//  EditProfileTableViewCell.swift
//  precastr
//
//  Created by Macbook on 07/06/19.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import TwitterKit
import TwitterCore

class EditProfileTableViewCell: UITableViewCell,UITextFieldDelegate, EditProfileTableViewCellProtocol {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameUIView: UIView!
    @IBOutlet weak var phoneNumberUIView: UIView!
    @IBOutlet weak var countryPhoneCodeView: UIView!
    @IBOutlet weak var cameraUIView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var invitationUIView: UIView!
    @IBOutlet weak var invitationCodeLabel: UILabel!
    @IBOutlet weak var countryCode: UILabel!
    
    @IBOutlet weak var updateNameButton: UIButton!
    
    @IBOutlet weak var currentPasswordTextField: UITextField!
    
    @IBOutlet weak var confirmPasswordTxtField: UITextField!
    
    @IBOutlet weak var updatePasswordBtn: UIButton!
    @IBOutlet weak var emailTextLabel: UILabel!
    
    @IBOutlet weak var facebookIDLabel: UILabel!
    @IBOutlet weak var twitterIDLabel: UILabel!
    
    @IBOutlet weak var emailEditBtnView: UIView!
    @IBOutlet weak var emailEditBtn: UIImageView!
    
    @IBOutlet weak var facebookLabelView: UIView!
    @IBOutlet weak var facebookEditBtnView: UIView!
    @IBOutlet weak var facebookEditBtn: UIImageView!
    
    @IBOutlet weak var twitterLabelView: UIView!
    @IBOutlet weak var twitterEditBtnView: UIView!
    @IBOutlet weak var twitterEditBtn: UIImageView!
    
    
    var editProfileViewControllerDelegate: EditProfileViewController!;
    var updateProfileInfoView: UpdateProfileInfoView!;
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
        self.cameraUIView.roundView();
        self.cameraUIView.layer.backgroundColor = UIColor.white.cgColor
        self.cameraUIView.layer.borderWidth = 1
        self.cameraUIView.layer.borderColor = UIColor(red: 12/255, green: 111/255, blue: 233/255, alpha: 1.0).cgColor
        self.profileImageView.roundView();
        self.profileImageView.layer.borderWidth = 2
        self.profileImageView.layer.borderColor = UIColor(red: 12/255, green: 111/255, blue: 233/255, alpha: 1.0).cgColor
        
        let cameraTap = UITapGestureRecognizer.init(target: self, action: #selector(cameraViewPressed));
        cameraUIView.addGestureRecognizer(cameraTap);
        
        let lineView = UIView(frame: CGRect(x: 0, y: self.nameTextField.frame.height, width: self.nameTextField.bounds.width - 14, height: 0.5))
        lineView.backgroundColor = UIColor.init(red: 146/255, green: 147/255, blue: 149/255, alpha: 1)
        self.nameTextField.addSubview(lineView)
        
        let lineViewPhone = UIView(frame: CGRect(x: 0, y: self.phoneNumberTextField.frame.height, width: self.phoneNumberTextField.bounds.width - 14, height: 0.5))
        lineViewPhone.backgroundColor = UIColor.init(red: 146/255, green: 147/255, blue: 149/255, alpha: 1)
        self.phoneNumberTextField.addSubview(lineViewPhone)
        
        let uplineView = UIView(frame: CGRect(x: 0, y: self.currentPasswordTextField.frame.height, width: self.currentPasswordTextField.bounds.width - 14, height: 0.5))
        uplineView.backgroundColor = UIColor.init(red: 146/255, green: 147/255, blue: 149/255, alpha: 1)
        self.currentPasswordTextField.addSubview(uplineView)
        
        
        let cplineView = UIView(frame: CGRect(x: 0, y: self.confirmPasswordTxtField.frame.height, width: self.confirmPasswordTxtField.bounds.width - 14, height: 0.5))
        cplineView.backgroundColor = UIColor.init(red: 146/255, green: 147/255, blue: 149/255, alpha: 1)
        self.confirmPasswordTxtField.addSubview(cplineView)
        
    
        updateNameButton.roundEdgesBtn();
        updatePasswordBtn.roundEdgesBtn();
        let countryCodeTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(countryPhoneCodeViewPressed));
        countryPhoneCodeView.addGestureRecognizer(countryCodeTapGesture);
        
        let editEmailTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(emailEditBtnPressed));
        emailEditBtnView.addGestureRecognizer(editEmailTapGesture);
        let emailTextLabelTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(emailEditBtnPressed));
        emailTextLabel.addGestureRecognizer(emailTextLabelTapGesture);

        
        let facebookEditTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(facebookEditBtnPressed));
        facebookEditBtnView.addGestureRecognizer(facebookEditTapGesture);
        let facebookLabelViewTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(facebookEditBtnPressed));
        facebookLabelView.addGestureRecognizer(facebookLabelViewTapGesture);
        
        let twitterEditTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(twitterEditBtnPressed));
        twitterEditBtnView.addGestureRecognizer(twitterEditTapGesture);
        let twitterLabelViewTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(twitterEditBtnPressed));
        twitterLabelView.addGestureRecognizer(twitterLabelViewTapGesture);
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func updateNameButtonPressed(_ sender: Any) {
        
        if (nameTextField.text == "") {
            editProfileViewControllerDelegate.showAlert(title: "Alert", message: "Name cannot be empty");
        } else {
            var postData = [String: Any]();
            postData["name"] = nameTextField.text!;
            postData["user_id"] = "\(editProfileViewControllerDelegate.loggedInUser.userId!)";
            postData["country_code"] = countryCode.text!
            postData["phone_number"] = phoneNumberTextField.text!
            editProfileViewControllerDelegate.updateNameProfilePic(postData: postData)
        }
    }
    
    
    @IBAction func updatePasswordBtnPressed(_ sender: Any) {
        
        if (currentPasswordTextField.text == "") {
            editProfileViewControllerDelegate.showAlert(title: "Alert", message: "Password cannot be empty");
        } else if (currentPasswordTextField.text != confirmPasswordTxtField.text) {
            editProfileViewControllerDelegate.showAlert(title: "Alert", message: "Password do not match");
        } else {
            
            var postData = [String: Any]();
            postData["password"] = currentPasswordTextField.text!;
            postData["user_id"] = "\(editProfileViewControllerDelegate.loggedInUser.userId!)";
            editProfileViewControllerDelegate.updatePassword(postData: postData);
        }
    }
    
    @objc func cameraViewPressed() {
        editProfileViewControllerDelegate.imageUploadClicked();
    }
    
    func pictureSelected(selectedImage: UIImage) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            self.profileImageView.image = selectedImage;
            self.profileImageView.setNeedsDisplay();

        });

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == nameTextField) {
            nameTextField.resignFirstResponder();
        } else if (textField == currentPasswordTextField) {
            confirmPasswordTxtField.becomeFirstResponder();
        } else if (textField == confirmPasswordTxtField) {
            confirmPasswordTxtField.resignFirstResponder();
        }else if(textField == phoneNumberTextField){
            phoneNumberTextField.resignFirstResponder();
        }
        
        return true;
    }
    @objc func countryPhoneCodeViewPressed() {
        editProfileViewControllerDelegate.openCountryCodeList();
        
    }
    
    @objc func emailEditBtnPressed() {
        updateProfileInfoView = UpdateProfileInfoView.instanceEmailAlertFromNib() as! UpdateProfileInfoView;        
        
        let closePopUpGesture = UITapGestureRecognizer.init(target: self, action: #selector(closePopupBtnPressed))
        updateProfileInfoView.closePopupBtn.addGestureRecognizer(closePopUpGesture);
        updateProfileInfoView.emailTextField.text = editProfileViewControllerDelegate.loggedInUser.username;
        
        let saveBtnTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(saveEmailBtnPressed));
        updateProfileInfoView.saveBtn.addGestureRecognizer(saveBtnTapGesture);
        
        let window = UIApplication.shared.keyWindow!
        updateProfileInfoView.frame = window.bounds;
        window.addSubview(updateProfileInfoView);
    }
    
    @objc func facebookEditBtnPressed() {
        
        updateProfileInfoView = UpdateProfileInfoView.instanceSocialAlertFromNib() as! UpdateProfileInfoView;
        updateProfileInfoView.socialInfoLabel.text = "Are you sure you want to change your Facebook ID. Please click \"Ok\" to proceed.";
        let closePopUpGesture = UITapGestureRecognizer.init(target: self, action: #selector(closePopupBtnPressed))
        updateProfileInfoView.closePopupBtn.addGestureRecognizer(closePopUpGesture);
        
        let facebookPopUpGesture = UITapGestureRecognizer.init(target: self, action: #selector(facebookButtonClicked))
        updateProfileInfoView.okBtn.addGestureRecognizer(facebookPopUpGesture);

        let window = UIApplication.shared.keyWindow!
        updateProfileInfoView.frame = window.bounds;
        window.addSubview(updateProfileInfoView);
    }
    
    @objc func twitterEditBtnPressed() {
        updateProfileInfoView = UpdateProfileInfoView.instanceSocialAlertFromNib() as! UpdateProfileInfoView;
        updateProfileInfoView.socialInfoLabel.text = "Are you sure you want to change your Twitter ID. Please click \"Ok\" to proceed.";

        let closePopUpGesture = UITapGestureRecognizer.init(target: self, action: #selector(closePopupBtnPressed))
        updateProfileInfoView.closePopupBtn.addGestureRecognizer(closePopUpGesture);
    
        let twitterPopUpGesture = UITapGestureRecognizer.init(target: self, action: #selector(twitterButtonClicked))
        updateProfileInfoView.okBtn.addGestureRecognizer(twitterPopUpGesture);

        let window = UIApplication.shared.keyWindow!
        updateProfileInfoView.frame = window.bounds;
        window.addSubview(updateProfileInfoView);
    }
    
    @objc func closePopupBtnPressed() {
        let window = UIApplication.shared.keyWindow!
        for uiview in window.subviews {
            if (uiview is UpdateProfileInfoView) {
                uiview.removeFromSuperview();
                break;
            }
        }
    }
    
    @objc func saveEmailBtnPressed() {
        
        if (updateProfileInfoView.emailTextField.text == "") {
            editProfileViewControllerDelegate.showAlert(title: "Alert", message: "Email cannot be empty");
        } else {
            var postData = [String: Any]();
            postData["name"] = nameTextField.text!;
            postData["user_id"] = "\(editProfileViewControllerDelegate.loggedInUser.userId!)";
            postData["country_code"] = countryCode.text!
            postData["phone_number"] = phoneNumberTextField.text!
            postData["email"] = updateProfileInfoView.emailTextField.text!;
            emailTextLabel.text = updateProfileInfoView.emailTextField.text!;
            
            editProfileViewControllerDelegate.updateNameProfilePic(postData: postData)
        
            let window = UIApplication.shared.keyWindow!
            for uiview in window.subviews {
                if (uiview is UpdateProfileInfoView) {
                    uiview.removeFromSuperview();
                    break;
                }
            }
        }
    }
    
    @objc func twitterButtonClicked() {
        
        let window = UIApplication.shared.keyWindow!
        for uiview in window.subviews {
            if (uiview is UpdateProfileInfoView) {
                uiview.removeFromSuperview();
                break;
            }
        }
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
                
                if (self.editProfileViewControllerDelegate.loggedInUser.isTwitter == 1) {
                    var postData = [String: Any]();
                    postData["name"] = name;
                    postData["user_id"] = "\(self.editProfileViewControllerDelegate.loggedInUser.userId!)";
                    postData["email"] = name;
                    postData["twitter_id"] = name;
                    self.editProfileViewControllerDelegate.updateNameProfilePic(postData: postData);
                }
                user.twitterAccessToken = session?.authToken
                user.twitterAccessSecret = session?.authTokenSecret
                user.twitterId = session?.userID
                user.username = name
                user.name = name
                            
                var postData = [String: Any]();
                postData["media_type"] = 2;
                postData["user_id"] = "\(self.editProfileViewControllerDelegate.loggedInUser.userId!)";
                var token = "";
                token = token + "{\"twitter_access_token\":\"\(user.twitterAccessToken!)\"";
                token = token + ",\"twitter_access_secret\":\"\(user.twitterAccessSecret!)\"";
                token = token + ",\"email\":\"\(user.username!)\"";
                token = token + ",\"twitter_id\":\"\(user.twitterId!)\"}";
                postData["tokens"] = "\(token)";
                self.editProfileViewControllerDelegate.updateSocialMedia(postData: postData);
                self.twitterIDLabel.text = user.username;
            } else {
                print("error: \(String(describing: error?.localizedDescription))");
            }
        }
    }
    
    
    @objc func facebookButtonClicked() {
           
        let window = UIApplication.shared.keyWindow!
        for uiview in window.subviews {
            if (uiview is UpdateProfileInfoView) {
                uiview.removeFromSuperview();
                break;
            }
        }
       let fbloginManger: LoginManager = LoginManager   ()
        //fbloginManger.logOut();
        
        //print(AccessToken.current?.tokenString);
        //editProfileViewControllerDelegate.showAlert(title: "Error", message: AccessToken.current!.tokenString);

        if (AccessToken.current?.tokenString != nil) {
            let cookies = HTTPCookieStorage.shared
            let facebookCookies = cookies.cookies(for: URL(string: "https://facebook.com/")!)
            for cookie in facebookCookies! {
                cookies.deleteCookie(cookie )
            }

            GraphRequest.init(graphPath: "me/",parameters: ["accessToken": AccessToken.current?.tokenString], httpMethod: .delete).start(completionHandler: { (connection, result, error) in
                   
                print(error);
                if (error != nil) {
                    //self.editProfileViewControllerDelegate.showAlert(title: "Error", message: error!.localizedDescription);
                }
                print(result);
                
                fbloginManger.logOut();
                //if (error == nil) {
                    /* CODE FOR LOGOUT */
                    fbloginManger.logIn(permissions: ["email"], from:self.editProfileViewControllerDelegate) {(result, error) -> Void in
                            if(error == nil){
                                let fbLoginResult: LoginManagerLoginResult  = result!
                                
                                if( result?.isCancelled)!{
                                    return }
                                
                                
                                if(fbLoginResult .grantedPermissions.contains("email")){
                                    self.getFbId()
                                    
                                }
                            }
                        }
                    
                //}
                
            });
        } else {
            /* CODE FOR LOGOUT */
            fbloginManger.logIn(permissions: ["email"], from:editProfileViewControllerDelegate) {(result, error) -> Void in
                    if(error == nil){
                        let fbLoginResult: LoginManagerLoginResult  = result!
                        
                        if( result?.isCancelled)!{
                            return }
                        
                        
                        if(fbLoginResult .grantedPermissions.contains("email")){
                            self.getFbId()
                            
                        }
                    }
                }
        }
       /*CODE FOR LOGOUT */
        //AccessToken.current = nil
        //Profile.current = nil
   }
    
   func getFbId()->Void {
       if(AccessToken.current != nil){
           GraphRequest(graphPath: "me", parameters: ["fields": "id,name , first_name, last_name , email,picture.type(large)"]).start(completionHandler: { (connection, result, error) in
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
                   print(AccessToken.current!.tokenString)
                   user.facebookAccessToken = String(AccessToken.current!.tokenString );
                   user.facebookId = String(Info["id"] as! String)
                
                    if (self.editProfileViewControllerDelegate.loggedInUser.isFacebook == 1) {
                        user.username = String(Info["email"]as! String)
                        user.name = String(Info["name"] as! String)
                        user.profilePic =  profilePic
                        user.isFacebook = 1;
                        
                        var postData = [String: Any]();
                        postData["name"] = user.name;
                        postData["username"] = user.username;
                        postData["facebook_id"] = user.facebookId;
                        postData["user_id"] = "\(self.editProfileViewControllerDelegate.loggedInUser.userId!)";
                        self.editProfileViewControllerDelegate.updateNameProfilePic(postData: postData);
                    }
                       
                    var postData = [String: Any]();
                    postData["user_id"] = "\(self.editProfileViewControllerDelegate.loggedInUser.userId!)";
                    postData["media_type"] = 1;
                    var token = "";
                     token = token + "{\"facebook_access_token\":\"\(user.facebookAccessToken!)\"";
                    token = token + ",\"email\":\"\(String(Info["email"]as! String))\"";
                    token = token + ",\"facebook_id\":\"\(user.facebookId!)\"}";
                    postData["tokens"] = token;
                    
                    self.facebookIDLabel.text = String(Info["email"]as! String);
                    self.editProfileViewControllerDelegate.updateSocialMedia(postData: postData);
               } else {
                   
                   let alert = UIAlertController.init(title: "Error", message: error as! String, preferredStyle: .alert);
                   alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil));
                   self.editProfileViewControllerDelegate.present(alert, animated: true)
                   
               }
           })
       }
   }
    
    func countryCodeValueSelected(country : CountryCodeService){
        self.countryCode.text = country.getPhoneCode();
    }
}
