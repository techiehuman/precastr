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
import MessageUI

protocol ImageLibProtocolC {
    func takePicture(viewC : UIViewController);
}

class CommunicationViewController: SharePostViewController,UITextViewDelegate, UIImagePickerControllerDelegate, EasyTipViewDelegate, SharingDelegate, MFMessageComposeViewControllerDelegate {

    var posts = [Post]();
    var post = Post();
    var postId : Int!;
    var postCommunicationid: Int!;
    @IBOutlet weak var communicationTableView: UITableView!
    //@IBOutlet weak var postTextField: UITextView!
    
    
    @IBOutlet weak var textAreaBtnBottomView: UIView!
    @IBOutlet weak var textArea: UITextView!
    @IBOutlet weak var attachmentBtn: UIButton!
    @IBOutlet weak var submitBtn : UIButton!
    @IBOutlet weak var postCommentLabel : UILabel!

    var loggedInUser : User!
    var uploadImage : [UIImage] = [UIImage]()
    var imageDelegate : ImageLibProtocolC!
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
    var keyboardHeight: CGFloat = 0.0;
    var placeholderText: NSMutableAttributedString!;
    var placeholderTextStr: String!;
    var sourceViewController: UIViewController!;

    var casterPlaceholderText1 = "Communicate with your Moderator.";
    var moderatorPlaceholderText1 = "Communicate with your Caster.";
    var placeholderText2 = "\nTo edit post click on the \"Edit Post\" button at top.";
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView();
    
    class func MainViewController() -> UITabBarController {
        
        let tabBarContro = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MadTabBar") as! UITabBarController
        let loggedInUser = User().loadUserDataFromUserDefaults(userDataDict: setting);
            //If Logged in user is a moderator, then we will
            if (loggedInUser.isCastr == 2) {
                
                if (tabBarContro != nil && tabBarContro.viewControllers?.count == 5) {
                    tabBarContro.viewControllers?.remove(at: 1)
                }
            } else {
                
                if (tabBarContro.viewControllers?.count == 4) {
                    
                    let navController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateNewPostNavController") as! UINavigationController;
                    tabBarContro.viewControllers?.insert(navController, at: 1);
                }
            }
        
        return tabBarContro;
        //return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MadTabBar") as! UITabBarController
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        postIdFromPush = 0;
        self.loggedInUser = User().loadUserDataFromUserDefaults(userDataDict: setting);
        social = SocialPlatform().loadSocialDataFromUserDefaults();
        
