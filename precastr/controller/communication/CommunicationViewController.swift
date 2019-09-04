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
import FBSDKShareKit
import FBSDKCoreKit
import EasyTipView
import TwitterKit
import TwitterCore

protocol ImageLibProtocolC {
    func takePicture(viewC : UIViewController);
}

class CommunicationViewController: UIViewController,UITextViewDelegate, UIImagePickerControllerDelegate, EasyTipViewDelegate, SharingDelegate {

    var posts = [Post]();
    var post = Post();
    @IBOutlet weak var communicationTableView: UITableView!
    //@IBOutlet weak var postTextField: UITextView!
    
    
    @IBOutlet weak var textAreaBtnBottomView: UIView!
    @IBOutlet weak var textArea: UITextView!
        
    @IBOutlet weak var changeStatusBtn: UIButton!
    
    @IBOutlet weak var editPostBtn: UIButton!
    @IBOutlet weak var editPostBtnBottom: UIButton!;
    
    @IBOutlet weak var attachmentBtn: UIButton!
    @IBOutlet weak var submitBtn : UIButton!
    @IBOutlet weak var topButtonBars: UIView!
    @IBOutlet weak var lblPostDate: UILabel!
    @IBOutlet weak var separator: UIView!
    
    
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
    var postToPublish: Post!;
    var easyToolTip: EasyTipView!
    var placeholderText = "Communicate with your Moderator.\nP.S. - This won't edit the post. In order to edit the post, please click on the \"Edit Post\" button.";
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView();
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loggedInUser = User().loadUserDataFromUserDefaults(userDataDict: setting);
        social = SocialPlatform().loadSocialDataFromUserDefaults();

        self.editPostBtn.semanticContentAttribute = UIApplication.shared
            .userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft;
        
