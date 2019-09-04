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

class PostFormTableViewCell: UITableViewCell, UITextViewDelegate, PostFormCellProtocol {
   

    @IBOutlet weak var postTextField: UITextView!
    //@IBOutlet weak var twitterBtn: UIButton!
    //@IBOutlet weak var facebookBtn: UIButton!
    @IBOutlet weak var sendViewArea: UIView!
    @IBOutlet weak var inputViewArea: UIView!

    @IBOutlet weak var filesUploadedtext: UILabel!
    
    @IBOutlet weak var charaterCountLabel: UILabel!
    @IBOutlet weak var attachmentBtn : UIButton!
    @IBOutlet weak var submitBtn : UIButton!
    @IBOutlet weak var changeStatusBtn: UIButton!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    var createPostViewControllerDelegate: CreatePostViewController!;
    var descriptionMsg : String = "";
    var selectedPostStatusId : Int = 0;
     var loggedInUser : User!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        /*self.facebookBtn.layer.borderColor = UIColor(red: 12/255, green: 111/255, blue: 233/255, alpha: 1).cgColor;
        self.facebookBtn.layer.borderWidth = 1
        self.twitterBtn.layer.borderColor = UIColor(red: 12/255, green: 111/255, blue: 233/255, alpha: 1).cgColor;
        self.twitterBtn.layer.borderWidth = 1*/
        self.imageCollectionView.register(UINib.init(nibName: "PostImageCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "PostImageCollectionViewCell");
        
        self.postTextField.delegate = self
        self.postTextField.layer.borderColor =  UIColor(red: 146/255, green: 147/255, blue: 149/255, alpha: 1).cgColor;
        self.postTextField.layer.borderWidth = 0.5
        self.postTextField.textColor = UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 1);
        self.attachmentBtn.roundEdgesLeftBtn();
        self.submitBtn.roundEdgesRightBtn();
        self.changeStatusBtn.roundEdgesBtn();
        self.changeStatusBtn.layer.borderWidth = 1;
        self.changeStatusBtn.layer.borderColor = UIColor(red: 112/255, green: 112/255, blue: 112/255, alpha: 1).cgColor;
         loggedInUser =  User().loadUserDataFromUserDefaults(userDataDict : setting);
        if(loggedInUser.isCastr == 2){
            self.changeStatusBtn.isHidden = false
          //  self.selectedPostStatusId = self.createPostViewControllerDelegate.post.postStatusId
        }
        
        addDoneButtonOnKeyboard();
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("A")
        if self.postTextField.textColor == UIColor(red: 118/255, green: 118/255, blue: 119/255, alpha: 1) {
            self.postTextField.text = ""
            self.postTextField.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        print("B")
        if self.postTextField.text == "" {
            self.postTextField.text = "Write Something..."
            self.postTextField.textColor = UIColor(red: 118/255, green: 118/255, blue: 119/255, alpha: 1);
        }
    }
    
    /*func activeFacebookIcon() {
        self.facebookBtn.backgroundColor = UIColor.init(red: 12/255, green: 111/255, blue: 2333/255, alpha: 1);
        self.facebookBtn.layer.borderWidth = 0
        let image = UIImage(named: "facebook")
        self.facebookBtn.setImage(image, for: UIControlState.normal)
        for obj in createPostViewControllerDelegate.social.socialPlatformId {
            if (obj.key == "Facebook") {
                createPostViewControllerDelegate.socialMediaPlatform.append(obj.value);
                createPostViewControllerDelegate.facebookStatus = true
                break;
            }
        }
    }*/

    /*@IBAction func facebookBtnClicked(_ sender: Any) {
        
        //self.socialMediaPlatform.append((social.socialPlatformId["facebook"])!)
        if(createPostViewControllerDelegate.facebookStatus == false){//If facebook is not clicked.
            
            if(self.createPostViewControllerDelegate.facebookExists == true){//If facebook is synced.
                self.activeFacebookIcon();                                     //Active the icon
            } else {
                self.facebookSocialSync();//if facebook not synced. We will sync it
            }
        }else{
            //If facebook is already clicked. That means it is synced. Then we have to unsync it.
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
     
        
    }*/
    
    
    /*func activeTwitterIcon () {
        self.twitterBtn.backgroundColor = UIColor.init(red: 12/255, green: 111/255, blue: 2333/255, alpha: 1);
        self.twitterBtn.layer.borderWidth = 0
        let image = UIImage(named: "twitter")
        self.twitterBtn.setImage(image, for: UIControlState.normal)
        for obj in createPostViewControllerDelegate.social.socialPlatformId {
            if (obj.key == "Twitter") {
                createPostViewControllerDelegate.socialMediaPlatform.append(obj.value);
                createPostViewControllerDelegate.twitterStatus = true //setting as clicked
                break;
            }
        }
    }*/
    
    /*@IBAction func twitterBtnClicked(_ sender: Any) {
        
        if(createPostViewControllerDelegate.twitterStatus==false) {//Twitter is not clicked yet.
            
            
            if (self.descriptionMsg.count > 280) {
                createPostViewControllerDelegate.showAlert(title: "Alert", message: "Description for Twitter cannot\nbe more than 280 characters.")
            } else {
                //If user clicked twitter
                //Lets check if user is already linked.
                if (createPostViewControllerDelegate.twitterExists == true) {//If user already linked to twotter
                    //hight light twitter icon
                    activeTwitterIcon();
                } else {
                    //Else sync with twitter
                    self.twitterSocialSync();
                }
            }
        }else{ //If icon is already clicked. User wnant to uncheck, then deactive it.
            createPostViewControllerDelegate.twitterStatus = false //setting to initial state
            
            self.twitterBtn.layer.borderWidth = 1
            self.twitterBtn.layer.borderColor =  UIColor(red: 12/255, green: 111/255, blue: 233/255, alpha: 1).cgColor;
            self.twitterBtn.backgroundColor = UIColor.white
            let image = UIImage(named: "twitter-group")
            self.twitterBtn.setImage(image, for: UIControlState.normal)
            /*for obj in createPostViewControllerDelegate.social.socialPlatformId {
                if (obj.key == "Twitter") {
                    if let index = createPostViewControllerDelegate.socialMediaPlatform.index(of:obj.value) {
                        createPostViewControllerDelegate.socialMediaPlatform.remove(at: index)
                    }
                    break;
                }
            }*/
            
        }
        
        
    }*/
    @IBAction func AddSocialMedia(_ sender: Any) {
        
        self.createPostViewControllerDelegate.imageUploadClicked();
    }
    
    @IBAction func postOnSocialPlatform(_ sender: Any) {
        
        let isValid = self.validateSocialPlatform();
        if(isValid == true) {
           
            //If its an edit post request
            if (self.createPostViewControllerDelegate.post != nil) {
                
                self.createPostViewControllerDelegate.activityIndicator.startAnimating();
                
                let jsonURL = "posts/post_update/format/json"
                var postData : [String : Any] = [String : Any]()
                postData["post_description"] = self.postTextField.text
                postData["user_id"] = self.createPostViewControllerDelegate.loggedInUser.userId
                postData["post_id"] = self.createPostViewControllerDelegate.post.postId
                if(self.changeStatusBtn.titleLabel?.text == "Rejected" && loggedInUser.isCastr == 1){
                     postData["post_status_id"] = 1
                }else{
                    postData["post_status_id"] = self.createPostViewControllerDelegate.post.postStatusId
                }
               
                if(loggedInUser.isCastr == 2){
                    postData["post_status_id"] = self.selectedPostStatusId
                }
                
                var imagesStr = "";
                self.createPostViewControllerDelegate.PhotoArray = [UIImage]();
                if (self.createPostViewControllerDelegate.postImageDtos.count > 0) {
                    
                    for postImageDto in self.createPostViewControllerDelegate.postImageDtos {
                        if (postImageDto.imageStr != "") {
                            imagesStr = imagesStr + "\(postImageDto.imageStr),";
                        } else {
                            self.createPostViewControllerDelegate.PhotoArray.append(postImageDto.postImage);
                        }
                    }
                    
                    //This is neeeded if we are updating and we have alreay image urls.
                    postData["old_image_path"] = imagesStr.prefix(imagesStr.count-1);
                }

                //let joiner = ","
                
                var joinedStrings = "";
                for obj in createPostViewControllerDelegate.social.socialPlatformId {
                    if (obj.key == "Facebook" && self.createPostViewControllerDelegate.facebookStatus == true) {//If user selcts facebook
                        joinedStrings = joinedStrings + "\(obj.value),";
                    } else if (obj.key == "Twitter" && self.createPostViewControllerDelegate.twitterStatus == true) {//If user selcts twiiter
                        joinedStrings = joinedStrings + "\(obj.value),";
                    }
                }
                
                let elements = (self.createPostViewControllerDelegate.socialMediaPlatform);
                
                /*            for elementItem in elements! {
                 joinedStrings = joinedStrings + "\(elementItem),";
                 }*/
                joinedStrings = String(joinedStrings.dropLast())
                print(joinedStrings)
                //postData["social_media"] = String(joinedStrings.suffix(joinedStrings.count-1));
                //postData["social_media_id"] = joinedStrings
                //  let size = CGSize(width: 0, height: 0)
                print(self.createPostViewControllerDelegate.PhotoArray.count)
                if(self.createPostViewControllerDelegate.PhotoArray.count > 0) {
                    UserService().postMultipartImageDataSocialMethod(jsonURL: jsonURL,image : self.createPostViewControllerDelegate.PhotoArray, postData:postData,complete:{(response) in
                        print(response);
                        let status = Int(response.value(forKey: "status") as! String)!
                        if(status == 0){
                            let message = response.value(forKey: "message") as! String;
                            self.createPostViewControllerDelegate.showAlert(title: "Error", message: message);
                        }else{
                        self.createPostViewControllerDelegate.activityIndicator.stopAnimating();
                        UIApplication.shared.keyWindow?.rootViewController = HomeViewController.MainViewController();
                    }
                    })
                } else {
                    UserService().postDataMethod(jsonURL: jsonURL, postData: postData, complete: { (response) in
                        print(response);
                        let status = Int(response.value(forKey: "status") as! String)!
                        if(status == 0){
                            let message = response.value(forKey: "message") as! String;
                            self.createPostViewControllerDelegate.showAlert(title: "Error", message: message);
                        }else{
                        self.createPostViewControllerDelegate.activityIndicator.stopAnimating();
                        UIApplication.shared.keyWindow?.rootViewController = HomeViewController.MainViewController();
                    }
                    })
                }
            }
            else {
                self.createPostViewControllerDelegate.activityIndicator.startAnimating();
                
                let jsonURL = "posts/create_new_caster_posts/format/json"
                var postData : [String : Any] = [String : Any]()
                postData["post_description"] = self.postTextField.text
                postData["user_id"] = self.createPostViewControllerDelegate.loggedInUser.userId
                //let joiner = ","
                
                var joinedStrings = "";
                for obj in createPostViewControllerDelegate.social.socialPlatformId {
                    if (obj.key == "Facebook" && self.createPostViewControllerDelegate.facebookStatus == true) {//If user selcts facebook
                        joinedStrings = joinedStrings + "\(obj.value),";
                    } else if (obj.key == "Twitter" && self.createPostViewControllerDelegate.twitterStatus == true) {//If user selcts twiiter
                        joinedStrings = joinedStrings + "\(obj.value),";
                    }
                }
                
                let elements = (self.createPostViewControllerDelegate.socialMediaPlatform);
                
                /*            for elementItem in elements! {
                 joinedStrings = joinedStrings + "\(elementItem),";
                 }*/
                joinedStrings = String(joinedStrings.dropLast())
                print(joinedStrings)
                //postData["social_media"] = String(joinedStrings.suffix(joinedStrings.count-1));
                //postData["social_media_id"] = joinedStrings
                //  let size = CGSize(width: 0, height: 0)
                if(self.createPostViewControllerDelegate.PhotoArray.count > 0){
                    UserService().postMultipartImageDataSocialMethod(jsonURL: jsonURL,image : self.createPostViewControllerDelegate.PhotoArray, postData:postData,complete:{(response) in
                        print(response);
                        let status = Int(response.value(forKey: "status") as! String)!
                        if (status == 0) {
                            let message = response.value(forKey: "message") as! String;
                            let alert = UIAlertController.init(title: "Error", message: message, preferredStyle: .alert);
                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil));
                            self.createPostViewControllerDelegate.present(alert, animated: true)
                            self.createPostViewControllerDelegate.activityIndicator.stopAnimating();
                        } else {
                           
                        self.createPostViewControllerDelegate.activityIndicator.stopAnimating();
                        UIApplication.shared.keyWindow?.rootViewController = HomeViewController.MainViewController();
                    }
                    })
                }else{
                    UserService().postDataMethod(jsonURL: jsonURL, postData: postData, complete: { (response) in
                        print(response);
                        let status = Int(response.value(forKey: "status") as! String)!
                        if (status == 0) {
                            let message = response.value(forKey: "message") as! String;
                            let alert = UIAlertController.init(title: "Error", message: message, preferredStyle: .alert);
                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil));
                            self.createPostViewControllerDelegate.present(alert, animated: true)
                            self.createPostViewControllerDelegate.activityIndicator.stopAnimating();
                        } else {
                           
                        self.createPostViewControllerDelegate.activityIndicator.stopAnimating();
                        UIApplication.shared.keyWindow?.rootViewController = HomeViewController.MainViewController();
                    }
                    })
                }
            }
            }
        
            
    }
    
    func validateSocialPlatform()->Bool{
        /*if(self.createPostViewControllerDelegate.twitterStatus == false && self.createPostViewControllerDelegate.facebookStatus == false){
            let message = "Please select social media platforms"
            let alert = UIAlertController.init(title: "Error", message: message, preferredStyle: .alert);
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil));
            self.createPostViewControllerDelegate.present(alert, animated: true)
            return false
        } else*/  if(self.postTextField.text == "" ){
            let message = "Text field is empty"
            let alert = UIAlertController.init(title: "Error", message: message, preferredStyle: .alert);
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil));
            self.createPostViewControllerDelegate.present(alert, animated: true)
            return false
        }
        
        return true
    }
    func facebookSocialSync() {
            
        let fbloginManger: LoginManager = LoginManager()
            /*CODE FOR LOGOUT */
            AccessToken.current = nil
            Profile.current = nil
            
            LoginManager().logOut()
            let cookies = HTTPCookieStorage.shared
            let facebookCookies = cookies.cookies(for: URL(string: "https://facebook.com/")!)
            for cookie in facebookCookies! {
                cookies.deleteCookie(cookie )
            }
            /* CODE FOR LOGOUT */
        fbloginManger.logIn(permissions: ["email"], from:createPostViewControllerDelegate) {(result, error) -> Void in
                if(error == nil){
                    let fbLoginResult: LoginManagerLoginResult  = result!
                    
                    if( result?.isCancelled)!{
                        return }
                    
                    
                    if(fbLoginResult .grantedPermissions.contains("email")){
                        GraphRequest(graphPath: "me", parameters: ["fields": "id"]).start(completionHandler: { (connection, result, error) in
                            guard let Info = result as? [String: Any] else { return }
                            let user = User();
                            print(AccessToken.current!.tokenString)
                            user.facebookAccessToken = String(AccessToken.current!.tokenString as! String);
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
                           
                            self.createPostViewControllerDelegate.facebookStatus = true;
                            self.createPostViewControllerDelegate.facebookExists = true;
                            let jsonURL = "user/upate_user_tokens/format/json";
                            UserService().postDataMethod(jsonURL: jsonURL,postData:postData,complete:{(response) in
                                print(response);
                                
                                //self.activeFacebookIcon();
                            });
                        });
                        
                    }
                }  }
    }
    func twitterSocialSync(){
            let store = TWTRTwitter.sharedInstance().sessionStore
            if let userID = store.session()?.userID {
                store.logOutUserID(userID)
            }
            
            TWTRTwitter.sharedInstance().logIn { (session, error) in
                if (session != nil) {
                    let user = User();
                    let name = session?.userName ?? ""
            
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
                        self.createPostViewControllerDelegate.twitterStatus = true
                        self.createPostViewControllerDelegate.twitterExists = true

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
    
    func upadedSelectedImageCounts(counts: String) {
        filesUploadedtext.isHidden = false;
        filesUploadedtext.text = "\(counts) files uploaded successfully"
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        descriptionMsg = currentText.replacingCharacters(in: stringRange, with: text)
        
        //This label is for showing the number of characters allowed
        self.charaterCountLabel.text = "\(descriptionMsg.count) Characters";
        
        if (createPostViewControllerDelegate.twitterStatus && createPostViewControllerDelegate.facebookStatus) {
            return descriptionMsg.count < 280
        } else if (createPostViewControllerDelegate.twitterStatus == true) {
            return descriptionMsg.count < 280
        } else if (createPostViewControllerDelegate.facebookStatus == true) {
            return true;
        }
        
        return true;
        
    }
    
    func addDoneButtonOnKeyboard() {
        
        // add a done button to the numberpad
        var toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        var cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        var doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: "doneButtonAction")
        var spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        self.postTextField.delegate = self
        self.postTextField.inputAccessoryView = toolBar
    }
    
    
    @objc func doneButtonAction() {
        self.postTextField.resignFirstResponder()
    }

    @IBAction func changeStatusButtonClicked(_ sender: Any) {
        
       
        // create an actionSheet
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // create an action
        for postStatus in postStatusList {
            
            
            if (self.loggedInUser.isCastr == 2) {
                
                //We will not moderator to Publish post
                if (postStatus.title == "Published") {
                    continue;
                }
                
                let pendingReviewAction: UIAlertAction = UIAlertAction(title: postStatus.title, style: .default) { action -> Void in
                    self.selectedPostStatusId = postStatus.postStatusId;
                    self.changeStatusBtn.setTitle(postStatus.title, for: .normal);
                    self.updatePostStatus(postStatusId: self.selectedPostStatusId);
                }
                actionSheetController.addAction(pendingReviewAction)

            }
        }
        print("selectedPostStatusId")
        print(self.selectedPostStatusId)
       
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
        cancelAction.setValue(UIColor.black, forKey: "titleTextColor")
        
        actionSheetController.addAction(cancelAction)
        
        // present an actionSheet...
        createPostViewControllerDelegate.present(actionSheetController, animated: true, completion: nil)
        print(createPostViewControllerDelegate.post.status)
       
    }
    func updatePostStatus(postStatusId: Int){
        if (createPostViewControllerDelegate.post.status != "Approved" && postStatusId == 7) { // going to publish
            
            let alert = UIAlertController.init(title: "Error", message: "Post not Approved yet", preferredStyle: .alert);
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil));
            createPostViewControllerDelegate.present(alert, animated: true);
            self.selectedPostStatusId = createPostViewControllerDelegate.post.postStatusId
             self.changeStatusBtn.setTitle(createPostViewControllerDelegate.post.status, for: .normal);
            
        }
    }
    
    func reloadCollctionView() {
        self.imageCollectionView.reloadData();
    }
    
    @objc func deleteFromList(sender: DeleteIconGestureRecognizer) {
        
        /*if (self.createPostViewControllerDelegate.post != nil && self.createPostViewControllerDelegate.post.postId != nil && self.createPostViewControllerDelegate.post.postImages.count != 0) {
            self.createPostViewControllerDelegate.post.postImages.remove(at: sender.index);
            self.upadedSelectedImageCounts(counts: String(self.createPostViewControllerDelegate.post.postImages.count));

        } else {
            
            self.createPostViewControllerDelegate.PhotoArray.remove(at: sender.index);
            self.upadedSelectedImageCounts(counts: String(self.createPostViewControllerDelegate.PhotoArray.count));

        }*/
        
        self.createPostViewControllerDelegate.postImageDtos.remove(at: sender.index);
        self.upadedSelectedImageCounts(counts: String(self.createPostViewControllerDelegate.postImageDtos.count));

        self.imageCollectionView.reloadData();
        self.createPostViewControllerDelegate.createPostTableView.reloadData();
    }
}