        communicationTableView.register(UINib(nibName: "PostItemTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "PostItemTableViewCell")
        communicationTableView.register(UINib.init(nibName: "LeftCommunicationTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "LeftCommunicationTableViewCell");
          communicationTableView.register(UINib.init(nibName: "RightCommunicationTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "RightCommunicationTableViewCell");
         //communicationTableView.register(UINib.init(nibName: "HomeTextPostTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "HomeTextPostTableViewCell");
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshScreenData), name: NSNotification.Name(rawValue: "reloadCommunicationScreen"), object: nil)

        
        activityIndicator.center = view.center;
        activityIndicator.hidesWhenStopped = true;
        activityIndicator.style = UIActivityIndicatorView.Style.gray;
        view.addSubview(activityIndicator);
        
        let boldAttribute = [
           NSAttributedString.Key.font: UIFont(name: "VisbyCF-Bold", size: 16.0)!
        ]
        let regularAttribute = [
           NSAttributedString.Key.font: UIFont(name: "VisbyCF-Regular", size: 16.0
            )!
        ]
        
        placeholderText = NSMutableAttributedString();
        if (self.loggedInUser.isCastr == 1) {
            //placeholderText = "\(casterPlaceholderText1)\(placeholderText2)";
            let boldText = NSAttributedString(string: "\(casterPlaceholderText1)", attributes: boldAttribute)
            placeholderText.append(boldText)
            placeholderTextStr = "\(casterPlaceholderText1)\(placeholderText2)";
        } else {
            //placeholderText = "\(moderatorPlaceholderText1)\(placeholderText2)";
            let boldText = NSAttributedString(string: "\(moderatorPlaceholderText1)", attributes: boldAttribute)
            placeholderText.append(boldText);
            placeholderTextStr = "\(moderatorPlaceholderText1)\(placeholderText2)";

        }
        let regularText = NSAttributedString(string: "\(placeholderText2)", attributes: regularAttribute)
        placeholderText.append(regularText)
        
        self.attachmentBtn.roundEdgesLeftBtn();
        self.submitBtn.roundEdgesRightBtn();
        self.attachmentBtn.backgroundColor = PrecasterColors.darkBlueButtonColor;
        self.submitBtn.backgroundColor = PrecasterColors.themeColor;
        self.textArea.layer.cornerRadius = 4;
        self.textArea.layer.borderWidth = 1;
        self.textArea.layer.borderColor = UIColor(red: 112/255, green: 112/255, blue: 112/255, alpha: 1).cgColor;
        self.textArea.attributedText = placeholderText;
        self.textArea.textColor = UIColor(red: 118/255, green: 118/255, blue: 119/255, alpha: 1);

        //self.changeStatusBtn.layer.borderColor = UIColor(red: 112/255, green: 112/255, blue: 112/255, alpha: 1).cgColor;
      
        if (self.post.postId != 0) {
            self.populatePostData();
            self.getPostCommunications(postId: self.post.postId );
        } else if (self.postId != nil) {
            self.getPostCommunications(postId: self.postId);
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        self.setUpNavigationBarItems();
        
        //self.hideKeyboadOnTapOutside();
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        communicationTableView.addGestureRecognizer(tap);

        self.getAllPostStatuses();
        
        self.changeStatusFunction();
        
        self.addDoneButtonOnKeyboard();
        
        PostService().markNotificationAsRead(notificationId: pushNotificationId, complete: {(response) in
            pushNotificationId = 0;
            self.showBadgeCount();
            
        });
        if (self.tabBarController != nil) {
            let positionOfBottomView = self.view.frame.height - (self.textAreaBtnBottomView.frame.height + ((self.tabBarController?.tabBar.frame.height)!) + 5);
            
            self.textAreaBtnBottomView.frame.origin.y = positionOfBottomView;
            
            self.communicationTableView.frame = CGRect.init(x: 0, y: self.communicationTableView.frame.origin.y, width: self.view.frame.width, height: self.textAreaBtnBottomView.frame.origin.y - self.communicationTableView.frame.origin.y)
            
        }
        //postStatusList = loadPostStatus()
        //Setting Status of Post
        
        //Lets hide the text filed view if status pf post is published
        var status = "";
        for postStatus in postStatusList {
            if (postStatus.postStatusId == post.postStatusId) {
                status = postStatus.title;
                break;
            }
        }
        if (status == "Published" || (sourceViewController != nil && sourceViewController is ArchieveViewController)) {
            self.textAreaBtnBottomView.isHidden = true;
            self.communicationTableView.frame = CGRect.init(x: 0, y: self.communicationTableView.frame.origin.y, width: self.view.frame.width, height: (self.view.frame.height - (self.communicationTableView.frame.origin.y + (self.tabBarController?.tabBar.frame.height)!)));
        }
        
        pushForScreenAt = "Home";
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        
       // self.getPostCommunications();
        self.communicationTableView.reloadData();
        
        //If Logged in user is a moderator, then we will
        self.loggedInUser = User().loadUserDataFromUserDefaults(userDataDict: setting);
        if (loggedInUser.isCastr == 2) {
            self.navigationItem.title = "Cast Detail";
            
            if (self.tabBarController != nil && self.tabBarController!.viewControllers?.count == 5) {
                self.tabBarController!.viewControllers?.remove(at: 1)
            }
        } else {
            self.navigationItem.title = "Cast Detail";
            
            if (self.tabBarController != nil && self.tabBarController!.viewControllers?.count == 4) {
                
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
                        index =  4;
                    } else {
                        index = 3;
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
                // Lets add ui labels in width.
                //self.changeStatusBtn.frame = CGRect.init(x: (self.changeStatusBtn.frame.origin.x), y: self.changeStatusBtn.frame.origin.y, width: totalWidthOfUIView, height: self.changeStatusBtn.frame.height);
                break;
            }
        }
    }
    
    func setUpNavigationBarItems() {
        
        let backButton = UIButton();
        backButton.setImage(UIImage.init(named: "left-arrow"), for: .normal);
        backButton.addTarget(self, action: #selector(backButtonPressed), for: UIControl.Event.touchUpInside)
        backButton.frame = CGRect.init(x: 0, y:0, width: 20, height: 15);
        
        let barButton = UIBarButtonItem(customView: backButton)
        
        navigationItem.leftBarButtonItem = barButton;
        
        let homeButton = UIButton();
        homeButton.setImage(UIImage.init(named: "menu"), for: .normal);
        homeButton.addTarget(self, action: #selector(menuButtonClicked), for: UIControl.Event.touchUpInside)
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
    @objc func postDeletePressed(sender: PostToSocialMediaGestureRecognizer){
        
        var postData = [String: Any]();
        let post = sender.post;
        postData["post_id"] = post?.postId;
        postData["timestamp"] = Int64(Date().timeIntervalSince1970 * 1000.0);

        let alert = UIAlertController.init(title: "Delete this cast.", message: "", preferredStyle: .alert);
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil));
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {(response) in
            
            
            
            let jsonURL = "posts/delete_cast/format/json"
            DispatchQueue.main.async {
                self.activityIndicator.startAnimating();
            }
            UserService().postDataMethod(jsonURL: jsonURL, postData: postData, complete: {(response) in
                print(response)
                self.activityIndicator.stopAnimating();
                
                let statusCode = Int(response.value(forKey: "status") as! String)!
                if(statusCode == 0) {
                    self.showAlert(title: "Alert", message: response.value(forKey: "message") as! String);
                } else {
                    let viewController: HomeV2ViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeV2ViewController") as! HomeV2ViewController;
                    self.navigationController?.pushViewController(viewController, animated: true);
                }
            });
            
            
            
            
            
        }));
        self.present(alert, animated: true)
    }
    
    func deleteButtonPresses(post : Post) {
        
        var postData = [String: Any]();
        postData["post_id"] = post.postId;
        postData["timestamp"] = Int64(Date().timeIntervalSince1970 * 1000.0);

        let alert = UIAlertController.init(title: "Delete this cast.", message: "", preferredStyle: .alert);
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil));
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {(response) in
            
            let jsonURL = "posts/delete_cast/format/json"
            DispatchQueue.main.async {
                self.activityIndicator.startAnimating();
            }
            UserService().postDataMethod(jsonURL: jsonURL, postData: postData, complete: {(response) in
                print(response)
                self.activityIndicator.stopAnimating();
                
                let statusCode = Int(response.value(forKey: "status") as! String)!
                if(statusCode == 0) {
                    self.showAlert(title: "Alert", message: response.value(forKey: "message") as! String);
                } else {
                    let viewController: HomeV2ViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeV2ViewController") as! HomeV2ViewController;
                    self.navigationController?.pushViewController(viewController, animated: true);
                }
            });
        }));
        self.present(alert, animated: true)
    }
    
