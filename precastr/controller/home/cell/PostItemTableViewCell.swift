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
import ReadabilityKit
import TwitterKit
import TwitterCore

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
        postItemsTableView.register(UINib(nibName: "WebsiteInfoTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "WebsiteInfoTableViewCell");
        postItemsTableView.register(UINib(nibName: "ModeratorHomeTopTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ModeratorHomeTopTableViewCell");
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func postStatusLabelPressed() {
        (pushViewController as! CommunicationViewController).changeStatusButtonClicked();
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
        } else if (pushViewController is CommunicationViewController) {
            (pushViewController as! CommunicationViewController).deleteButtonPresses(post: sender.post);
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
        if (post.createdOnTimestamp == 0) {
            cell.postDateLbl.text = Date().ddspEEEEcmyyyy(dateStr: post.createdOn);

            if (pushViewController is CommunicationViewController) {
                cell.postDateLbl.text = Date().ddspEEEEcmyyyyspHHclmmclaa(dateStr: post.createdOn);
            }
        } else {
            let date = Date(timeIntervalSince1970: TimeInterval.init(post.createdOnTimestamp/1000));
            cell.postDateLbl.text = Date().ddspEEEEcmyyyyV2(dateStrDt: date);
            
            if (pushViewController is CommunicationViewController) {
                cell.postDateLbl.text = Date().ddspEEEEcmyyyyspHHclmmclaaV2(dateStrDt: date);
            }
        }
        cell.postDateLbl.frame = CGRect.init(x: (self.contentView.frame.width -  cell.postDateLbl.intrinsicContentSize.width - 5), y: cell.postDateLbl.frame.origin.y, width: cell.postDateLbl.intrinsicContentSize.width, height: cell.postDateLbl.frame.height);
        
        //Setting Status of Post
        var status = "";
        for postStatus in postStatusList {
            if (postStatus.postStatusId == post.postStatusId) {
                status = postStatus.title;
                break;
            }
        }
        
        let pipe = " |"
        
        //This line will run if the status is not Approved/Published
        cell.postStatusLbl.text = "\((status))\(pipe)"
        cell.postStatusLbl.layer.borderWidth = 0;

        //This code will run when user is Moderator
        //And the status of post has to be updated.
        if (pushViewController is CommunicationViewController) {
            if ((pushViewController as! CommunicationViewController).loggedInUser.isCastr == 2 && status != "Published") {
                // create an NSMutableAttributedString that we'll append everything to
                let fullString = NSMutableAttributedString(string: " \((status)) ")

                // create our NSTextAttachment
                let image1Attachment = NSTextAttachment()
                image1Attachment.image = UIImage(named: "down_arrow")
                // wrap the attachment in its own attributed string so we can append it
                let image1String = NSAttributedString(attachment: image1Attachment)

                // add the NSTextAttachment wrapper to our full string, then add some more text.
                fullString.append(image1String)
                
                let suffix = NSMutableAttributedString(string: " |");
                let range = (" |" as NSString).range(of: "|")
                suffix.addAttribute(NSAttributedStringKey.foregroundColor,value: UIColor.white , range: range)
                fullString.append(suffix);
                cell.postStatusLbl.attributedText = fullString;
                cell.postStatusLbl.layer.cornerRadius = 4;
                cell.postStatusLbl.layer.borderWidth = 0.5;
                
                cell.postStatusLbl.isUserInteractionEnabled = true;
                let postStatusTapGuesture = UITapGestureRecognizer.init(target: self, action: #selector(postStatusLabelPressed));
                cell.postStatusLbl.addGestureRecognizer(postStatusTapGuesture);
            }
        }
    
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
        cell.postStatusImg.frame = CGRect.init(x: cell.postStatusLbl.frame.origin.x - ( cell.postStatusImg.frame.width + 2), y: cell.postStatusImg.frame.origin.y, width: cell.postStatusImg.frame.width, height: cell.postStatusImg.frame.height)
        
        
        if (pushViewController is CommunicationViewController) {
            if (status == "Published") {
                cell.viewDetailsBtn.isHidden = true;
            } else {
                cell.viewDetailsBtn.setTitle("Edit Post", for: .normal);
                cell.viewDetailsBtn.setImage(UIImage.init(named: "edit_pencil"), for: .normal);
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
        
        if (status == "Pending" || status == "Rejected") {
            
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
    
            var gapBetweenButtons: CGFloat = 23;
            if (pushViewController is CommunicationViewController || post.status == "Approved") {
                gapBetweenButtons = 10;
            }
            let buttonsHeightWidth: CGFloat = 30;
            
            var deleteButtonVisible = true;
            if (status == "Published") {
                deleteButtonVisible = false;
                cell.deleteBtn.isHidden = true;
            } else {
                cell.deleteBtn.isHidden = false;
            }
            
            var facebookPublished = false;
            for socialMediaId in post.socialMediaIds {
                if (socialMediaId == social.socialPlatformId["Facebook"]) {
                    facebookPublished = true;
                    break;
                }else{
                    facebookPublished = false;
                }
            }
            if (facebookPublished == true) {
                cell.facebookInfoBtn.isHidden = true;
            } else {
                cell.facebookInfoBtn.isHidden = false;
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
        
        let postCastMenu: PostCastMenu = PostCastMenu.instanceFromNib() as! PostCastMenu;
        let buttonAbsoluteFrame = shareButtonGlobal.convert(shareButtonGlobal.bounds, to: self.pushViewController.view)
        postCastMenu.frame = CGRect.init(x: buttonAbsoluteFrame.origin.x - 60, y: buttonAbsoluteFrame.origin.y + 30, width: 80, height: 150)
        
        let postToFacebookTapGesture = PostToSocialMediaGestureRecognizer.init(target: self, action: #selector(postToFacebookPressed(sender:)));
        postToFacebookTapGesture.post = post;
        
        let postToTwitterTapGesture = PostToSocialMediaGestureRecognizer.init(target: self, action: #selector(postToTwitterPressed(sender:)));
           postToTwitterTapGesture.post = post;
           
        let postToSMSTapGesture = PostToSocialMediaGestureRecognizer.init(target: self, action: #selector(postToSMSPressed(sender:)));
           postToSMSTapGesture.post = post;
        
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
            
            if (facebookPublished == false) {
                postCastMenu.facebookItem.addGestureRecognizer(postToFacebookTapGesture);
            }
            if (twitterPublished == false) {
                postCastMenu.twitterItem.addGestureRecognizer(postToTwitterTapGesture);
            }
            
            postCastMenu.messageItem.addGestureRecognizer(postToSMSTapGesture);
            
        } else {
            postCastMenu.facebookItem.addGestureRecognizer(postToFacebookTapGesture);
            postCastMenu.twitterItem.addGestureRecognizer(postToTwitterTapGesture);
            postCastMenu.messageItem.addGestureRecognizer(postToSMSTapGesture);
        }
        
        self.pushViewController.view.addSubview(postCastMenu);
        isShareMenuOpened = true;
        if (self.pushViewController is HomeV2ViewController) {
            (self.pushViewController as! HomeV2ViewController).postsTableView.isScrollEnabled = false;
        }
        
        let descHeight = pushViewController.getHeightOfPostDescripiton(contentView: contentView, postDescription: post.postDescription);
        if (descHeight < 150 && pushViewController is HomeV2ViewController && postRowIndex == (totalPosts - 1) && totalPosts > 1) {
            postCastMenu.frame = CGRect.init(x: buttonAbsoluteFrame.origin.x - 60, y: buttonAbsoluteFrame.origin.y - 150, width: 80, height: 150)
        }
    }
    
    func flowToCallPostToTwitter(post: Post) {
        
        if (self.pushViewController is HomeV2ViewController) {
            (self.pushViewController as! HomeV2ViewController).activityIndicator.startAnimating();
        } else if (self.pushViewController is CommunicationViewController) {
            (self.pushViewController as! CommunicationViewController).activityIndicator.startAnimating();
        }
        
        PostManager().publishPostOnTwitter(post: post, complete: {(response) in
            if (self.pushViewController is HomeV2ViewController) {
                (self.pushViewController as! HomeV2ViewController).activityIndicator.stopAnimating();
            } else if (self.pushViewController is CommunicationViewController) {
                (self.pushViewController as! CommunicationViewController).activityIndicator.stopAnimating();
            }
            let statusCode = Int(response.value(forKey: "status") as! String)!
            if (statusCode == 0) {
                self.pushViewController.showAlert(title: "Alert", message: response.value(forKey: "message") as! String);
            } else {
                for view in self.pushViewController.view.subviews {
                    if (view is PostCastMenu) {
                        view.removeFromSuperview();
                    }
                }
                if (self.pushViewController is HomeV2ViewController) {
                    (self.pushViewController as! HomeV2ViewController).postsTableView.isScrollEnabled = true;
                    (self.pushViewController as! HomeV2ViewController).showToast(message: "Post Shared Successfully On Twitter")
                    (self.pushViewController as! HomeV2ViewController).loadUserPosts();
               
                } else if(self.pushViewController is CommunicationViewController) {
                    
                  (self.pushViewController as!  CommunicationViewController).showToast(message: "Post Shared Successfully On Twitter")
                    
                }
                
            }
        });
    }
    
    func postTokensToTwitter(postData: [String: Any], post: Post) {
        
        let userTokenUdpdateEndPoint = "\(ApiUrl)/user/upate_user_tokens/format/json";
        UserService().postDataMethod(jsonURL: userTokenUdpdateEndPoint, postData: postData, complete: {response in
            
            let status: Int = Int(response.value(forKey: "status") as! String)!;
            if (status == 1) {
                let userDict = response.value(forKey: "data") as! NSDictionary;
                print(userDict)
                let user = User().getUserData(userDataDict: userDict);
                user.loadUserDefaults();
            }
            self.flowToCallPostToTwitter(post: post);
        });
    }
    
    @objc func postToSMSPressed(sender: PostToSocialMediaGestureRecognizer) {
        
        if (sender.post.postDescription == "") {
            if (pushViewController is HomeV2ViewController) {
                (pushViewController as! HomeV2ViewController).showAlert(title: "Alert", message: "Sorry, you are not allowed to send the images via SMS.")
            } else if (pushViewController is CommunicationViewController) {
                (pushViewController as! CommunicationViewController).showAlert(title: "Alert", message: "Sorry, you are not allowed to send the images via SMS.")
            }
        } else if (sender.post.postDescription != "" && sender.post.postImages.count > 0) {
            
            var refreshAlert = UIAlertController(title: "Confirm!", message: "The images in the post will be removed, do you stll want to send the SMS.", preferredStyle: UIAlertControllerStyle.alert)

            refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
              
                let viewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ContactsViewController") as! ContactsViewController;
                viewController.requestFrom = ContactsViewController.ContactsViewRequestFrom.PostMenuRequest;
                viewController.postItemTableViewDelegate = self;
                //viewController.moderatorViewControllerDelegte = self;
                self.pushViewController.navigationController?.pushViewController(viewController, animated: true);
              }))

            refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
              print("Handle Cancel Logic here")
              }))

            self.pushViewController.present(refreshAlert, animated: true, completion: nil)

        } else {
            let viewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ContactsViewController") as! ContactsViewController;
            viewController.requestFrom = ContactsViewController.ContactsViewRequestFrom.PostMenuRequest;
            viewController.postItemTableViewDelegate = self;
            //viewController.moderatorViewControllerDelegte = self;
            self.pushViewController.navigationController?.pushViewController(viewController, animated: true);
        }
        
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
        
        var loggedInUser: User = User();
        if (pushViewController is HomeV2ViewController) {
            loggedInUser = (pushViewController as! HomeV2ViewController).loggedInUser
        } else if (pushViewController is CommunicationViewController) {
            loggedInUser = (pushViewController as! CommunicationViewController).loggedInUser;
        }
        
        let userSocialMedias = UserSocialMedia().populationUserSocialMediaFromArray(socialMediaArr: loggedInUser.tokens);
        var isTwitterSynced = false;
        if (userSocialMedias.count > 0) {
            for userSocialMedia in userSocialMedias {
                if (userSocialMedia.type == "Twitter") {
                    isTwitterSynced = true;
                }
            }
        }
        
        //If twitter already synced.. Lets post on twitter then
        if (isTwitterSynced == true) {
            flowToCallPostToTwitter(post: sender.post);
        } else {
            //Lets authenticate user for twitter
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
                    user.username = name
                    user.name = name
                    user.isTwitter = 1;
                
                    var loggedInUser: User = User();
                    if (self.pushViewController is HomeV2ViewController) {
                        loggedInUser = (self.pushViewController as! HomeV2ViewController).loggedInUser;
                    } else if (self.pushViewController is CommunicationViewController) {
                        loggedInUser = (self.pushViewController as! CommunicationViewController).loggedInUser;
                    }
                    var postData = [String: Any]();
                    postData["user_id"] = loggedInUser.userId;
                    postData["social_media"] = 2;
                    postData["twitter_id"] = user.twitterId;

                    var token = [String: Any]();
                    token["twitter_secret_success"] = session?.authTokenSecret;
                    token["twitter_access_token"] = session?.authToken;
                    token["email"] = user.username;
                    postData["token"] = token;
                    self.postTokensToTwitter(postData: postData, post: sender.post);
                } else {
                    print("error: \(String(describing: error?.localizedDescription))");
                }
            }
        }
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
                
                var contentUrlStr = "http://precastr.com";
                if (pushViewController is HomeV2ViewController) {
                    let websiteUrl = (pushViewController as! HomeV2ViewController).extractWebsiteFromText(text: sender.post.postDescription);
                    if (websiteUrl != nil && websiteUrl != "") {
                        contentUrlStr = websiteUrl;
                    }
                } else if (pushViewController is CommunicationViewController) {
                    let websiteUrl = (pushViewController as! CommunicationViewController).extractWebsiteFromText(text: sender.post.postDescription);
                    if (websiteUrl != nil && websiteUrl != "") {
                        contentUrlStr = websiteUrl;
                    }
                }
                
                content.contentURL = URL.init(string: contentUrlStr)!;
                let shareDialog = ShareDialog()
                shareDialog.shareContent = content;
                
                var fbInstalled = false;
                if (pushViewController is HomeV2ViewController) {
                    fbInstalled = (pushViewController as! HomeV2ViewController).schemeAvailable(scheme: "fb://");
                } else if (pushViewController is CommunicationViewController) {
                    fbInstalled = (pushViewController as! CommunicationViewController).schemeAvailable(scheme: "fb://");
                } else if (pushViewController is ArchieveViewController) {
                    fbInstalled = (pushViewController as! ArchieveViewController).schemeAvailable(scheme: "fb://");
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
                        (pushViewController as! CommunicationViewController).showFacebookFailAlert();
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
                    (pushViewController as! CommunicationViewController).showFacebookFailAlert();
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
        if (pushViewController is HomeV2ViewController) {
            (pushViewController as! HomeV2ViewController).activityIndicator.startAnimating();
        } else if (pushViewController is CommunicationViewController) {
            (pushViewController as! CommunicationViewController).activityIndicator.startAnimating();
        }
        self.hidePostMenu();
        PostManager().publishOnFacebook(post: post, complete: {(response) in
            print(response);
            if (self.pushViewController is HomeV2ViewController) {
                (self.pushViewController as! HomeV2ViewController).activityIndicator.stopAnimating();
            } else if (self.pushViewController is CommunicationViewController) {
                (self.pushViewController as! CommunicationViewController).activityIndicator.stopAnimating();
            };
            
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
        self.hidePostMenu();
        
        if (pushViewController is HomeV2ViewController) {
            (pushViewController as! HomeV2ViewController).activityIndicator.stopAnimating();
            (pushViewController as! HomeV2ViewController).showFacebookFailAlert();
        } else if (pushViewController is CommunicationViewController) {
            (pushViewController as! CommunicationViewController).activityIndicator.stopAnimating();
            (pushViewController as! CommunicationViewController).showFacebookFailAlert();
        } else if (pushViewController is ArchieveViewController) {
            (pushViewController as! HomeV2ViewController).activityIndicator.stopAnimating();
            (pushViewController as! ArchieveViewController).showFacebookFailAlert();
        }
    }
    
    func sharerDidCancel(_ sharer: Sharing) {
        print("Cancel");
        self.hidePostMenu();
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
               
               if (self.pushViewController is HomeV2ViewController) {
                   (self.pushViewController as! HomeV2ViewController).activityIndicator.startAnimating();
               } else if (self.pushViewController is CommunicationViewController) {
                   (self.pushViewController as! CommunicationViewController).activityIndicator.startAnimating();
               }
               
               UserService().postDataMethod(jsonURL: jsonURL,postData:postData,complete:{(response) in
                
                self.hidePostMenu();
                    if (self.pushViewController is HomeV2ViewController) {
                        (self.pushViewController as! HomeV2ViewController).activityIndicator.stopAnimating();
                    } else if (self.pushViewController is CommunicationViewController) {
                        (self.pushViewController as! CommunicationViewController).activityIndicator.stopAnimating();
                    }
                   
                   let statusCode = Int(response.value(forKey: "status") as! String)!
                   if(statusCode == 0) {
                    self.pushViewController.showAlert(title: "Alert", message: response.value(forKey: "message") as! String);
                   } else {
                        if (self.pushViewController is HomeV2ViewController) {
                            (self.pushViewController as! HomeV2ViewController).loadUserPosts();
                        }
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
                   
               });
               break
           case .cancelled:
                hidePostMenu();
               print("sms cancelled.")
               break
           case .failed:
                hidePostMenu();
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
        
        if (pushViewController is HomeV2ViewController) {
            (pushViewController as! HomeV2ViewController).postsTableView.reloadRows(at: [parentTableIndexPath], with: .automatic);
        }
    }
    
    func hidePostMenu() {
        for view in self.pushViewController.view.subviews {
            if (view is PostCastMenu) {
                view.removeFromSuperview();
            }
        }
        if (self.pushViewController is HomeV2ViewController) {
            (self.pushViewController as! HomeV2ViewController).postsTableView.isScrollEnabled = true;
        }
    }
    
    func isPostArchieved() -> Bool {
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
        
        if (facebookPublished == true && twitterPublished == true && smsPublished == true) {
            return true;
        }
        
        return false;
    }
}

extension PostItemTableViewCell: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.row == PostRows.Post_Status_Row) {
            
            if (pushViewController is CastContactsViewController) {
                return UITableViewCell();
            }
            
            //If Mooderator is at Home Controller
            if (pushViewController is HomeV2ViewController) {
                if ((pushViewController as! HomeV2ViewController).loggedInUser.isCastr == 2) {
                    let moderatorCell: ModeratorHomeTopTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ModeratorHomeTopTableViewCell", for: indexPath) as! ModeratorHomeTopTableViewCell;
                    moderatorCell.pushViewController = pushViewController;
                    //Populating Status
                    moderatorCell.populateModeratorTopView(cell: moderatorCell, post: post);
                    return moderatorCell;
                }
            }
        
            let cell: CasterPostStatusTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CasterPostStatusTableViewCell", for: indexPath) as! CasterPostStatusTableViewCell;
                //Populating Status
                populateCasterTopView(cell: cell);
                return cell;
            } else if (indexPath.row == PostRows.Post_Action_Row) {
            
                //We will hide action row if its an Archieve Tab/ Cast Contacts Page or
                //If the user is moderator, then we wil hide this row at HomeScreen and Cast Detail Screen
            if (pushViewController is ArchieveViewController || pushViewController is CastContactsViewController) {
                    return UITableViewCell();
                } else {
                    if (pushViewController is HomeV2ViewController) {
                        if ((pushViewController as! HomeV2ViewController).loggedInUser.isCastr == 2) {
                            return UITableViewCell();
                        }
                    } else if (pushViewController is CommunicationViewController) {
                        if ((pushViewController as! CommunicationViewController).loggedInUser.isCastr == 2 || isPostArchieved() == true) {
                            return UITableViewCell();
                        }
                    }
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
            
            } else if (indexPath.row == PostRows.Post_WebsiteInfo_Row) {
                 var websiteUrl = "";
                 if (pushViewController is HomeV2ViewController) {
                     websiteUrl = (pushViewController as! HomeV2ViewController).extractWebsiteFromText(text: post.postDescription);
                 } else if (pushViewController is CommunicationViewController) {
                     websiteUrl = (pushViewController as! CommunicationViewController).extractWebsiteFromText(text: post.postDescription);
                 } else if (pushViewController is ArchieveViewController) {
                     websiteUrl = (pushViewController as! ArchieveViewController).extractWebsiteFromText(text: post.postDescription);
                 } else if (pushViewController is CastContactsViewController) {
                     websiteUrl = (pushViewController as! CastContactsViewController).extractWebsiteFromText(text: post.postDescription);
                 }
                 if (websiteUrl == "") {
                     return UITableViewCell();
                 } else {
                     let cell: WebsiteInfoTableViewCell = tableView.dequeueReusableCell(withIdentifier: "WebsiteInfoTableViewCell", for: indexPath) as! WebsiteInfoTableViewCell;
                     cell.pushViewController = pushViewController;
                     cell.fetchWebsiteLinkFromUrl(desc: post.postDescription);
                       return cell;
                 }
                
              } else if (indexPath.row == PostRows.Post_Gallery_Row) {
                               
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
            if (pushViewController is HomeV2ViewController) {
                if ((pushViewController as! HomeV2ViewController).loggedInUser.isCastr == 2) {
                    return CGFloat(PostRowsHeight.Post_Moderator_Status_Row_Height);
                }
            }
            return CGFloat(PostRowsHeight.Post_Status_Row_Height);
        } else if (PostRows.Post_Action_Row == indexPath.row) {
            if (pushViewController is ArchieveViewController || pushViewController is CastContactsViewController) {
                return 0;
            }
            //If its Cast Detail Controller and post status is published,
            //We will then hide all the options
            if (pushViewController is HomeV2ViewController) {
                if ((pushViewController as! HomeV2ViewController).loggedInUser.isCastr == 2) {
                    return 0;
                }
            } else if (pushViewController is CommunicationViewController) {
                if ((pushViewController as! CommunicationViewController).loggedInUser.isCastr == 2) {
                    return 0;
                }
                if (isPostArchieved() == true) {
                    return 0
                }
            }
            
            
            return CGFloat(PostRowsHeight.Post_Action_Row_Height);
        } else if (PostRows.Post_Description_Row == indexPath.row) {
            print(post.postDescription);
            var height =  pushViewController.getHeightOfPostDescripiton(contentView: self.contentView, postDescription: post.postDescription);
            if (pushViewController is HomeV2ViewController) {
                if (height == 25) {
                    return 35;
                }
                if ((pushViewController as! HomeV2ViewController).postIdDescExpansionMap[post.postId] == nil || (pushViewController as! HomeV2ViewController).postIdDescExpansionMap[post.postId] == false) {
                    if (height > 100) {
                        return 100;
                    }
                }
            }
            
            return height;
        }  else if (PostRows.Post_WebsiteInfo_Row == indexPath.row) {

            var websiteUrl = "";
            if (pushViewController is HomeV2ViewController) {
                websiteUrl = (pushViewController as! HomeV2ViewController).extractWebsiteFromText(text: post.postDescription);
            } else if (pushViewController is CommunicationViewController) {
                websiteUrl = (pushViewController as! CommunicationViewController).extractWebsiteFromText(text: post.postDescription);
            } else if (pushViewController is ArchieveViewController) {
                websiteUrl = (pushViewController as! ArchieveViewController).extractWebsiteFromText(text: post.postDescription);
            } else if (pushViewController is CastContactsViewController) {
                websiteUrl = (pushViewController as! CastContactsViewController).extractWebsiteFromText(text: post.postDescription);
            }
            if (websiteUrl == "") {
                return 0;
            } else {
                return CGFloat(PostRowsHeight.Post_WebsiteInfo_Row_Height);
            }
        } else if (PostRows.Post_Gallery_Row == indexPath.row) {
            if (post.postImages.count == 0) {
                return 0;
            }
            return CGFloat(PostRowsHeight.Post_Gallery_Row_Height);
        }
        return 0;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row == PostRows.Post_WebsiteInfo_Row) {
            
            var websiteUrl = "";
           if (pushViewController is HomeV2ViewController) {
               websiteUrl = (pushViewController as! HomeV2ViewController).extractWebsiteFromText(text: post.postDescription);
           } else if (pushViewController is CommunicationViewController) {
               websiteUrl = (pushViewController as! CommunicationViewController).extractWebsiteFromText(text: post.postDescription);
           } else if (pushViewController is ArchieveViewController) {
               websiteUrl = (pushViewController as! ArchieveViewController).extractWebsiteFromText(text: post.postDescription);
           } else if (pushViewController is CastContactsViewController) {
               websiteUrl = (pushViewController as! CastContactsViewController).extractWebsiteFromText(text: post.postDescription);
           }
           if (websiteUrl != "") {
            UIApplication.shared.openURL(URL(string: websiteUrl)!)
            }
        }
    }
}
