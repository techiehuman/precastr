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

        self.loggedInUser = User().loadUserDataFromUserDefaults(userDataDict: setting);
        
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
        self.twitterBtn.layer.borderWidth = 1
        self.facebookBtn.layer.borderWidth = 1
        self.twitterBtn.layer.borderColor = UIColor(red: 12/255, green: 111/255, blue: 233/255, alpha: 1).cgColor
        self.facebookBtn.layer.borderColor = UIColor(red: 12/255, green: 111/255, blue: 233/255, alpha: 1).cgColor
        
        self.textArea.layer.borderWidth = 1
        self.textArea.layer.borderColor = UIColor(red: 112/255, green: 112/255, blue: 112/255, alpha: 1).cgColor
        
        
        self.getPostCommunications();
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
        
        if(textArea.text != ""){
            
            
            self.activityIndicator.startAnimating();
            
            let jsonURL = "\(ApiUrl)posts/add_post_communication/format/json"
            var postData : [String : Any] = [String : Any]()
            postData["post_communication_description"] = self.textArea.text
            postData["post_id"] = self.post.postId;
            postData["user_id"] = self.loggedInUser.userId;
            HttpService().postMethod(url: jsonURL, postData: postData, complete: {(response) in
                
                print(response);
                
                self.activityIndicator.stopAnimating();
                    //Load latest Communications
                self.getPostCommunications();
                self.textArea.text = "";
            });
            
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
        actionSheetController.addAction(takePhotoAction)
        actionSheetController.addAction(cancelAction)
        
        // present an actionSheet...
        present(actionSheetController, animated: true, completion: nil)
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
            
            let status = Int(response.value(forKey: "status") as! String);
            let message = response.value(forKey: "message") as! String;
            //let status =  response.value(forKey: "status") as? Bool ?? false
            if status == 0 {
                self.showAlert(title: "Error", message: message);
            } else {
                print("sala bhen da")
                print(response)
                let data = response.value(forKey: "data") as! NSDictionary;
                let postCommArr = data.value(forKey: "postcommunication") as! NSArray;
                
                self.post.postCommunications = PostCommunication().loadCommunicationsFromNsArray(commArray: postCommArr);
                self.communicationTableView.reloadData();
            }
        });
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
                
                /*for sourcePlatformId in post.socialMediaIds {
                    if(Int(sourcePlatformId) == social.socialPlatformId["Facebook"]){
                        facebookIconHidden = false;
                    }  else if(Int(sourcePlatformId) == social.socialPlatformId["Twitter"]) {
                        twitterIconHidden = false;
                    }
                }*/
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
            if(post.status == "Pending"){
                imageStatus = "pending-review"
                status = "Pending review"
            }else if(post.status == "Approved by moderator"){
                imageStatus = "approved"
                status = "Approved"
            }else if (post.status == "Rejected by moderator"){
                imageStatus = "rejected"
                status = "Rejected"
            }else if(post.status == "Pending with caster"){
                imageStatus = "under-review"
                status = "Under review"
            }
            else if(post.status == "Pending with moderator"){
                imageStatus = "under-review"
                status = "Under review"
            }        else if(status == ""){
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
            
            if (height > 100) {
                proNameLbl.numberOfLines = 4
            } else {
                proNameLbl.numberOfLines = 0
            }
            
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
                
                var heightOfDesc = 0;
                if (height > 100) {
                    heightOfDesc = 100;
                } else {
                    heightOfDesc = Int(height);
                }
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
                    
                    //cell.commentedDate.text = Date().ddspEEEEcmyyyyspHHclmmclaa(dateStr: communication.commentedOn);
                    cell.commentorPic.sd_setImage(with: URL.init(string: communication.communicatedProfilePic), placeholderImage: UIImage.init(named: "Profile-1"));
                    
                    
                    //Call this function
                    let height = heightForView(text: post.postDescription, font: UIFont.init(name: "VisbyCF-Regular", size: 16.0)!, width: cell.descriptionView.frame.width - 10)
                    
                    //This is your label
                    for view in cell.descriptionView.subviews {
                        view.removeFromSuperview();
                    }
                    let proNameLbl = UILabel(frame: CGRect(x: 0, y: 10, width: cell.descriptionView.frame.width - 10, height: height))
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
                    
                    return cell;
                    
                } else {
                    
                    
                    let cell: RightCommunicationTableViewCell = tableView.dequeueReusableCell(withIdentifier: "RightCommunicationTableViewCell") as! RightCommunicationTableViewCell;
                    cell.commentedDate.text = Date().ddspEEEEcmyyyyspHHclmmclaa(dateStr: communication.commentedOn);

                    return cell;
                }
                
                
            //}
            
        }
        
        return UITableViewCell();
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (indexPath.row == 0) {
            return 300;
        } else {
            
            let height = heightForView(text: post.postDescription, font: UIFont.init(name: "VisbyCF-Regular", size: 16.0)!, width: tableView.frame.width - 60)
            
            return height + 40;
        }
    }
}