    /*@objc func callInfoButtonPressed(sender: PostToSocialMediaGestureRecognizer) {
        let post = sender.post;
        let viewController = storyboard?.instantiateViewController(withIdentifier: "CastContactsViewController") as! CastContactsViewController;
        
        var contacts = [User]();
        for userP in post!.castModerators {
            if (userP.phoneNumber != "" && userP.phoneNumber != nil) {
                contacts.append(userP);
            }
        }
        viewController.castContacts = contacts;
        viewController.postDescription = post?.postDescription;
        self.navigationController?.pushViewController(viewController, animated: true);
    }*/

    @IBAction func submitBtnClicked(_ sender: Any) {
        
       /* if(textArea.text != "" && textArea.text != placeholderText || PhotoArray.count > 0){ */
            self.activityIndicator.startAnimating();
            
            let jsonURL = "\(ApiUrl)posts/add_post_communication/format/json"
            var postData : [String : Any] = [String : Any]()
            if(textArea.text != placeholderTextStr) {
                postData["post_communication_description"] = self.textArea.text
            } else {
                postData["post_communication_description"] = "";
        }
            postData["post_id"] = self.post.postId;
            postData["user_id"] = self.loggedInUser.userId;
            postData["timestamp"] = Int64(Date().timeIntervalSince1970 * 1000.0)
            if (PhotoArray.count > 0) {
            
                HttpService().postMultipartImageForPostCommunication(url: jsonURL, image: PhotoArray, postData: postData, complete: {(response) in
                    self.PhotoArray = [UIImage]();
                    print(response);
                    
                    self.activityIndicator.stopAnimating();
                    //Load latest Communications
                    self.getPostCommunications(postId: self.post.postId);
                    self.textArea.attributedText = self.placeholderText;
                    self.textArea.textColor = UIColor(red: 118/255, green: 118/255, blue: 119/255, alpha: 1)
                    self.textArea.resignFirstResponder();
                });
            } else {
                HttpService().postMethod(url: jsonURL, postData: postData, complete: {(response) in
                    print(response);
                    
                    self.activityIndicator.stopAnimating();
                    //Load latest Communications
                    self.getPostCommunications(postId: self.post.postId);
                    self.textArea.attributedText = self.placeholderText;
                    self.textArea.textColor = UIColor(red: 118/255, green: 118/255, blue: 119/255, alpha: 1)
                    self.textArea.resignFirstResponder();
                    self.communicationTableView.reloadData();
                });
            }
       /* }else{
            if (PhotoArray.count == 0) {
            let message = "Please enter some text or image to post!"
            self.showAlert(title: "Error", message: message);
            }
        }*/
    }
    
