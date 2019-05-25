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
    var homePosts : [Any] = [Any]()
    var loggedInUser : User!
    var social : SocialPlatform!
    var postArray : [String:Any] = [String:Any]()
    
    class func MainViewController() -> UITabBarController{
        
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MadTabBar") as! UITabBarController
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       
        loggedInUser = User().loadUserDataFromUserDefaults(userDataDict : setting);
        social = SocialPlatform().loadSocialDataFromUserDefaults();
        // Do any additional setup after loading the view.
        
        socialPostList.register(UINib(nibName: "HomeTextPostTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "HomeTextPostTableViewCell")
        
        
        let jsonURL = "posts/all_caster_posts/format/json";
        print("loggedInUser")
        print(Int(loggedInUser.userId))
        postArray["user_id"] = String(loggedInUser.userId)
       // postArray["social_media_platform_id"] = 2
        
        UserService().postDataMethod(jsonURL: jsonURL, postData: postArray, complete: {(response) in
            print(response);
            
            let modeArray = response.value(forKey: "data") as! NSArray;
            /* for mode in modeArray{
             var posts = [String : Any]()
             var modeDict = mode as! NSDictionary;
             // self.moderators.append(String((modeDict.value(forKey: "username") as! NSString) as String)!);
             posts["short_user_name"] = modeDict.value(forKey: "short_user_name") as! String
             
             
             } */
            self.homePosts = modeArray as! [Any]
            self.socialPostList.reloadData();
        });
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor(red: 12/255, green: 111/255, blue: 233/255, alpha: 1)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil);
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New", style: .plain, target: self, action: #selector(redirectOnSocialPlatform))
        navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 12/255, green: 111/255, blue: 233/255, alpha: 1)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func MenuButtonClicked(_ sender: Any) {
        print("hello")
        print(self.navigationController)
        let viewController: TableTableViewController = self.storyboard?.instantiateViewController(withIdentifier: "TableTableViewController") as! TableTableViewController;
        self.navigationController?.pushViewController(viewController, animated: true);
       
        
    }
    @objc func redirectOnSocialPlatform(){
        print("hello addTapped")
        let viewController: TwitterPostViewController = self.storyboard?.instantiateViewController(withIdentifier: "TwitterPostViewController") as! TwitterPostViewController;
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
        print(self.homePosts.count)
        return self.homePosts.count;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let homeObject = self.homePosts[indexPath.row] as! NSDictionary ;
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTextPostTableViewCell", for: indexPath) as! HomeTextPostTableViewCell;

        cell.postTextLabel.text = String(homeObject.value(forKey: "post_description") as! String);
        let postImage = homeObject.value(forKey: "post_images") as! NSArray
        if (postImage != nil && postImage.count > 0) {
            
            let postImageURL = postImage[0] as! NSDictionary;
            let imgUrl = postImageURL.value(forKey: "image") as! String;
            print(imgUrl)
          //  cell.sourceImageFacebook.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(named: "profile"));
            //cell.sourceImageFacebook.layer.masksToBounds = false
        }
        
        
        //cell.profileImage.roundImageView();
        let sourcePlatformArray = homeObject.value(forKey: "social_media") as! NSArray
        if (sourcePlatformArray != nil && sourcePlatformArray.count > 0) {
            
            let sourcePlatform = Int(((((sourcePlatformArray[0]) as! NSDictionary).value(forKey: "id") as? NSString)?.doubleValue)!)
            print(sourcePlatform)
            if(Int(sourcePlatform) == social.socialPlatformId["Facebook"]){
                cell.sourceImageFacebook.image = UIImage.init(named: "facebook")
            }else  if(Int(sourcePlatform) == social.socialPlatformId["Twitter"]){
                print("dsf")
                cell.sourceImageTwitter.image = UIImage.init(named: "twitter")
            }
            cell.sourceImageTwitter.layer.masksToBounds = false
            cell.sourceImageFacebook.layer.masksToBounds = false
        }
        
        cell.dateLabel.text = homeObject.value(forKey: "elapsed_time_setting_value") as! String
        return cell;
    }
}
