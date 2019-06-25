//
//  CommunicationViewController.swift
//  precastr
//
//  Created by Macbook on 14/06/19.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit
import BSImagePicker
import MobileCoreServices
import Photos
import FBSDKLoginKit
import FBSDKCoreKit
import TwitterKit
import TwitterCore

protocol ImageLibProtocolC {
    func takePicture(viewC : UIViewController);
}

class CommunicationViewController: UIViewController,UITextViewDelegate, UIImagePickerControllerDelegate {

    var posts = [Post]();
    var post = Post();
    @IBOutlet weak var communicationTableView: UITableView!
    //@IBOutlet weak var postTextField: UITextView!
    
    @IBOutlet weak var textAreaBtnBottomView: UIView!
    @IBOutlet weak var textArea: UITextView!
        
    @IBOutlet weak var changeStatusBtn: UIButton!
    
    @IBOutlet weak var editPostBtn: UIButton!
    var loggedInUser : User!
    var uploadImage : [UIImage] = [UIImage]()
    var imageDelegate : ImageLibProtocolT!
    var socialMediaPlatform : [Int]!
    var uploadImageStatus = false
    var facebookExists = false
    var twitterExists = false
    var facebookStatus = false
    var twitterStatus = false
    var facebookAPI = false
    var twitterAPI = false
    var SelectedAssets = [PHAsset]()
    var PhotoArray = [UIImage]()
    var postStatus : Int = 0
    var postArray : [String:Any] = [String:Any]()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView();
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loggedInUser = User().loadUserDataFromUserDefaults(userDataDict: setting);
        social = SocialPlatform().loadSocialDataFromUserDefaults();

        self.editPostBtn.semanticContentAttribute = UIApplication.shared
            .userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft;
        
