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
    @IBOutlet weak var communicationTableView: UITableView!
    @IBOutlet weak var postTextField: UITextView!
    
    @IBOutlet weak var editPostBtn: UIButton!
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
    var facebookAPI = false
    var twitterAPI = false
    var SelectedAssets = [PHAsset]()
    var PhotoArray = [UIImage]()
    var postStatus : Int = 0
    var postArray : [String:Any] = [String:Any]()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView();
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.editPostBtn.semanticContentAttribute = UIApplication.shared
            .userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft; communicationTableView.register(UINib.init(nibName: "LeftCommunicationTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "LeftCommunicationTableViewCell");
          communicationTableView.register(UINib.init(nibName: "RightCommunicationTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "RightCommunicationTableViewCell");
         communicationTableView.register(UINib.init(nibName: "HomeTextPostTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "HomeTextPostTableViewCell");
        // Do any additional setup after loading the view.
        self.pendingBtn.roundBtn()
        self.approvedBtn.roundBtn()
        self.rejectedBtn.roundBtn()
        self.underReviewBtn.roundBtn()
        
        
        self.pendingBtn.radioBtnDefault();
        self.approvedBtn.radioBtnDefault();
        self.rejectedBtn.radioBtnDefault();
        self.underReviewBtn.radioBtnDefault();
        self.twitterBtn.layer.borderWidth = 1
        self.facebookBtn.layer.borderWidth = 1
        self.twitterBtn.layer.borderColor = UIColor(red: 12/255, green: 111/255, blue: 233/255, alpha: 1).cgColor
        self.facebookBtn.layer.borderColor = UIColor(red: 12/255, green: 111/255, blue: 233/255, alpha: 1).cgColor
        self.postTextField.layer.borderWidth = 1
        self.postTextField.layer.borderColor = UIColor(red: 112/255, green: 112/255, blue: 112/255, alpha: 1).cgColor
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

    
    
    @IBAction func submitBtnClicked(_ sender: Any) {
        
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
        actionSheetController.addAction(takePhotoAction)
        actionSheetController.addAction(cancelAction)
        
        // present an actionSheet...
        present(actionSheetController, animated: true, completion: nil)
    }
    @IBAction func multipleButtonClicked(_ sender: AnyObject) {
        
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
    func loadModeratorCasterUserPosts() {
        social = SocialPlatform().loadSocialDataFromUserDefaults();
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
}

extension CommunicationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell : RightCommunicationTableViewCell = tableView.dequeueReusableCell(withIdentifier: "RightCommunicationTableViewCell") as! RightCommunicationTableViewCell;
        let cell: LeftCommunicationTableViewCell = tableView.dequeueReusableCell(withIdentifier: "LeftCommunicationTableViewCell") as! LeftCommunicationTableViewCell;
        
        cell.communicationViewControllerDelegate = self;
        
        activityIndicator.center = cell.center;
        activityIndicator.hidesWhenStopped = true;
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge;
        cell.addSubview(activityIndicator);
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (self.view.frame.height + 120);
    }
}

