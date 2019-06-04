//
//  HomeViewController.swift
//  precastr
//
//  Created by Macbook on 15/04/19.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit
import SDWebImage

class HomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var socialPostList: UITableView!
    
    @IBOutlet weak var noPostsText: UILabel!
    
    var homePosts : [Any] = [Any]()
    var loggedInUser : User!
    var social : SocialPlatform!
    var postArray : [String:Any] = [String:Any]()
     private let refreshControl = UIRefreshControl()
    var slides:[SlideUIView] = [];
    class func MainViewController() -> UITabBarController{
        
        var tabBarContro = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MadTabBar") as! UITabBarController
        let loggedInUser = User().loadUserDataFromUserDefaults(userDataDict: setting);
        if (loggedInUser.isCastr == 2) {
            tabBarContro.viewControllers?.remove(at: 1)
        }
        return tabBarContro;
        //return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MadTabBar") as! UITabBarController
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       
            // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            self.socialPostList.refreshControl = refreshControl
        } else {
            self.socialPostList.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshPostsData(_:)), for: .valueChanged);
        socialPostList.register(UINib(nibName: "HomeTextPostTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "HomeTextPostTableViewCell")
        
        loggedInUser = User().loadUserDataFromUserDefaults(userDataDict : setting);
        
        

    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = false;
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor(red: 12/255, green: 111/255, blue: 233/255, alpha: 1)
        //If Logged in user is a moderator, then we will
        if (loggedInUser.isCastr == 2) {
            self.navigationItem.title = "Moderate Casts";
        } else {
            self.navigationItem.title = "My Casts";
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil);
        
        let menuButton = UIButton();
        menuButton.setImage(UIImage.init(named: "menu"), for: .normal);
        menuButton.addTarget(self, action: #selector(menuButtonClicked), for: UIControlEvents.touchUpInside)
        menuButton.frame = CGRect.init(x: 0, y:0, width: 24, height: 24);

        let barButton = UIBarButtonItem(customView: menuButton)
        
        navigationItem.rightBarButtonItem = barButton;
        navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 12/255, green: 111/255, blue: 233/255, alpha: 1)

        if (loggedInUser.isCastr == 1) {
            self.loadUserPosts();
        } else if (loggedInUser.isCastr == 2) {
            loadModeratorUserPosts();
        }
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      //  print(self.homePosts.count)
        return self.homePosts.count;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let homeObject = self.homePosts[indexPath.row] as! NSDictionary ;
        let postImage = homeObject.value(forKey: "post_images") as! NSArray
        var heightToAdd = 0;
        if (loggedInUser.isCastr == 2) {
            heightToAdd = 30;//height for name
        }
        
        if (postImage != nil && postImage.count > 0) {
            return (CGFloat(340 + heightToAdd))
        }
        return (CGFloat(110 + heightToAdd))
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let homeObject = self.homePosts[indexPath.row] as! NSDictionary ;
        
        let cell: HomeTextPostTableViewCell = tableView.dequeueReusableCell(withIdentifier: "HomeTextPostTableViewCell", for: indexPath) as! HomeTextPostTableViewCell;
        
        cell.postTextLabel.text = String(homeObject.value(forKey: "post_description") as! String);
        let postImages = homeObject.value(forKey: "post_images") as! NSArray
        if (postImages.count > 0) {
            cell.imagesArray = [String]();
            cell.imageGalleryScrollView.isHidden = false
            for postImg in postImages {
                let postImageURL = postImg as! NSDictionary;
                let imgUrl: String = postImageURL.value(forKey: "image") as! String;
                cell.imagesArray.append(imgUrl);
            }
            //  cell.sourceImageFacebook.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(named: "profile"));
            //cell.sourceImageFacebook.layer.masksToBounds = false
        } else {
            cell.imagesArray = [String]();
            cell.imageGalleryScrollView.isHidden = true;
        }
        
        if (loggedInUser.isCastr == 1) { //If user is a caster
            cell.profilePicImageView.isHidden = true
            cell.socialIconsView.frame = CGRect.init(x: 15, y: 20, width: 35, height: 25)
            cell.postTextLabel.frame = CGRect.init(x: 15, y: 45, width: (cell.frame.width - 15), height: 54)
            
            if (postImages.count > 0) {
                cell.imageGalleryScrollView.frame = CGRect.init(x: 0, y: 110, width: cell.frame.width, height: 218);
                cell.imageGalleryScrollView.isHidden = false;
            } else {
                cell.imageGalleryScrollView.isHidden = true;
            }
        } else {
            
            //If user is a moderator
            cell.profilePicImageView.isHidden = false
            cell.socialIconsView.frame = CGRect.init(x: 65, y: 20, width: 35, height: 25)
            cell.postTextLabel.frame = CGRect.init(x: 15, y: 75, width: (cell.frame.width - 15), height: 54)
            if (postImages.count > 0) {
                cell.imageGalleryScrollView.frame = CGRect.init(x: 0, y: 130, width: cell.frame.width, height: 218);
                cell.imageGalleryScrollView.isHidden = false;
            } else {
                cell.imageGalleryScrollView.isHidden = true;
            }
            
        }

        
        
        
        
        //cell.profileImage.roundImageView();
        var facebookIconHidden = true;
        var twitterIconHidden = true;
        let sourcePlatformArray = homeObject.value(forKey: "social_media") as! NSArray
        if (sourcePlatformArray != nil && sourcePlatformArray.count > 0) {
            
            for sourcePlatform in sourcePlatformArray {
                let sourcePlatformDict = sourcePlatform as! NSDictionary;
                
                let sourcePlatformId = Int(((sourcePlatformDict.value(forKey: "id") as? NSString)?.doubleValue)!)
                
                print("sourcePlatform")
                print(sourcePlatform)
                if(Int(sourcePlatformId) == social.socialPlatformId["Facebook"]){
                    cell.sourceImageFacebook.image = UIImage.init(named: "facebook-group")
                    cell.sourceImageFacebook.isHidden = false
                    facebookIconHidden = false;
                }  else if(Int(sourcePlatformId) == social.socialPlatformId["Twitter"]) {
                    // print("dsf")
                    cell.sourceImageTwitter.image = UIImage.init(named: "twitter-group")
                    cell.sourceImageTwitter.isHidden = false
                    twitterIconHidden = false;
                }
            }
            
            cell.sourceImageTwitter.layer.masksToBounds = false
            cell.sourceImageFacebook.layer.masksToBounds = false
        }
        
        if (facebookIconHidden == true) {
            cell.sourceImageFacebook.isHidden = true;
        }
        if (twitterIconHidden == true) {
            cell.sourceImageTwitter.isHidden = true;
        }
        if (twitterIconHidden == true && facebookIconHidden == false) {
            cell.sourceImageFacebook.frame = CGRect.init(x: 2, y: 3, width: 15, height: 15)
        }
        
        var imageStatus = ""
        var status = (homeObject.value(forKey: "status") as! String)
        if(status == "Pending"){
            imageStatus = "pending-review"
            status = "Pending review"
        }else if(status == "Approved by moderator"){
            imageStatus = "approved"
            status = "Approved"
        }else if (status == "Rejected by moderator"){
            imageStatus = "rejected"
            status = "Rejected"
        }else if(status == ""){
            imageStatus = ""
        }
        cell.statusImage.image = UIImage.init(named: imageStatus)
        let pipe = " |"
        cell.profileLabel.text = "\((status))\(pipe)"
        cell.dateLabel.text = Date().ddspEEEEcmyyyy(dateStr: homeObject.value(forKey: "created_on") as! String)
                
        //ScrollView functionality
        //self.slides = cell.createSlides()
        if(homeObject["username"] != nil){
            let profileUserName = homeObject.value(forKey: "username") as! String;
            let profilePic = homeObject.value(forKey: "profile_pic") as! String;
            if(profileUserName != ""){
                cell.usernameLabel.text = String(profileUserName)
                cell.usernameLabel.isHidden = false
            }
            
            if(profilePic != "") {
                cell.profilePicImageView.sd_setImage(with: URL(string: profilePic), placeholderImage: UIImage.init(named: "my-account-black"));
                cell.profilePicImageView.isHidden = false
                cell.profilePicImageView.roundImageView()
            }
        }
        cell.setupSlideScrollView()
        
        cell.pageControl.numberOfPages = self.slides.count
        cell.pageControl.currentPage = 0
        cell.contentView.bringSubview(toFront: cell.pageControl)
        //ScrollView functionality
        return cell;
    }
    @objc private func refreshPostsData(_ sender: Any) {
      //  In this methid call the home screen api
        if (loggedInUser.isCastr == 1) {
            self.loadUserPosts();
        } else if (loggedInUser.isCastr == 2) {
            loadModeratorUserPosts();
        }
        self.refreshControl.endRefreshing()
       
        
    }
    
    func loadUserPosts() {
        social = SocialPlatform().loadSocialDataFromUserDefaults();
        // Do any additional setup after loading the view.
        socialPostList.register(UINib(nibName: "HomeTextPostTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "HomeTextPostTableViewCell")
        
        
        let jsonURL = "posts/all_caster_posts/format/json";
        
        postArray["user_id"] = String(loggedInUser.userId)
        
        
        UserService().postDataMethod(jsonURL: jsonURL, postData: postArray, complete: {(response) in
            
            let modeArray = response.value(forKey: "data") as! NSArray;
            
            if (modeArray.count != 0) {
                
                self.noPostsText.isHidden = true;
                self.socialPostList.isHidden = false;
                self.homePosts = modeArray as! [Any]
                self.socialPostList.reloadData();

            } else {
                self.noPostsText.isHidden = false;
                self.socialPostList.isHidden = true;
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
            let modeArray = response.value(forKey: "data") as! NSArray;
            
            if (modeArray.count != 0) {
                
                self.noPostsText.isHidden = true;
                self.socialPostList.isHidden = false;
                self.homePosts = modeArray as! [Any]
                self.socialPostList.reloadData();
                
            } else {
                self.noPostsText.isHidden = false;
                self.socialPostList.isHidden = true;
            }
        });
    }
}
