//
//  HomeV2ViewController.swift
//  precastr
//
//  Created by mandeep singh on 17/02/20.
//  Copyright © 2020 Macbook. All rights reserved.
//

import UIKit
import SDWebImage
import FBSDKCoreKit
import FBSDKLoginKit
import FacebookShare
import FBSDKCoreKit
import EasyTipView
import MessageUI

class HomeV2ViewController: SharePostViewController,EasyTipViewDelegate, SharingDelegate,MFMessageComposeViewControllerDelegate {
    
    class func MainViewController() -> UITabBarController{
        
        let tabBarContro = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MadTabBar") as! UITabBarController
        let loggedInUser = User().loadUserDataFromUserDefaults(userDataDict: setting);
        if (loggedInUser.isCastr == 2) {
            tabBarContro.viewControllers?.remove(at: 1)
        }
        return tabBarContro;
        //return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MadTabBar") as! UITabBarController
        
    }
    
    @IBOutlet weak var postsTableView: UITableView!
    @IBOutlet weak var noPostsText: UILabel!
    @IBOutlet weak var noPostsIcon: UIImageView!

    var loggedInUser: User!;
    var posts: [Post] = [Post]();
    var postToPublish: Post!;
    var postId: Int!;
    var easyToolTip: EasyTipView!
    var postIdDescExpansionMap = [Int: Bool]();


