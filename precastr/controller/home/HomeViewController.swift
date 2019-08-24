//
//  HomeViewController.swift
//  precastr
//
//  Created by Macbook on 15/04/19.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit
import SDWebImage
import FBSDKShareKit
import FBSDKCoreKit
import FBSDKLoginKit
import FacebookShare
import FBSDKCoreKit
import EasyTipView

class HomeViewController: UIViewController, EasyTipViewDelegate, SharingDelegate {

    @IBOutlet weak var socialPostList: UITableView!
    
    @IBOutlet weak var noPostsText: UILabel!
    @IBOutlet weak var noPostsIcon: UIImageView!
    
    var postToPublish: Post!;
    var posts = [Post]();
    var loggedInUser : User!
    var social : SocialPlatform!
    var postArray : [String:Any] = [String:Any]()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView();
    private let refreshControl = UIRefreshControl()
    var slides:[SlideUIView] = [];
    var toolTipOpened: Bool = false;
    var easyToolTip: EasyTipView!
    
    class func MainViewController() -> UITabBarController{
        
        let tabBarContro = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MadTabBar") as! UITabBarController
        let loggedInUser = User().loadUserDataFromUserDefaults(userDataDict: setting);
        if (loggedInUser.isCastr == 2) {
            tabBarContro.viewControllers?.remove(at: 1)
        }
        return tabBarContro;
        //return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MadTabBar") as! UITabBarController
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            self.socialPostList.refreshControl = refreshControl
        } else {
            self.socialPostList.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshPostsData(_:)), for: .valueChanged);
        socialPostList.register(UINib(nibName: "HomeTextPostTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "HomeTextPostTableViewCell")
        socialPostList.register(UINib(nibName: "ModeratorCastsTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ModeratorCastsTableViewCell")
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshPostsData), name: NSNotification.Name(rawValue: "reloadHomeScreen"), object: nil)

        //socialPostList.register(UINib(nibName: "PostTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "PostTableViewCell")
        loggedInUser = User().loadUserDataFromUserDefaults(userDataDict : setting);

        self.getAllPostStatuses();

        if (loggedInUser.isCastr == 1) {
            self.loadUserPosts();
        } else if (loggedInUser.isCastr == 2) {
            loadModeratorUserPosts();
        }
        
        self.showBadgeCount();
    }
    override func viewWillAppear(_ animated: Bool) {
        loggedInUser = User().loadUserDataFromUserDefaults(userDataDict : setting);

        self.tabBarController?.tabBar.isHidden = false;
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor(red: 12/255, green: 111/255, blue: 233/255, alpha: 1)
        //If Logged in user is a moderator, then we will
        if (loggedInUser.isCastr == 2) {
            self.navigationItem.title = "Moderate Casts";
            
            if (self.tabBarController!.viewControllers?.count == 4) {
                self.tabBarController!.viewControllers?.remove(at: 1)
            }
        } else {
            self.navigationItem.title = "My Casts";
            
            if (self.tabBarController!.viewControllers?.count == 3) {
                
                let navController = self.storyboard?.instantiateViewController(withIdentifier: "CreateNewPostNavController") as! UINavigationController;
                self.tabBarController!.viewControllers?.insert(navController, at: 1);
            }
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil);
        
        let menuButton = UIButton();
        menuButton.setImage(UIImage.init(named: "menu"), for: .normal);
        menuButton.addTarget(self, action: #selector(menuButtonClicked), for: UIControlEvents.touchUpInside)
        menuButton.frame = CGRect.init(x: 0, y:0, width: 24, height: 24);

        let barButton = UIBarButtonItem(customView: menuButton)
        
        navigationItem.rightBarButtonItem = barButton;
        navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 12/255, green: 111/255, blue: 233/255, alpha: 1)

        noPostsText.text = "Loading, please wait...";
        noPostsText.frame = CGRect.init(x: noPostsText.frame.origin.x, y: noPostsText.frame.origin.y, width: noPostsText.frame.width, height: 25)
        noPostsText.numberOfLines = 1;
        
        if (loggedInUser.isCastr == 1) {
            self.loadUserPosts();
        } else if (loggedInUser.isCastr == 2) {
            loadModeratorUserPosts();
        }

        //self.showBadgeCount();
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func menuButtonClicked() {
        let viewController: SideMenuTableViewController = self.storyboard?.instantiateViewController(withIdentifier: "SideMenuTableViewController") as! SideMenuTableViewController;
        self.navigationController?.pushViewController(viewController, animated: true);
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc private func refreshPostsData(_ sender: Any) {
      //  In this methid call the home screen api
        if (loggedInUser.isCastr == 1) { // caster
            self.loadUserPosts();
        } else if (loggedInUser.isCastr == 2) { // moderator
            loadModeratorUserPosts();
        }
        self.showBadgeCount();
        self.refreshControl.endRefreshing()
       
    }
    
    func showBadgeCount() {
        loggedInUser = User().loadUserDataFromUserDefaults(userDataDict : setting);
        let jsonURL = "posts/get_notifications_count/format/json"
        self.postArray["user_id"] = String(loggedInUser.userId)
        if (self.loggedInUser.isCastr == 1) {
            self.postArray["role_id"] = 0;
        } else {
            self.postArray["role_id"] = 1;
        }
        UserService().postDataMethod(jsonURL: jsonURL, postData: self.postArray, complete: {(response) in
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
    
    func loadUserPosts() {
        social = SocialPlatform().loadSocialDataFromUserDefaults();
        // Do any additional setup after loading the view.
        socialPostList.register(UINib(nibName: "HomeTextPostTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "HomeTextPostTableViewCell")
        
        
        let jsonURL = "posts/all_caster_posts/format/json";
        
        postArray["user_id"] = String(loggedInUser.userId)
        
        
        UserService().postDataMethod(jsonURL: jsonURL, postData: postArray, complete: {(response) in
            print(response)
            
            let status = Int(response.value(forKey: "status") as! String)!
            if(status == 0){
                print("hello")
                self.noPostsText.text = response.value(forKey: "message") as! String;
                let alert = UIAlertController.init(title: "Error", message: response.value(forKey: "message") as! String, preferredStyle: .alert);
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil));
                self.present(alert, animated: true)
            } else {
            let modeArray = response.value(forKey: "data") as! NSArray;
            print(modeArray)
            if (modeArray.count != 0) {
                
                self.noPostsText.isHidden = true;
                self.noPostsIcon.isHidden = true;

                self.socialPostList.isHidden = false;
                //self.homePosts = modeArray as! [Any]
                self.posts = Post().loadPostsFromNSArray(postsArr: modeArray);
                self.socialPostList.reloadData();

            } else {
                self.noPostsText.text = "You do not have any casts, please click on \"Add New\" in order to create a new Cast !";
                self.noPostsText.frame = CGRect.init(x: self.noPostsText.frame.origin.x, y: self.noPostsText.frame.origin.y, width: self.noPostsText.frame.width, height: 70)
                self.noPostsText.numberOfLines = 3;
                
                self.noPostsText.isHidden = false;
                self.noPostsIcon.isHidden = false;

                self.socialPostList.isHidden = true;
            }
        }
        });
    }
    
    func loadModeratorUserPosts() {
        social = SocialPlatform().loadSocialDataFromUserDefaults();
        // Do any additional setup after loading the view.
        let jsonURL = "posts/all_moderator_caster_posts/format/json";
        
        postArray["user_id"] = String(loggedInUser.userId)
        
        
        UserService().postDataMethod(jsonURL: jsonURL, postData: postArray, complete: {(response) in
            print(response)
            
            let success = Int(response.value(forKey: "status") as! String)!
            if (success == 0) {
              /*  let alert = UIAlertController.init(title: "Error", message: response.value(forKey: "message") as! String, preferredStyle: .alert);
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil));
                self.present(alert, animated: true) */
                self.noPostsText.text = "No casts available for moderating !";
                self.noPostsText.frame = CGRect.init(x: self.noPostsText.frame.origin.x, y: self.noPostsText.frame.origin.y, width: self.noPostsText.frame.width, height: 25)
                self.noPostsText.numberOfLines = 1;
                
                self.noPostsText.isHidden = false;
                self.noPostsIcon.isHidden = false;
                
                self.socialPostList.isHidden = true;
            } else {
                let modeArray = response.value(forKey: "data") as! NSArray;
                
                if (modeArray.count != 0) {
                    
                    self.noPostsText.isHidden = true;
                    self.noPostsIcon.isHidden = true;
                    
                    self.socialPostList.isHidden = false;
                    //self.homePosts = modeArray as! [Any]
                    self.posts = Post().loadPostsFromNSArray(postsArr: modeArray);
                    self.socialPostList.reloadData();
                    
                } else {
                    self.noPostsText.text = "No casts available for moderating !";
                    self.noPostsText.frame = CGRect.init(x: self.noPostsText.frame.origin.x, y: self.noPostsText.frame.origin.y, width: self.noPostsText.frame.width, height: 25)
                    self.noPostsText.numberOfLines = 1;
                    
                    self.noPostsText.isHidden = false;
                    self.noPostsIcon.isHidden = false;
                    
                    self.socialPostList.isHidden = true;
                }
            }
            
        });
    }
    
    func getAllPostStatuses() {
        
        let jsonURL = "home/get_all_post_status/format/json"
        UserService().getDataMethod(jsonURL: jsonURL, complete: {(response) in
            print(response)
            let status = Int(response.value(forKey: "status") as! String)!
            if (status == 0) {
                let message = response.value(forKey: "message") as! String;
                self.showAlert(title: "Error", message: message);
                
            } else {
            let modeArray = response.value(forKey: "data") as! NSArray
            postStatusList = PostStatus().loadPostStatusFromNSArray(postStatusArr: modeArray);
            self.socialPostList.reloadData();
        }
        });
    }
    
    @objc func postDescriptionPressed(sender: MyTapRecognizer){
       
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "CommunicationViewController") as! CommunicationViewController;
        viewController.post = self.posts[sender.rowId];
        self.navigationController?.pushViewController(viewController, animated: true);
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
                self.loadUserPosts();
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
                self.loadUserPosts();
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
    func refreshScreenData(){
        
        loggedInUser = User().loadUserDataFromUserDefaults(userDataDict : setting);

        if (loggedInUser.isCastr == 1) {
            self.loadUserPosts();
        } else if (loggedInUser.isCastr == 2) {
            loadModeratorUserPosts();
        }
        
        self.showBadgeCount();

    }
    
    func schemeAvailable(scheme: String) -> Bool {
        if let url = URL(string: scheme) {
            return UIApplication.shared.canOpenURL(url)
        }
        return false
    }
}

class MyTapRecognizer : UITapGestureRecognizer {
    var rowId: Int!;
}

class PostToSocialMediaGestureRecognizer: UITapGestureRecognizer {
    var rowId: Int!;
    var post: Post!;
}

class FacebookPublishInfoGestureRecognizer: UIGestureRecognizer {
    var cell: HomeTextPostTableViewCell!;
    var publishInfoIcon: UIButton!;
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let post = self.posts[indexPath.row];
        if (loggedInUser.isCastr == 2) {
            
            //Call this function
            var height = self.heightForView(text: post.postDescription, font: UIFont.init(name: "VisbyCF-Regular", size: 16.0)!, width: tableView.frame.width - 30)
            
            if (height > 100) {
                height = 100;
            }
            
            if (post.postImages.count > 0) {
                
                if (post.postImages.count == 1) {
                    
                    return (CGFloat(HomePostCellHeight.GapAboveStatus) + 44 + height + 20 + 20 + 420);
                }
                return (CGFloat(HomePostCellHeight.GapAboveStatus) + 44 + height + 20 + 20 + 420 + 40);
            }
            
            return (CGFloat(HomePostCellHeight.GapAboveStatus + 44) + height + 20 + 20);
            
        } else if (loggedInUser.isCastr == 1) {
            
            //Call this function
            var postPublishViewHeight = 0
            //Lets handle the logic of Hiding and Shwoing Publish Buttons.
            //First lets check if post status is Approved/ Published.
            //If post status is approved, then we would have to show both buttons.
            //Publish to Twitter and Publish to Facebook
            if (post.postStatusId == HomePostPublishStatusId.APPROVEDSTATUSID) {
                postPublishViewHeight = HomePostCellHeight.publishPostButtonsView;
                
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
                    postPublishViewHeight = HomePostCellHeight.publishPostButtonsView;
                }
                //If Post status is neither approved nor publised
                //Then we will hide the Publish Post Bar
            }
            
            var height = self.heightForView(text: post.postDescription, font: UIFont.init(name: "VisbyCF-Regular", size: 16.0)!, width: tableView.frame.width - 30)
            
            if (height > 100) {
                height = 100;
            }
            if (post.postImages.count > 0) {
                
                if (post.postImages.count == 1) {
                    
                    return (CGFloat(HomePostCellHeight.GapAboveStatus) + CGFloat(HomePostCellHeight.PostStatusViewHeight) + CGFloat(HomePostCellHeight.GapBelowStatus) + CGFloat(postPublishViewHeight) + height + CGFloat(HomePostCellHeight.GapBelowLabel) + 420);
                }
                return (CGFloat(HomePostCellHeight.GapAboveStatus) + CGFloat(HomePostCellHeight.PostStatusViewHeight) + CGFloat(HomePostCellHeight.GapBelowStatus) + CGFloat(postPublishViewHeight) + height + CGFloat(HomePostCellHeight.GapBelowLabel) + 420 +  30);
            }
            return (CGFloat(HomePostCellHeight.GapAboveStatus + Int(postPublishViewHeight) + HomePostCellHeight.PostStatusViewHeight) + height);
        }
        return 0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = self.posts[indexPath.row];
        
        if (loggedInUser.isCastr == 1) { // caster
            
            //var postTextDescHeight: CGFloat = 0;
            let cell: HomeTextPostTableViewCell = tableView.dequeueReusableCell(withIdentifier: "HomeTextPostTableViewCell", for: indexPath) as! HomeTextPostTableViewCell;
            cell.sourceImageFacebook.isHidden = false;
            cell.sourceImageTwitter.isHidden = false;
            cell.homeViewControllerDelegate = self;
            let postDescTap = MyTapRecognizer.init(target: self, action: #selector(postDescriptionPressed(sender:)));
            postDescTap.rowId = indexPath.row;
            
            let postToFacebookTapGesture = PostToSocialMediaGestureRecognizer.init(target: self, action: #selector(postToFacebookPressed(sender:)));
            postToFacebookTapGesture.post = post;
            
            let postToTwitterTapGesture = PostToSocialMediaGestureRecognizer.init(target: self, action: #selector(postToTwitterPressed(sender:)));
            postToTwitterTapGesture.post = post;
            
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
                cell.sourceImageTwitter.image = UIImage.init(named: "twitter-group");
                cell.sourceImageFacebook.image = UIImage.init(named: "facebook-group");
            } else if (facebookIconHidden == false && twitterIconHidden == true) {
                //If twitter is not present then we will replace sourceImageTwitter image with facebook
                cell.sourceImageTwitter.isHidden = false;
                cell.sourceImageFacebook.isHidden = true;
                cell.sourceImageTwitter.image = UIImage.init(named: "facebook-group");
            } else if (twitterIconHidden == false && facebookIconHidden == true) {
                cell.sourceImageTwitter.isHidden = false;
                cell.sourceImageFacebook.isHidden = true;
                cell.sourceImageTwitter.image = UIImage.init(named: "twitter-group");
            } else {
                cell.sourceImageTwitter.isHidden = true;
                cell.sourceImageFacebook.isHidden = true;
            }
            
            /***** CODE TO SHOW HIDE PUSH TO TWITTER/FACEBOOK BUTTONS  *********/
            //Lets handle the logic of Hiding and Shwoing Publish Buttons.
            //First lets check if post status is Approved/ Published.
            //If post status is approved, then we would have to show both buttons.
            //Publish to Twitter and Publish to Facebook
            if (post.postStatusId == HomePostPublishStatusId.APPROVEDSTATUSID) {
                cell.postPrePublishView.isHidden = false;
                
                
                //cell.pushToFacebookView.isHidden = false;
                cell.pushToFacebookText.textColor = UIColor.white
                cell.pushToFacebookView.backgroundColor = UIColor.init(red: 48/255, green: 77/255, blue: 141/255, alpha: 1);
                cell.pushToFacebookView.layer.borderWidth = 0;
                cell.pushToFacebookView.backgroundColor = UIColor.init(red: 82/255, green: 117/255, blue: 194/255, alpha: 1);
                cell.pushToFacebookView.isUserInteractionEnabled = true;
                
                cell.pushToTwitterText.textColor = UIColor.white
                cell.pushToTwitterView.backgroundColor = UIColor.init(red: 0, green: 153/255, blue: 219/255, alpha: 1);
                cell.pushToTwitterView.layer.borderWidth = 0;
                cell.publishToTwitterImage.backgroundColor = UIColor.init(red: 42/255, green: 185/255, blue: 195/255, alpha: 1);
                cell.pushToTwitterView.isUserInteractionEnabled = true;
                
                //If post status is Published, Then we have to check
                //If user posted on both platforms or not
            } else if (post.postStatusId == HomePostPublishStatusId.PUBLISHSTATUSID) {
                
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
                
                if (facebookPublished == true && twitterPublished == true) {
                    cell.postPrePublishView.isHidden = true;
                } else {
                    cell.postPrePublishView.isHidden = false;
                    
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
                         print(post.postDescription)
                        //cell.pushToTwitterView.isHidden = true;
                        cell.pushToTwitterText.textColor = UIColor.init(red: 34/255, green: 34/255, blue: 34/255, alpha: 1)
                        cell.pushToTwitterView.backgroundColor = UIColor.clear;
                        cell.pushToTwitterView.layer.borderWidth = 0.5;
                        cell.pushToTwitterView.layer.borderColor = UIColor.init(red: 146/255, green: 147/255, blue: 149/255, alpha: 1).cgColor

                        cell.publishToTwitterImage.backgroundColor = UIColor.init(red: 237/255, green: 237/255, blue: 237/255, alpha: 1);
                        cell.pushToTwitterView.isUserInteractionEnabled = false;

                    } else {
                        print("*****")
                        print(post.postDescription)
                        //cell.pushToTwitterView.isHidden = false;
                        cell.pushToTwitterText.textColor = UIColor.white
                        cell.pushToTwitterView.backgroundColor = UIColor.init(red: 0, green: 153/255, blue: 219/255, alpha: 1);
                        cell.pushToTwitterView.layer.borderWidth = 0;
                        cell.publishToTwitterImage.backgroundColor = UIColor.init(red: 42/255, green: 185/255, blue: 195/255, alpha: 1);
                        cell.pushToTwitterView.isUserInteractionEnabled = true;

                    }
                }
                
                //If Post status is neither approved nor publised
                //Then we will hide the Publish Post Bar
            } else {
                cell.postPrePublishView.isHidden = true;
            }
            
            var imageStatus = ""
            var status = "";

            for postStatus in postStatusList {
                if (postStatus.postStatusId == post.postStatusId) {
                    status = postStatus.title;
                }
            }
            
            if (status == "Pending") {
                imageStatus = "pending-review"
               // status = "Pending review"
            } else if (status == "Approved") {
                imageStatus = "approved"
              //  status = "Approved"
            } else if (status == "Rejected") {
                imageStatus = "rejected"
              //  status = "Rejected"
            } else if(status == "Published") {
                imageStatus = "published"
               // status = "Deleted"
            } else if(status == ""){
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
            
            if (cell.postPrePublishView.isHidden == false) {
                cell.pushToTwitterView.addGestureRecognizer(postToTwitterTapGesture);
                cell.pushToFacebookView.addGestureRecognizer(postToFacebookTapGesture);
            }
            
            //Call this function
            var height = self.heightForView(text: post.postDescription, font: UIFont.init(name: "VisbyCF-Regular", size: 16.0)!, width: cell.contentView.frame.width - 30)
            if (height > 100) {
                height = 100;
            }

            //This is your label
            for view in cell.descriptionView.subviews {
                view.removeFromSuperview();
            }
            let proNameLbl = UILabel(frame: CGRect(x: 0, y: 0, width: cell.contentView.frame.width - 30, height: height))
            var lblToShow = "\(post.postDescription)";
           
           // proNameLbl.lineBreakMode = .byTruncatingTail
            let paragraphStyle = NSMutableParagraphStyle()
            //line height size
            paragraphStyle.lineSpacing = 2
            paragraphStyle.lineBreakMode = .byTruncatingTail
            let attributes = [
                NSAttributedStringKey.font : UIFont(name: "VisbyCF-Regular", size: 16.0)!,
                NSAttributedStringKey.foregroundColor : UIColor.init(red: 34/255, green: 34/255, blue: 34/255, alpha: 1),
                NSAttributedStringKey.paragraphStyle: paragraphStyle]
            
            let attrString = NSMutableAttributedString(string: lblToShow)
            attrString.addAttributes(attributes, range: NSMakeRange(0, attrString.length));
            proNameLbl.attributedText = attrString;
            proNameLbl.isUserInteractionEnabled = true;
            //proNameLbl.addGestureRecognizer(postDescTap);
            if (height > 100) {
                proNameLbl.numberOfLines = 4
            } else {
                proNameLbl.numberOfLines = 0
            }
            cell.descriptionView.addSubview(proNameLbl)
            if (cell.postPrePublishView.isHidden == true) {
                cell.descriptionView.frame = CGRect.init(x: cell.descriptionView.frame.origin.x, y: 55, width: cell.descriptionView.frame.width, height: height);
            } else {
                cell.descriptionView.frame = CGRect.init(x: cell.descriptionView.frame.origin.x, y: (55 + 25), width: cell.descriptionView.frame.width, height: height);
            }
            
            
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
            cell.addGestureRecognizer(postDescTap)
            
            activityIndicator.center = cell.center;
            activityIndicator.hidesWhenStopped = true;
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge;
            cell.addSubview(activityIndicator);

            return cell;
            
        } else if (loggedInUser.isCastr == 2) { // moderator
            
            
            let cell: ModeratorCastsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ModeratorCastsTableViewCell", for: indexPath) as! ModeratorCastsTableViewCell;

            if (post.name != "") {
                cell.usernameLabel.text = post.name;
                cell.usernameLabel.isHidden = false
            } else if(post.username != ""){
                cell.usernameLabel.text = post.username;
                cell.usernameLabel.isHidden = false
            }
            
            if(post.profilePic != "") {
                cell.profilePicImageView.sd_setImage(with: URL(string: post.profilePic), placeholderImage: UIImage.init(named: "Moderate Casts"));
                cell.profilePicImageView.isHidden = false
                cell.profilePicImageView.roundImageView()
            }
            
            
            //********************  CODE TO SHOW HIDE SOCIAL MEDIA ICON STARTS   *********************//
            var facebookIconHidden = true;
            var twitterIconHidden = true;
            if (post.socialMediaIds.count > 0) {
                
                for sourcePlatformId in post.socialMediaIds {
                    print("Platform from settings : ",social.socialPlatformId)
                    if(Int(sourcePlatformId) == social.socialPlatformId["Facebook"]){
                        
                        print("Inside Facebokk Exist condition for row : ", indexPath.row)
                        
                        facebookIconHidden = false;
                    }  else if(Int(sourcePlatformId) == social.socialPlatformId["Twitter"]) {
                        
                        print("Inside Twitter Exist condition for row : ", indexPath.row)
                        
                        twitterIconHidden = false;
                    }
                }
            }
            
            if (twitterIconHidden == false && facebookIconHidden == false) {
                cell.sourceImageTwitter.isHidden = false;
                cell.sourceImageFacebook.isHidden = false;
                cell.sourceImageTwitter.image = UIImage.init(named: "twitter-group");
                cell.sourceImageFacebook.image = UIImage.init(named: "facebook-group");
            } else if (facebookIconHidden == false && twitterIconHidden == true) {
                cell.sourceImageTwitter.isHidden = false;
                cell.sourceImageFacebook.isHidden = true;
                cell.sourceImageTwitter.image = UIImage.init(named: "facebook-group");
            } else if (twitterIconHidden == false && facebookIconHidden == true) {
                //If facebook is not present then we will replace facebook image with twitter
                cell.sourceImageTwitter.isHidden = false;
                cell.sourceImageFacebook.isHidden = true;
                cell.sourceImageTwitter.image = UIImage.init(named: "twitter-group");
            } else {
                cell.sourceImageTwitter.isHidden = true;
                cell.sourceImageFacebook.isHidden = true;
            }
            
            //********************  CODE TO SHOW HIDE SOCIAL MEDIA ICON ENDS   *********************//

            //********************  CODE TO ADJUST POST STATUS STARTS   *********************//
            var imageStatus = ""
            var status = "";
            for postStatus in postStatusList {
                if (postStatus.postStatusId == post.postStatusId) {
                    status = postStatus.title;
                }
            }
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
            
            //This is your label
            for view in cell.postStatusViewCell.subviews {
                view.removeFromSuperview();
            }
            
            let statusImage = UIImageView.init(image: UIImage.init(named: imageStatus))
            statusImage.frame = CGRect.init(x: 0, y: 0, width: 20, height: 20);
            cell.postStatusViewCell.addSubview(statusImage);
            
            let pipe = "  |"
            //cell.profileLabel.text = "\((status))\(pipe)"
            //cell.profileLabel.frame = CGRect.init(x: 25, y: 0, width: cell.profileLabel.intrinsicContentSize.width, height: 20);
            
            let profileLabel = UILabel()
            profileLabel.text = "\((status))\(pipe)"
            profileLabel.frame =  CGRect(x: 25, y: 0, width: profileLabel.intrinsicContentSize.width, height: 20)
            profileLabel.font = UIFont(name: "VisbyCF-Regular",
                                     size: 14.0)
            profileLabel.textColor = UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 1)
            cell.postStatusViewCell.addSubview(profileLabel);
            
            
            //cell.dateLabel.text = Date().ddspEEEEcmyyyy(dateStr: post.createdOn)
            let dateLabel = UILabel()
            dateLabel.font = UIFont(name: "VisbyCF-Regular",
                                       size: 14.0)
            dateLabel.textColor = UIColor(red: 100/255, green: 166/255, blue: 247/255, alpha: 1)
            dateLabel.text = Date().ddspEEEEcmyyyy(dateStr: post.createdOn)
            dateLabel.frame =  CGRect(x: profileLabel.intrinsicContentSize.width+32, y: 0, width: dateLabel.intrinsicContentSize.width, height: 20)
            cell.postStatusViewCell.addSubview(dateLabel)
            
           // let totalWidthOfUIView = cell.statusImage.frame.width + cell.profileLabel.intrinsicContentSize.width + cell.dateLabel.intrinsicContentSize.width + 10;
           // cell.dateLabel.frame = CGRect.init(x: (cell.profileLabel.intrinsicContentSize.width + cell.profileLabel.frame.origin.x + 5), y: 0, width: cell.dateLabel.intrinsicContentSize.width, height: 20);
           
          //  cell.postStatusViewCell.frame = CGRect.init(x: cell.postStatusViewCell.frame.origin.x, y: cell.postStatusViewCell.frame.origin.y, width: 260, height: cell.postStatusViewCell.frame.height);
            //********************  CODE TO ADJUST POST STATUS ENDS   *********************//

            
            
            //********************  CODE TO SHOW POST DESCRIPTION STARTS   *********************//
            //Call this function
            var height = self.heightForView(text: post.postDescription, font: UIFont.init(name: "VisbyCF-Regular", size: 16.0)!, width: self.view.frame.width - 30)
            if (height > 100) {
                height = 100;
            }

            //This is your label
            for view in cell.descriptionView.subviews {
                view.removeFromSuperview();
            }
            let proNameLbl = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 30, height: height))
            var lblToShow = "\(post.postDescription)"
            
            if (height > 100) {
                proNameLbl.numberOfLines = 4
            } else {
                proNameLbl.numberOfLines = 0
            }
            
         //   proNameLbl.lineBreakMode = .byTruncatingTail
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineBreakMode = .byTruncatingTail
            //line height size
            paragraphStyle.lineSpacing = 2
            let postDescTap = MyTapRecognizer.init(target: self, action: #selector(postDescriptionPressed(sender:)));
            postDescTap.rowId = indexPath.row;
            let attributes = [
                NSAttributedStringKey.font : UIFont(name: "VisbyCF-Regular", size: 16.0)!,
                NSAttributedStringKey.foregroundColor : UIColor.init(red: 34/255, green: 34/255, blue: 34/255, alpha: 1),
                NSAttributedStringKey.paragraphStyle: paragraphStyle]
            
            let attrString = NSMutableAttributedString(string: lblToShow)
            attrString.addAttributes(attributes, range: NSMakeRange(0, attrString.length));
            proNameLbl.attributedText = attrString;
            cell.descriptionView.addSubview(proNameLbl)

           
            //********************  CODE TO SHOW POST DESCRIPTION ENDS   *********************//
            
            
            //********************  CODE TO ADJUST IMAGE SCROLL VIEW STARTS   *********************//
            if (post.postImages.count > 0) {
                cell.imagesArray = [String]();
                cell.imageGalleryScrollView.isHidden = false
                for postImg in post.postImages {
                    cell.imagesArray.append(postImg);
                }
                
                let y = Int(cell.descriptionView.frame.origin.y) + Int(height) + 20;
                cell.imageGalleryScrollView.frame = CGRect.init(x: 0, y: y, width: Int(cell.imageGalleryScrollView.frame.width), height: HomePostCellHeight.ScrollViewHeight)
                
                cell.setupSlideScrollView()
                if(cell.imagesArray.count > 1) {
                    
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
            //********************  CODE TO ADJUST IMAGE SCROLL VIEW ENDS   *********************//

            
            cell.addGestureRecognizer(postDescTap);
            return cell;
        }
        return UITableViewCell();
    }
}
