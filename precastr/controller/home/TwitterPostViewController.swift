//
//  TwitterPostViewController.swift
//  precastr
//
//  Created by Macbook on 26/04/19.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import TwitterKit
import TwitterCore

protocol ImageLibProtocolT {
    func takePicture(viewC : UIViewController);
    func selectPicture(viewC : UIViewController,cameraView : UIImageView);
}
class TwitterPostViewController: UIViewController,UITextViewDelegate {

     @IBOutlet weak var postTextField: UITextView!
    var loggedInUser : User!
    var social : SocialPlatform!
    var uploadImage : UIImageView!
    var imageDelegate : ImageLibProtocolT!
    var socialMediaPlatform : [Int]!
    var uploadImageStatus = false
    var facebookExists = false
    var twitterExists = false
    var facebookStatus = false
    var twitterStatus = false
    
    @IBOutlet weak var twitterBtn: UIButton!
    
    @IBOutlet weak var facebookBtn: UIButton!
    @IBOutlet weak var sendViewArea: UIView!
    @IBOutlet weak var inputViewArea: UIView!
    var postArray : [String:Any] = [String:Any]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Create a new Cast";
        
        self.facebookBtn.layer.borderColor = UIColor(red: 12/255, green: 111/255, blue: 233/255, alpha: 1).cgColor;
        self.facebookBtn.layer.borderWidth = 1
        self.twitterBtn.layer.borderColor = UIColor(red: 12/255, green: 111/255, blue: 233/255, alpha: 1).cgColor;
        self.twitterBtn.layer.borderWidth = 1
            self.postTextField.delegate = self
            //self.postTextField.text = "Please add text to be posted ..."
           // self.postTextField.textColor = UIColor.lightGray
        self.postTextField.layer.borderColor =  UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1).cgColor;
        self.postTextField.layer.borderWidth = 1
             loggedInUser =  User().loadUserDataFromUserDefaults(userDataDict : setting);
            self.social = SocialPlatform().loadSocialDataFromUserDefaults();
            imageDelegate = Reusable()
        let imageTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(imageUploadClicked))
        //uploadImage.addGestureRecognizer(imageTapGesture);
        // Do any additional setup after loading the view.
        self.socialMediaPlatform = [Int]();
        
        let jsonURL = "user/get_user_details/format/json";
         postArray["user_id"] = String(loggedInUser.userId)
        UserService().postDataMethod(jsonURL: jsonURL, postData: postArray, complete: {(response) in
           // print(response);
           let modeArray = response.value(forKey: "data") as! NSDictionary;
            var tokens  = modeArray.value(forKey: "tokens") as! NSArray
            for mode in tokens{
                var type = [String : Any]()
                var modeDict = mode as! NSDictionary;
                // self.moderators.append(String((modeDict.value(forKey: "username") as! NSString) as String)!);
                print(modeDict.value(forKey: "type") as! String);
                if(modeDict.value(forKey: "type") as! String == "Facebook") {
                    self.facebookExists = true
                }
                if(modeDict.value(forKey: "type") as! String == "Twitter") {
                    self.twitterExists = true
                }
                
            }
            
        });
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
            
            self.postTextField.text = "Placeholder text ..."
            self.postTextField.textColor = UIColor.lightGray
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
   
    
    @IBAction func facebookBtnClicked(_ sender: Any) {
        
        //self.socialMediaPlatform.append((social.socialPlatformId["facebook"])!)
        if(self.facebookStatus==false){
            self.facebookStatus = true
            self.facebookBtn.backgroundColor = UIColor.init(red: 12/255, green: 111/255, blue: 2333/255, alpha: 1);
            self.facebookBtn.layer.borderWidth = 0
            let image = UIImage(named: "facebook")
            self.facebookBtn.setImage(image, for: UIControlState.normal)
        }else{
            self.facebookStatus = false
            self.facebookBtn.layer.borderWidth = 1
            self.facebookBtn.layer.borderColor =  UIColor(red: 12/255, green: 111/255, blue: 233/255, alpha: 1).cgColor;
            self.facebookBtn.backgroundColor = UIColor.white
            let image = UIImage(named: "facebook-group")
            self.facebookBtn.setImage(image, for: UIControlState.normal)
        }
        if(self.facebookExists == false){
            
            
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
                        FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id"]).start(completionHandler: { (connection, result, error) in
                            guard let Info = result as? [String: Any] else { return }
                        let user = User();
                        print(FBSDKAccessToken.current().tokenString)
                        user.facebookAccessToken = String(FBSDKAccessToken.current().tokenString as! String);
                        user.facebookId = String(Info["id"] as! String)
                        
                        user.isFacebook = 1;
                        var postData = [String : Any]()
                        for obj in self.social.socialPlatformId {
                            if (obj.key == "Facebook") {
                                self.socialMediaPlatform.append(obj.value);
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
        
        if(self.twitterStatus==false){
            self.twitterStatus = true //setting as clicked
           self.twitterBtn.backgroundColor = UIColor.init(red: 12/255, green: 111/255, blue: 2333/255, alpha: 1);
            self.twitterBtn.layer.borderWidth = 0
            let image = UIImage(named: "twitter")
            self.twitterBtn.setImage(image, for: UIControlState.normal)
        
        }else{
            self.twitterStatus = false //setting to initial state
            
            self.twitterBtn.layer.borderWidth = 1
            self.twitterBtn.layer.borderColor =  UIColor(red: 12/255, green: 111/255, blue: 233/255, alpha: 1).cgColor;
            self.twitterBtn.backgroundColor = UIColor.white
             let image = UIImage(named: "twitter-group")
            self.twitterBtn.setImage(image, for: UIControlState.normal)
            
        }
        if(self.twitterExists == false){
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
                    postData["user_id"] = self.loggedInUser.userId
                    for obj in self.social.socialPlatformId {
                        if (obj.key == "Twitter") {
                            self.socialMediaPlatform.append(obj.value);
                            postData["social_media"] = obj.value
                            break;
                        }
                    }
                    postData["user_id"] = user.twitterAccessSecret
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
        // create an actionSheet
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // create an action
        let uploadPhotoAction: UIAlertAction = UIAlertAction(title: "Upload Photo", style: .default) { action -> Void in
            self.imageDelegate.selectPicture(viewC: self,cameraView: self.uploadImage);
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
    
   
    
   
    @IBAction func postOnSocialPlatform(_ sender: Any) {
        
        let isValid = self.validateSocialPlatform();
        if(isValid == true){
        let jsonURL = "posts/create_new_caster_posts/format/json"
        var postData : [String : Any] = [String : Any]()
        postData["post_description"] = self.postTextField.text
        postData["user_id"] = self.loggedInUser.userId
        let joiner = ","
        let elements = (self.socialMediaPlatform);
        
        var joinedStrings = "";
        for elementItem in elements! {
            joinedStrings = joinedStrings + "\(elementItem),";
        }
        print(joinedStrings)
        postData["social_media_id"] = String(joinedStrings.suffix(joinedStrings.count-1));
        
        if(uploadImage.image != nil){
            UserService().postMultipartImageDataSocialMethod(jsonURL: jsonURL,image : uploadImage.image!, postData:postData,complete:{(response) in
                print(response);
            })
        }else{
            UserService().postDataMethod(jsonURL: jsonURL, postData: postData, complete: { (response) in
                  print(response);
            })
        }
    }
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
    func validateSocialPlatform()->Bool{
        if(self.socialMediaPlatform == nil){
            let message = "Please select social media platforms"
            let alert = UIAlertController.init(title: "Error", message: message, preferredStyle: .alert);
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil));
            self.present(alert, animated: true)
            return false
        }
        return true
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
