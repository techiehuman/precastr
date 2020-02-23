//
//  PostItemTableViewCell.swift
//  precastr
//
//  Created by Cenes_Dev on 16/02/2020.
//  Copyright © 2020 Macbook. All rights reserved.
//

import UIKit
import MessageUI
import FBSDKCoreKit
import FBSDKLoginKit
import FacebookShare
import FBSDKCoreKit

class PostItemTableViewCell: UITableViewCell, SharingDelegate, MFMessageComposeViewControllerDelegate, PostItemTableViewDelegate {

    @IBOutlet weak var postItemsTableView: UITableView!
    var pushViewController: UIViewController!;
    var post: Post!;
    var postRowIndex: Int!;
    var totalPosts: Int!;
    var isShareMenuOpened: Bool = false;
    var shareButtonGlobal: UIButton!;
    var isDescriptionFullView: Bool = false;
    var parentTableIndexPath: IndexPath!;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Do any additional setup after loading the view.
        postItemsTableView.register(UINib(nibName: "CasterPostStatusTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "CasterPostStatusTableViewCell");
        postItemsTableView.register(UINib(nibName: "BeforeApprovedButtonsTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "BeforeApprovedButtonsTableViewCell");
        postItemsTableView.register(UINib(nibName: "AfterApprovedButtonsTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "AfterApprovedButtonsTableViewCell");
        postItemsTableView.register(UINib(nibName: "PostDescriptionTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "PostDescriptionTableViewCell");
        postItemsTableView.register(UINib(nibName: "PostGalleryTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "PostGalleryTableViewCell");
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func postDescriptionPressed(sender: MyTapRecognizer){
    
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CommunicationViewController") as! CommunicationViewController;
        viewController.post = sender.post;
         pushViewController.navigationController?.pushViewController(viewController, animated: true);
    }
    
    @objc func editPostButtonPressed(sender: MyTapRecognizer){
        
        (pushViewController as! CommunicationViewController).editButtonPressed(post: sender.post);

    }
    
    @objc func deleteButtonPressed(sender: MyTapRecognizer){
        if (pushViewController is HomeV2ViewController) {
            (pushViewController as! HomeV2ViewController).deleteButtonPresses(post: sender.post);
        }
    }
    
    @objc func shareIconPressed(sender: MyTapRecognizer){
        shareButtonGlobal = sender.uiButton;
        createPublishPostMenu(post: sender.post);
        //postItemsTableView.reloadData();
    }
    
    @objc func callInfoButtonPressed(sender: MyTapRecognizer) {
        let post = sender.post;
        let viewController =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CastContactsViewController") as! CastContactsViewController;
        
        var contacts = [User]();
        for userP in post!.castModerators {
            if (userP.phoneNumber != "" && userP.phoneNumber != nil) {
                contacts.append(userP);
            }
        }
        viewController.castContacts = contacts;
        viewController.post = post;
        viewController.castContactListType = CastContactListType.CallList;
        pushViewController.navigationController!.pushViewController(viewController, animated: true);
    }
    
    @objc func moderatorIconButtonPressed(sender: MyTapRecognizer) {
        let post = sender.post;
        let viewController =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CastContactsViewController") as! CastContactsViewController;
        
        var contacts = [User]();
        for userP in post!.castModerators {
                contacts.append(userP);
        }
        viewController.castContacts = contacts;
        viewController.post = post;
        viewController.castContactListType = CastContactListType.ModeratorList;
        pushViewController.navigationController!.pushViewController(viewController, animated: true);
    }
    
    func populateCasterTopView(cell: CasterPostStatusTableViewCell) {
    
        cell.viewDetailsBtn.layer.cornerRadius = 4;
        cell.viewDetailsBtn.backgroundColor = blueLinkColor;
        
        //Setting Date of Post
        cell.postDateLbl.text = Date().ddspEEEEcmyyyy(dateStr: post.createdOn);
        cell.postDateLbl.frame = CGRect.init(x: (self.contentView.frame.width -  cell.postDateLbl.intrinsicContentSize.width - 15), y: cell.postDateLbl.frame.origin.y, width: cell.postDateLbl.intrinsicContentSize.width, height: cell.postDateLbl.frame.height);
        
        //Setting Status of Post
        var status = "";
        for postStatus in postStatusList {
            if (postStatus.postStatusId == post.postStatusId) {
                status = postStatus.title;
                break;
            }
        }
        
        let pipe = " |"
        cell.postStatusLbl.text = "\((status))\(pipe)"
        cell.postStatusLbl.frame = CGRect.init(x: cell.postDateLbl.frame.origin.x - (cell.postStatusLbl.intrinsicContentSize.width + 5), y: cell.postStatusLbl.frame.origin.y, width: cell.postStatusLbl.intrinsicContentSize.width, height: cell.postStatusLbl.frame.height);
        
        //Setting Status Image of Post
        var imageStatus = "";
        if (pushViewController is HomeV2ViewController) {
            imageStatus = (pushViewController as! HomeV2ViewController).adapterCasterGetPostStatusImage(status: status);
        } else if (pushViewController is CommunicationViewController) {
           imageStatus = (pushViewController as! CommunicationViewController).adapterCasterGetPostStatusImage(status: status);
       } else if (pushViewController is ArchieveViewController) {
            imageStatus = (pushViewController as! ArchieveViewController).adapterCasterGetPostStatusImage(status: status);
        }
        cell.postStatusImg.image = UIImage.init(named: imageStatus)
        cell.postStatusImg.frame = CGRect.init(x: cell.postStatusLbl.frame.origin.x - ( cell.postStatusImg.frame.width + 10), y: cell.postStatusImg.frame.origin.y, width: cell.postStatusImg.frame.width, height: cell.postStatusImg.frame.height)
        
        
        if (pushViewController is CommunicationViewController) {
            if (status == "Published") {
                cell.viewDetailsBtn.isHidden = true;
            } else {
                cell.viewDetailsBtn.setTitle("Edit Post", for: .normal);
                cell.viewDetailsBtn.setImage(UIImage.init(named: "pencil"), for: .normal);
                cell.viewDetailsBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
                cell.viewDetailsBtn.backgroundColor = PrecasterColors.themeColor;
                
                let editButtonTapRecognizer = MyTapRecognizer.init(target: self, action: #selector(editPostButtonPressed(sender:)));
                       editButtonTapRecognizer.post = post;
                cell.viewDetailsBtn.addGestureRecognizer(editButtonTapRecognizer);
            }
        } else {
            let editButtonTapRecognizer = MyTapRecognizer.init(target: self, action: #selector(postDescriptionPressed(sender:)));
                   editButtonTapRecognizer.post = post;
            cell.viewDetailsBtn.addGestureRecognizer(editButtonTapRecognizer);

        }
    }
    
    func populateCastActionsCell(indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        //Setting Status of Post
        var status = "";
        for postStatus in postStatusList {
            if (postStatus.postStatusId == post.postStatusId) {
                status = postStatus.title;
                break;
            }
        }
        
        if (status == "Pending") {
            
            let cell: BeforeApprovedButtonsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "BeforeApprovedButtonsTableViewCell", for: indexPath) as! BeforeApprovedButtonsTableViewCell;
            
            let deleteButtonTapRecognizer = MyTapRecognizer.init(target: self, action: #selector(deleteButtonPressed(sender:)));
            deleteButtonTapRecognizer.post = post;
            cell.deleteBtn.addGestureRecognizer(deleteButtonTapRecognizer);
            
            let callButtonTapRecognizer = MyTapRecognizer.init(target: self, action: #selector(callInfoButtonPressed(sender:)));
                       callButtonTapRecognizer.post = post;
            cell.callButtonBtn.addGestureRecognizer(callButtonTapRecognizer);
            return cell;
            
        } else {
            
            let cell: AfterApprovedButtonsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AfterApprovedButtonsTableViewCell", for: indexPath) as! AfterApprovedButtonsTableViewCell;

            var postModeratorsButtonVisible: Bool = false;
            if (pushViewController is HomeV2ViewController) {
                
                cell.postModeratorsBtn.isHidden = true;
                postModeratorsButtonVisible = false;

            } else if (pushViewController is CommunicationViewController) {
                
                //Post Moderators Icon Stuff
                cell.postModeratorsBtn.isHidden = false;
                cell.postModeratorsBtn.frame = CGRect.init(x: 12, y: cell.postModeratorsBtn.frame.origin.y, width: cell.postModeratorsBtn.frame.width, height: cell.postModeratorsBtn.frame.height);
                
                let postModeratorTapRecognizer = MyTapRecognizer.init(target: self, action: #selector(moderatorIconButtonPressed(sender:)));
                           postModeratorTapRecognizer.post = post;
                cell.postModeratorsBtn.addGestureRecognizer(postModeratorTapRecognizer);
                
                postModeratorsButtonVisible = true;
            }
    
            let gapBetweenButtons: CGFloat = 23;
            let buttonsHeightWidth: CGFloat = 30;
            
            var deleteButtonVisible = true;
            if (status == "Published") {
                deleteButtonVisible = false;
                cell.deleteBtn.isHidden = true;
            }
            
            if (deleteButtonVisible == true) {
                //If post is published we will hide delete button
                let deleteButtonTapRecognizer = MyTapRecognizer.init(target: self, action: #selector(deleteButtonPressed(sender:)));
                deleteButtonTapRecognizer.post = post;
                

                if (postModeratorsButtonVisible == true) {
                
                    let newXCord: CGFloat = (cell.postModeratorsBtn.frame.origin.x + cell.postModeratorsBtn.frame.width + gapBetweenButtons);
                    
                    cell.deleteBtn.frame = CGRect.init(x: newXCord, y: cell.deleteBtn.frame.origin.y, width: buttonsHeightWidth, height: buttonsHeightWidth);
                } else {
                    cell.deleteBtn.frame = CGRect.init(x: 12, y: cell.deleteBtn.frame.origin.y, width: buttonsHeightWidth, height: buttonsHeightWidth);
                }
                cell.deleteBtn.addGestureRecognizer(deleteButtonTapRecognizer);
            }
            
            let callButtonTapRecognizer = MyTapRecognizer.init(target: self, action: #selector(callInfoButtonPressed(sender:)));
                       callButtonTapRecognizer.post = post;
            cell.callButtonBtn.addGestureRecognizer(callButtonTapRecognizer);
            
            //Lets set cordinate of Call Button
            if (deleteButtonVisible) {
                cell.callButtonBtn.frame = CGRect.init(x: (cell.deleteBtn.frame.origin.x + buttonsHeightWidth + gapBetweenButtons), y: cell.callButtonBtn.frame.origin.y, width: buttonsHeightWidth, height: buttonsHeightWidth);
            } else if (postModeratorsButtonVisible == true) {
                let newXCord: CGFloat = (cell.postModeratorsBtn.frame.origin.x + cell.postModeratorsBtn.frame.width + gapBetweenButtons);
                
                cell.callButtonBtn.frame = CGRect.init(x: newXCord, y: cell.callButtonBtn.frame.origin.y, width: buttonsHeightWidth, height: buttonsHeightWidth);
            } else {
                cell.callButtonBtn.frame = CGRect.init(x: 12, y: cell.callButtonBtn.frame.origin.y, width: buttonsHeightWidth, height: buttonsHeightWidth);
            }
        
            cell.facebookInfoBtn.frame = CGRect.init(x: (cell.callButtonBtn.frame.origin.x + buttonsHeightWidth + gapBetweenButtons), y: cell.facebookInfoBtn.frame.origin.y, width: buttonsHeightWidth, height: buttonsHeightWidth);
            
            let shareButtonTapRecognizer = MyTapRecognizer.init(target: self, action: #selector(shareIconPressed(sender:)));
            shareButtonTapRecognizer.post = post;
            shareButtonTapRecognizer.uiButton = cell.sharePostBtn;
            cell.sharePostBtn.addGestureRecognizer(shareButtonTapRecognizer);
            
            cell.viewController = pushViewController;
            return cell;
        }
        
        return UITableViewCell();
    }
    
    func createPublishPostMenu(post: Post) {
        
        if (isShareMenuOpened == true) {
            isShareMenuOpened = false;
            if (self.pushViewController is HomeV2ViewController) {
                (self.pushViewController as! HomeV2ViewController).postsTableView.isScrollEnabled = true;
            }
            for view in self.pushViewController.view.subviews {
                if (view is PostCastMenu) {
                    view.removeFromSuperview();
                }
            }
            return;
        }
        
        let postToFacebookTapGesture = PostToSocialMediaGestureRecognizer.init(target: self, action: #selector(postToFacebookPressed(sender:)));
        postToFacebookTapGesture.post = post;
        
        let postToTwitterTapGesture = PostToSocialMediaGestureRecognizer.init(target: self, action: #selector(postToTwitterPressed(sender:)));
           postToTwitterTapGesture.post = post;
           
        let postToSMSTapGesture = PostToSocialMediaGestureRecognizer.init(target: self, action: #selector(postToSMSPressed(sender:)));
           postToSMSTapGesture.post = post;
        
        let postCastMenu: PostCastMenu = PostCastMenu.instanceFromNib() as! PostCastMenu;
        
        let buttonAbsoluteFrame = shareButtonGlobal.convert(shareButtonGlobal.bounds, to: self.pushViewController.view)

        postCastMenu.frame = CGRect.init(x: buttonAbsoluteFrame.origin.x - 60, y: buttonAbsoluteFrame.origin.y + 30, width: 80, height: 150)
        postCastMenu.facebookItem.addGestureRecognizer(postToFacebookTapGesture);
        postCastMenu.twitterItem.addGestureRecognizer(postToTwitterTapGesture);
        postCastMenu.messageItem.addGestureRecognizer(postToSMSTapGesture);
        
        if (post.postStatusId == HomePostPublishStatusId.PUBLISHSTATUSID) {
            
            var facebookPublished = false;
            for socialMediaId in post.socialMediaIds {
                if (socialMediaId == social.socialPlatformId["Facebook"]) {
                    facebookPublished = true;
                    break;
                }else{
                    facebookPublished = false;
                }
            }
            
            var twitterPublished = false;
            for socialMediaId in post.socialMediaIds {
                if (socialMediaId == social.socialPlatformId["Twitter"]) {
                    twitterPublished = true;
                    break;
                }else{
                    twitterPublished = false;
                }
            }

            var smsPublished = false;
            for socialMediaId in post.socialMediaIds {
                if (socialMediaId == social.socialPlatformId["SMS"]) {
                    smsPublished = true;
                    break;
                }else{
                    smsPublished = false;
                }
            }
            
            if (facebookPublished == true) {
                postCastMenu.facebookChecked.isHidden = false;
            } else {
                postCastMenu.facebookChecked.isHidden = true;
            }
            
            if (twitterPublished == true) {
                postCastMenu.twitterChecked.isHidden = false;
            } else {
                postCastMenu.twitterChecked.isHidden = true;
            }
            
            if (smsPublished == true) {
                postCastMenu.messageChecked.isHidden = false;
            } else {
                postCastMenu.messageChecked.isHidden = true;
            }
        }
        self.pushViewController.view.addSubview(postCastMenu);
        isShareMenuOpened = true;
        if (self.pushViewController is HomeV2ViewController) {
            (self.pushViewController as! HomeV2ViewController).postsTableView.isScrollEnabled = false;
        }
    }
    
    @objc func postToSMSPressed(sender: PostToSocialMediaGestureRecognizer) {
        let viewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ContactsViewController") as! ContactsViewController;
        viewController.requestFrom = ContactsViewController.ContactsViewRequestFrom.PostMenuRequest;
        viewController.postItemTableViewDelegate = self;
        //viewController.moderatorViewControllerDelegte = self;
        self.pushViewController.navigationController?.pushViewController(viewController, animated: true);

        /*let post = sender.post;
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
            self.pushViewController.present(controller, animated: true, completion: nil)
        }*/
    }
    
    //This method will be called. when user pushlish on twitter.
    @objc func postToTwitterPressed(sender: PostToSocialMediaGestureRecognizer) {
        
        //self.activityIndicator.startAnimating();
        PostManager().publishPostOnTwitter(post: sender.post, complete: {(response) in
            //self.activityIndicator.stopAnimating();
            
            let statusCode = Int(response.value(forKey: "status") as! String)!
            if(statusCode == 0) {
                self.pushViewController.showAlert(title: "Alert", message: response.value(forKey: "message") as! String);
            } else {
                if (self.pushViewController is HomeV2ViewController) {
                    (self.pushViewController as! HomeV2ViewController).loadUserPosts();
                }
            }
        });
    }
    
    @objc func postToFacebookPressed(sender: PostToSocialMediaGestureRecognizer) {
        
        print(sender.post.postDescription);
        
        DispatchQueue.main.async {
            if (self.pushViewController is HomeV2ViewController) {
                (self.pushViewController as! HomeV2ViewController).activityIndicator.startAnimating();
            } else if (self.pushViewController is CommunicationViewController) {
                (self.pushViewController as! CommunicationViewController).activityIndicator.startAnimating();
            }
        }
        
        if (sender.post.postDescription != "") {
            
            if (sender.post.postImages.count == 0) {
                
                let content = ShareLinkContent();
                content.quote = post.postDescription;
                content.contentURL = URL.init(string: "http://precastr.com")!;
                let shareDialog = ShareDialog()
                shareDialog.shareContent = content;
                
                var fbInstalled = false;
                if (pushViewController is HomeV2ViewController) {
                    (pushViewController as! HomeV2ViewController).schemeAvailable(scheme: "fb://");
                } else if (pushViewController is CommunicationViewController) {
                    (pushViewController as! HomeV2ViewController).schemeAvailable(scheme: "fb://");
                } else if (pushViewController is ArchieveViewController) {
                    (pushViewController as! ArchieveViewController).schemeAvailable(scheme: "fb://");
                }
                    
                
                if (fbInstalled) {
                    shareDialog.mode = .automatic;
                } else {
                    shareDialog.mode = .native;
                }
                if (pushViewController is HomeV2ViewController) {
                       shareDialog.fromViewController = pushViewController as! HomeV2ViewController;
                   } else if (pushViewController is CommunicationViewController) {
                       shareDialog.fromViewController = pushViewController as! CommunicationViewController;
                   } else if (pushViewController is ArchieveViewController) {
                       shareDialog.fromViewController = pushViewController as! ArchieveViewController;
                   }
                
                
                shareDialog.delegate = self;
                shareDialog.shouldFailOnDataError = true;
                if (shareDialog.canShow == false) {
                    //self.showAlert(title: "Alert", message: "Please install Facebook App");
                    if (pushViewController is HomeV2ViewController) {
                        (pushViewController as! HomeV2ViewController).showFacebookFailAlert();
                    } else if (pushViewController is CommunicationViewController) {
                        (pushViewController as! HomeV2ViewController).showFacebookFailAlert();
                    } else if (pushViewController is ArchieveViewController) {
                        (pushViewController as! ArchieveViewController).showFacebookFailAlert();
                    }
                } else {
                    shareDialog.show();
                }
                
            } else {
                
                //self.showToast(message: "Text Copied to clipboard");
                UIPasteboard.general.string = "\(post.postDescription)";
                
                let sharePhotoContent = SharePhotoContent();
                for photoStr in sender.post.postImages {
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
                if (pushViewController is HomeV2ViewController) {
                    shareDialog.fromViewController = pushViewController as! HomeV2ViewController;
                } else if (pushViewController is CommunicationViewController) {
                    shareDialog.fromViewController = pushViewController as! CommunicationViewController;
                } else if (pushViewController is ArchieveViewController) {
                    shareDialog.fromViewController = pushViewController as! ArchieveViewController;
                }
                shareDialog.delegate = self;
                shareDialog.shouldFailOnDataError = true;
                if (shareDialog.canShow == false) {
                    if (pushViewController is HomeV2ViewController) {
                        (pushViewController as! HomeV2ViewController).showFacebookFailAlert();
                    } else if (pushViewController is CommunicationViewController) {
                        (pushViewController as! HomeV2ViewController).showFacebookFailAlert();
                    } else if (pushViewController is ArchieveViewController) {
                        (pushViewController as! ArchieveViewController).showFacebookFailAlert();
                    }                } else {
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
            
            //self.activityIndicator.stopAnimating();
            let shareDialog = ShareDialog()
            shareDialog.shareContent = sharePhotoContent;
            shareDialog.mode = .automatic;
            if (pushViewController is HomeV2ViewController) {
                shareDialog.fromViewController = pushViewController as! HomeV2ViewController;
            } else if (pushViewController is CommunicationViewController) {
                shareDialog.fromViewController = pushViewController as! CommunicationViewController;
            } else if (pushViewController is ArchieveViewController) {
                shareDialog.fromViewController = pushViewController as! ArchieveViewController;
            }
            shareDialog.delegate = self;
            shareDialog.shouldFailOnDataError = true;
            if (shareDialog.canShow == false) {
                if (pushViewController is HomeV2ViewController) {
                    (pushViewController as! HomeV2ViewController).showFacebookFailAlert();
                } else if (pushViewController is CommunicationViewController) {
                    (pushViewController as! HomeV2ViewController).showFacebookFailAlert();
                } else if (pushViewController is ArchieveViewController) {
                    (pushViewController as! ArchieveViewController).showFacebookFailAlert();
                }
                
            } else {
                shareDialog.show();
            }
        }
    }
    
    //This method will be called when user post feed on facebook.
    func sharer(_ sharer: Sharing, didCompleteWithResults results: [String : Any]) {
        
        print("Response from facebook..")
        //self.activityIndicator.startAnimating();
        PostManager().publishOnFacebook(post: post, complete: {(response) in
            print(response);
            //self.activityIndicator.stopAnimating();
            let statusCode = Int(response.value(forKey: "status") as! String)!
            if(statusCode == 0) {
                self.pushViewController.showAlert(title: "Alert", message: response.value(forKey: "message") as! String);
            } else {
                if (self.pushViewController is HomeV2ViewController) {
                    (self.pushViewController as! HomeV2ViewController).loadUserPosts();
                }
            }
        });
    }
    
    func sharer(_ sharer: Sharing, didFailWithError error: Error) {
        print("Fail")
        //self.activityIndicator.stopAnimating();
        if (pushViewController is HomeV2ViewController) {
            (pushViewController as! HomeV2ViewController).showFacebookFailAlert();
        } else if (pushViewController is CommunicationViewController) {
            (pushViewController as! HomeV2ViewController).showFacebookFailAlert();
        } else if (pushViewController is ArchieveViewController) {
            (pushViewController as! ArchieveViewController).showFacebookFailAlert();
        }
    }
    
    func sharerDidCancel(_ sharer: Sharing) {
        print("Cancel")
    }
    
    func onSelectingContacts(userContacts: [UserContactItem]) {
        
           var phoneNumbers = [String]();
           for userContact in userContacts {
                print(userContact.phone!)
                phoneNumbers.append("\(userContact.phone!)");
           }
           if (MFMessageComposeViewController.canSendText()) {
               let controller = MFMessageComposeViewController()
               controller.recipients = phoneNumbers
               controller.body = post?.postDescription;
               controller.messageComposeDelegate = self
               self.pushViewController.present(controller, animated: true, completion: nil)
           }
    }
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
        var loggedInUser: User!;
        if (pushViewController is HomeV2ViewController) {
            loggedInUser = (pushViewController as! HomeV2ViewController).loggedInUser;
        } else if (pushViewController is CommunicationViewController) {
            loggedInUser = (pushViewController as! CommunicationViewController).loggedInUser;
        }
            
           switch (result)
           {
           case .sent:
               print("sms sent.")
               var postData = [String: Any]();
               postData["user_id"] = loggedInUser.userId
               postData["post_id"] = post.postId
               postData["timestamp"] = Date().timeIntervalMilliSeconds();
               let jsonURL = "posts/send_post_sms/format/json";
               UserService().postDataMethod(jsonURL: jsonURL,postData:postData,complete:{(response) in
                   //self.activityIndicator.stopAnimating();
                   
                   let statusCode = Int(response.value(forKey: "status") as! String)!
                   if(statusCode == 0) {
                    self.pushViewController.showAlert(title: "Alert", message: response.value(forKey: "message") as! String);
                   } else {
                        if (self.pushViewController is HomeV2ViewController) {
                            (self.pushViewController as! HomeV2ViewController).loadUserPosts();
                        }
                    if (self.isShareMenuOpened == true) {
                        self.isShareMenuOpened = false;
                            if (self.pushViewController is HomeV2ViewController) {
                                (self.pushViewController as! HomeV2ViewController).postsTableView.isScrollEnabled = true;
                            }
                            for view in self.pushViewController.view.subviews {
                                if (view is PostCastMenu) {
                                    view.removeFromSuperview();
                                    
                                }
                            }
                        self.createPublishPostMenu(post: self.post);
                        }
                        
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
        self.pushViewController.dismiss(animated: true, completion: nil)
       }
    
    func contentChanged() {
        //(pushViewController as! HomeV2ViewController).postsTableView.beginUpdates();
        //(pushViewController as! HomeV2ViewController).postsTableView.endUpdates();
        
        (pushViewController as! HomeV2ViewController).postsTableView.reloadRows(at: [parentTableIndexPath], with: .automatic);
    }
}

extension PostItemTableViewCell: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.row == PostRows.Post_Status_Row) {
                
                let cell: CasterPostStatusTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CasterPostStatusTableViewCell", for: indexPath) as! CasterPostStatusTableViewCell;
            
                    //Populating Status
                    populateCasterTopView(cell: cell);
                return cell;

                
            } else if (indexPath.row == PostRows.Post_Action_Row) {
            
            if (pushViewController is ArchieveViewController || pushViewController is CastContactsViewController) {
                return UITableViewCell();
            } else {
                return populateCastActionsCell(indexPath: indexPath, tableView: tableView)
            }
            
            
            } else if (indexPath.row == PostRows.Post_Description_Row) {
                
                let cell: PostDescriptionTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PostDescriptionTableViewCell", for: indexPath) as! PostDescriptionTableViewCell;
            
                    cell.pushViewController = pushViewController;
                    cell.postItemTableViewCellDelegate = self;
                    cell.addLabelToPost(post: post);
                    cell.addTapGestureToArrow(rowId: postRowIndex);
                    
                    if (postRowIndex == totalPosts - 1) {
                        cell.castPaginationArrow.isHidden = true;
                    } else {
                        cell.castPaginationArrow.isHidden = false;
                    }
                    return cell;
            
            }  else if (indexPath.row == PostRows.Post_Gallery_Row) {
                               
                   let cell: PostGalleryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PostGalleryTableViewCell", for: indexPath) as! PostGalleryTableViewCell;
                    cell.pushViewController = pushViewController;
                    cell.createGalleryScrollView(post: post);
                    return cell;
            }

        return UITableViewCell();
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (PostRows.Post_Status_Row == indexPath.row) {
            
            //We will hide the bar in cast contacts screen
            if (pushViewController is CastContactsViewController) {
                return 0;
            }
            return CGFloat(PostRowsHeight.Post_Status_Row_Height);
        } else if (PostRows.Post_Action_Row == indexPath.row) {
            if (pushViewController is ArchieveViewController) {
                return 0;
            }
            //We will hide the bar in cast contacts screen
            if (pushViewController is CastContactsViewController) {
                return 0;
            }
            return CGFloat(PostRowsHeight.Post_Action_Row_Height);
        } else if (PostRows.Post_Description_Row == indexPath.row) {
            let height =  pushViewController.getHeightOfPostDescripiton(contentView: self.contentView, postDescription: post.postDescription);
            if ((pushViewController as! HomeV2ViewController).postIdDescExpansionMap[post.postId] == nil || (pushViewController as! HomeV2ViewController).postIdDescExpansionMap[post.postId] == false) {
                if (height > 100) {
                    return 100;
                }
            }
            return height;
        } else if (PostRows.Post_Gallery_Row == indexPath.row) {
            if (post.postImages.count == 0) {
                return 0;
            }
            return CGFloat(PostRowsHeight.Post_Gallery_Row_Height);
        }
        return 0;
    }
}