        communicationTableView.register(UINib(nibName: "PostDetailTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "PostDetailTableViewCell")
        communicationTableView.register(UINib.init(nibName: "LeftCommunicationTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "LeftCommunicationTableViewCell");
          communicationTableView.register(UINib.init(nibName: "RightCommunicationTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "RightCommunicationTableViewCell");
         communicationTableView.register(UINib.init(nibName: "HomeTextPostTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "HomeTextPostTableViewCell");
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshScreenData), name: NSNotification.Name(rawValue: "reloadCommunicationScreen"), object: nil)

        
        activityIndicator.center = view.center;
        activityIndicator.hidesWhenStopped = true;
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray;
        view.addSubview(activityIndicator);
        
        self.attachmentBtn.roundEdgesLeftBtn();
        self.submitBtn.roundEdgesRightBtn();
        self.textArea.layer.cornerRadius = 4;
        self.textArea.layer.borderWidth = 1;
        self.textArea.layer.borderColor = UIColor(red: 112/255, green: 112/255, blue: 112/255, alpha: 1).cgColor;
        self.textArea.text = placeholderText;
        
        self.textArea.textColor = UIColor.lightGray

        self.editPostBtn.layer.cornerRadius = 4;
        self.editPostBtnBottom.layer.cornerRadius = 4;

        self.changeStatusBtn.layer.cornerRadius = 4;
        self.changeStatusBtn.layer.borderWidth = 1;
        self.changeStatusBtn.layer.borderColor = UIColor(red: 112/255, green: 112/255, blue: 112/255, alpha: 1).cgColor;
      
        
        self.lblPostDate.text = Date().ddspEEEEcmyyyyspHHclmmclaa(dateStr: self.post.createdOn);
        self.lblPostDate.frame = CGRect.init(x: self.view.frame.width - (self.lblPostDate.intrinsicContentSize.width + 10), y: self.lblPostDate.frame.origin.y, width: self.lblPostDate.intrinsicContentSize.width, height: self.lblPostDate.frame.height)
        self.separator.frame = CGRect.init(x: self.view.frame.width - (self.lblPostDate.intrinsicContentSize.width + 20), y: self.separator.frame.origin.y, width: 1, height: 15)
        
        self.changeStatusBtn.setTitle(post.status.capitalized, for: .normal)
        self.changeStatusBtn.frame = CGRect.init(x: self.view.frame.width - (self.lblPostDate.intrinsicContentSize.width + self.changeStatusBtn.intrinsicContentSize.width + 40), y: self.changeStatusBtn.frame.origin.y, width: self.changeStatusBtn.intrinsicContentSize.width, height: self.changeStatusBtn.frame.height);
        
        self.topButtonBars.frame = CGRect.init(x: 0, y: (UIApplication.shared.statusBarFrame.size.height + (self.navigationController?.navigationBar.frame.height)!) + 10, width: self.view.frame.width, height: self.topButtonBars.frame.height);
        
        
        let positionOfBottomView = self.view.frame.height - (self.textAreaBtnBottomView.frame.height + ((self.tabBarController?.tabBar.frame.height)!) + 5);
        self.textAreaBtnBottomView.frame = CGRect.init(x: 0, y: positionOfBottomView, width: self.view.frame.width, height: self.textAreaBtnBottomView.frame.height);
        
        self.communicationTableView.frame = CGRect.init(x: 0, y: self.topButtonBars.frame.origin.y + 30, width: self.view.frame.width, height: self.textAreaBtnBottomView.frame.origin.y -  (self.topButtonBars.frame.origin.y + 30 + 10));
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        self.setUpNavigationBarItems();
        
        //self.hideKeyboadOnTapOutside();
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        tap.cancelsTouchesInView = false
        communicationTableView.addGestureRecognizer(tap);

        
        self.getPostCommunications();
        
        self.getAllPostStatuses();
        
        self.changeStatusFunction();
        
        self.addDoneButtonOnKeyboard();
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

    override func viewWillAppear(_ animated: Bool) {
        
       // self.getPostCommunications();
        self.editPostBtn.layer.cornerRadius = 4;
        self.editPostBtnBottom.layer.cornerRadius = 4;

        self.communicationTableView.reloadData();
        
        //If Logged in user is a moderator, then we will
        self.loggedInUser = User().loadUserDataFromUserDefaults(userDataDict: setting);
        if (loggedInUser.isCastr == 2) {
            self.navigationItem.title = "Cast Detail";
            
            if (self.tabBarController!.viewControllers?.count == 4) {
                self.tabBarController!.viewControllers?.remove(at: 1)
            }
        } else {
            self.navigationItem.title = "Cast Detail";
            
            if (self.tabBarController!.viewControllers?.count == 3) {
                
                let navController = self.storyboard?.instantiateViewController(withIdentifier: "CreateNewPostNavController") as! UINavigationController;
                self.tabBarController!.viewControllers?.insert(navController, at: 1);
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func showBadgeCount() {
        let jsonURL = "posts/get_notifications_count/format/json"
        
        var postArray = [String: Any]();
        postArray["user_id"] = String(loggedInUser.userId)
        if (self.loggedInUser.isCastr == 1) {
            postArray["role_id"] = 0;
        } else {
            postArray["role_id"] = 1;
        }
        UserService().postDataMethod(jsonURL: jsonURL, postData: postArray, complete: {(response) in
            print(response)
            
            let success = Int(response.value(forKey: "status") as! String)!
            if (success == 1) {
                let dataArray = response.value(forKey: "data") as! NSDictionary;
                if let tabItems = self.tabBarController?.tabBar.items {
                    // In this case we want to modify the badge number of the third tab:
                    var index = 0;
                    if (self.loggedInUser.isCastr == 1) {
                        index =  3;
                    } else {
                        index = 2;
                    }
                    let tabItem = tabItems[index]
                    let badgeCount = dataArray.value(forKey: "total") as! String
                    print(badgeCount)
                    if (badgeCount != "nil" && badgeCount != "0"){
                        tabItem.badgeValue =  dataArray.value(forKey: "total") as? String;
                    } else {
                        tabItem.badgeValue =  nil;
                    }
                    
                }
            }
        });
    }
    
    func getAllPostStatuses() {
        for postStatus in postStatusList {
            if (postStatus.postStatusId == self.post.postStatusId) {
                self.changeStatusBtn.setTitle(postStatus.title, for: .normal);
                
                // Lets add ui labels in width.
                let totalWidthOfUIView = self.changeStatusBtn.intrinsicContentSize.width + 20;
                self.changeStatusBtn.frame = CGRect.init(x: (self.changeStatusBtn.frame.origin.x), y: self.changeStatusBtn.frame.origin.y, width: totalWidthOfUIView, height: self.changeStatusBtn.frame.height);
                break;
            }
        }
    }
    
    func setUpNavigationBarItems() {
        
        let backButton = UIButton();
        backButton.setImage(UIImage.init(named: "left-arrow"), for: .normal);
        backButton.addTarget(self, action: #selector(backButtonPressed), for: UIControlEvents.touchUpInside)
        backButton.frame = CGRect.init(x: 0, y:0, width: 20, height: 15);
        
        let barButton = UIBarButtonItem(customView: backButton)
        
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
        
        if(textArea.text != "" && textArea.text != placeholderText || PhotoArray.count > 0){
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
                    self.textArea.text = self.placeholderText;
                    self.textArea.textColor = UIColor.darkGray
                });
            } else {
                HttpService().postMethod(url: jsonURL, postData: postData, complete: {(response) in
                    print(response);
                    
                    self.activityIndicator.stopAnimating();
                    //Load latest Communications
                    self.getPostCommunications();
                    self.textArea.text = self.placeholderText;
                    self.textArea.textColor = UIColor.darkGray
                    self.communicationTableView.reloadData();
                });
            }
        }else{
            if (PhotoArray.count == 0) {
            let message = "Please enter some text or image to post!"
            self.showAlert(title: "Error", message: message);
            }
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
                //We will not moderator to Publish post
                if (postStatus.title == "Published") {
                    continue;
                }
            
                let pendingReviewAction: UIAlertAction = UIAlertAction(title: postStatus.title, style: .default) { action -> Void in
                    self.updatePostStatus(postStatusId: postStatus.postStatusId);
                }
                actionSheetController.addAction(pendingReviewAction)
        }
        

        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
        cancelAction.setValue(UIColor.black, forKey: "titleTextColor")
        
        actionSheetController.addAction(cancelAction)
        
        // present an actionSheet...
        //Only Moderatuor can change the status from dropdown
        if (self.loggedInUser.isCastr == 2) {
            //self.changeStatusFunction();
            present(actionSheetController, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func editPostBtnClicked(_ sender: Any) {
        
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "CreatePostViewController") as! CreatePostViewController;
        viewController.post = self.post;
        self.navigationController?.pushViewController(viewController, animated: true);
        
        
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
                option.isSynchronous = false
                option.isNetworkAccessAllowed = true
                
                manager.requestImage(for: SelectedAssets[i], targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: option, resultHandler: {(result, info)->Void in
                    if(result != nil){
                    thumbnail = result!
                    }
                })
                if(thumbnail != nil){
                let data = UIImageJPEGRepresentation(thumbnail, 0.7)
                let newImage = UIImage(data: data!)
                
                
                PhotoArray.append(newImage! as UIImage)
                }else{
                    let message = "Error in Image loading..."
                    self.showAlert(title: "Error", message: message);
                }
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
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            let bottomAreaViewPosition = self.view.frame.height - (self.textAreaBtnBottomView.frame.height + 5 + keyboardSize.height);
            self.textAreaBtnBottomView.frame.origin.y = bottomAreaViewPosition;
            
            
            var keyboardHeight = self.view.frame.height - (keyboardSize.height + self.textAreaBtnBottomView.frame.height + 5 + self.communicationTableView.frame.origin.y);
            self.communicationTableView.frame = CGRect.init(x: 0, y: self.communicationTableView.frame.origin.y, width: self.view.frame.width, height: keyboardHeight)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            if (self.tabBarController != nil) {
                let positionOfBottomView = self.view.frame.height - (self.textAreaBtnBottomView.frame.height + ((self.tabBarController?.tabBar.frame.height)!) + 5);
                
                self.textAreaBtnBottomView.frame.origin.y = positionOfBottomView;
                
                self.communicationTableView.frame = CGRect.init(x: 0, y: self.communicationTableView.frame.origin.y, width: self.view.frame.width, height: self.textAreaBtnBottomView.frame.origin.y - self.communicationTableView.frame.origin.y)
            }
        }
    }
    
    func updatePostStatus(postStatusId: Int) {
        
        if (self.post.status != "Approved" && postStatusId == 7) { // going to publish
            
            let alert = UIAlertController.init(title: "Error", message: "Post not Approved yet", preferredStyle: .alert);
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil));
            self.present(alert, animated: true);
            
        } else {
            let tempPostTitle = self.post.status;
            let tempPostStatusId = postStatusId;
            let jsonURL = "posts/update_post_status/format/json";
            
            var postData = [String: Any]();
            postData["post_id"] = self.post.postId;
            postData["user_id"] = self.loggedInUser.userId;
            postData["post_status_id"] = postStatusId;
            PostService().postDataMethod(jsonURL: jsonURL, postData: postData, complete: {(response) in
                
                print(response);
                let statusResponse = Int(response.value(forKey: "status") as! String)!
                for postStatus in postStatusList {
                    if( statusResponse == 0){
                        let alert = UIAlertController.init(title: "Error", message: response.value(forKey: "message") as! String, preferredStyle: .alert);
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil));
                        self.present(alert, animated: true);
                        break;
                    }
                    else if (postStatus.postStatusId == postStatusId) {
                        
                        self.post.postStatusId = postStatusId;
                        self.post.status = postStatus.title;
                        self.communicationTableView.reloadData();
                        self.changeStatusBtn.setTitle(postStatus.title, for: .normal);
                        
                        // Lets add ui labels in width.
                        let totalWidthOfUIView = self.changeStatusBtn.intrinsicContentSize.width + 20;
                        self.changeStatusBtn.frame = CGRect.init(x:  self.view.frame.width - (self.lblPostDate.intrinsicContentSize.width + self.changeStatusBtn.intrinsicContentSize.width + 40), y: self.changeStatusBtn.frame.origin.y, width: totalWidthOfUIView, height: self.changeStatusBtn.frame.height);
                        
                        
                        self.changeStatusFunction();
                        /*if(self.post.status == "Published"){
                            
                         
                            for sourcePlatformId in self.post.socialMediaIds {
                                if(Int(sourcePlatformId) == social.socialPlatformId["Twitter"]) {
                                    var postDataTwitter = [String: Any]();
                                    postDataTwitter["post_id"] = self.post.postId;
                                    postDataTwitter["user_id"] = self.post.postUserId;
                                    let jsonPostURL = "posts/publish_post_on_twitter/format/json";
                                    PostService().postDataMethod(jsonURL: jsonPostURL, postData: postDataTwitter, complete: {(response) in
                                        print(response)
                                      let statusCode = Int(response.value(forKey: "status") as! String)!
                                        if(statusCode == 0){
                                            self.post.postStatusId = tempPostStatusId;
                                            self.post.status = tempPostTitle;
                                            postData["post_status_id"] = tempPostStatusId
                                            PostService().postDataMethod(jsonURL: jsonURL, postData: postData, complete: {(response) in
                                                
                                            });
                                        }
                                        
                                    });
                                    
                                }
                            }
                            
                        }*/
                        break;
                        
                        
                    }
                }
                
            });
            
        }
        
        
   
    }
    
    func getPostCommunications() {
        
        let getComUrl = "\(ApiUrl)posts/get_post_communication/format/json";
        var postData : [String : Any] = [String : Any]()
        postData["post_id"] = self.post.postId;
        
        HttpService().postMethod(url: getComUrl, postData: postData, complete: {(response) in
            
            let status = Int(response.value(forKey: "status") as! String)!
            let message = response.value(forKey: "message") as! String;
            //let status =  response.value(forKey: "status") as? Bool ?? false
            if status == 0 {
                self.showAlert(title: "Error", message: message);
            } else {
                print(response)
                let data = response.value(forKey: "data") as! NSDictionary;
                let postCommArr = data.value(forKey: "postcommunication") as! NSArray;
                
                self.post.postCommunications = PostCommunication().loadCommunicationsFromNsArray(commArray: postCommArr);
                
                // Put your code which should be executed with a delay here
                self.communicationTableView.reloadData();
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200), execute: {
                    self.communicationTableView.reloadData();
                })
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
            self.textArea.text = self.placeholderText
            self.textArea.textColor = UIColor.darkGray
        }
    }

    @objc func postToFacebookPressed(sender: PostToSocialMediaGestureRecognizer) {
        
        print(sender.post.postDescription);
        
        DispatchQueue.main.async {
            //self.activityIndicator.startAnimating();
        }
        
        let post = sender.post!;
        self.postToPublish = sender.post;
        if (post.postDescription != "") {
            
            if (post.postImages.count == 0) {
                
                
                let content = ShareLinkContent();
                content.quote = post.postDescription;
                content.contentURL = URL.init(string: "http://precastr.com")!;
                let shareDialog = ShareDialog()
                shareDialog.shareContent = content;

                let fbInstalled = schemeAvailable(scheme: "fb://")
                
                if (fbInstalled) {
                    shareDialog.mode = .automatic;
                } else {
                    shareDialog.mode = .native;
                }

                shareDialog.fromViewController = self;
                shareDialog.delegate = self;
                shareDialog.shouldFailOnDataError = true;
                if (shareDialog.canShow == false) {
                    //self.showAlert(title: "Alert", message: "Please install Facebook App");
                    showFacebookFailAlert();
                } else {
                    shareDialog.show();
                }
                
            } else {
                
                //self.showToast(message: "Text Copied to clipboard");
                UIPasteboard.general.string = "\(sender.post.postDescription)";
                
                let sharePhotoContent = SharePhotoContent();
                for photoStr in post.postImages {
                    let sharePhoto = SharePhoto();
                    //sharePhoto.imageURL = URL.init(string:photoStr)!
                    let url = URL(string: photoStr)
                    let data = try? Data(contentsOf: url!)
                    
                    if let imageData = data {
                        let image = UIImage(data: imageData)
                        sharePhoto.image = image;
                    }
                    sharePhotoContent.photos.append(sharePhoto);
                }
                
                
                
                //self.activityIndicator.stopAnimating();
                
                
                let shareDialog = ShareDialog()
                shareDialog.shareContent = sharePhotoContent;
                shareDialog.mode = .automatic;
                shareDialog.fromViewController = self;
                shareDialog.delegate = self;
                shareDialog.shouldFailOnDataError = true;
                if (shareDialog.canShow == false) {
                    showFacebookFailAlert();
                } else {
                    shareDialog.show();
                }
            }
        } else {
            
            //If there are only images but not text.. Then we will go for this.
            let sharePhotoContent = SharePhotoContent();
            for photoStr in post.postImages {
                let sharePhoto = SharePhoto();
                //sharePhoto.imageURL = URL.init(string:photoStr)!
                let url = URL(string: photoStr)
                let data = try? Data(contentsOf: url!)
                
                if let imageData = data {
                    let image = UIImage(data: imageData)
                    sharePhoto.image = image;
                }
                sharePhotoContent.photos.append(sharePhoto);
            }
            
            self.activityIndicator.stopAnimating();
            let shareDialog = ShareDialog()
            shareDialog.shareContent = sharePhotoContent;
            shareDialog.mode = .automatic;
            shareDialog.fromViewController = self;
            shareDialog.delegate = self;
            shareDialog.shouldFailOnDataError = true;
            if (shareDialog.canShow == false) {
                showFacebookFailAlert();
            } else {
                shareDialog.show();
            }
        }
    }
    
    //This method will be called. when user pushlish on twitter.
    @objc func postToTwitterPressed(sender: PostToSocialMediaGestureRecognizer) {
        
        self.activityIndicator.startAnimating();
        self.postToPublish = sender.post;
        PostManager().publishPostOnTwitter(post: self.postToPublish, complete: {(response) in
            self.activityIndicator.stopAnimating();
            
            let statusCode = Int(response.value(forKey: "status") as! String)!
            if(statusCode == 0) {
                self.showAlert(title: "Alert", message: response.value(forKey: "message") as! String);
            } else {
                self.post.postStatusId = 7;
                self.post.status = "Approved";
                self.communicationTableView.reloadData();
                self.changeStatusBtn.setTitle("Approved", for: .normal);
                
                // Lets add ui labels in width.
                let totalWidthOfUIView = self.changeStatusBtn.intrinsicContentSize.width + 20;
                self.changeStatusBtn.frame = CGRect.init(x: (self.changeStatusBtn.frame.origin.x), y: self.changeStatusBtn.frame.origin.y, width: totalWidthOfUIView, height: self.changeStatusBtn.frame.height);

            }
        });
    }
    
    //This method will be called when user post feed on facebook.
    func sharer(_ sharer: Sharing, didCompleteWithResults results: [String : Any]) {
        
        print("Response from facebook..")
        self.activityIndicator.startAnimating();
        PostManager().publishOnFacebook(post: self.postToPublish, complete: {(response) in
            print(response);
            self.activityIndicator.stopAnimating();
            let statusCode = Int(response.value(forKey: "status") as! String)!
            if(statusCode == 0) {
                self.showAlert(title: "Alert", message: response.value(forKey: "message") as! String);
            } else {
                self.post.postStatusId = 7;
                self.post.status = "Approved";
                self.communicationTableView.reloadData();
                self.changeStatusBtn.setTitle("Approved", for: .normal);
                
                // Lets add ui labels in width.
                let totalWidthOfUIView = self.changeStatusBtn.intrinsicContentSize.width + 20;
                self.changeStatusBtn.frame = CGRect.init(x: (self.changeStatusBtn.frame.origin.x), y: self.changeStatusBtn.frame.origin.y, width: totalWidthOfUIView, height: self.changeStatusBtn.frame.height);
            }
        });
    }
    
    func sharer(_ sharer: Sharing, didFailWithError error: Error) {
        print("Fail")
        self.activityIndicator.stopAnimating();
        showFacebookFailAlert();
    }
    
    func sharerDidCancel(_ sharer: Sharing) {
        print("Cancel")
    }
    
    func easyTipViewDidDismiss(_ tipView: EasyTipView) {
        tipView.dismiss();
    }
    
    
    func showFacebookFailAlert() {
        
        var refreshAlert = UIAlertController(title: "Facebook Not Installed", message: "It looks like the Facebook app is not installed on your iPhone. Click \"OK\" to download, after installing please \"LOG IN\" to the \"FB App\" and come back to the same screen on \"PreCastr\" and hit the \"Push to FB\" button", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            if let url = URL(string: "https://apps.apple.com/in/app/facebook/id284882215") {
                UIApplication.shared.open(url)
            }
        }));
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
            
            
        }));
        self.present(refreshAlert, animated: true, completion: nil)
        
    }
    func changeStatusFunction(){
        print("SDSDSDSDSDSD")
        if (loggedInUser.isCastr == 1 || (loggedInUser.isCastr == 2 && (self.post.status == "Approved" || self.post.status == "Published"))) {
        self.changeStatusBtn.isUserInteractionEnabled = false;
        self.changeStatusBtn.layer.borderWidth = 0
        var status = "";
        var imageStatus = "";
        status = self.post.status
        if (status == "Pending") {
            imageStatus = "pending-review"
            // status = "Pending review"
        } else if (status == "Approved") {
            imageStatus = "approved"
            // status = "Approved"
        } else if (status == "Rejected") {
            imageStatus = "rejected"
            // status = "Rejected"
        } else if(status == "Published") {
            imageStatus = "published"
            //  status = "Deleted"
        } else if(status == ""){
            imageStatus = ""
        }
        
        self.changeStatusBtn.setImage(UIImage.init(named: imageStatus), for: .normal);
        self.changeStatusBtn.semanticContentAttribute = UIApplication.shared
            .userInterfaceLayoutDirection == .leftToRight ? .forceLeftToRight : .forceRightToLeft;
        
        self.changeStatusBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
            self.separator.isHidden = false
        }else{
            self.changeStatusBtn.setImage(UIImage.init(named: "down_arrow"), for: .normal);
            self.changeStatusBtn.isUserInteractionEnabled = true;
            self.separator.isHidden = true
        }
    }
    
    func schemeAvailable(scheme: String) -> Bool {
        if let url = URL(string: scheme) {
            return UIApplication.shared.canOpenURL(url)
        }
        return false
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
        
        self.textArea.delegate = self
        self.textArea.inputAccessoryView = toolBar
    }
    

    @objc func doneButtonAction() {
        self.textArea.resignFirstResponder()
    }

    @objc func refreshScreenData(){
        self.getPostCommunications();
        self.showBadgeCount();
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
            let cell: PostDetailTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PostDetailTableViewCell") as! PostDetailTableViewCell;
            
            let postToFacebookTapGesture = PostToSocialMediaGestureRecognizer.init(target: self, action: #selector(postToFacebookPressed(sender:)));
            postToFacebookTapGesture.post = post;
            
            let postToTwitterTapGesture = PostToSocialMediaGestureRecognizer.init(target: self, action: #selector(postToTwitterPressed(sender:)));
            postToTwitterTapGesture.post = post;

            //Lets handle the logic of Hiding and Shwoing Publish Buttons.
            //First lets check if post status is Approved/ Published.
            //If post status is approved, then we would have to show both buttons.
            //Publish to Twitter and Publish to Facebook
            if (post.postStatusId == HomePostPublishStatusId.APPROVEDSTATUSID) {
                
                if (loggedInUser.isCastr == 2) {
                    cell.postPrePublishView.isHidden = true;
                } else {
                    cell.postPrePublishView.isHidden = false;
                }
                
                //If post status is Published, Then we have to check
                //If user posted on both platforms or not
            } else if (post.postStatusId == HomePostPublishStatusId.PUBLISHSTATUSID) {
                
                var facebookPublished = false;
                for socialMediaId in post.socialMediaIds {
                    if (socialMediaId == social.socialPlatformId["Facebook"]) {
                        facebookPublished = true;
                        break;
                    }
                }
                
                var twitterPublished = false;
                for socialMediaId in post.socialMediaIds {
                    if (socialMediaId == social.socialPlatformId["Twitter"]) {
                        twitterPublished = true;
                        break;
                    }
                }
                
                if (facebookPublished == true && twitterPublished == true) {
                    cell.postPrePublishView.isHidden = true;
                } else {
                    
                    if (loggedInUser.isCastr == 2) {
                        cell.postPrePublishView.isHidden = true;
                    } else {
                        if (facebookPublished == true) {
                            //cell.pushToFacebookView.isHidden = true;
                            cell.pushToFacebookText.textColor = UIColor.init(red: 34/255, green: 34/255, blue: 34/255, alpha: 1)
                            cell.pushToFacebookView.backgroundColor = UIColor.clear;
                            cell.pushToFacebookView.layer.borderWidth = 0.5;
                            
                            cell.pushToFacebookView.layer.borderColor = UIColor.init(red: 146/255, green: 147/255, blue: 149/255, alpha: 1).cgColor
                            
                            cell.publishToFacebookImage.backgroundColor = UIColor.init(red: 237/255, green: 237/255, blue: 237/255, alpha: 1);
                            cell.pushToFacebookView.isUserInteractionEnabled = false;
                        } else {
                            //cell.pushToFacebookView.isHidden = false;
                            cell.pushToFacebookText.textColor = UIColor.white
                            cell.pushToFacebookView.backgroundColor = UIColor.init(red: 48/255, green: 77/255, blue: 141/255, alpha: 1);
                            cell.pushToFacebookView.layer.borderWidth = 0;

                            cell.pushToFacebookView.backgroundColor = UIColor.init(red: 82/255, green: 117/255, blue: 194/255, alpha: 1);
                            cell.pushToFacebookView.isUserInteractionEnabled = true;
                        }
                        
                        
                        if (twitterPublished == true) {
                            //cell.pushToTwitterView.isHidden = true;
                            cell.pushToTwitterText.textColor = UIColor.init(red: 34/255, green: 34/255, blue: 34/255, alpha: 1)
                            cell.pushToTwitterView.backgroundColor = UIColor.clear;
                            cell.pushToTwitterView.layer.borderWidth = 0.5;
                            cell.pushToTwitterView.layer.borderColor = UIColor.init(red: 146/255, green: 147/255, blue: 149/255, alpha: 1).cgColor
                            
                            cell.publishToTwitterImage.backgroundColor = UIColor.init(red: 237/255, green: 237/255, blue: 237/255, alpha: 1);
                            cell.pushToTwitterView.isUserInteractionEnabled = false;
                            
                        } else {
                            //cell.pushToTwitterView.isHidden = false;
                            cell.pushToTwitterText.textColor = UIColor.white
                            cell.pushToTwitterView.backgroundColor = UIColor.init(red: 0, green: 153/255, blue: 219/255, alpha: 1);
                            cell.pushToTwitterView.layer.borderWidth = 0;

                            cell.publishToTwitterImage.backgroundColor = UIColor.init(red: 42/255, green: 185/255, blue: 195/255, alpha: 1);
                            cell.pushToTwitterView.isUserInteractionEnabled = true;
                        }
                    }
                }
                
                //If Post status is neither approved nor publised
                //Then we will hide the Publish Post Bar
            } else {
                cell.postPrePublishView.isHidden = true;
            }
            
            var imageStatus = ""
            var status = "";
            if (post.status == "Pending") {
                imageStatus = "pending-review"
               // status = "Pending review"
            } else if (post.status == "Approved") {
                 self.editPostBtn.isHidden = true
                self.editPostBtnBottom.isHidden = true

                imageStatus = "approved"
               // status = "Approved"
            } else if (post.status == "Rejected") {
                imageStatus = "rejected"
               // status = "Rejected"
            } else if(post.status == "Pending with caster") {
                imageStatus = "under-review"
               // status = "Under review"
            } else if(post.status == "Unread by moderator") {
                imageStatus = "under-review"
               // status = "Unread by moderator"
            } else if(post.status == "Pending with moderator") {
                imageStatus = "under-review"
               // status = "Under review"
            } else if(post.status == "Deleted") {
                imageStatus = "under-review"
               // status = "Deleted"
            } else if(post.status == "Published") {
                imageStatus = "published";
                
                    self.communicationTableView.frame = CGRect.init(x: 0, y: self.topButtonBars.frame.origin.y + self.topButtonBars.frame.height + 5, width: self.view.frame.width, height: self.textAreaBtnBottomView.frame.origin.y -  (self.topButtonBars.frame.origin.y + 40));
               
                    self.changeStatusBtn.setImage(UIImage.init(named: imageStatus), for: .normal);
                    self.changeStatusBtn.isUserInteractionEnabled = false;
                    self.editPostBtn.isHidden = true
                    self.editPostBtnBottom.isHidden = true

                imageStatus = "published"
              //  status = "Deleted"
            } else if(post.status == ""){
                imageStatus = ""
            }
            
            if (cell.postPrePublishView.isHidden == false) {
                cell.pushToTwitterView.addGestureRecognizer(postToTwitterTapGesture);
                cell.pushToFacebookView.addGestureRecognizer(postToFacebookTapGesture);
            }
            
            //Call this function
            let height = self.heightForView(text: post.postDescription, font: UIFont.init(name: "VisbyCF-Regular", size: 16.0)!, width: cell.contentView.frame.width - 30)
            
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
            
            
            //Setting frame for DESCRIPITON VIEW
            if (cell.postPrePublishView.isHidden == true) {
                cell.descriptionView.frame = CGRect.init(x: cell.descriptionView.frame.origin.x, y: 15, width: cell.descriptionView.frame.width, height: height);
            } else {
                cell.descriptionView.frame = CGRect.init(x: cell.descriptionView.frame.origin.x, y: (55), width: cell.descriptionView.frame.width, height: height);
            }
            
            
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
            
            cell.communicationViewControllerDelegate = self;
            return cell;
            
            
        } else {
            
            //if (post.postCommunications.count > 0) {
                
                let communication = post.postCommunications[indexPath.row - 1];

                //We will show logged in user comments on right side and other users comment on
                //left side.
            /*    if (communication.communicatedByUserId == loggedInUser.userId) { //left side
                    
                    let cell: LeftCommunicationTableViewCell = tableView.dequeueReusableCell(withIdentifier: "LeftCommunicationTableViewCell") as! LeftCommunicationTableViewCell;
                    
                    cell.commentedDate.text = Date().ddspEEEEcmyyyyspHHclmmclaa(dateStr: communication.commentedOn);
                    
                    cell.commentorPic.sd_setImage(with: URL.init(string: communication.communicatedProfilePic), placeholderImage: UIImage.init(named: "Profile-1"));
                    
                    //Call this function
                    let height = self.heightForView(text: communication.postCommunicationDescription, font: UIFont.init(name: "VisbyCF-Regular", size: 16.0)!, width: self.view.frame.width - 100)
                    
                    //This is your label
                    for view in cell.descriptionView.subviews {
                        view.removeFromSuperview();
                    }

                    let proNameLbl = UILabel(frame: CGRect(x: 10, y: 35, width: self.view.frame.width - 100, height: height))
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
                    cell.descriptionView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1);

                    print("width")
                    print(cell.descriptionView.frame.width)
                    
                    if (communication.attachments.count > 0) {
                        
                        cell.imageScrollView.isHidden = false;
                        cell.imagesArray = [String]();
                        for attachment in communication.attachments {
                            cell.imagesArray.append(attachment.image);
                        }
                        cell.setupSlideScrollView();
                        cell.imageScrollView.frame = CGRect.init(x: cell.imageScrollView.frame.origin.x, y: cell.descriptionView.frame.origin.y + 50 + height, width: cell.imageScrollView.frame.width, height: cell.imageScrollView.frame.height);
                        
                        if (communication.attachments.count == 1) {
                            cell.pageControl.isHidden = true;
                            
                            //50 Top Height, height: Label height, imasge scroll view height, Gap below image scroll view.
                            let totalDescriptionHeight = 50 + height + cell.imageScrollView.frame.height + 10;
                            cell.descriptionView.frame = CGRect.init(x: 15, y: 10, width: self.view.frame.width - 70, height: totalDescriptionHeight);

                        } else {
                            
                            cell.pageControl.numberOfPages = cell.imagesArray.count
                            cell.pageControl.currentPage = 0
                            cell.contentView.bringSubview(toFront: cell.pageControl)

                            cell.pageControl.isHidden = false;
                            cell.pageControl.frame = CGRect.init(x: cell.imageScrollView.frame.width/2 - cell.pageControl.frame.width/4, y: cell.imageScrollView.frame.origin.y + cell.imageScrollView.frame.height - 10, width: cell.pageControl.frame.width, height: cell.pageControl.frame.height)
                            
                            let totalDescriptionHeight = 40 + height + cell.imageScrollView.frame.height + cell.pageControl.frame.height;
                            cell.descriptionView.frame = CGRect.init(x: 15, y: 10, width: self.view.frame.width - 70, height: totalDescriptionHeight);

                        }
                    } else {
                        cell.imageScrollView.isHidden = true;
                        cell.pageControl.isHidden = true;
                        
                        cell.descriptionView.frame = CGRect.init(x: 15, y: 10, width: self.view.frame.width - 70, height: 50 + height);

                    }
                    return cell;
                    
               } else { //right side */
                    
                    
                    let cell: RightCommunicationTableViewCell = tableView.dequeueReusableCell(withIdentifier: "RightCommunicationTableViewCell") as! RightCommunicationTableViewCell;

                    cell.commentedDate.text = Date().ddspEEEEcmyyyyspHHclmmclaa(dateStr: communication.commentedOn);
                    
                    cell.commentorPic.sd_setImage(with: URL.init(string: communication.communicatedProfilePic), placeholderImage: UIImage.init(named: "Profile-1"));
                    
                    //Call this function
                    let height = self.heightForView(text: communication.postCommunicationDescription, font: UIFont.init(name: "VisbyCF-Regular", size: 16.0)!, width: self.view.frame.width - 100)
                    
                    //This is your label
                    for view in cell.descriptionView.subviews {
                        view.removeFromSuperview();
                    }
                    let proNameLbl = UILabel(frame: CGRect(x: 10, y: 35, width: self.view.frame.width - 100, height: height))
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
                    cell.descriptionView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1);

                    
                    if (communication.attachments.count > 0) {
                        
                        cell.imageScrollView.isHidden = false;
                        cell.imagesArray = [String]();

                        for attachment in communication.attachments {
                            cell.imagesArray.append(attachment.image);
                        }
                        cell.setupSlideScrollView();
                        cell.imageScrollView.frame = CGRect.init(x: cell.imageScrollView.frame.origin.x, y: cell.descriptionView.frame.origin.y + 50 + height, width: cell.imageScrollView.frame.width, height: cell.imageScrollView.frame.height);
                        
                        if (communication.attachments.count == 1) {
                            cell.pageControl.isHidden = true;
                            
                            let totalDescriptionHeight = 50 + height + cell.imageScrollView.frame.height + 10;
                            
                            cell.descriptionView.frame = CGRect.init(x: cell.descriptionView.frame.origin.x, y: cell.descriptionView.frame.origin.y, width: self.view.frame.width - 70, height: totalDescriptionHeight)
                            
                        } else {
                            cell.pageControl.numberOfPages = cell.imagesArray.count
                            cell.pageControl.currentPage = 0
                            cell.contentView.bringSubview(toFront: cell.pageControl)
                            cell.pageControl.isHidden = false;
                            cell.pageControl.frame = CGRect.init(x: cell.imageScrollView.frame.origin.x + cell.imageScrollView.frame.width/2 - cell.pageControl.frame.width/2, y: cell.imageScrollView.frame.origin.y + cell.imageScrollView.frame.height - 10, width: cell.pageControl.frame.width, height: cell.pageControl.frame.height);
                            
                            let totalDescriptionHeight = 50 + height + cell.imageScrollView.frame.height + cell.pageControl.frame.height +  10;
                            
                            cell.descriptionView.frame = CGRect.init(x: cell.descriptionView.frame.origin.x, y: cell.descriptionView.frame.origin.y, width: self.view.frame.width - 70, height: totalDescriptionHeight)

                        }
                    } else {
                        cell.imageScrollView.isHidden = true;
                        cell.pageControl.isHidden = true;
                        
                        cell.descriptionView.frame = CGRect.init(x: cell.descriptionView.frame.origin.x, y: 10, width: self.view.frame.width - 70, height: 50 + height)
                    }
                    return cell;
             /*   } */
        }
        
        return UITableViewCell();
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (indexPath.row == 0) {
            
            var postPublishViewHeight = CGFloat(HomePostCellHeight.publishPostButtonsView);
            if (self.loggedInUser.isCastr == 2) {
                postPublishViewHeight = 0.0;
            } else {
                //Lets handle the logic of Hiding and Shwoing Publish Buttons.
                //First lets check if post status is Approved/ Published.
                //If post status is approved, then we would have to show both buttons.
                //Publish to Twitter and Publish to Facebook
                if (post.postStatusId == HomePostPublishStatusId.APPROVEDSTATUSID) {
                    postPublishViewHeight = CGFloat(HomePostCellHeight.publishPostButtonsView);
                    
                    //If post status is Published, Then we have to check
                    //If user posted on both platforms or not
                } else if (post.postStatusId == HomePostPublishStatusId.PUBLISHSTATUSID) {
                    
                    var facebookPublished = false;
                    for socialMediaId in post.socialMediaIds {
                        if (socialMediaId == social.socialPlatformId["Facebook"]) {
                            facebookPublished = true;
                            break;
                        }
                    }
                    
                    var twitterPublished = false;
                    for socialMediaId in post.socialMediaIds {
                        if (socialMediaId == social.socialPlatformId["Twitter"]) {
                            twitterPublished = true;
                            break;
                        }
                    }
                    
                    if (facebookPublished == true && twitterPublished == true) {
                        postPublishViewHeight = 0;
                    } else {
                        postPublishViewHeight = CGFloat(HomePostCellHeight.publishPostButtonsView);
                    }
                    
                    //If Post status is neither approved nor publised
                    //Then we will hide the Publish Post Bar
                } else {
                    postPublishViewHeight = 0
                }                
            }

            var height = self.heightForView(text: post.postDescription, font: UIFont.init(name: "VisbyCF-Regular", size: 16.0)!, width: tableView.frame.width - 30);
            
            /*if (height > 100) {
                height = 100;
            }*/
            if (post.postImages.count > 0) {
                
                if (post.postImages.count == 1) {
                    
                    return (CGFloat(HomePostCellHeight.GapAboveStatus) + postPublishViewHeight +  height + CGFloat(HomePostCellHeight.GapBelowLabel) + 420);
                }
                return (CGFloat(HomePostCellHeight.GapAboveStatus) + postPublishViewHeight + height + CGFloat(HomePostCellHeight.GapBelowLabel) + 420 +  30);
            }
            return (CGFloat(HomePostCellHeight.GapAboveStatus + HomePostCellHeight.PostStatusViewHeight) + postPublishViewHeight + height);
        } else {
            let communication = post.postCommunications[indexPath.row - 1];
            
            let height = self.heightForView(text: communication.postCommunicationDescription, font: UIFont.init(name: "VisbyCF-Regular", size: 16.0)!, width: self.view.frame.width - 100)
            if (communication.attachments.count > 0) {
                if (communication.attachments.count == 1) {
                    return height + 60 + 200 + 20;
                } else {
                    return height + 60 + 200 + 40;
                }
            } else {
                return height + 70;
            }
        }
    }
}

