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
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func scrollTableToPosition(indexPath: IndexPath) {
        postsTableView.scrollToRow(at: indexPath, at: .top, animated: true);
    }
    
    func loadArchievePosts() {
        
        var postArray : [String:Any] = [String:Any]();
        let jsonURL = "posts/all_caster_posts/format/json";
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
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let post = self.posts[indexPath.row];

        var height: CGFloat = CGFloat(PostRowsHeight.Post_Status_Row_Height + PostRowsHeight.Post_Action_Row_Height);
        
        height = height + getHeightOfPostDescripiton(contentView: self.view, postDescription: post.postDescription) + CGFloat(PostRowsHeight.Post_Description_Row_Height);

        let cell = tableView.cellForRow(at: indexPath) as! PostItemTableViewCell;
        if (cell.isShareMenuOpened == true) {
            
        }
        if (post.postImages.count != 0) {
            height = height + CGFloat(PostRowsHeight.Post_Gallery_Row_Height);
        }
        
        return CGFloat(height);
    }
}
