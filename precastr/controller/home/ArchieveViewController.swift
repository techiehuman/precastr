//
//  ArchieveViewController.swift
//  precastr
//
//  Created by Cenes_Dev on 11/02/2020.
//  Copyright © 2020 Macbook. All rights reserved.
//

import UIKit
import SDWebImage

class ArchieveViewController: SharePostViewController {

    @IBOutlet weak var postsTableView: UITableView!
    @IBOutlet weak var noArchiveCastsView: UIView!

    var loggedInUser: User!;
    var posts: [Post] = [Post]();
    var postIdDescExpansionMap = [Int: Bool]();
    var postLinkInfoFetched = [String: LinkInfoData]();
    private let refreshControl = UIRefreshControl()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView();

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //postsTableView.register(UINib(nibName: "CasterViewTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "CasterViewTableViewCell");
        
        activityIndicator.center = view.center;
        activityIndicator.hidesWhenStopped = true;
        activityIndicator.style = UIActivityIndicatorView.Style.gray;
        view.addSubview(activityIndicator);

        postsTableView.register(UINib(nibName: "PostItemTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "PostItemTableViewCell");
        loggedInUser = User().loadUserDataFromUserDefaults(userDataDict : setting);

        loadArchievePosts();
        
        self.navigationItem.title = "Archived Casts";
        /*if (loggedInUser.isCastr == 1) {
            self.navigationItem.title = "My Casts";
        } else {
            self.navigationItem.title = "Moderator Casts";
        }*/
        //Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            self.postsTableView.refreshControl = refreshControl
        } else {
            self.postsTableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshPostsData(_:)), for: .valueChanged);
        
        self.setupNavBar();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false;
        self.navigationController?.navigationBar.isHidden = false
        loadArchievePosts();
        /*if (loggedInUser.isCastr == 1) {
            self.navigationItem.title = "My Casts";
        } else {
            self.navigationItem.title = "Moderator Casts";
        }*/
        self.navigationItem.title = "Archived Casts";
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc func menuButtonClicked() {
        let viewController: SideMenuTableViewController = self.storyboard?.instantiateViewController(withIdentifier: "SideMenuTableViewController") as! SideMenuTableViewController;
        self.navigationController?.pushViewController(viewController, animated: true);
    }
    @objc private func refreshPostsData(_ sender: Any) {
        
        //  In this methid call the home screen api
        self.loadArchievePosts();
        self.showBadgeCount();
        self.refreshControl.endRefreshing()
        
    }

    func showBadgeCount() {
        let loggedInUser = User().loadUserDataFromUserDefaults(userDataDict: setting);
        let jsonURL = "posts/get_notifications_count/format/json";
        var postArray = [String: Any]();
        if (loggedInUser.userId == nil) {
            return;
        }
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
                //let tabBarContro = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MadTabBar") as! UITabBarController
                
                if let tabItems = self.tabBarController?.tabBar.items {
                    // In this case we want to modify the badge number of the third tab:
                    var index = 0;
                    if (self.loggedInUser.isCastr == 1) {
                        index =  4;
                    } else {
                        index = 3;
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
    
    func setupNavBar() {
        let menuButton = UIButton();
               menuButton.setImage(UIImage.init(named: "menu"), for: .normal);
               menuButton.addTarget(self, action: #selector(menuButtonClicked), for: UIControl.Event.touchUpInside)
               menuButton.frame = CGRect.init(x: 0, y:0, width: 24, height: 24);
               
               let barButton = UIBarButtonItem(customView: menuButton)
               
               navigationItem.rightBarButtonItem = barButton;
               navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 12/255, green: 111/255, blue: 233/255, alpha: 1)
    }
    func loadArchievePosts() {
        
        var postArray : [String:Any] = [String:Any]();
        var jsonURL = "";
        if (loggedInUser.isCastr == 1) {
            jsonURL = "posts/all_caster_archive_posts/format/json";
        } else {
            jsonURL = "posts/all_moderator_casters_archive_posts/format/json";
        }
        postArray["user_id"] = String(loggedInUser.userId);
        
        UserService().postDataMethod(jsonURL: jsonURL, postData: postArray, complete: {(response) in
            
            print(response)

            let status = Int(response.value(forKey: "status") as! String)!
            if (status == 0) {
                //self.noPostsText.text = response.value(forKey: "message") as! String;
                /*let alert = UIAlertController.init(title: "Error", message: response.value(forKey: "message") as! String, preferredStyle: .alert);
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil));
                self.present(alert, animated: true)*/
            } else {
                let modeArray = response.value(forKey: "data") as! NSArray;
                print(modeArray)
                if (modeArray.count != 0) {
                    self.postsTableView.isHidden = false;
                    self.noArchiveCastsView.isHidden = true;

                    //self.homePosts = modeArray as! [Any]
                    self.posts = Post().loadPostsFromNSArray(postsArr: modeArray);
                    self.postsTableView.reloadData();
                    
                    /*if (self.loggedInUser.isCastr == 1) {
                        self.navigationItem.title = "My Casts (\(response.value(forKey: "count") as! Int))";
                    } else if (self.loggedInUser.isCastr == 1) {
                        self.navigationItem.title = "Moderator Casts (\(response.value(forKey: "count") as! Int))";
                    }*/
                    
                    self.navigationItem.title = "Archived Casts (\(response.value(forKey: "count") as! Int))";

                } else {
                    self.postsTableView.isHidden = true;
                    self.noArchiveCastsView.isHidden = false;
                }
            }
        });
    }
    
    func deleteButtonPresses(post: Post) {
        
        var postData = [String: Any]();
        postData["post_id"] = post.postId;
        postData["timestamp"] = Int64(Date().timeIntervalSince1970 * 1000.0);

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
                    self.loadArchievePosts();
                }
            });
        }));
        self.present(alert, animated: true)
    }
}

extension ArchieveViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        cell.parentTableIndexPath = indexPath;
        cell.postItemsTableView.reloadData();
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let post = self.posts[indexPath.row];

        var height: CGFloat = 0
        if (loggedInUser.isCastr == 2) {
            height += CGFloat(PostRowsHeight.Post_Status_Row_Height);
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
        } else if (heightOfDesc == 25) {
            heightOfDesc = 35;
        }
        //print("Height of Descriptiojn :  ",heightOfDesc, "POst Id : ", post.postId);
        let websiteUrl = extractWebsiteFromText(text: post.postDescription);
        if (websiteUrl == post.postDescription) {
            heightOfDesc = 10;//Default height of TV without text
        }
        height = height + heightOfDesc;
        
        if (websiteUrl != "") {
            height = height + CGFloat(PostRowsHeight.Post_WebsiteInfo_Row_Height);
        }
        if (post.postImages.count != 0) {
            height = height + CGFloat(PostRowsHeight.Post_Gallery_Row_Height);
        }
        
        return CGFloat(height);
    }
}