    @IBAction func mediaAttachmentBtnClicked(_ sender: Any) {
        if (PHPhotoLibrary.authorizationStatus() == .denied) {
            let alertController = UIAlertController(title: "Permission Denied", message: "Enable permission for gallery under app settings", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                
                // Code in this block will trigger when OK button tapped.
                if let settingUrl = URL(string:UIApplication.openSettingsURLString) {
                    UIApplication.shared.openURL(settingUrl);
                } else {
                    print("Setting URL invalid")
                }
                
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion:nil);
        } else {
            self.selectMultipleImages();
        }

       
    }
    
    
    func changeStatusButtonClicked() {
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
    
    func editButtonPressed(post: Post) {
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
                option.isSynchronous = true
                option.isNetworkAccessAllowed = true
                var thumbnail = UIImage();
                
                manager.requestImage(for: SelectedAssets[i], targetSize: CGSize(width: 512, height: 512), contentMode: .aspectFill, options: option, resultHandler: {(result, info)->Void in
                
                    if(result != nil){
                        thumbnail = result!
                        let data = thumbnail.jpegData(compressionQuality: 0.7)
                        let newImage = UIImage(data: data!)
                        self.PhotoArray.append(newImage! as UIImage)

                    } else {
                        
                        let message = "Error in Image loading..."
                        self.showAlert(title: "Error", message: message);
                    }
                });
                
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
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            self.keyboardHeight = keyboardSize.height;
            
            let bottomAreaViewPosition = self.view.frame.height - (self.textAreaBtnBottomView.frame.height + 5 + keyboardSize.height);
            self.textAreaBtnBottomView.frame.origin.y = bottomAreaViewPosition;
            
            
            var keyboardHeight = self.view.frame.height - (keyboardSize.height + self.textAreaBtnBottomView.frame.height + 5 + self.communicationTableView.frame.origin.y);
            self.communicationTableView.frame = CGRect.init(x: 0, y: self.communicationTableView.frame.origin.y, width: self.view.frame.width, height: keyboardHeight);
            
            self.textArea.font = UIFont.init(name: "VisbyCF-Regular", size: 16.0);
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            self.keyboardHeight = 0.0;

            if (self.tabBarController != nil) {
                let positionOfBottomView = self.view.frame.height - (self.textAreaBtnBottomView.frame.height + ((self.tabBarController?.tabBar.frame.height)!) + 10);
                
                self.textAreaBtnBottomView.frame.origin.y = positionOfBottomView;
                
                self.communicationTableView.frame = CGRect.init(x: 0, y: self.communicationTableView.frame.origin.y, width: self.view.frame.width, height: self.textAreaBtnBottomView.frame.origin.y - self.communicationTableView.frame.origin.y)
                
            }
        }
        
        if (self.textArea.text == castTextAreaPlaceholder) {
            self.textArea.textColor = UIColor(red: 118/255, green: 118/255, blue: 119/255, alpha: 1);
        }
    }
    