    private let refreshControl = UIRefreshControl()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView();



    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        postsTableView.register(UINib(nibName: "PostItemTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "PostItemTableViewCell");
        loggedInUser = User().loadUserDataFromUserDefaults(userDataDict : setting);
        
        //Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            self.postsTableView.refreshControl = refreshControl
        } else {
            self.postsTableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshPostsData(_:)), for: .valueChanged);
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshPostsData), name: NSNotification.Name(rawValue: "reloadHomeScreen"), object: nil)
        
        if (loggedInUser.isCastr == 1) {
            self.loadUserPosts();
        } else if (loggedInUser.isCastr == 2) {
            loadModeratorUserPosts();
        }
        
        SocialPlatform().fetchSocialPlatformData();
        HomeV2ViewController.showBadgeCount();
        
        if (postIdFromPush != 0) {
            
            let viewController: CommunicationViewController = self.storyboard?.instantiateViewController(withIdentifier: "CommunicationViewController") as! CommunicationViewController;
            viewController.postId = postIdFromPush
            self.navigationController?.pushViewController(viewController, animated: true);
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        loggedInUser = User().loadUserDataFromUserDefaults(userDataDict : setting);
        
        self.tabBarController?.tabBar.isHidden = false;
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor(red: 12/255, green: 111/255, blue: 233/255, alpha: 1)
        //If Logged in user is a moderator, then we will
        if (loggedInUser.isCastr == 2) {
            self.navigationItem.title = "Moderate Casts";
            
            if (self.tabBarController != nil && self.tabBarController!.viewControllers?.count == 4) {
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
        
        /*if (loggedInUser.isCastr == 1) {
            self.loadUserPosts();
        } else if (loggedInUser.isCastr == 2) {
            loadModeratorUserPosts();
        }*/
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

    
    @objc private func refreshPostsData(_ sender: Any) {
        
        //  In this methid call the home screen api
        if (loggedInUser.isCastr == 1) { // caster
            self.loadUserPosts();
        } else if (loggedInUser.isCastr == 2) { // moderator
            loadModeratorUserPosts();
        }
        HomeV2ViewController.showBadgeCount();
        self.refreshControl.endRefreshing()
        
    }
    
    func postToFacebookPressed(post: Post) {
        
        print(post.postDescription);
        
        DispatchQueue.main.async {
            //self.activityIndicator.startAnimating();
        }
        
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
                UIPasteboard.general.string = "\(post.postDescription)";
                
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
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch (result)
        {
        case .sent:
            print("sms sent.")
            var postData = [String: Any]();
            postData["user_id"] = self.loggedInUser.userId
            postData["post_id"] = self.postId!
            let jsonURL = "user/send_post_sms/format/json";
            UserService().postDataMethod(jsonURL: jsonURL,postData:postData,complete:{(response) in
                self.activityIndicator.stopAnimating();
                
                let statusCode = Int(response.value(forKey: "status") as! String)!
                if(statusCode == 0) {
                    self.showAlert(title: "Alert", message: response.value(forKey: "message") as! String);
                } else {
                    self.loadUserPosts();
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
    
    func deleteButtonPresses(post: Post) {
        var postData = [String: Any]();
        postData["post_id"] = post.postId;
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
                    self.loadUserPosts();
                }
            });
        }));
        self.present(alert, animated: true)
    }

    class func showBadgeCount() {
        let loggedInUser = User().loadUserDataFromUserDefaults(userDataDict: setting);
        let jsonURL = "posts/get_notifications_count/format/json";
        var postArray = [String: Any]();
        postArray["user_id"] = String(loggedInUser.userId)
        if (loggedInUser.isCastr == 1) {
            postArray["role_id"] = 0;
        } else {
            postArray["role_id"] = 1;
        }
        UserService().postDataMethod(jsonURL: jsonURL, postData: postArray, complete: {(response) in
            print(response)
            
            let success = Int(response.value(forKey: "status") as! String)!
            if (success == 1) {
                let dataArray = response.value(forKey: "data") as! NSDictionary;
                let tabBarContro = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MadTabBar") as! UITabBarController
                
                if let tabItems = tabBarContro.tabBar.items {
                    // In this case we want to modify the badge number of the third tab:
                    var index = 0;
                    if (loggedInUser.isCastr == 1) {
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

        var postArray : [String:Any] = [String:Any]();
        let jsonURL = "posts/all_caster_posts/format/json";
        
        postArray["user_id"] = String(loggedInUser.userId)
        
        
        UserService().postDataMethod(jsonURL: jsonURL, postData: postArray, complete: {(response) in
            print(response)
            
            let status = Int(response.value(forKey: "status") as! String)!
            if(status == 0){
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
                    
                    self.postsTableView.isHidden = false;
                    //self.homePosts = modeArray as! [Any]
                    self.posts = Post().loadPostsFromNSArray(postsArr: modeArray);
                    self.posts = self.posts.sorted {$0.postId > $1.postId};
                    self.postsTableView.reloadData();
                    
                    
                    
                    if (self.loggedInUser.isCastr == 1) {
                        self.navigationItem.title = "My Casts (\(response.value(forKey: "count") as! Int))";
                    }
                    
                    
                } else {
                    self.noPostsText.text = "You do not have any casts.\n Please click \"Add New\" to create a Cast!";
                    self.noPostsText.frame = CGRect.init(x: self.noPostsText.frame.origin.x, y: self.noPostsText.frame.origin.y, width: self.noPostsText.frame.width, height: 70)
                    self.noPostsText.numberOfLines = 3;
                    
                    self.noPostsText.isHidden = false;
                    self.noPostsIcon.isHidden = false;
                    
                    self.postsTableView.isHidden = true;
                }
                
                
            }
        });
    }
    
    
    func loadModeratorUserPosts() {
        social = SocialPlatform().loadSocialDataFromUserDefaults();

        var postArray : [String:Any] = [String:Any]();
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
                
                self.postsTableView.isHidden = true;
            } else {
                let modeArray = response.value(forKey: "data") as! NSArray;
                
                if (modeArray.count != 0) {
                    
                    self.noPostsText.isHidden = true;
                    self.noPostsIcon.isHidden = true;
                    
                    self.postsTableView.isHidden = false;
                    //self.homePosts = modeArray as! [Any]
                    self.posts = Post().loadPostsFromNSArray(postsArr: modeArray);
                    self.postsTableView.reloadData();
                    
                    if (self.loggedInUser.isCastr == 2) {
                        self.navigationItem.title = "Moderate Casts (\(response.value(forKey: "count") as! Int))";
                    }
                    
                } else {
                    self.noPostsText.text = "No casts available for moderating !";
                    self.noPostsText.frame = CGRect.init(x: self.noPostsText.frame.origin.x, y: self.noPostsText.frame.origin.y, width: self.noPostsText.frame.width, height: 25)
                    self.noPostsText.numberOfLines = 1;
                    
                    self.noPostsText.isHidden = false;
                    self.noPostsIcon.isHidden = false;
                    
                    self.postsTableView.isHidden = true;
                }
            }
            
        });
    }

}


extension HomeV2ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = self.posts[indexPath.row];
        
        /*let cell: CasterViewTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CasterViewTableViewCell", for: indexPath) as! CasterViewTableViewCell;
         cell.pushViewController = self;
         cell.postTopView.addSubview(cell.populateCasterTopView(post: post));
         cell.castOptionsView.addSubview(cell.populateCastOptionsView(post: post));
         cell.addLabelToPost(post: post);
         cell.createGalleryScrollView(post: post);*/
        
        let cell: PostItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PostItemTableViewCell", for: indexPath) as! PostItemTableViewCell;
        cell.pushViewController = self;
        cell.post = post
        cell.postRowIndex = indexPath.row;
        cell.totalPosts = posts.count;
        //self.postIdDescExpansionMap[post.postId] = cell.isDescriptionFullView;
        cell.parentTableIndexPath = indexPath;
        cell.postItemsTableView.reloadData();
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let post = self.posts[indexPath.row];
        
        var height: CGFloat = 0
        if (loggedInUser.isCastr == 2) {
            height += CGFloat(PostRowsHeight.Post_Moderator_Status_Row_Height);
        } else {
            height += CGFloat(PostRowsHeight.Post_Status_Row_Height + PostRowsHeight.Post_Action_Row_Height);
        }
        
        var heightOfDesc: CGFloat = getHeightOfPostDescripiton(contentView: self.view, postDescription: post.postDescription);
        if (heightOfDesc > 100) {
            print(postIdDescExpansionMap);
            if (!(postIdDescExpansionMap[post.postId] != nil && postIdDescExpansionMap[post.postId] == true)) {
                heightOfDesc = 100;
            }
            //heightOfDesc = 100;
        }
        print("Height of Descriptiojn :  ",heightOfDesc, "POst Id : ", post.postId);
        height = height + heightOfDesc + CGFloat(PostRowsHeight.Post_Description_Row_Height);
    
        let websiteUrl = extractWebsiteFromText(text: post.postDescription);
        if (websiteUrl != "") {
            height = height + CGFloat(PostRowsHeight.Post_WebsiteInfo_Row_Height);
        }
        if (post.postImages.count != 0) {
            height = height + CGFloat(PostRowsHeight.Post_Gallery_Row_Height);
        }
        
        return CGFloat(height);
}
}
