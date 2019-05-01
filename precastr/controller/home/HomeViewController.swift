//
//  HomeViewController.swift
//  precastr
//
//  Created by Macbook on 15/04/19.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var socialPostList: UITableView!
    var homePosts : [Any] = [Any]()
    var loggedInUser : User!
    
    
    class func MainViewController() -> UINavigationController{
        
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "nav") as! UINavigationController
        
    }
    
    
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
       // view.backgroundColor = UIColor (red: 0, green: 0.4745, blue: 0.9176, alpha: 1)
       /* let doneButton = UIButton(type: .system);
        doneButton.setTitle("Save", for: .normal);
       // doneButton.addTarget(self, action: #selector(selectFriendsDone(_ :)), for: .touchUpInside)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: doneButton); */
        loggedInUser = User().loadUserDataFromUserDefaults(userDataDict : setting);
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(addTapped))
        // Do any additional setup after loading the view.
        
        socialPostList.register(UINib(nibName: "HomeTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "HomeTableViewCell")
        
        
        let jsonURL = "posts/get_twitter_posts/format/json?user_id=\(String(loggedInUser.userId))&submit=1";
        print("loggedInUser")
        print(Int(loggedInUser.userId))
        UserService().getDataMethod(jsonURL: jsonURL,complete:{(response) in
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
    @objc func addTapped(){
        print("hello addTapped")
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
        
        let homeObject = self.homePosts[indexPath.row];
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell;
        print("******")
       
        cell.postTextLabel.text = (homeObject as AnyObject).value(forKey: "message") as? String
        cell.profileLabel.text = (homeObject as AnyObject).value(forKey: "screen_name") as? String
        cell.profileImage.image = (homeObject as AnyObject).value(forKey: "image_Url") as? UIImage
        
        cell.profileImage.layer.masksToBounds = false
        
        cell.profileImage.layer.cornerRadius = cell.profileImage.frame.height/2
        cell.profileImage.clipsToBounds = true
        cell.sourceImage.image = (homeObject as AnyObject).value(forKey: "sharing_media_Url") as? UIImage
        cell.sourceImage.layer.masksToBounds = false
        
        cell.sourceImage.layer.cornerRadius = cell.profileImage.frame.height/2
        cell.sourceImage.clipsToBounds = true

        
        cell.dateLabel.text = Calendar.current as? String
        return cell;
    }
}
