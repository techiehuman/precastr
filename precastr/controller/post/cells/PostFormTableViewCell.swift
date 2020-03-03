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
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    var createPostViewControllerDelegate: CreatePostViewController!;
    var descriptionMsg : String = "";
    var selectedPostStatusId : Int = 0;
    var loggedInUser : User!
    var textPlaceholder : String = "Type your post here and attach any files using the icon below";
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
        self.postTextField.autocorrectionType = .yes
        self.attachmentBtn.roundEdgesLeftBtn();
        self.attachmentBtn.backgroundColor = PrecasterColors.darkBlueButtonColor;
        self.submitBtn.roundEdgesRightBtn();
        self.submitBtn.backgroundColor = PrecasterColors.themeColor;
         loggedInUser =  User().loadUserDataFromUserDefaults(userDataDict : setting);
        addDoneButtonOnKeyboard();
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("A")
        print(self.postTextField.textColor!)
        if (/*self.postTextField.textColor == UIColor(red: 118/255, green: 118/255, blue: 119/255, alpha: 1) && */ self.postTextField.text == self.textPlaceholder) {
            print("C")
            self.postTextField.text = ""
            self.postTextField.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        print("B")
        if self.postTextField.text == "" {
            self.postTextField.text = textPlaceholder
            self.postTextField.textColor = UIColor(red: 118/255, green: 118/255, blue: 119/255, alpha: 1);
        }
    }
    
    
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
                postData["timestamp"] = Int64(Date().timeIntervalSince1970 * 1000.0);

                if (loggedInUser.isCastr == 2) {
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
                    
                    if (imagesStr != "") {
                        //This is neeeded if we are updating and we have alreay image urls.
                        postData["old_image_path"] = imagesStr.prefix(imagesStr.count-1);
                    }
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
                        UIApplication.shared.keyWindow?.rootViewController = HomeV2ViewController.MainViewController();
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
                        UIApplication.shared.keyWindow?.rootViewController = HomeV2ViewController.MainViewController();
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
                postData["timestamp"] = Int64(Date().timeIntervalSince1970 * 1000.0);
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
                        UIApplication.shared.keyWindow?.rootViewController = HomeV2ViewController.MainViewController();
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
                        UIApplication.shared.keyWindow?.rootViewController = HomeV2ViewController.MainViewController();
                    }
                    })
                }
            }
            }
        
            
    }
    
    func validateSocialPlatform()->Bool{
        if(self.postTextField.text == "" ){
            let message = "Text field is empty"
            let alert = UIAlertController.init(title: "Error", message: message, preferredStyle: .alert);
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil));
            self.createPostViewControllerDelegate.present(alert, animated: true)
            return false
        }
        
        return true
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
        
        if (createPostViewControllerDelegate.post != nil && createPostViewControllerDelegate.post.postId != nil) {
            cell.crossIconImage.image = UIImage.init(named: "remove_icon_red")
        } else {
            cell.crossIconImage.image = UIImage.init(named: "remove_icon_green")
        }
        var deleteButtonTapGestureReco = DeleteIconGestureRecognizer.init(target: self, action: #selector(deleteFromList(sender:)));
        deleteButtonTapGestureReco.index = indexPath.row;
        cell.crossIconImage.addGestureRecognizer(deleteButtonTapGestureReco);
        
        return cell;
    }
    
    
    
}
