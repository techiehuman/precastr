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

    var loggedInUser: User!;
    var posts: [Post] = [Post]();
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //postsTableView.register(UINib(nibName: "CasterViewTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "CasterViewTableViewCell");
        
        
        postsTableView.register(UINib(nibName: "PostItemTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "PostItemTableViewCell");
        loggedInUser = User().loadUserDataFromUserDefaults(userDataDict : setting);

        loadArchievePosts();
        self.navigationItem.title = "My Casts";
        
        self.setupNavBar();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false;
        self.navigationController?.navigationBar.isHidden = false

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

    func setupNavBar() {
        let menuButton = UIButton();
               menuButton.setImage(UIImage.init(named: "menu"), for: .normal);
               menuButton.addTarget(self, action: #selector(menuButtonClicked), for: UIControlEvents.touchUpInside)
               menuButton.frame = CGRect.init(x: 0, y:0, width: 24, height: 24);
               
               let barButton = UIBarButtonItem(customView: menuButton)
               
               navigationItem.rightBarButtonItem = barButton;
               navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 12/255, green: 111/255, blue: 233/255, alpha: 1)
    }
    func loadArchievePosts() {
        
        var postArray : [String:Any] = [String:Any]();
        let jsonURL = "posts/all_caster_archive_posts/format/json";
        postArray["user_id"] = String(loggedInUser.userId);
        
        UserService().postDataMethod(jsonURL: jsonURL, postData: postArray, complete: {(response) in
            
            print(response)

            let status = Int(response.value(forKey: "status") as! String)!
            if (status == 0) {
                //self.noPostsText.text = response.value(forKey: "message") as! String;
                let alert = UIAlertController.init(title: "Error", message: response.value(forKey: "message") as! String, preferredStyle: .alert);
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil));
                self.present(alert, animated: true)
            } else {
                let modeArray = response.value(forKey: "data") as! NSArray;
                print(modeArray)
                if (modeArray.count != 0) {
                    
                    //self.homePosts = modeArray as! [Any]
                    self.posts = Post().loadPostsFromNSArray(postsArr: modeArray);
                    self.postsTableView.reloadData();
                    
                    if (self.loggedInUser.isCastr == 1) {
                        self.navigationItem.title = "My Casts (\(response.value(forKey: "count") as! Int))";
                    }
                }
            }
        });
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
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let post = self.posts[indexPath.row];

        var height: CGFloat = CGFloat(PostRowsHeight.Post_Status_Row_Height);
        
        height = height + getHeightOfPostDescripiton(contentView: self.view, postDescription: post.postDescription) + CGFloat(PostRowsHeight.Post_Description_Row_Height);
        
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