        communicationTableView.register(UINib(nibName: "HomeTextPostTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "HomeTextPostTableViewCell")
        communicationTableView.register(UINib.init(nibName: "LeftCommunicationTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "LeftCommunicationTableViewCell");
          communicationTableView.register(UINib.init(nibName: "RightCommunicationTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "RightCommunicationTableViewCell");
         communicationTableView.register(UINib.init(nibName: "HomeTextPostTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "HomeTextPostTableViewCell");
        
        
        activityIndicator.center = view.center;
        activityIndicator.hidesWhenStopped = true;
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray;
        view.addSubview(activityIndicator);
        
        // Do any additional setup after loading the view.
        /*self.pendingBtn.roundBtn()
        self.approvedBtn.roundBtn()
        self.rejectedBtn.roundBtn()
        self.underReviewBtn.roundBtn()
        
        
        self.pendingBtn.radioBtnx`Default();
        self.approvedBtn.radioBtnDefault();
        self.rejectedBtn.radioBtnDefault();
        self.underReviewBtn.radioBtnDefault();*/
        /*self.twitterBtn.layer.borderWidth = 1
        self.facebookBtn.layer.borderWidth = 1
        self.twitterBtn.layer.borderColor = UIColor(red: 12/255, green: 111/255, blue: 233/255, alpha: 1).cgColor
        self.facebookBtn.layer.borderColor = UIColor(red: 12/255, green: 111/255, blue: 233/255, alpha: 1).cgColor
        */
        self.textArea.layer.cornerRadius = 4;
        self.textArea.layer.borderWidth = 1;
        self.textArea.layer.borderColor = UIColor(red: 112/255, green: 112/255, blue: 112/255, alpha: 1).cgColor;
        self.textArea.text = "Type a message..."
        self.textArea.textColor = UIColor.lightGray

        self.editPostBtn.layer.cornerRadius = 4;
        
        self.changeStatusBtn.layer.cornerRadius = 4;
        self.changeStatusBtn.layer.borderWidth = 1;
        self.changeStatusBtn.layer.borderColor = UIColor(red: 112/255, green: 112/255, blue: 112/255, alpha: 1).cgColor;
        print(loggedInUser.userCastSettingId)
        if(loggedInUser.userCastSettingId == 1){
            self.changeStatusBtn.isUserInteractionEnabled = false
           // self.changeStatusBtn.isEnabled = false
            self.changeStatusBtn.alpha = 0.5;
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        self.setUpNavigationBarItems();
        
        self.hideKeyboadOnTapOutside();
        
        self.getPostCommunications();
        
        self.getAllPostStatuses();
   //  postStatusList = loadPostStatus()
    }

    @IBOutlet weak var pendingBtn : UIButton!
    @IBOutlet weak var approvedBtn : UIButton!
    @IBOutlet weak var underReviewBtn : UIButton!
    @IBOutlet weak var rejectedBtn : UIButton!
    
    @IBOutlet weak var twitterBtn: UIButton!
     @IBOutlet weak var facebookBtn: UIButton!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func getAllPostStatuses() {
        for postStatus in postStatusList {
            if (postStatus.postStatusId == self.post.postStatusId) {
                self.changeStatusBtn.setTitle(postStatus.title, for: .normal);
                
                // Lets add ui labels in width.
                let totalWidthOfUIView = self.changeStatusBtn.intrinsicContentSize.width + 20;
                self.changeStatusBtn.frame = CGRect.init(x: (self.view.frame.width - totalWidthOfUIView - 15), y: self.changeStatusBtn.frame.origin.y, width: totalWidthOfUIView, height: self.changeStatusBtn.frame.height);
                break;
            }
        }
    }
    
    func setUpNavigationBarItems() {
        
        let menuButton = UIButton();
        menuButton.setImage(UIImage.init(named: "left-arrow"), for: .normal);
        menuButton.addTarget(self, action: #selector(backButtonPressed), for: UIControlEvents.touchUpInside)
        menuButton.frame = CGRect.init(x: 0, y:0, width: 20, height: 15);
        
        let barButton = UIBarButtonItem(customView: menuButton)
        
        navigationItem.leftBarButtonItem = barButton;
        
        let homeButton = UIButton();
        homeButton.setImage(UIImage.init(named: "menu"), for: .normal);
        homeButton.addTarget(self, action: #selector(menuButtonClicked), for: UIControlEvents.touchUpInside)
        homeButton.frame = CGRect.init(x: 0, y:0, width: 24, height: 24);
        
        let homeBarButton = UIBarButtonItem(customView: homeButton)
        
        navigationItem.rightBarButtonItem = homeBarButton;
        navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 12/255, green: 111/255, blue: 233/255, alpha: 1)
    }
    
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true);
    }
    
    
    @objc func menuButtonClicked() {
        let viewController: SideMenuTableViewController = self.storyboard?.instantiateViewController(withIdentifier: "SideMenuTableViewController") as! SideMenuTableViewController;
        self.navigationController?.pushViewController(viewController, animated: true);
    }


    
    @IBAction func submitBtnClicked(_ sender: Any) {
        
        if(textArea.text != ""){
            self.activityIndicator.startAnimating();
            
            let jsonURL = "\(ApiUrl)posts/add_post_communication/format/json"
            var postData : [String : Any] = [String : Any]()
            postData["post_communication_description"] = self.textArea.text
            postData["post_id"] = self.post.postId;
            postData["user_id"] = self.loggedInUser.userId;
            
            if (PhotoArray.count > 0) {
            
                HttpService().postMultipartImageForPostCommunication(url: jsonURL, image: PhotoArray, postData: postData, complete: {(response) in
                    
                    print(response);
                    
                    self.activityIndicator.stopAnimating();
                    //Load latest Communications
                    self.getPostCommunications();
                    self.textArea.text = "";
                });
            } else {
                HttpService().postMethod(url: jsonURL, postData: postData, complete: {(response) in
                    print(response);
                    
                    self.activityIndicator.stopAnimating();
                    //Load latest Communications
                    self.getPostCommunications();
                    self.textArea.text = "";
                });
            }
            
            
            //let joiner = ","
            
            /*var joinedStrings = "";
            for obj in social.socialPlatformId {
                if (obj.key == "Facebook" && self.createPostViewControllerDelegate.facebookStatus == true) {//If user selcts facebook
                    joinedStrings = joinedStrings + "\(obj.value),";
                } else if (obj.key == "Twitter" && self.createPostViewControllerDelegate.twitterStatus == true) {//If user selcts twiiter
                    joinedStrings = joinedStrings + "\(obj.value),";
                }
            }
            
            let elements = (self.socialMediaPlatform);
            
                        for elementItem in elements! {
             joinedStrings = joinedStrings + "\(elementItem),";
             }
            joinedStrings = String(joinedStrings.dropLast())
            print(joinedStrings)
            postData["social_media"] = String(joinedStrings.suffix(joinedStrings.count-1));
            postData["social_media_id"] = joinedStrings
            
            //  let size = CGSize(width: 0, height: 0)
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
            }*/
        }
    }
    
    @IBAction func mediaAttachmentBtnClicked(_ sender: Any) {
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
       // actionSheetController.addAction(takePhotoAction)
        actionSheetController.addAction(cancelAction)
        
        // present an actionSheet...
        present(actionSheetController, animated: true, completion: nil)
    }
    
    
    @IBAction func changeStatusButtonClicked(_ sender: Any) {
        
        // create an actionSheet
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // create an action
        for postStatus in postStatusList {
            
            if (postStatus.title == "Pending") {
                let pendingReviewAction: UIAlertAction = UIAlertAction(title: "Pending review", style: .default) { action -> Void in
                    self.updatePostStatus(postStatusId: postStatus.postStatusId);
                }
                actionSheetController.addAction(pendingReviewAction)
            }
            if (postStatus.title == "Unread by moderator") {
                let pendingReviewAction: UIAlertAction = UIAlertAction(title: "Unread by moderator", style: .default) { action -> Void in
                    self.updatePostStatus(postStatusId: postStatus.postStatusId);
                }
                actionSheetController.addAction(pendingReviewAction)
            }
            if (postStatus.title == "Pending with moderator") {
                let pendingReviewAction: UIAlertAction = UIAlertAction(title: "Pending with moderator", style: .default) { action -> Void in
                    self.updatePostStatus(postStatusId: postStatus.postStatusId);
                }
                actionSheetController.addAction(pendingReviewAction)
            }
            if (postStatus.title == "Pending with caster") {
                let pendingReviewAction: UIAlertAction = UIAlertAction(title: "Pending with caster", style: .default) { action -> Void in
                    self.updatePostStatus(postStatusId: postStatus.postStatusId);
                }
                actionSheetController.addAction(pendingReviewAction)
            }
            if (postStatus.title == "Approved") {
                let pendingReviewAction: UIAlertAction = UIAlertAction(title: "Approved", style: .default) { action -> Void in
                    self.updatePostStatus(postStatusId: postStatus.postStatusId);
                }
                actionSheetController.addAction(pendingReviewAction)
            }
            if (postStatus.title == "Rejected by moderator") {
                let pendingReviewAction: UIAlertAction = UIAlertAction(title: "Rejected by moderator", style: .default) { action -> Void in
                    self.updatePostStatus(postStatusId: postStatus.postStatusId);
                }
                actionSheetController.addAction(pendingReviewAction)
            }
            if (postStatus.title == "Published") {
                let pendingReviewAction: UIAlertAction = UIAlertAction(title: "Published", style: .default) { action -> Void in
                    self.updatePostStatus(postStatusId: postStatus.postStatusId);
                }
                actionSheetController.addAction(pendingReviewAction)
            }
            if (postStatus.title == "Deleted") {
                let pendingReviewAction: UIAlertAction = UIAlertAction(title: "Deleted", style: .default) { action -> Void in
                    self.updatePostStatus(postStatusId: postStatus.postStatusId);
                }
                actionSheetController.addAction(pendingReviewAction)
            }
        }
        

        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
        cancelAction.setValue(UIColor.black, forKey: "titleTextColor")
        
        actionSheetController.addAction(cancelAction)
        
        // present an actionSheet...
        present(actionSheetController, animated: true, completion: nil)
    }
    
    @IBAction func editPostBtnClicked(_ sender: Any) {
        
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "CreatePostViewController") as! CreatePostViewController;
        viewController.post = self.post;
        self.navigationController?.pushViewController(viewController, animated: true);
        
        
    }
    /*@IBAction func multipleButtonClicked(_ sender: AnyObject) {
        
        switch sender.tag {
        case 1: self.postStatus = 1 //button1
        self.pendingBtn.radioBtnSelect()
        self.approvedBtn.radioBtnDefault()
        self.underReviewBtn.radioBtnDefault()
        self.rejectedBtn.radioBtnDefault()
        break;
        case 2: self.postStatus = 2 //button2
        self.pendingBtn.radioBtnDefault()
        self.approvedBtn.radioBtnSelect()
        self.underReviewBtn.radioBtnDefault()
        self.rejectedBtn.radioBtnDefault()
        break;
        case 3: self.postStatus = 3 //button3
        self.pendingBtn.radioBtnDefault()
        self.approvedBtn.radioBtnDefault()
        self.underReviewBtn.radioBtnSelect()
        self.rejectedBtn.radioBtnDefault()
        break;
       
        case 4: self.postStatus = 4 //button4
        self.pendingBtn.radioBtnDefault()
        self.approvedBtn.radioBtnDefault()
        self.underReviewBtn.radioBtnDefault()
        self.rejectedBtn.radioBtnSelect()
        break;
        default: self.postStatus = 1
        break;
        }
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("A")
        if self.postTextField.textColor == UIColor.lightGray {
            self.postTextField.text = ""
            self.postTextField.textColor = UIColor(red: 12/255, green: 111/255, blue: 233/255, alpha: 1)
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        print("B")
        if self.postTextField.text == "" {
            
            self.postTextField.text = "Type a Message...."
            self.postTextField.textColor = UIColor.lightGray
        }
    }*/
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
      //  actionSheetController.addAction(takePhotoAction)
        actionSheetController.addAction(cancelAction)
        
        // present an actionSheet...
        present(actionSheetController, animated: true, completion: nil)
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.textAreaBtnBottomView.frame.origin.y = (self.textAreaBtnBottomView.frame.origin.y + self.textAreaBtnBottomView.frame.height - self.tabBarController!.tabBar.frame.height - 10) - (keyboardSize.height);
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.textAreaBtnBottomView.frame.origin.y = (self.view.frame.height - (self.textAreaBtnBottomView.frame.height + self.tabBarController!.tabBar.frame.height));
        }
    }
    
    func loadModeratorCasterUserPosts() {
        // Do any additional setup after loading the view.
        let jsonURL = "posts/get_post_communication/format/json";
        
        postArray["post_id"] = String(loggedInUser.userId)
        
        
        UserService().postDataMethod(jsonURL: jsonURL, postData: postArray, complete: {(response) in
            print(response)
            
            let success = Int(response.value(forKey: "status") as! String)
            if (success == 0) {
                /*  let alert = UIAlertController.init(title: "Error", message: response.value(forKey: "message") as! String, preferredStyle: .alert);
                 alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil));
                 self.present(alert, animated: true) */
                //self.socialPostList.isHidden = true;
            } else {
                let modeArray = response.value(forKey: "data") as! NSArray;
                
                if (modeArray.count != 0) {
                    
                    //self.homePosts = modeArray as! [Any]
                    self.posts = Post().loadPostsFromNSArray(postsArr: modeArray);
                    self.communicationTableView.reloadData();
                    
                } else {

                }
            }
            
        });
    }
    
    func updatePostStatus(postStatusId: Int) {
        
        let jsonURL = "posts/update_post_status/format/json";

        var postData = [String: Any]();
        postData["post_id"] = self.post.postId;
        postData["user_id"] = self.loggedInUser.userId;
        postData["post_status_id"] = postStatusId;
        PostService().postDataMethod(jsonURL: jsonURL, postData: postData, complete: {(response) in
            
            print(response);
            
            for postStatus in postStatusList {
                if (postStatus.postStatusId == postStatusId) {
                    
                    self.post.postStatusId = postStatusId;
                    self.post.status = postStatus.title;
                    self.communicationTableView.reloadData();
                    self.changeStatusBtn.setTitle(postStatus.title, for: .normal);
                    
                    // Lets add ui labels in width.
                    let totalWidthOfUIView = self.changeStatusBtn.intrinsicContentSize.width + 20;
                    self.changeStatusBtn.frame = CGRect.init(x: (self.view.frame.width - totalWidthOfUIView - 15), y: self.changeStatusBtn.frame.origin.y, width: totalWidthOfUIView, height: self.changeStatusBtn.frame.height);
                    break;
                    
                    
                }
            }
            
        });
    }
    
    //To calculate height for label based on text size and width
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        let paragraphStyle = NSMutableParagraphStyle()
        //line height size
        paragraphStyle.lineSpacing = 2
        let attributes = [
            NSAttributedStringKey.font : UIFont(name: "VisbyCF-Regular", size: 16.0)!,
            NSAttributedStringKey.paragraphStyle: paragraphStyle]
        
        let attrString = NSMutableAttributedString(string: text)
        attrString.addAttributes(attributes, range: NSMakeRange(0, attrString.length));
        label.attributedText = attrString;
        label.sizeToFit()
        
        return (label.frame.height)
    }
    
    func getPostCommunications() {
        
        let getComUrl = "\(ApiUrl)posts/get_post_communication/format/json";
        var postData : [String : Any] = [String : Any]()
        postData["post_id"] = self.post.postId;
        
        HttpService().postMethod(url: getComUrl, postData: postData, complete: {(response) in
            
            let status = Int((response.value(forKey: "status") as! NSObject) as! String);
            let message = response.value(forKey: "message") as! String;
            //let status =  response.value(forKey: "status") as? Bool ?? false
            if status == 0 {
                self.showAlert(title: "Error", message: message);
            } else {
                print(response)
                let data = response.value(forKey: "data") as! NSDictionary;
                let postCommArr = data.value(forKey: "postcommunication") as! NSArray;
                
                self.post.postCommunications = PostCommunication().loadCommunicationsFromNsArray(commArray: postCommArr);
                self.communicationTableView.reloadData();
            }
        });
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if self.textArea.textColor == UIColor.lightGray {
            self.textArea.text = nil
            self.textArea.textColor = UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 1);
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if self.textArea.text.isEmpty {
            self.textArea.text = "Type a message..."
            self.textArea.textColor = UIColor.lightGray
        }
    }

    
}

extension CommunicationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.post.postCommunications.count + 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell : RightCommunicationTableViewCell = tableView.dequeueReusableCell(withIdentifier: "RightCommunicationTableViewCell") as! RightCommunicationTableViewCell;
        
        if (indexPath.row == 0) {
            let cell: HomeTextPostTableViewCell = tableView.dequeueReusableCell(withIdentifier: "HomeTextPostTableViewCell") as! HomeTextPostTableViewCell;
            
            cell.sourceImageFacebook.isHidden = false;
            cell.sourceImageTwitter.isHidden = false;
            
            var facebookIconHidden = true;
            var twitterIconHidden = true;
            if (post.socialMediaIds.count > 0) {
                
                for sourcePlatformId in post.socialMediaIds {
                    if(Int(sourcePlatformId) == social.socialPlatformId["Facebook"]){
                        facebookIconHidden = false;
                    }  else if(Int(sourcePlatformId) == social.socialPlatformId["Twitter"]) {
                        twitterIconHidden = false;
                    }
                }
            }
            
            if (twitterIconHidden == false && facebookIconHidden == false) {
                cell.sourceImageTwitter.isHidden = false;
                cell.sourceImageFacebook.isHidden = false;
            } else if (facebookIconHidden == false && twitterIconHidden == true) {
                //If twitter is not present then we will replace sourceImageTwitter image with facebook
                cell.sourceImageTwitter.isHidden = false;
                cell.sourceImageFacebook.isHidden = true;
                cell.sourceImageTwitter.image = UIImage.init(named: "facebook-group");
            } else if (twitterIconHidden == false && facebookIconHidden == true) {
                cell.sourceImageTwitter.isHidden = false;
                cell.sourceImageFacebook.isHidden = true;
                cell.sourceImageTwitter.image = UIImage.init(named: "twitter-group");
            }
            
            var imageStatus = ""
            var status = "";
            if (post.status == "Pending") {
                imageStatus = "pending-review"
                status = "Pending review"
            } else if (post.status == "Approved") {
                imageStatus = "approved"
                status = "Approved"
            } else if (post.status == "Rejected by moderator") {
                imageStatus = "rejected"
                status = "Rejected"
            } else if(post.status == "Pending with caster") {
                imageStatus = "under-review"
                status = "Under review"
            } else if(post.status == "Unread by moderator") {
                imageStatus = "under-review"
                status = "Unread by moderator"
            } else if(post.status == "Pending with moderator") {
                imageStatus = "under-review"
                status = "Under review"
            } else if(post.status == "Deleted") {
                imageStatus = "under-review"
                status = "Deleted"
            } else if(post.status == "Published") {
                imageStatus = "approved"
                status = "Deleted"
            } else if(post.status == ""){
                imageStatus = ""
            }
            
            // status = "dfsdf fdsdfs dsfsdfsdf"
            cell.statusImage.image = UIImage.init(named: imageStatus)
            let pipe = " |"
            cell.profileLabel.text = "\((status))\(pipe)"
            print(cell.profileLabel.intrinsicContentSize.width)
            cell.dateLabel.text = Date().ddspEEEEcmyyyy(dateStr: post.createdOn)
            
            // Lets add ui labels in width.
            let totalWidthOfUIView = cell.statusImage.frame.width + cell.profileLabel.intrinsicContentSize.width + cell.dateLabel.intrinsicContentSize.width + 10;
            cell.postStatusDateView.frame = CGRect.init(x: cell.frame.width - (totalWidthOfUIView + 15), y: cell.postStatusDateView.frame.origin.y, width: totalWidthOfUIView, height: cell.postStatusDateView.frame.height);
            
            cell.statusImage.frame = CGRect.init(x: 0, y: 0, width: 20, height: 20);
            cell.profileLabel.frame = CGRect.init(x: 25, y: 0, width: cell.profileLabel.intrinsicContentSize.width, height: 20);
            cell.dateLabel.frame = CGRect.init(x: (cell.profileLabel.intrinsicContentSize.width + cell.profileLabel.frame.origin.x + 5), y: 0, width: cell.dateLabel.intrinsicContentSize.width, height: 20);
            
            //Call this function
            let height = heightForView(text: post.postDescription, font: UIFont.init(name: "VisbyCF-Regular", size: 16.0)!, width: cell.contentView.frame.width - 30)
            
            //This is your label
            for view in cell.descriptionView.subviews {
                view.removeFromSuperview();
            }
            let proNameLbl = UILabel(frame: CGRect(x: 0, y: 0, width: cell.contentView.frame.width - 30, height: height))
            var lblToShow = "\(post.postDescription)"
            
            /*if (height > 100) {
                proNameLbl.numberOfLines = 4
            } else {*/
                proNameLbl.numberOfLines = 0
            //}
            
            proNameLbl.lineBreakMode = .byTruncatingTail
            let paragraphStyle = NSMutableParagraphStyle()
            //line height size
            paragraphStyle.lineSpacing = 2
            
            let attributes = [
                NSAttributedStringKey.font : UIFont(name: "VisbyCF-Regular", size: 16.0)!,
                NSAttributedStringKey.foregroundColor : UIColor.init(red: 34/255, green: 34/255, blue: 34/255, alpha: 1),
                NSAttributedStringKey.paragraphStyle: paragraphStyle]
            
            let attrString = NSMutableAttributedString(string: lblToShow)
            attrString.addAttributes(attributes, range: NSMakeRange(0, attrString.length));
            proNameLbl.attributedText = attrString;
            
            cell.descriptionView.addSubview(proNameLbl)
            
            if (post.postImages.count > 0) {
                cell.imagesArray = [String]();
                cell.imageGalleryScrollView.isHidden = false
                for postImg in post.postImages {
                    cell.imagesArray.append(postImg);
                }
                
                /*var heightOfDesc = 0;
                if (height > 100) {
                    heightOfDesc = 100;
                } else {
                    heightOfDesc = Int(height);
                }*/
                var heightOfDesc = 0;
                heightOfDesc = Int(height);
                let y = Int(cell.descriptionView.frame.origin.y) + heightOfDesc + 10;
                cell.imageGalleryScrollView.frame = CGRect.init(x: 0, y: y, width: Int(cell.imageGalleryScrollView.frame.width), height: HomePostCellHeight.ScrollViewHeight)
                
                cell.setupSlideScrollView()
                if(cell.imagesArray.count > 1){
                    
                    cell.pageControl.numberOfPages = cell.imagesArray.count
                    cell.pageControl.currentPage = 0
                    cell.contentView.bringSubview(toFront: cell.pageControl)
                    
                    cell.pageControl.isHidden = false;
                    cell.imageCounterView.isHidden = true // false
                    cell.totalCountImageLbl.text = " \(cell.imagesArray.count)";
                    cell.currentCountImageLbl.text = "1"
                    
                    cell.imageCounterView.isHidden = true //false
                    
                    //If logged in user is a caster
                    //70 width of counter view
                    //20 Padding from right
                    //20 from top of image scroll view
                    //cell.imageGalleryScrollView.frame = CGRect.init(x: cell.imageGalleryScrollView.frame.origin.x, y: postTextDescHeight + CGFloat(HomePostCellHeight.PostStatusViewHeight), width: cell.imageGalleryScrollView.frame.width, height: cell.imageGalleryScrollView.frame.height)
                    
                    cell.imageCounterView.frame = CGRect.init(x: (cell.frame.width - (60 + 20) ), y: (cell.imageGalleryScrollView.frame.origin.y + 20), width: 60, height: 25)
                    
                    cell.pageControl.frame = CGRect.init(x: cell.pageControl.frame.origin.x, y: cell.imageGalleryScrollView.frame.origin.y + cell.imageGalleryScrollView.frame.height + 1, width: cell.pageControl.frame.width, height: cell.pageControl.frame.height)
                } else {
                    cell.imageCounterView.isHidden = true
                    cell.pageControl.isHidden = true;
                }
                
                
            } else {
                cell.imagesArray = [String]();
                cell.imageGalleryScrollView.isHidden = true;
                cell.pageControl.isHidden = true;
            }
            //ScrollView functionality
            return cell;
            
            
        } else {
            
            //if (post.postCommunications.count > 0) {
                
                let communication = post.postCommunications[indexPath.row - 1];

                //We will show logged in user comments on right side and other users comment on
                //left side.
                if (communication.communicatedByUserId == loggedInUser.userId) {
                    
                    let cell: LeftCommunicationTableViewCell = tableView.dequeueReusableCell(withIdentifier: "LeftCommunicationTableViewCell") as! LeftCommunicationTableViewCell;
                    
                    cell.commentedDate.text = Date().ddspEEEEcmyyyyspHHclmmclaa(dateStr: communication.commentedOn);
                    
                    cell.commentorPic.sd_setImage(with: URL.init(string: communication.communicatedProfilePic), placeholderImage: UIImage.init(named: "Profile-1"));
                    
                    //Call this function
                    let height = heightForView(text: communication.postCommunicationDescription, font: UIFont.init(name: "VisbyCF-Regular", size: 16.0)!, width: cell.descriptionView.frame.width - 20)
                    
                    //This is your label
                    for view in cell.descriptionView.subviews {
                        view.removeFromSuperview();
                    }
                    let proNameLbl = UILabel(frame: CGRect(x: 10, y: 35, width: cell.descriptionView.frame.width - 10, height: height))
                    var lblToShow = "\(communication.postCommunicationDescription)"
                    proNameLbl.numberOfLines = 0
                    proNameLbl.lineBreakMode = .byWordWrapping
                    let paragraphStyle = NSMutableParagraphStyle()
                    //line height size
                    paragraphStyle.lineSpacing = 2
                    
                    let attributes = [
                        NSAttributedStringKey.font : UIFont(name: "VisbyCF-Regular", size: 16.0)!,
                        NSAttributedStringKey.foregroundColor : UIColor.init(red: 34/255, green: 34/255, blue: 34/255, alpha: 1),
                        NSAttributedStringKey.paragraphStyle: paragraphStyle]
                    
                    let attrString = NSMutableAttributedString(string: lblToShow)
                    attrString.addAttributes(attributes, range: NSMakeRange(0, attrString.length));
                    proNameLbl.attributedText = attrString;
                    
                    cell.descriptionView.addSubview(proNameLbl)
                    cell.descriptionView.frame = CGRect.init(x: cell.descriptionView.frame.origin.x, y: cell.descriptionView.frame.origin.y, width: cell.descriptionView.frame.width, height: 50 + height);
                    
                    if (communication.attachments.count > 0) {
                        
                        cell.imageScrollView.isHidden = false;
                        
                        for attachment in communication.attachments {
                            cell.imagesArray.append(attachment.image);
                        }
                        cell.setupSlideScrollView();
                        cell.imageScrollView.frame = CGRect.init(x: cell.imageScrollView.frame.origin.x, y: cell.descriptionView.frame.origin.y + cell.descriptionView.frame.height, width: cell.imageScrollView.frame.width, height: cell.imageScrollView.frame.height);
                        
                        if (communication.attachments.count == 1) {
                            cell.pageControl.isHidden = true;
                        } else {
                            cell.pageControl.isHidden = false;
                            cell.pageControl.frame = CGRect.init(x: cell.imageScrollView.frame.width/2 - cell.imageScrollView.frame.origin.x, y: cell.imageScrollView.frame.origin.y + cell.imageScrollView.frame.height - 10, width: cell.pageControl.frame.width, height: cell.pageControl.frame.height)
                        }
                    } else {
                        cell.imageScrollView.isHidden = true;
                        cell.pageControl.isHidden = true;
                    }
                    return cell;
                    
                } else {
                    
                    
                    let cell: RightCommunicationTableViewCell = tableView.dequeueReusableCell(withIdentifier: "RightCommunicationTableViewCell") as! RightCommunicationTableViewCell;

                    cell.commentedDate.text = Date().ddspEEEEcmyyyyspHHclmmclaa(dateStr: communication.commentedOn);
                    
                    cell.commentorPic.sd_setImage(with: URL.init(string: communication.communicatedProfilePic), placeholderImage: UIImage.init(named: "Profile-1"));
                    
                    //Call this function
                    let height = heightForView(text: communication.postCommunicationDescription, font: UIFont.init(name: "VisbyCF-Regular", size: 16.0)!, width: cell.descriptionView.frame.width - 20)
                    
                    //This is your label
                    for view in cell.descriptionView.subviews {
                        view.removeFromSuperview();
                    }
                    let proNameLbl = UILabel(frame: CGRect(x: 10, y: 35, width: cell.descriptionView.frame.width - 10, height: height))
                    var lblToShow = "\(communication.postCommunicationDescription)"
                    proNameLbl.numberOfLines = 0
                    proNameLbl.lineBreakMode = .byWordWrapping
                    let paragraphStyle = NSMutableParagraphStyle()
                    //line height size
                    paragraphStyle.lineSpacing = 2
                    
                    let attributes = [
                        NSAttributedStringKey.font : UIFont(name: "VisbyCF-Regular", size: 16.0)!,
                        NSAttributedStringKey.foregroundColor : UIColor.init(red: 34/255, green: 34/255, blue: 34/255, alpha: 1),
                        NSAttributedStringKey.paragraphStyle: paragraphStyle]
                    
                    let attrString = NSMutableAttributedString(string: lblToShow)
                    attrString.addAttributes(attributes, range: NSMakeRange(0, attrString.length));
                    proNameLbl.attributedText = attrString;
                    
                    cell.descriptionView.addSubview(proNameLbl)
                    cell.descriptionView.frame = CGRect.init(x: cell.descriptionView.frame.origin.x, y: cell.descriptionView.frame.origin.y, width: cell.descriptionView.frame.width, height: 50 + height)
                    
                    return cell;
                }
            //}
            
        }
        
        return UITableViewCell();
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (indexPath.row == 0) {
            
            var height = heightForView(text: post.postDescription, font: UIFont.init(name: "VisbyCF-Regular", size: 16.0)!, width: tableView.frame.width - 30);
            
            /*if (height > 100) {
                height = 100;
            }*/
            if (post.postImages.count > 0) {
                
                if (post.postImages.count == 1) {
                    
                    return (CGFloat(HomePostCellHeight.GapAboveStatus) + CGFloat(HomePostCellHeight.PostStatusViewHeight) + CGFloat(HomePostCellHeight.GapBelowStatus) + height + CGFloat(HomePostCellHeight.GapBelowLabel) + 420);
                }
                return (CGFloat(HomePostCellHeight.GapAboveStatus) + CGFloat(HomePostCellHeight.PostStatusViewHeight) + CGFloat(HomePostCellHeight.GapBelowStatus) + height + CGFloat(HomePostCellHeight.GapBelowLabel) + 420 +  30);
            }
            return (CGFloat(HomePostCellHeight.GapAboveStatus + HomePostCellHeight.PostStatusViewHeight) + height);
        } else {
            let communication = post.postCommunications[indexPath.row - 1];
            
            let height = heightForView(text: communication.postCommunicationDescription, font: UIFont.init(name: "VisbyCF-Regular", size: 16.0)!, width: tableView.frame.width - 60)
            
            if (communication.attachments.count > 0) {
                if (communication.attachments.count == 1) {
                    return height + 60 + 200;
                } else {
                    return height + 60 + 200 + 40;
                }
            } else {
                return height + 60;
            }
        }
    }
}

