//
//  CreatePostViewController.swift
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
import BSImagePicker
import MobileCoreServices
import Photos

protocol PostFormCellProtocol {
    func upadedSelectedImageCounts(counts: String);
    func reloadCollctionView();
}

class CreatePostViewController: UIViewController, UIImagePickerControllerDelegate {

    @IBOutlet weak var createPostTableView: UITableView!
    
    var postFormCellProtocolDelegate: PostFormCellProtocol!;
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView();
    var loggedInUser : User!
    var post: Post!;
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
    var postArray : [String:Any] = [String:Any]()
    var postImageDtos = [PostImageDto]();
    var isSubmitAlreadyAdjustedUp = false;
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        createPostTableView.register(UINib.init(nibName: "PostFormTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "PostFormTableViewCell");
        self.hideKeyboadOnTapOutside();
        
        loggedInUser =  User().loadUserDataFromUserDefaults(userDataDict : setting);
        self.social = SocialPlatform().loadSocialDataFromUserDefaults();
        //imageDelegate = Reusable()
        // Do any additional setup after loading the view.
        self.socialMediaPlatform = [Int]();
        social = SocialPlatform().loadSocialDataFromUserDefaults();
        self.getUserDetail();
        
        postImageDtos = [PostImageDto]();
        if (post != nil) {
            var index = 0;
            for imageStr in post.postImages {
                let postImageDto = PostImageDto();
                postImageDto.imageStr = imageStr;
                postImageDto.index = index;
                self.postImageDtos.append(postImageDto);
                index = index + 1;
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        let menuButton = UIButton();
        menuButton.setImage(UIImage.init(named: "menu"), for: .normal);
        menuButton.addTarget(self, action: #selector(menuButtonClicked), for: UIControlEvents.touchUpInside)
        menuButton.frame = CGRect.init(x: 0, y:0, width: 24, height: 24);
        
        let barButton = UIBarButtonItem(customView: menuButton)
        
        navigationItem.rightBarButtonItem = barButton;
        navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 12/255, green: 111/255, blue: 233/255, alpha: 1);

        self.tabBarController?.tabBar.isHidden = false;
        
        if (post != nil) {
            let backButton = UIButton();
            backButton.setImage(UIImage.init(named: "left-arrow"), for: .normal);
            backButton.addTarget(self, action: #selector(backButtonPressed), for: UIControlEvents.touchUpInside)
            backButton.frame = CGRect.init(x: 0, y:0, width: 20, height: 15);
            
            let barBackButton = UIBarButtonItem(customView: backButton)
            
            navigationItem.leftBarButtonItem = barBackButton;
            self.navigationItem.title = "Update Cast";
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func imageUploadClicked(){
        // create an actionSheet
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // create an action
        let uploadPhotoAction: UIAlertAction = UIAlertAction(title: "Upload Photo", style: .default) { action -> Void in
            //self.imageUploadClicked();
            self.selectMultipleImages();
        }
        //uploadPhotoAction.setValue(selectedColor, forKey: "titleTextColor")
        //let takePhotoAction: UIAlertAction = UIAlertAction(title: "Take Photo", style: .default) { action -> Void in
        //    self.imageDelegate.takePicture(viewC: self);
        //}
        //takePhotoAction.setValue(cenesLabelBlue, forKey: "titleTextColor")
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
        cancelAction.setValue(UIColor.black, forKey: "titleTextColor")
        
        actionSheetController.addAction(uploadPhotoAction)
        //actionSheetController.addAction(takePhotoAction)
        actionSheetController.addAction(cancelAction)
        
        // present an actionSheet...
        self.present(actionSheetController, animated: true, completion: nil)
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
            self.SelectedAssets = [PHAsset]();
            for i in 0..<assets.count
            {
                self.SelectedAssets.append(assets[i])
                
            }
            self.convertAssetToImages()
            
        }, completion: nil)
        
    }
    
    func convertAssetToImages() -> Void {
        self.PhotoArray = [UIImage]();
        if SelectedAssets.count != 0{
            
            for i in 0..<SelectedAssets.count{
                
                let manager = PHImageManager.default()
                let option = PHImageRequestOptions()
                option.isSynchronous = true
                option.isNetworkAccessAllowed = true

                var thumbnail = UIImage();
                
                manager.requestImage(for: SelectedAssets[i], targetSize: CGSize(width: 512, height: 512), contentMode: .aspectFill, options: option, resultHandler: {(result, info)->Void in
                    
                    //if (self.post != nil && self.post.postId != nil && self.post.postImages.count != 0) {
                    //    self.post.postImages = [String]();
                    //}
                    if(result != nil){
                        thumbnail = result!
                        
                        let data = UIImageJPEGRepresentation(thumbnail, 0.7)
                        let newImage = UIImage(data: data!)
                        
                        self.PhotoArray.append(newImage as! UIImage);
                        
                        let postImageDto = PostImageDto();
                        postImageDto.postImage = newImage as! UIImage;
                        self.postImageDtos.append(postImageDto);
                        
                        self.postFormCellProtocolDelegate.reloadCollctionView();
                    }else{
                        let message = "Error in Image loading..."
                        self.showAlert(title: "Error", message: message);
                    }
                })
                
            }
            
            //activityIndicator.stopAnimating();
            // self.imgView.animationImages = self.PhotoArray
            //self.imgView.animationDuration = 3.0
            //self.imgView.startAnimating()
            self.createPostTableView.reloadData()
        }
    }
    
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true);
    }
    @objc func menuButtonClicked() {
        let viewController: SideMenuTableViewController = self.storyboard?.instantiateViewController(withIdentifier: "SideMenuTableViewController") as! SideMenuTableViewController;
        viewController.sideMenuOpenedFromScreen = SideMenuSource.CREATE;
        self.navigationController?.pushViewController(viewController, animated: true);
    }
    func getUserDetail(){
        DispatchQueue.global(qos: .background).async {
            let jsonURL = "user/get_user_details/format/json";
            self.postArray["user_id"] = String(self.loggedInUser.userId)
            UserService().postDataMethod(jsonURL: jsonURL, postData: self.postArray, complete: {(response) in
                print(response);
                
                let status = Int(response.value(forKey: "status") as! String)!
                if (status == 0) {
                    let message = response.value(forKey: "message") as! String;
                    self.showAlert(title: "Error", message: message);
                    
                } else {
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
                }
            });
        }
    }
}

extension CreatePostViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: PostFormTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PostFormTableViewCell") as! PostFormTableViewCell;
        cell.createPostViewControllerDelegate = self;
        
        if (post != nil) {
            cell.postTextField.text = post.postDescription
            cell.charaterCountLabel.text = "\(post.postDescription.count) Characters";
            if (post.postImages.count > 0) {
                cell.filesUploadedtext.isHidden = false;
                cell.filesUploadedtext.text = "\(post.postImages.count) files uploaded successfully."
                cell.reloadCollctionView();
            }
            
            /*var facebookIconHidden = true;
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
            
            if (facebookIconHidden == false && twitterIconHidden == true) {
                //If twitter is not present then we will replace sourceImageTwitter image with facebook
                cell.activeFacebookIcon();
                cell.charaterCountLabel.isHidden = true;
                
            } else if (twitterIconHidden == false && facebookIconHidden == true) {
                cell.activeTwitterIcon();
                cell.charaterCountLabel.isHidden = false;

            } else if (facebookIconHidden == false  && twitterIconHidden == false) {
                cell.activeFacebookIcon();
                cell.activeTwitterIcon();
                cell.charaterCountLabel.isHidden = false;

            }*/
            for postStatus in postStatusList {
                if (postStatus.postStatusId == self.post.postStatusId) {
                    cell.changeStatusBtn.setTitle(postStatus.title, for: .normal);
                    cell.selectedPostStatusId = self.post.postStatusId
                    // Lets add ui labels in width.
                  //  let totalWidthOfUIView = cell.changeStatusBtn.intrinsicContentSize.width + 20;
                  //  cell.changeStatusBtn.frame = CGRect.init(x: (self.view.frame.width - totalWidthOfUIView - 15), y: cell.changeStatusBtn.frame.origin.y, width: totalWidthOfUIView, height: cell.changeStatusBtn.frame.height);
                    
                    break;
                }
            }
            
            
        }
        
        /*if (post == nil) {
            if (PhotoArray.count == 0) {
                
                cell.sendViewArea.frame = CGRect.init(x: cell.sendViewArea.frame.origin.x, y: (cell.sendViewArea.frame.origin.y - 100), width: cell.sendViewArea.frame.width, height: cell.sendViewArea.frame.height);
                cell.changeStatusBtn.frame = CGRect.init(x: cell.changeStatusBtn.frame.origin.x, y: (cell.changeStatusBtn.frame.origin.y - 100), width: cell.changeStatusBtn.frame.width, height: cell.changeStatusBtn.frame.height);
                cell.filesUploadedtext.frame = CGRect.init(x: cell.filesUploadedtext.frame.origin.x, y: (cell.filesUploadedtext.frame.origin.y - 100), width: cell.filesUploadedtext.frame.width, height: cell.filesUploadedtext.frame.height);
            } else {
                
                cell.sendViewArea.frame = CGRect.init(x: cell.sendViewArea.frame.origin.x, y: (cell.sendViewArea.frame.origin.y + 100), width: cell.sendViewArea.frame.width, height: cell.sendViewArea.frame.height);
                cell.changeStatusBtn.frame = CGRect.init(x: cell.changeStatusBtn.frame.origin.x, y: (cell.changeStatusBtn.frame.origin.y + 100), width: cell.changeStatusBtn.frame.width, height: cell.changeStatusBtn.frame.height);
                cell.filesUploadedtext.frame = CGRect.init(x: cell.filesUploadedtext.frame.origin.x, y: (cell.filesUploadedtext.frame.origin.y + 100), width: cell.filesUploadedtext.frame.width, height: cell.filesUploadedtext.frame.height);

            }
            
        } else {
            
            if (post != nil) {
                if (post.postImages.count > 0 || PhotoArray.count > 0) {
                
                    cell.sendViewArea.frame = CGRect.init(x: cell.sendViewArea.frame.origin.x, y: cell.sendViewArea.frame.origin.y, width: cell.sendViewArea.frame.width, height: cell.sendViewArea.frame.height);
                    cell.changeStatusBtn.frame = CGRect.init(x: cell.changeStatusBtn.frame.origin.x, y: cell.changeStatusBtn.frame.origin.y, width: cell.changeStatusBtn.frame.width, height: cell.changeStatusBtn.frame.height);
                    cell.filesUploadedtext.frame = CGRect.init(x: cell.filesUploadedtext.frame.origin.x, y: cell.filesUploadedtext.frame.origin.y, width: cell.filesUploadedtext.frame.width, height: cell.filesUploadedtext.frame.height);

                } else {
                    
                    cell.sendViewArea.frame = CGRect.init(x: cell.sendViewArea.frame.origin.x, y: (cell.sendViewArea.frame.origin.y + 100), width: cell.sendViewArea.frame.width, height: cell.sendViewArea.frame.height);
                    cell.changeStatusBtn.frame = CGRect.init(x: cell.changeStatusBtn.frame.origin.x, y: (cell.changeStatusBtn.frame.origin.y + 100), width: cell.changeStatusBtn.frame.width, height: cell.changeStatusBtn.frame.height);
                    cell.filesUploadedtext.frame = CGRect.init(x: cell.filesUploadedtext.frame.origin.x, y: (cell.filesUploadedtext.frame.origin.y + 100), width: cell.filesUploadedtext.frame.width, height: cell.filesUploadedtext.frame.height);

                }
            }
        }*/
            
        if (self.isSubmitAlreadyAdjustedUp == false && self.postImageDtos.count == 0) {
            cell.sendViewArea.frame = CGRect.init(x: cell.sendViewArea.frame.origin.x, y: (cell.sendViewArea.frame.origin.y - 100), width: cell.sendViewArea.frame.width, height: cell.sendViewArea.frame.height);
            cell.changeStatusBtn.frame = CGRect.init(x: cell.changeStatusBtn.frame.origin.x, y: (cell.changeStatusBtn.frame.origin.y - 100), width: cell.changeStatusBtn.frame.width, height: cell.changeStatusBtn.frame.height);
            cell.filesUploadedtext.frame = CGRect.init(x: cell.filesUploadedtext.frame.origin.x, y: (cell.filesUploadedtext.frame.origin.y - 100), width: cell.filesUploadedtext.frame.width, height: cell.filesUploadedtext.frame.height);
            self.isSubmitAlreadyAdjustedUp = true;
        } else {
            if (self.isSubmitAlreadyAdjustedUp == true) {
                cell.sendViewArea.frame = CGRect.init(x: cell.sendViewArea.frame.origin.x, y: (cell.sendViewArea.frame.origin.y + 100), width: cell.sendViewArea.frame.width, height: cell.sendViewArea.frame.height);
                cell.changeStatusBtn.frame = CGRect.init(x: cell.changeStatusBtn.frame.origin.x, y: (cell.changeStatusBtn.frame.origin.y + 100), width: cell.changeStatusBtn.frame.width, height: cell.changeStatusBtn.frame.height);
                cell.filesUploadedtext.frame = CGRect.init(x: cell.filesUploadedtext.frame.origin.x, y: (cell.filesUploadedtext.frame.origin.y + 100), width: cell.filesUploadedtext.frame.width, height: cell.filesUploadedtext.frame.height);
                self.isSubmitAlreadyAdjustedUp = false
            }
        }

        DispatchQueue.main.async {
            //self.showToast(message: "\(self.SelectedAssets.count) Images Uploaded")
            self.postFormCellProtocolDelegate.upadedSelectedImageCounts(counts: "\(self.postImageDtos.count)");
        }
            
        activityIndicator.center = view.center;
        activityIndicator.hidesWhenStopped = true;
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray;
        cell.addSubview(activityIndicator);
        
        postFormCellProtocolDelegate = cell;
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (self.view.frame.height - ((self.tabBarController?.tabBar.frame.height)! + (self.navigationController?.navigationBar.frame.height)!)) + 40;
    }
}
