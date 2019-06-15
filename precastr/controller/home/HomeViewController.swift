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
    @IBOutlet weak var noPostsIcon: UIImageView!
    
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
        socialPostList.register(UINib(nibName: "ModeratorCastsTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ModeratorCastsTableViewCell")
        loggedInUser = User().loadUserDataFromUserDefaults(userDataDict : setting);
        

        if (loggedInUser.isCastr == 1) {
            self.loadUserPosts();
        } else if (loggedInUser.isCastr == 2) {
            loadModeratorUserPosts();
        }

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

        noPostsText.text = "Loading, please wait...";
        noPostsText.frame = CGRect.init(x: noPostsText.frame.origin.x, y: noPostsText.frame.origin.y, width: noPostsText.frame.width, height: 25)
        noPostsText.numberOfLines = 1;
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
        if (loggedInUser.isCastr == 2) {
            
            if (postImage != nil && postImage.count > 0) {
                return 620
            } else {
                return 165
            }
        } else {
            if (postImage != nil && postImage.count > 0) {
                return 590
            }
            return 130
        }
        return 0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let homeObject = self.homePosts[indexPath.row] as! NSDictionary ;
        
        if (loggedInUser.isCastr == 1) { // caster
        let cell: HomeTextPostTableViewCell = tableView.dequeueReusableCell(withIdentifier: "HomeTextPostTableViewCell", for: indexPath) as! HomeTextPostTableViewCell;
            cell.sourceImageFacebook.isHidden = false;
            cell.sourceImageTwitter.isHidden = false;

            //cell.postTextLabel.text = String(homeObject.value(forKey: "post_description") as! String);
            let postDescTap = UITapGestureRecognizer.init(target: self, action: #selector(postDescriptionPressed));
            cell.postTextLabel.addGestureRecognizer(postDescTap);
            
            let attributedString = NSMutableAttributedString(string: String(homeObject.value(forKey: "post_description") as! String))
            
            // *** Create instance of `NSMutableParagraphStyle`
            let paragraphStyle = NSMutableParagraphStyle()
            
            // *** set LineSpacing property in points ***
            paragraphStyle.lineSpacing = 2 // Whatever line spacing you want in points
            
            // *** Apply attribute to string ***
            attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
            
            // *** Set Attributed String to your label ***
            cell.postTextLabel.attributedText = attributedString
           
            if(cell.postTextLabel.calculateMaxLines() <= 3){
                cell.postTextLabel.numberOfLines = Int(cell.postTextLabel.calculateMaxLines())
                print("numberOfLines")
                
                let frameHeight : Int = Int(cell.postTextLabel.frame.height)
                 print(frameHeight)
                let numLines : Int = Int(cell.postTextLabel.numberOfLines)
                let calcHeight :Int = Int((frameHeight*numLines)/4);
                cell.postTextLabel.frame = CGRect.init(x: cell.postTextLabel.frame.origin.x, y: cell.postTextLabel.frame.origin.y, width: cell.postTextLabel.frame.width, height: CGFloat(calcHeight))
            }
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
            
            if (postImages.count > 0) {
                cell.imageGalleryScrollView.isHidden = false;
            } else {
                cell.imageGalleryScrollView.isHidden = true;
            }
            
            //cell.profileImage.roundImageView();
            var facebookIconHidden = true;
            var twitterIconHidden = true;
            let sourcePlatformArray = homeObject.value(forKey: "social_media") as! NSArray
            if (sourcePlatformArray != nil && sourcePlatformArray.count > 0) {
                
                for sourcePlatform in sourcePlatformArray {
                    let sourcePlatformDict = sourcePlatform as! NSDictionary;
                    
                    let sourcePlatformId = Int(((sourcePlatformDict.value(forKey: "id") as? NSString)?.doubleValue)!)
                    print("sourcePlatform", sourcePlatform)
                    if(Int(sourcePlatformId) == social.socialPlatformId["Facebook"]){
                        //cell.sourceImageFacebook.image = UIImage.init(named: "facebook-group")
                        facebookIconHidden = false;
                    }  else if(Int(sourcePlatformId) == social.socialPlatformId["Twitter"]) {
                        // print("dsf")
                        //cell.sourceImageTwitter.image = UIImage.init(named: "twitter-group")
                        twitterIconHidden = false;
                    }
                }
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
            
            /*if (twitterIconHidden == true && facebookIconHidden == false) {
                cell.sourceImageFacebook.frame = CGRect.init(x: 0, y: 5, width: 15, height: 15)
            } else if (twitterIconHidden == false && facebookIconHidden == true) {
                cell.sourceImageTwitter.frame = CGRect.init(x: 0, y: 5, width: 15, height: 15)

            } else if (twitterIconHidden == true && facebookIconHidden == true) {
                cell.sourceImageTwitter.frame = CGRect.init(x: 0, y: 5, width: 15, height: 15)
                cell.sourceImageFacebook.frame = CGRect.init(x: 20, y: 5, width: 15, height: 15)
            }*/
            
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
            }else if(status == "Pending with caster"){
                imageStatus = "under-review"
                status = "Under review"
            }
            else if(status == "Pending with moderator"){
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
            cell.dateLabel.text = Date().ddspEEEEcmyyyy(dateStr: homeObject.value(forKey: "created_on") as! String)
            
            // Lets add ui labels in width.
            let totalWidthOfUIView = cell.statusImage.frame.width + cell.profileLabel.intrinsicContentSize.width + cell.dateLabel.intrinsicContentSize.width + 10;
            cell.postStatusDateView.frame = CGRect.init(x: cell.frame.width - (totalWidthOfUIView + 15), y: cell.postStatusDateView.frame.origin.y, width: totalWidthOfUIView, height: cell.postStatusDateView.frame.height);
            
            cell.statusImage.frame = CGRect.init(x: 0, y: 0, width: 20, height: 20);
            cell.profileLabel.frame = CGRect.init(x: 25, y: 0, width: cell.profileLabel.intrinsicContentSize.width, height: 20);
            cell.dateLabel.frame = CGRect.init(x: (cell.profileLabel.intrinsicContentSize.width + cell.profileLabel.frame.origin.x + 5), y: 0, width: cell.dateLabel.intrinsicContentSize.width, height: 20);

            
            cell.setupSlideScrollView()
            cell.pageControl.numberOfPages = cell.imagesArray.count
            cell.pageControl.currentPage = 0
            cell.contentView.bringSubview(toFront: cell.pageControl)
            if(cell.imagesArray.count > 1){
                cell.imageCounterView.isHidden = true // false
                cell.totalCountImageLbl.text = " \(cell.imagesArray.count)";
                cell.currentCountImageLbl.text = "1"
                
                cell.imageCounterView.isHidden = true //false
                
                //If logged in user is a caster
                //70 width of counter view
                //20 Padding from right
                //20 from top of image scroll view
                cell.imageCounterView.frame = CGRect.init(x: (cell.frame.width - (60 + 20) ), y: (cell.imageGalleryScrollView.frame.origin.y + 20), width: 60, height: 25)
                
            } else {
                cell.imageCounterView.isHidden = true
            }
            
            //ScrollView functionality
            return cell;
        } else if (loggedInUser.isCastr == 2) { // moderator
             let cell: ModeratorCastsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ModeratorCastsTableViewCell", for: indexPath) as! ModeratorCastsTableViewCell;
            
            //cell.postTextLabel.text = String(homeObject.value(forKey: "post_description") as! String);
            let attributedString = NSMutableAttributedString(string: String(homeObject.value(forKey: "post_description") as! String))
            
            // *** Create instance of `NSMutableParagraphStyle`
            let paragraphStyle = NSMutableParagraphStyle()
            
            // *** set LineSpacing property in points ***
            paragraphStyle.lineSpacing = 2 // Whatever line spacing you want in points
            
            // *** Apply attribute to string ***
            attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
            
            // *** Set Attributed String to your label ***
            cell.postTextLabel.attributedText = attributedString
            
            if(cell.postTextLabel.calculateMaxLines() <= 3){
                cell.postTextLabel.numberOfLines = Int(cell.postTextLabel.calculateMaxLines())
                print("numberOfLines")
                let frameHeight : Int = Int(cell.postTextLabel.frame.height)
                print(frameHeight)
                let numLines : Int = Int(cell.postTextLabel.numberOfLines)
                let calcHeight :Int = Int((frameHeight*numLines)/4);
                cell.postTextLabel.frame = CGRect.init(x: cell.postTextLabel.frame.origin.x, y: cell.postTextLabel.frame.origin.y, width: cell.postTextLabel.frame.width, height: CGFloat(calcHeight))
                
            }
            let postImages = homeObject.value(forKey: "post_images") as! NSArray
            if (postImages.count > 0) {
                cell.imagesArray = [String]();
                cell.imageGalleryScrollView.isHidden = false
                for postImg in postImages {
                    let postImageURL = postImg as! NSDictionary;
                    let imgUrl: String = postImageURL.value(forKey: "image") as! String;
                    cell.imagesArray.append(imgUrl);
                }
            } else {
                cell.imagesArray = [String]();
                cell.imageGalleryScrollView.isHidden = true;
            }

            //If user is a moderator
            cell.profilePicImageView.isHidden = false
            if (postImages.count > 0) {
                cell.imageGalleryScrollView.isHidden = false;
            } else {
                cell.imageGalleryScrollView.isHidden = true;
            }
                        

            print("Going to check social Media icons for row : ", indexPath.row)
            var facebookIconHidden = true;
            var twitterIconHidden = true;
            let sourcePlatformArray = homeObject.value(forKey: "social_media") as! NSArray
            if (sourcePlatformArray.count > 0) {
                
                print("Inside if condition for Row : ", indexPath.row)
                print("sourcePlatformArray for Row : ", indexPath.row, "is : ",sourcePlatformArray)
                for sourcePlatform in sourcePlatformArray {
                    let sourcePlatformDict = sourcePlatform as! NSDictionary;
                    
                    let sourcePlatformId = Int(((sourcePlatformDict.value(forKey: "id") as? NSString)?.doubleValue)!)
                    
                    print("Platform Id for row for Row : ", indexPath.row, "is : ",sourcePlatformId)
                    
                    
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
            
            /*if (facebookIconHidden == true) {
                cell.sourceImageFacebook.isHidden = true;
            } else {
                cell.sourceImageFacebook.isHidden = false;
            }
            
            if (twitterIconHidden == true) {
                cell.sourceImageTwitter.isHidden = true;
            } else {
                cell.sourceImageTwitter.isHidden = false;
            }*/
            
            if (twitterIconHidden == false && facebookIconHidden == false) {
                cell.sourceImageTwitter.isHidden = false;
                cell.sourceImageFacebook.isHidden = false;
            } else if (facebookIconHidden == false && twitterIconHidden == true) {
                cell.sourceImageTwitter.isHidden = true;
                cell.sourceImageFacebook.isHidden = false;
                cell.sourceImageFacebook.image = UIImage.init(named: "facebook-group");
            } else if (twitterIconHidden == false && facebookIconHidden == true) {
                //If facebook is not present then we will replace facebook image with twitter
                cell.sourceImageTwitter.isHidden = true;
                cell.sourceImageFacebook.isHidden = false;
                cell.sourceImageFacebook.image = UIImage.init(named: "twitter-group");
            }
            
            /*if (twitterIconHidden == false && facebookIconHidden == false) {
                cell.sourceImageTwitter.frame = CGRect.init(x: cell.socialIconsView.frame.origin.x, y: 0, width: cell.sourceImageTwitter.frame.width, height: cell.sourceImageTwitter.frame.height)
                cell.sourceImageFacebook.frame = CGRect.init(x: (cell.sourceImageTwitter.frame.origin.x + 3), y: 0, width: cell.sourceImageFacebook.frame.width, height: cell.sourceImageFacebook.frame.height)
            } else if (facebookIconHidden == false && twitterIconHidden == true) {
                
            }*/
            
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
            }else if(status == "Pending with caster"){
                imageStatus = "under-review"
                status = "Under review"
            }
            else if(status == "Pending with moderator"){
                imageStatus = "under-review"
                status = "Under review"
            }        else if(status == ""){
                imageStatus = ""
            }
            cell.statusImage.image = UIImage.init(named: imageStatus)
            let pipe = " |"
            cell.profileLabel.text = "\((status))\(pipe)"
            cell.dateLabel.text = Date().ddspEEEEcmyyyy(dateStr: homeObject.value(forKey: "created_on") as! String)
            
            
            let totalWidthOfUIView = cell.statusImage.frame.width + cell.profileLabel.intrinsicContentSize.width + cell.dateLabel.intrinsicContentSize.width + 10;
            cell.postStatusViewCell.frame = CGRect.init(x: cell.frame.width - (totalWidthOfUIView + 15), y: cell.postStatusViewCell.frame.origin.y, width: totalWidthOfUIView, height: cell.postStatusViewCell.frame.height);
            
            cell.statusImage.frame = CGRect.init(x: 0, y: 0, width: 20, height: 20);
            cell.profileLabel.frame = CGRect.init(x: 25, y: 0, width: cell.profileLabel.intrinsicContentSize.width, height: 20);
            cell.dateLabel.frame = CGRect.init(x: (cell.profileLabel.intrinsicContentSize.width + cell.profileLabel.frame.origin.x + 5), y: 0, width: cell.dateLabel.intrinsicContentSize.width, height: 20);
            
            
            
            //ScrollView functionality
            //self.slides = cell.createSlides()
            if(homeObject["username"] != nil){
                let profileUserName = homeObject.value(forKey: "username") as! String;
                let profilePic = homeObject.value(forKey: "profile_pic") as! String;
                let name =  homeObject.value(forKey: "name") as! String;
                
                if (name != "") {
                    cell.usernameLabel.text = String(profileUserName)
                    cell.usernameLabel.isHidden = false
                } else if(profileUserName != ""){
                    cell.usernameLabel.text = String(profileUserName)
                    cell.usernameLabel.isHidden = false
                }
                
                if(profilePic != "") {
                    cell.profilePicImageView.sd_setImage(with: URL(string: profilePic), placeholderImage: UIImage.init(named: "Moderate Casts"));
                    cell.profilePicImageView.isHidden = false
                    cell.profilePicImageView.roundImageView()
                }
            }
            cell.setupSlideScrollView()
            print("current")
            print(cell.pageControl.currentPage)
            cell.pageControl.numberOfPages = cell.imagesArray.count
            cell.pageControl.currentPage = 0
            cell.contentView.bringSubview(toFront: cell.pageControl)
            if(cell.imagesArray.count > 1){
                cell.imageCounterView.isHidden = true // false
                cell.totalCountImageLbl.text = " \(cell.imagesArray.count)";
                cell.currentCountImageLbl.text = "1"
                
                cell.imageCounterView.isHidden = true //false
            } else {
                cell.imageCounterView.isHidden = true
            }
            
            //ScrollView functionality
            return cell;
        }
        return UITableViewCell();
    }
    @objc private func refreshPostsData(_ sender: Any) {
      //  In this methid call the home screen api
        if (loggedInUser.isCastr == 1) { // caster
            self.loadUserPosts();
        } else if (loggedInUser.isCastr == 2) { // moderator
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
                self.noPostsIcon.isHidden = true;

                self.socialPostList.isHidden = false;
                self.homePosts = modeArray as! [Any]
                self.socialPostList.reloadData();

            } else {
                self.noPostsText.text = "You do not have any casts, please check on \"Add New\" in order to create a new Cast !";
                self.noPostsText.frame = CGRect.init(x: self.noPostsText.frame.origin.x, y: self.noPostsText.frame.origin.y, width: self.noPostsText.frame.width, height: 70)
                self.noPostsText.numberOfLines = 3;
                
                self.noPostsText.isHidden = false;
                self.noPostsIcon.isHidden = false;

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
            
            let success = Int(response.value(forKey: "status") as! String)
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
                    self.homePosts = modeArray as! [Any]
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
    @objc func postDescriptionPressed(){
        var viewController = self.storyboard?.instantiateViewController(withIdentifier: "CommunicationViewController") as! CommunicationViewController;
        self.navigationController?.pushViewController(viewController, animated: true);
    }
}
