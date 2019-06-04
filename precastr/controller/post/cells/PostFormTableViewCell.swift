//
//  PostFormTableViewCell.swift
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

class PostFormTableViewCell: UITableViewCell, UITextViewDelegate {

    @IBOutlet weak var postTextField: UITextView!
    @IBOutlet weak var twitterBtn: UIButton!
    @IBOutlet weak var facebookBtn: UIButton!
    @IBOutlet weak var sendViewArea: UIView!
    @IBOutlet weak var inputViewArea: UIView!

    var createPostViewControllerDelegate: CreatePostViewController!;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.facebookBtn.layer.borderColor = UIColor(red: 12/255, green: 111/255, blue: 233/255, alpha: 1).cgColor;
        self.facebookBtn.layer.borderWidth = 1
        self.twitterBtn.layer.borderColor = UIColor(red: 12/255, green: 111/255, blue: 233/255, alpha: 1).cgColor;
        self.twitterBtn.layer.borderWidth = 1
        
        self.postTextField.delegate = self
        self.postTextField.layer.borderColor =  UIColor(red: 146/255, green: 147/255, blue: 149/255, alpha: 1).cgColor;
        self.postTextField.layer.borderWidth = 0.5

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("A")
        if self.postTextField.textColor == UIColor.lightGray {
            self.postTextField.text = ""
            self.postTextField.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        print("B")
        if self.postTextField.text == "" {
            self.postTextField.text = "Write Something..."
            self.postTextField.textColor = UIColor.lightGray
        }
    }
    
    
    