    func updatePostStatus(postStatusId: Int) {
        
        if (self.post.status != "Approved" && postStatusId == 7) { // going to publish
            
            let alert = UIAlertController.init(title: "Error", message: "Post not Approved yet", preferredStyle: .alert);
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil));
            self.present(alert, animated: true);
            
        } else {
            
            DispatchQueue.main.async {
                self.activityIndicator.startAnimating();
            }
            
            let tempPostTitle = self.post.status;
            let tempPostStatusId = postStatusId;
            let jsonURL = "posts/update_post_status/format/json";
            
            var postData = [String: Any]();
            postData["post_id"] = self.post.postId;
            postData["user_id"] = self.loggedInUser.userId;
            postData["post_status_id"] = postStatusId;
            postData["timestamp"] = Date().timeIntervalMilliSeconds();
            PostService().postDataMethod(jsonURL: jsonURL, postData: postData, complete: {(response) in
                self.activityIndicator.stopAnimating();
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
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadHomeScreen"), object: nil);
                        // Lets add ui labels in width.
                        //self.changeStatusBtn.frame = CGRect.init(x:  self.view.frame.width - (self.lblPostDate.intrinsicContentSize.width + self.changeStatusBtn.intrinsicContentSize.width + 40), y: self.changeStatusBtn.frame.origin.y, width: totalWidthOfUIView, height: self.changeStatusBtn.frame.height);
                        
                        
                        //self.changeStatusFunction();
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
    
    func getPostCommunications(postId:Int) {
        
        let getComUrl = "\(ApiUrl)posts/get_post_communication/format/json";
        var postData : [String : Any] = [String : Any]()
        postData["post_id"] = postId;
        
        HttpService().postMethod(url: getComUrl, postData: postData, complete: {(response) in
            
            let status = Int(response.value(forKey: "status") as! String)!
            let message = response.value(forKey: "message") as! String;
            //let status =  response.value(forKey: "status") as? Bool ?? false
            if status == 0 {
                self.showAlert(title: "Error", message: message);
            } else {
                print(response)
                let data = response.value(forKey: "data") as! NSDictionary;
                
                //if (self.post.postId == 0){
                    var postData = data.value(forKey: "postdetails") as! NSDictionary;
                    self.post = Post().loadPostFromDict(postDict: postData);
                    self.populatePostData();
                    self.communicationTableView.reloadData();
                //}
                
                let postCommArr = data.value(forKey: "postcommunication") as! NSArray;
                
                self.post.postCommunications = PostCommunication().loadCommunicationsFromNsArray(commArray: postCommArr);
                self.getAllPostStatuses();
                // Put your code which should be executed with a delay here
                self.communicationTableView.reloadData();
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200), execute: {
                    self.communicationTableView.reloadData();
                        
                    if (self.postCommunicationid != nil) {
                        var indexOfCommunication = 1;
                        for postComm in self.post.postCommunications {
                            if (self.postCommunicationid == postComm.postCommunicationId) {
                                break;
                            }
                            indexOfCommunication = indexOfCommunication + 1;
                        }
                        self.communicationTableView.selectRow(at: IndexPath.init(row: indexOfCommunication, section: 0), animated: true, scrollPosition: .top);
                        //self.communicationTableView.scrollToRow(at: , at: .top, animated: true);
                    }
                    
                })
            }
        });
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if self.textArea.textColor == UIColor(red: 118/255, green: 118/255, blue: 119/255, alpha: 1) {
            self.textArea.text = nil
            self.textArea.textColor = UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 1);
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if self.textArea.text.isEmpty {
            self.textArea.attributedText = self.placeholderText
            self.textArea.textColor = UIColor(red: 118/255, green: 118/255, blue: 119/255, alpha: 1)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        print("Content Size : ", textView.contentSize.height);

        if textView.contentSize.height > textView.frame.size.height {

            if (textView.frame.size.height > 130) {
                return;
            }
            let fixedWidth = textView.frame.size.width
            textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))

            var newFrame = textView.frame
            let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))

            newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
            
            textView.frame = newFrame;
            
            if (textView.contentSize.height < textView.frame.size.height) {
                textView.frame = CGRect.init(x: textView.frame.origin.x, y: textView.frame.origin.y, width: textView.frame.width, height: textView.frame.height - 20);
            }
            
            if (self.tabBarController != nil) {
                
               self.textArea.frame.origin.y = 10;
                
               let positionOfBottomView = self.view.frame.height - (128 + 10 + (newSize.height - 85) + self.keyboardHeight);
               
               self.textAreaBtnBottomView.frame.origin.y = positionOfBottomView;
                
                self.textAreaBtnBottomView.frame = CGRect.init(x: self.textAreaBtnBottomView.frame.origin.x, y: self.textAreaBtnBottomView.frame.origin.y, width: self.textAreaBtnBottomView.frame.width, height: self.textAreaBtnBottomView.frame.height + (newSize.height - 85));
                
                self.attachmentBtn.frame = CGRect.init(x: self.attachmentBtn.frame.origin.x, y: self.textArea.frame.height + 20, width: self.attachmentBtn.frame.width, height: self.attachmentBtn.frame.height);
                
                self.submitBtn.frame = CGRect.init(x: self.submitBtn.frame.origin.x, y: self.textArea.frame.height + 20, width: self.submitBtn.frame.width, height: self.submitBtn.frame.height);
                
                self.postCommentLabel.frame = CGRect.init(x: self.postCommentLabel.frame.origin.x, y: self.textArea.frame.height + 20, width: self.postCommentLabel.frame.width, height: self.postCommentLabel.frame.height);
                
               self.communicationTableView.frame = CGRect.init(x: 0, y: self.communicationTableView.frame.origin.y, width: self.view.frame.width, height: self.textAreaBtnBottomView.frame.origin.y - self.communicationTableView.frame.origin.y)
           }
        } else if (textView.contentSize.height < textView.frame.size.height && textView.contentSize.height > 74 && textView.contentSize.height <= 112) {
            
            self.textArea.frame = CGRect.init(x: self.textArea.frame.origin.x, y: self.textArea.frame.origin.y, width: self.textArea.frame.width, height: textView.contentSize.height);
             
            let positionOfBottomView = self.view.frame.height - (128 + 10 + (textView.contentSize.height - 85) + self.keyboardHeight);
            
            self.textAreaBtnBottomView.frame.origin.y = positionOfBottomView;
             
             self.textAreaBtnBottomView.frame = CGRect.init(x: self.textAreaBtnBottomView.frame.origin.x, y: self.textAreaBtnBottomView.frame.origin.y, width: self.textAreaBtnBottomView.frame.width, height: self.textAreaBtnBottomView.frame.height + (textView.contentSize.height - 85));
             
             self.attachmentBtn.frame = CGRect.init(x: self.attachmentBtn.frame.origin.x, y: self.textArea.frame.height + 20, width: self.attachmentBtn.frame.width, height: self.attachmentBtn.frame.height);
             
             self.submitBtn.frame = CGRect.init(x: self.submitBtn.frame.origin.x, y: self.textArea.frame.height + 20, width: self.submitBtn.frame.width, height: self.submitBtn.frame.height);
             
             self.postCommentLabel.frame = CGRect.init(x: self.postCommentLabel.frame.origin.x, y: self.textArea.frame.height + 20, width: self.postCommentLabel.frame.width, height: self.postCommentLabel.frame.height);
             
            self.communicationTableView.frame = CGRect.init(x: 0, y: self.communicationTableView.frame.origin.y, width: self.view.frame.width, height: self.textAreaBtnBottomView.frame.origin.y - self.communicationTableView.frame.origin.y)
            
        } else if (textView.contentSize.height <= 74)  {
            if (self.tabBarController != nil) {
                
                self.textArea.frame = CGRect.init(x: self.textArea.frame.origin.x, y: self.textArea.frame.origin.y, width: self.textArea.frame.width, height: 85);
                
                self.textArea.frame.origin.y = 10;
                let positionOfBottomView = self.view.frame.height - 128 - 10
                    - self.keyboardHeight;
                
                self.textAreaBtnBottomView.frame.origin.y = positionOfBottomView;
                 
                 self.textAreaBtnBottomView.frame = CGRect.init(x: self.textAreaBtnBottomView.frame.origin.x, y: positionOfBottomView, width: self.textAreaBtnBottomView.frame.width, height: 128);
                 
                 self.attachmentBtn.frame = CGRect.init(x: self.attachmentBtn.frame.origin.x, y: self.textArea.frame.height + 20, width: self.attachmentBtn.frame.width, height: self.attachmentBtn.frame.height);
                 
                 self.submitBtn.frame = CGRect.init(x: self.submitBtn.frame.origin.x, y: self.textArea.frame.height + 20, width: self.submitBtn.frame.width, height: self.submitBtn.frame.height);
                 
                 self.postCommentLabel.frame = CGRect.init(x: self.postCommentLabel.frame.origin.x, y: self.textArea.frame.height + 20, width: self.postCommentLabel.frame.width, height: self.postCommentLabel.frame.height);
                 
                self.communicationTableView.frame = CGRect.init(x: 0, y: self.communicationTableView.frame.origin.y, width: self.view.frame.width, height: self.textAreaBtnBottomView.frame.origin.y - self.communicationTableView.frame.origin.y)
            }
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
                
                // Lets add ui labels in width.
                //self.changeStatusBtn.frame = CGRect.init(x: (self.changeStatusBtn.frame.origin.x), y: self.changeStatusBtn.frame.origin.y, width: totalWidthOfUIView, height: self.changeStatusBtn.frame.height);

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
                
                // Lets add ui labels in width.
                //self.changeStatusBtn.frame = CGRect.init(x: (self.changeStatusBtn.frame.origin.x), y: self.changeStatusBtn.frame.origin.y, width: totalWidthOfUIView, height: self.changeStatusBtn.frame.height);
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
    
    
    /*func showFacebookFailAlert() {
        
        var refreshAlert = UIAlertController(title: "Facebook Not Installed", message: "It looks like the Facebook app is not installed on your iPhone. Click \"OK\" to download, after installing please \"LOG IN\" to the \"FB App\" and come back to the same screen on \"PreCastr\" and hit the \"Push to FB\" button", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            if let url = URL(string: "https://apps.apple.com/in/app/facebook/id284882215") {
                UIApplication.shared.open(url)
            }
        }));
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
            
            
        }));
        self.present(refreshAlert, animated: true, completion: nil)
        
    }*/
    func changeStatusFunction(){
        print("SDSDSDSDSDSD")
        if (loggedInUser.isCastr == 1 || (loggedInUser.isCastr == 2 && (self.post.status == "Approved" || self.post.status == "Published"))) {
        //self.changeStatusBtn.isUserInteractionEnabled = false;
        //self.changeStatusBtn.layer.borderWidth = 0
        var status = "";
        var imageStatus = "";
        status = self.post.status
        if (status == "Pending") {
            imageStatus = "pending-review"
            
        } else if (status == "Approved") {
            imageStatus = "approved"
            
        } else if (status == "Rejected") {
            imageStatus = "rejected"
            
        } else if(status == "Published") {
            imageStatus = "published"
            
        } else if(status == ""){
            imageStatus = ""
        }
        
        //self.changeStatusBtn.setImage(UIImage.init(named: imageStatus), for: .normal);
        //self.changeStatusBtn.semanticContentAttribute = UIApplication.shared
            //.userInterfaceLayoutDirection == .leftToRight ? .forceLeftToRight : .forceRightToLeft;
        
        //self.changeStatusBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
            //self.separator.isHidden = false
    } else {
        //self.changeStatusBtn.setImage(UIImage.init(named: "down_arrow"), for: .normal);
        //self.changeStatusBtn.isUserInteractionEnabled = true;
        //self.separator.isHidden = true
    }
}
    
    func addDoneButtonOnKeyboard() {
        
        // add a done button to the numberpad
        var toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        var cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        var doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: "doneButtonAction")
        var spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
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
        self.getPostCommunications(postId: self.post.postId);
        self.showBadgeCount();
    }
    func populatePostData(){
        
    }
    @objc func postToSMSPressed(sender: PostToSocialMediaGestureRecognizer) {
        let post = sender.post;
        self.postId = post?.postId
        var phoneNumbers = [String]();
        for user in post!.castModerators {
            //print(user.countryCode!)
            print(user.phoneNumber!)
            if(user.countryCode != nil && user.phoneNumber != nil && user.countryCode != "" && user.phoneNumber != ""){
                phoneNumbers.append("\(user.countryCode!)\(user.phoneNumber!)");
            }
        }
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.recipients = phoneNumbers
            controller.body = post?.postDescription;
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch (result)
        {
        case .sent:
            print("sms sent.")
            var postData = [String: Any]();
            postData["user_id"] = self.loggedInUser.userId
            postData["post_id"] = self.postId!
            postData["timestamp"] = Date().timeIntervalMilliSeconds()
            let jsonURL = "user/send_post_sms/format/json";
            UserService().postDataMethod(jsonURL: jsonURL,postData:postData,complete:{(response) in
                self.activityIndicator.stopAnimating();
                
                let statusCode = Int(response.value(forKey: "status") as! String)!
                if(statusCode == 0) {
                    self.showAlert(title: "Alert", message: response.value(forKey: "message") as! String);
                } else {
                    //self.populatePostData();
                }
                
            });
            break
        case .cancelled:
            print("sms cancelled.")
            break
        case .failed:
            print("failed sending email")
            break
        default:
            break
        }
        self.dismiss(animated: true, completion: nil)
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
            let cell: PostItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PostItemTableViewCell") as! PostItemTableViewCell;
            cell.pushViewController = self;
            cell.post = post
            cell.postRowIndex = indexPath.row;
            cell.totalPosts = 1;
            cell.postItemsTableView.reloadData();
            return cell;
            
        } else {
            
            //if (post.postCommunications.count > 0) {
                
            let communication = post.postCommunications[indexPath.row - 1];

                    
            let cell: RightCommunicationTableViewCell = tableView.dequeueReusableCell(withIdentifier: "RightCommunicationTableViewCell") as! RightCommunicationTableViewCell;

            cell.communicationViewControllerDelegate = self;
            if (communication.commentedOnTimestamp != 0) {
                let date = Date(timeIntervalSince1970: Double(communication.commentedOnTimestamp) / 1000.0);
                cell.commentedDate.text = Date().ddspEEEEcmyyyyspHHclmmclaaV2(dateStrDt: date);
            } else {
                cell.commentedDate.text = Date().ddspEEEEcmyyyyspHHclmmclaa(dateStr: communication.commentedOn);
            }
               
            for uiTextNameView in cell.subviews {
                if (uiTextNameView is AlphabetInitialsView) {
                    uiTextNameView.removeFromSuperview();
                }
            }

            for alphabeView in cell.subviews {
                if (alphabeView is AlphabetInitialsView) {
                    alphabeView.removeFromSuperview();
                }
            }
            if (communication.communicatedProfilePic == "") {
                                
                cell.commentorPic.isHidden = true;
                cell.commentorAlphabetView.isHidden = false;
                let user = User();
                user.name = communication.communicatedName;
                user.userId = Int32(communication.postCommunicationId);
                cell.commentorAlphabetLabel.text = getNameInitials(name: user.name);
                
            } else {
                cell.commentorAlphabetView.isHidden = true;
                cell.commentorPic.isHidden = false;
                cell.commentorPic.sd_setImage(with: URL.init(string: communication.communicatedProfilePic), placeholderImage: UIImage.init(named: "Profile-1"),  completed: nil);
            }
                    
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
                        NSAttributedString.Key.font : UIFont(name: "VisbyCF-Regular", size: 16.0)!,
                        NSAttributedString.Key.foregroundColor : UIColor.init(red: 34/255, green: 34/255, blue: 34/255, alpha: 1),
                        NSAttributedString.Key.paragraphStyle: paragraphStyle]
                    
                    let attrString = NSMutableAttributedString(string: lblToShow)
                    attrString.addAttributes(attributes, range: NSMakeRange(0, attrString.length));
                    proNameLbl.attributedText = attrString;
                    
                    cell.descriptionView.addSubview(proNameLbl)
                    cell.descriptionView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1);

                    
                    cell.imagesArray = [String]();
                    if (communication.attachments.count > 0) {
                        cell.imageSlideShow.isHidden = false;
                        for attachment in communication.attachments {
                            cell.imagesArray.append(attachment.image);
                        }
                        cell.createGalleryScrollView();
                        cell.imageSlideShow.frame = CGRect.init(x: cell.imageSlideShow.frame.origin.x, y: cell.descriptionView.frame.origin.y + 50 + height, width: cell.imageSlideShow.frame.width, height: cell.imageSlideShow.frame.height);
                    } else {
                        cell.imageSlideShow.isHidden = true;
                        cell.descriptionView.frame = CGRect.init(x: cell.descriptionView.frame.origin.x, y: 10, width: self.view.frame.width - 70, height: 50 + height)
                    }
            
                    if (postCommunicationid == communication.postCommunicationId) {
                        postCommunicationid = 0;
                        UIView.animate(withDuration: 2, animations: {
                            cell.backgroundColor = UIColor.lightGray;
                        }, completion: {(Bool) -> Void in
                            UIView.animate(withDuration: 2, animations: {
                                cell.backgroundColor = UIColor.clear;
                            });
                        });
                    }
                    return cell;
             /*   } */
        }
        
        return UITableViewCell();
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (indexPath.row == 0) {
            
            var height: CGFloat = 0
            if (loggedInUser.isCastr == 2) {
                height += CGFloat(PostRowsHeight.Post_Status_Row_Height);
            } else {
                height += CGFloat(PostRowsHeight.Post_Status_Row_Height + PostRowsHeight.Post_Action_Row_Height);
            }

            height = height + getHeightOfPostDescripiton(contentView: self.view, postDescription: post.postDescription) + CGFloat(PostRowsHeight.Post_Description_Row_Height);
            
            let websiteUrl = extractWebsiteFromText(text: post.postDescription);
            if (websiteUrl == post.postDescription) {
                height = height + 25;
            } else if (websiteUrl != "") {
                height = height + CGFloat(PostRowsHeight.Post_WebsiteInfo_Row_Height);
            }
            if (post.postImages.count != 0) {
                height = height + CGFloat(PostRowsHeight.Post_Gallery_Row_Height);
            }
            return height;
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