class DeleteIconGestureRecognizer: UITapGestureRecognizer {
    
    var index: Int = 0;
}
extension PostFormTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var counts = 0;
        
        /*if (self.createPostViewControllerDelegate.post != nil && self.createPostViewControllerDelegate.post.postId != nil && self.createPostViewControllerDelegate.post.postImages.count != 0) {
            counts = counts + self.createPostViewControllerDelegate.post.postImages.count;
        }
        
        if (self.createPostViewControllerDelegate.PhotoArray.count > 0) {
            counts = counts +  self.createPostViewControllerDelegate.PhotoArray.count;
        }*/
        
        return self.createPostViewControllerDelegate.postImageDtos.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var imageToShow : UIImage? = nil;
        var imageUrlToShow:  String? = nil;
        var postImageDto = self.createPostViewControllerDelegate.postImageDtos[indexPath.row];
        
        /*if (self.createPostViewControllerDelegate.post != nil && self.createPostViewControllerDelegate.post.postId != nil && self.createPostViewControllerDelegate.post.postImages.count != 0) {
            imageUrlToShow = self.createPostViewControllerDelegate.post.postImages[indexPath.row];
        } else {
            imageToShow = self.createPostViewControllerDelegate.PhotoArray[indexPath.row];
        }*/
        if (postImageDto.imageStr != "") {
            imageUrlToShow = postImageDto.imageStr;
        } else {
            imageToShow = postImageDto.postImage;
        }
        let cell = self.imageCollectionView.dequeueReusableCell(withReuseIdentifier: "PostImageCollectionViewCell", for: indexPath) as! PostImageCollectionViewCell;
        
        if (imageToShow != nil) {
            cell.postImage.image = imageToShow;
        } else {
            cell.postImage.sd_setImage(with: URL.init(string: imageUrlToShow!), placeholderImage: UIImage.init(named: "post-image-placeholder"));
        }
        var deleteButtonTapGestureReco = DeleteIconGestureRecognizer.init(target: self, action: #selector(deleteFromList(sender:)));
        deleteButtonTapGestureReco.index = indexPath.row;
        cell.crossIconImage.addGestureRecognizer(deleteButtonTapGestureReco);
        
        return cell;
    }
    
    
    
}