    @IBAction func facebookBtnClicked(_ sender: Any) {
        
        //self.socialMediaPlatform.append((social.socialPlatformId["facebook"])!)
        if(createPostViewControllerDelegate.facebookStatus==false){
            createPostViewControllerDelegate.facebookStatus = true
            self.facebookBtn.backgroundColor = UIColor.init(red: 12/255, green: 111/255, blue: 2333/255, alpha: 1);
            self.facebookBtn.layer.borderWidth = 0
            let image = UIImage(named: "facebook")
            self.facebookBtn.setImage(image, for: UIControlState.normal)
            for obj in createPostViewControllerDelegate.social.socialPlatformId {
                if (obj.key == "Facebook") {
                    createPostViewControllerDelegate.socialMediaPlatform.append(obj.value);
                    break;
                }
            }
        }else{
            createPostViewControllerDelegate.facebookStatus = false
            self.facebookBtn.layer.borderWidth = 1
            self.facebookBtn.layer.borderColor =  UIColor(red: 12/255, green: 111/255, blue: 233/255, alpha: 1).cgColor;
            self.facebookBtn.backgroundColor = UIColor.white
            let image = UIImage(named: "facebook-group")
            self.facebookBtn.setImage(image, for: UIControlState.normal)
            
            for obj in createPostViewControllerDelegate.social.socialPlatformId {
                if (obj.key == "Facebook") {
                    if let index = createPostViewControllerDelegate.socialMediaPlatform.index(of:obj.value) {
                        createPostViewControllerDelegate.socialMediaPlatform.remove(at: index)
                    }
                    break;
                }
            }
            
            
        }
        if(createPostViewControllerDelegate.facebookExists == false && createPostViewControllerDelegate.facebookStatus == true){
            
            
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
            fbloginManger.logIn(withReadPermissions: ["email"], from:createPostViewControllerDelegate) {(result, error) -> Void in
                if(error == nil){
                    let fbLoginResult: FBSDKLoginManagerLoginResult  = result!
                    
                    if( result?.isCancelled)!{
                        return }
                    
                    
                    if(fbLoginResult .grantedPermissions.contains("email")){
                        FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id"]).start(completionHandler: { (connection, result, error) in
                            guard let Info = result as? [String: Any] else { return }
                            let user = User();
                            print(FBSDKAccessToken.current().tokenString)
                            user.facebookAccessToken = String(FBSDKAccessToken.current().tokenString as! String);
                            user.facebookId = String(Info["id"] as! String)
                            
                            user.isFacebook = 1;
                            var postData = [String : Any]()
                            postData["user_id"] = self.createPostViewControllerDelegate.loggedInUser.userId
                            postData["facebook_id"] = user.facebookId
                            for obj in self.createPostViewControllerDelegate.social.socialPlatformId {
                                if (obj.key == "Facebook") {
                                    
                                    postData["social_media"] = obj.value
                                    break;
                                }
                            }
                            var token = "";
                            token = token + "{\"facebook_access_token\":\"\(user.facebookAccessToken!)\"";
                            token = token + ",\"facebook_id\":\"\(user.facebookId!)\"}";
                            postData["token"] = token;
                            let jsonURL = "user/upate_user_tokens/format/json";
                            UserService().postDataMethod(jsonURL: jsonURL,postData:postData,complete:{(response) in
                                print(response)
                            });
                        });
                        
                    }
                }  }
        }
        
        
    }
    
    @IBAction func twitterBtnClicked(_ sender: Any) {
        
        
        
        if(createPostViewControllerDelegate.twitterStatus==false){
            createPostViewControllerDelegate.twitterStatus = true //setting as clicked
            self.twitterBtn.backgroundColor = UIColor.init(red: 12/255, green: 111/255, blue: 2333/255, alpha: 1);
            self.twitterBtn.layer.borderWidth = 0
            let image = UIImage(named: "twitter")
            self.twitterBtn.setImage(image, for: UIControlState.normal)
            for obj in createPostViewControllerDelegate.social.socialPlatformId {
                if (obj.key == "Twitter") {
                    createPostViewControllerDelegate.socialMediaPlatform.append(obj.value);
                    break;
                }
            }
            
        }else{
            createPostViewControllerDelegate.twitterStatus = false //setting to initial state
            
            self.twitterBtn.layer.borderWidth = 1
            self.twitterBtn.layer.borderColor =  UIColor(red: 12/255, green: 111/255, blue: 233/255, alpha: 1).cgColor;
            self.twitterBtn.backgroundColor = UIColor.white
            let image = UIImage(named: "twitter-group")
            self.twitterBtn.setImage(image, for: UIControlState.normal)
            for obj in createPostViewControllerDelegate.social.socialPlatformId {
                if (obj.key == "Twitter") {
                    if let index = createPostViewControllerDelegate.socialMediaPlatform.index(of:obj.value) {
                        createPostViewControllerDelegate.socialMediaPlatform.remove(at: index)
                    }
                    break;
                }
            }
            
        }
        if(createPostViewControllerDelegate.twitterExists == false && createPostViewControllerDelegate.twitterStatus == true){
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
                    
                    user.isTwitter = 1;
                    
                    let jsonURL = "user/upate_user_tokens/format/json";
                    
                    var postData = [String: Any]();
                    postData["user_id"] = self.createPostViewControllerDelegate.loggedInUser.userId
                    for obj in self.createPostViewControllerDelegate.social.socialPlatformId {
                        if (obj.key == "Twitter") {
                            
                            postData["social_media"] = obj.value
                            break;
                        }
                    }
                    
                    postData["twitter_id"] = user.twitterId
                    
                    if (user.isTwitter == 1) {
                        var token = "";
                        token = token + "{\"twitter_access_token\":\"\(user.twitterAccessToken!)\"";
                        token = token + ",\"twitter_access_secret\":\"\(user.twitterAccessSecret!)\"";
                        token = token + ",\"twitter_id\":\"\(user.twitterId!)\"}";
                        postData["token"] = "\(token)";
                    } else if (user.isFacebook == 1) {
                        var token = "";
                        token = token + "{\"facebook_access_token\":\"\(user.facebookAccessToken!)\"";
                        token = token + ",\"facebook_id\":\"\(user.facebookId!)\"}";
                        postData["token"] = token;
                    }
                    
                    print(user.toDictionary(user: user ))
                    UserService().postDataMethod(jsonURL: jsonURL,postData:postData,complete:{(response) in
                        print(response)
                    });
                    
                }else {
                    print("error: \(String(describing: error?.localizedDescription))");
                }
            }
        }
        
        
    }
    @IBAction func AddSocialMedia(_ sender: Any) {
        
        self.createPostViewControllerDelegate.imageUploadClicked();
    }
    
    @IBAction func postOnSocialPlatform(_ sender: Any) {
        
        let isValid = self.validateSocialPlatform();
        if(isValid == true){
            
            self.createPostViewControllerDelegate.activityIndicator.startAnimating();
            
            let jsonURL = "posts/create_new_caster_posts/format/json"
            var postData : [String : Any] = [String : Any]()
            postData["post_description"] = self.postTextField.text
            postData["user_id"] = self.createPostViewControllerDelegate.loggedInUser.userId
            //let joiner = ","
            let elements = (self.createPostViewControllerDelegate.socialMediaPlatform);
            
            var joinedStrings = "";
            for elementItem in elements! {
                joinedStrings = joinedStrings + "\(elementItem),";
            }
            joinedStrings = String(joinedStrings.dropLast())
            print(joinedStrings)
            postData["social_media"] = String(joinedStrings.suffix(joinedStrings.count-1));
            postData["social_media_id"] = joinedStrings
            //  let size = CGSize(width: 0, height: 0)
            print(self.createPostViewControllerDelegate.PhotoArray.count)
            if(self.createPostViewControllerDelegate.PhotoArray.count > 0){
                UserService().postMultipartImageDataSocialMethod(jsonURL: jsonURL,image : self.createPostViewControllerDelegate.PhotoArray, postData:postData,complete:{(response) in
                    print(response);
                    self.createPostViewControllerDelegate.activityIndicator.stopAnimating();
                    UIApplication.shared.keyWindow?.rootViewController = HomeViewController.MainViewController();
                })
            }else{
                UserService().postDataMethod(jsonURL: jsonURL, postData: postData, complete: { (response) in
                    print(response);
                    self.createPostViewControllerDelegate.activityIndicator.stopAnimating();
                    UIApplication.shared.keyWindow?.rootViewController = HomeViewController.MainViewController();
                })
            }
        }
    }
    
    func validateSocialPlatform()->Bool{
        if(self.createPostViewControllerDelegate.socialMediaPlatform.count == 0){
            let message = "Please select social media platforms"
            let alert = UIAlertController.init(title: "Error", message: message, preferredStyle: .alert);
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil));
            self.createPostViewControllerDelegate.present(alert, animated: true)
            return false
        } else  if(self.postTextField.text == "" ){
            let message = "Text field is empty"
            let alert = UIAlertController.init(title: "Error", message: message, preferredStyle: .alert);
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil));
            self.createPostViewControllerDelegate.present(alert, animated: true)
            return false
        }
        return true
    }
}
