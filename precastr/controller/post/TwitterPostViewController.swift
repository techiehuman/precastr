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
import BSImagePicker
import MobileCoreServices
import Photos
import NVActivityIndicatorView

protocol ImageLibProtocolT {
    func takePicture(viewC : UIViewController);
}
class TwitterPostViewController: UIViewController,UITextViewDelegate, UIImagePickerControllerDelegate, NVActivityIndicatorViewable {

     @IBOutlet weak var postTextField: UITextView!
    var loggedInUser : User!
    var social : SocialPlatform!
    var uploadImage : [UIImage] = [UIImage]()
    var imageDelegate : ImageLibProtocolT!
    var socialMediaPlatform : [Int]!
    var uploadImageStatus = false
    var facebookExists = false
    var twitterExists = false
    var facebookStatus = false
    var twitterStatus = false
    var SelectedAssets = [PHAsset]()
    var PhotoArray = [UIImage]()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView();

    @IBOutlet weak var twitterBtn: UIButton!
    
    @IBOutlet weak var facebookBtn: UIButton!
    @IBOutlet weak var sendViewArea: UIView!
    @IBOutlet weak var inputViewArea: UIView!
    var postArray : [String:Any] = [String:Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.center = self.view.center;
        activityIndicator.hidesWhenStopped = true;
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge;
        self.view.addSubview(activityIndicator);
   
        self.facebookBtn.layer.borderColor = UIColor(red: 12/255, green: 111/255, blue: 233/255, alpha: 1).cgColor;
        self.facebookBtn.layer.borderWidth = 1
        self.twitterBtn.layer.borderColor = UIColor(red: 12/255, green: 111/255, blue: 233/255, alpha: 1).cgColor;
        self.twitterBtn.layer.borderWidth = 1
        
        self.postTextField.delegate = self
        self.postTextField.layer.borderColor =  UIColor(red: 146/255, green: 147/255, blue: 149/255, alpha: 1).cgColor;
        self.postTextField.layer.borderWidth = 0.5
        
        loggedInUser =  User().loadUserDataFromUserDefaults(userDataDict : setting);
        self.social = SocialPlatform().loadSocialDataFromUserDefaults();
            //imageDelegate = Reusable()
        // Do any additional setup after loading the view.
        self.socialMediaPlatform = [Int]();
        
        let jsonURL = "user/get_user_details/format/json";
        postArray["user_id"] = String(loggedInUser.userId)
        UserService().postDataMethod(jsonURL: jsonURL, postData: postArray, complete: {(response) in
           // print(response);
           let modeArray = response.value(forKey: "data") as! NSDictionary;
            let tokens  = modeArray.value(forKey: "tokens") as! NSArray
            for mode in tokens{
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
            print(self.facebookExists)
            print(self.twitterExists)
            
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
            
            self.postTextField.text = "Write Something..."
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
            for obj in self.social.socialPlatformId {
                if (obj.key == "Facebook") {
                    self.socialMediaPlatform.append(obj.value);
                    break;
                }
            }
        }else{
            self.facebookStatus = false
            self.facebookBtn.layer.borderWidth = 1
            self.facebookBtn.layer.borderColor =  UIColor(red: 12/255, green: 111/255, blue: 233/255, alpha: 1).cgColor;
            self.facebookBtn.backgroundColor = UIColor.white
            let image = UIImage(named: "facebook-group")
            self.facebookBtn.setImage(image, for: UIControlState.normal)
            
            for obj in self.social.socialPlatformId {
                if (obj.key == "Facebook") {
                    if let index = socialMediaPlatform.index(of:obj.value) {
                        socialMediaPlatform.remove(at: index)
                    }
                    break;
                }
            }
           
           
        }
        if(self.facebookExists == false && self.facebookStatus == true){
            
            
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
                             postData["user_id"] = self.loggedInUser.userId
                            postData["facebook_id"] = user.facebookId
                        for obj in self.social.socialPlatformId {
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
        
        
        
        if(self.twitterStatus==false){
            self.twitterStatus = true //setting as clicked
           self.twitterBtn.backgroundColor = UIColor.init(red: 12/255, green: 111/255, blue: 2333/255, alpha: 1);
            self.twitterBtn.layer.borderWidth = 0
            let image = UIImage(named: "twitter")
            self.twitterBtn.setImage(image, for: UIControlState.normal)
            for obj in self.social.socialPlatformId {
                if (obj.key == "Twitter") {
                    self.socialMediaPlatform.append(obj.value);
                    break;
                }
            }
        
        }else{
            self.twitterStatus = false //setting to initial state
            
            self.twitterBtn.layer.borderWidth = 1
            self.twitterBtn.layer.borderColor =  UIColor(red: 12/255, green: 111/255, blue: 233/255, alpha: 1).cgColor;
            self.twitterBtn.backgroundColor = UIColor.white
             let image = UIImage(named: "twitter-group")
            self.twitterBtn.setImage(image, for: UIControlState.normal)
            for obj in self.social.socialPlatformId {
                if (obj.key == "Twitter") {
                    if let index = socialMediaPlatform.index(of:obj.value) {
                        socialMediaPlatform.remove(at: index)
                    }
                    break;
                }
            }
            
        }
        if(self.twitterExists == false && self.twitterStatus == true){
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
        // create an actionSheet
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // create an action
        let uploadPhotoAction: UIAlertAction = UIAlertAction(title: "Upload Photo", style: .default) { action -> Void in
            //self.imageUploadClicked();
            self.selectMultipleImages();
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
        
            self.activityIndicator.startAnimating();

        let jsonURL = "posts/create_new_caster_posts/format/json"
        var postData : [String : Any] = [String : Any]()
        postData["post_description"] = self.postTextField.text
        postData["user_id"] = self.loggedInUser.userId
        //let joiner = ","
        let elements = (self.socialMediaPlatform);
        
        var joinedStrings = "";
        for elementItem in elements! {
            joinedStrings = joinedStrings + "\(elementItem),";
        }
            joinedStrings = String(joinedStrings.dropLast())
        print(joinedStrings)
        postData["social_media"] = String(joinedStrings.suffix(joinedStrings.count-1));
        postData["social_media_id"] = joinedStrings
       //  let size = CGSize(width: 0, height: 0)
            print(PhotoArray.count)
        if(PhotoArray.count > 0){
            UserService().postMultipartImageDataSocialMethod(jsonURL: jsonURL,image : PhotoArray, postData:postData,complete:{(response) in
                print(response);
                self.activityIndicator.stopAnimating();
                UIApplication.shared.keyWindow?.rootViewController = HomeViewController.MainViewController();
            })
        }else{
            UserService().postDataMethod(jsonURL: jsonURL, postData: postData, complete: { (response) in
                  print(response);
                self.activityIndicator.stopAnimating();
                UIApplication.shared.keyWindow?.rootViewController = HomeViewController.MainViewController();
            })
        }
    }
    }
    @objc func imageUploadClicked(){
        // create an actionSheet
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // create an action
        let uploadPhotoAction: UIAlertAction = UIAlertAction(title: "Upload Photo", style: .default) { action -> Void in
            self.selectMultipleImages();
            //self.uploadImage.isHidden = false
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
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func validateSocialPlatform()->Bool{
        if(self.socialMediaPlatform.count == 0){
            let message = "Please select social media platforms"
            let alert = UIAlertController.init(title: "Error", message: message, preferredStyle: .alert);
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil));
            self.present(alert, animated: true)
            return false
        } else  if(self.postTextField.text == "" ){
            let message = "Text field is empty"
            let alert = UIAlertController.init(title: "Error", message: message, preferredStyle: .alert);
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil));
            self.present(alert, animated: true)
            return false
        }
        return true
    }
    
    func selectMultipleImages(){
        
        // create an instance
        let vc = BSImagePickerViewController()
        
        //display picture gallery
        self.bs_presentImagePickerController(vc, animated: true,
                                             select: { (asset: PHAsset) -> Void in
                                                
        }, deselect: { (asset: PHAsset) -> Void in
            // User deselected an assets.
            
        }, cancel: { (assets: [PHAsset]) -> Void in
            // User cancelled. And this where the assets currently selected.
        }, finish: { (assets: [PHAsset]) -> Void in
            // User finished with these assets
            for i in 0..<assets.count
            {
                self.SelectedAssets.append(assets[i])
                
            }
            
            self.convertAssetToImages()
            
        }, completion: nil)
        
    }
    
    func convertAssetToImages() -> Void {
        
        if SelectedAssets.count != 0{
            
            
            for i in 0..<SelectedAssets.count{
                
                let manager = PHImageManager.default()
                let option = PHImageRequestOptions()
                var thumbnail = UIImage()
                option.isSynchronous = true
                
                
                manager.requestImage(for: SelectedAssets[i], targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: option, resultHandler: {(result, info)->Void in
                    thumbnail = result!
                    
                })
                
                let data = UIImageJPEGRepresentation(thumbnail, 0.7)
                let newImage = UIImage(data: data!)
                
                
                PhotoArray.append(newImage! as UIImage)
                
            }
            // self.imgView.animationImages = self.PhotoArray
            //self.imgView.animationDuration = 3.0
            //self.imgView.startAnimating()
            
        }
    }
}
