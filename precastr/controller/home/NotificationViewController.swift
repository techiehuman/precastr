//
//  NotificationViewController.swift
//  precastr
//
//  Created by Macbook on 10/06/19.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController {

    @IBOutlet weak var notificationTableView: UITableView!
    
    @IBOutlet weak var clearAllButton: UIButton!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView();
    var loggedInUser : User!
    var postData : [String : Any] = [String : Any]()
    var modeArray : NSArray = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setupNavigationBar();
        // Do any additional setup after loading the view.
        notificationTableView.register(UINib.init(nibName: "NotificationTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "NotificationTableViewCell");
        self.hideKeyboadOnTapOutside();
        self.loggedInUser = User().loadUserDataFromUserDefaults(userDataDict: setting);
        
        activityIndicator.activityIndicatorViewStyle = .gray;
        activityIndicator.center = view.center;
        self.view.addSubview(activityIndicator);
        
        self.postData["user_id"] = self.loggedInUser.userId;
        if (self.loggedInUser.isCastr == 1) {
            self.postData["role_id"] = 0;
        } else {
            self.postData["role_id"] = 1;
        }
        
        self.loadNotifications();
       /* let jsonURL = "posts/update_notification_status/format/json"
        
        UserService().postDataMethod(jsonURL: jsonURL, postData: self.postData, complete: {(response) in
            print(response)
            
            let success = Int(response.value(forKey: "status") as! String)!
            if (success == 1) {
                if let tabItems = self.tabBarController?.tabBar.items {
                    // In this case we want to modify the badge number of the third tab:
                    var index = 0;
                    if (self.loggedInUser.isCastr == 1) {
                        index =  3;
                    } else {
                        index = 2;
                    }
                    let tabItem = tabItems[index]
                    tabItem.badgeValue = nil
                }
            }else{
                
            }
        });*/
        if let tabItems = self.tabBarController?.tabBar.items {
            // In this case we want to modify the badge number of the third tab:
            var index = 0;
            if (self.loggedInUser.isCastr == 1) {
                index =  3;
            } else {
                index = 2;
            }
            let tabItem = tabItems[index]
            tabItem.badgeValue = nil
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        //If Logged in user is a moderator, then we will
        self.loggedInUser = User().loadUserDataFromUserDefaults(userDataDict: setting);
        self.postData["user_id"] = self.loggedInUser.userId;
        if (self.loggedInUser.isCastr == 1) {
            self.postData["role_id"] = 0;
        } else {
            self.postData["role_id"] = 1;
        }
        
        self.setupNavigationBar();
        self.loadNotifications();
        
        if (loggedInUser.isCastr == 2) {
            self.navigationItem.title = "Notifications";
            
            if (self.tabBarController!.viewControllers?.count == 4) {
                self.tabBarController!.viewControllers?.remove(at: 1)
            }
        } else {
            self.navigationItem.title = "Notifications";
            
            if (self.tabBarController!.viewControllers?.count == 3) {
                
                var navController = self.storyboard?.instantiateViewController(withIdentifier: "CreateNewPostNavController") as! UINavigationController;
                self.tabBarController!.viewControllers?.insert(navController, at: 1);
            }
        }
    }

    func loadNotifications() {
        let jsonURL = "posts/get_notifications/format/json"
        activityIndicator.startAnimating();
        UserService().postDataMethod(jsonURL: jsonURL, postData: self.postData, complete: {(response) in
            print(response)
            self.activityIndicator.stopAnimating();
            let success = Int(response.value(forKey: "status") as! String)!
            if (success == 0) {
                self.notificationTableView.isHidden =  true;
                let message = response.value(forKey: "message") as! String;
                self.showAlert(title: "Error", message: message);
            }else{
                 self.modeArray = response.value(forKey: "data") as! NSArray;
                if(self.modeArray.count == 0){
                    self.notificationTableView.isHidden =  true;
                }else{
                    self.notificationTableView.isHidden =  false;
                    self.notificationTableView.reloadData()
                }
            }
        });
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func setupNavigationBar(){
        let menuButton = UIButton();
        menuButton.setImage(UIImage.init(named: "menu"), for: .normal);
        menuButton.addTarget(self, action: #selector(menuButtonClicked), for: UIControlEvents.touchUpInside)
        menuButton.frame = CGRect.init(x: 0, y:0, width: 24, height: 24);
        
        let barButton = UIBarButtonItem(customView: menuButton)
        
        navigationItem.rightBarButtonItem = barButton;
        navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 12/255, green: 111/255, blue: 233/255, alpha: 1);
        
        self.tabBarController?.tabBar.isHidden = false;

    }
    
    func clearAllNotification() {
        //http://lyonsdemoz.website/pre-caster/api/posts/clear_notification/format/json
        
        let jsonURL = "posts/clear_notification/format/json"
        activityIndicator.startAnimating();
        UserService().postDataMethod(jsonURL: jsonURL, postData: self.postData, complete: {(response) in
            print(response)
            self.activityIndicator.stopAnimating();
            let success = Int(response.value(forKey: "status") as! String)!
            if (success == 0) {
                let message = response.value(forKey: "message") as! String;
                self.showAlert(title: "Error", message: message);
            } else {
                self.loadNotifications();
            }
        });
    }
    
    func markNotificationAsRead(notificationId: Int) {
        PostService().markNotificationAsRead(notificationId: notificationId, complete: {(response) in
            
        });
    }
    
    @objc func menuButtonClicked() {
        let viewController: SideMenuTableViewController = self.storyboard?.instantiateViewController(withIdentifier: "SideMenuTableViewController") as! SideMenuTableViewController;
        self.navigationController?.pushViewController(viewController, animated: true);
    }
    
    @IBAction func clearButtonPressed(_ sender: Any) {
        clearAllNotification();
    }
    @objc func postDescriptionPressed(sender:MyTapRecognizer){
        
        self.markNotificationAsRead(notificationId: sender.notificationId);
        
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "CommunicationViewController") as! CommunicationViewController;
        viewController.postId = sender.postId;
        self.navigationController?.pushViewController(viewController, animated: true);
    }
    class MyTapRecognizer : UITapGestureRecognizer {
        var postId: Int!;
        var notificationId: Int!;
    }
    
}
extension NotificationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.modeArray.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let notification = modeArray[indexPath.row] as AnyObject;
        print("*****");
        print(Int(notification.value(forKey: "post_id") as! String)!);
        let cell: NotificationTableViewCell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell") as! NotificationTableViewCell;
        
        let postDescTap = MyTapRecognizer.init(target: self, action: #selector(postDescriptionPressed(sender:)));
        postDescTap.postId = Int(notification.value(forKey: "post_id") as! String)! ;
        postDescTap.notificationId = Int(notification.value(forKey: "notification_id") as! String)!;
        cell.notificationTextView.addGestureRecognizer(postDescTap)
        //This is your label
        for view in cell.notificationTextView.subviews {
            view.removeFromSuperview();
        }
        //Call this function
        let height = self.heightForView(text: (notification.value(forKey: "notification_message") as? String)!, font: UIFont.init(name: "VisbyCF-Regular", size: 16.0)!, width: self.view.frame.width - 85);
        
        let notificationLabel  = UILabel.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 85, height: height));
        let lblToShow = "\(notification.value(forKey: "notification_message") as! String)"
        notificationLabel.numberOfLines = 0
        notificationLabel.lineBreakMode = .byWordWrapping
        let paragraphStyle = NSMutableParagraphStyle()
        //line height size
        paragraphStyle.lineSpacing = 2
        
        let attributes = [
            NSAttributedStringKey.font : UIFont(name: "VisbyCF-Regular", size: 16.0)!,
            NSAttributedStringKey.foregroundColor : UIColor.init(red: 34/255, green: 34/255, blue: 34/255, alpha: 1),
            NSAttributedStringKey.paragraphStyle: paragraphStyle]
        
        let attrString = NSMutableAttributedString(string: lblToShow)
        attrString.addAttributes(attributes, range: NSMakeRange(0, attrString.length));
        notificationLabel.attributedText = attrString;
        cell.notificationTextView.addSubview(notificationLabel);
        
        cell.notificationTextView.frame = CGRect.init(x: cell.notificationTextView.frame.origin.x, y: 12, width: self.view.frame.width - 85, height: height);
        
        //cell.profileTextView.text = notification.value(forKey: "notification_message") as? String;
        //print(notification.value(forKey: "created_on") as! String)
        cell.dateTextView.text = Date().ddspEEEEcmyyyyspHHclmmclaa(dateStr: notification.value(forKey: "created_on") as! String)
        cell.dateTextView.frame = CGRect.init(x: cell.dateTextView.frame.origin.x, y: 12 + height, width: cell.dateTextView.intrinsicContentSize.width, height: 20);

        cell.profileImageView.sd_setImage(with: URL(string: notification.value(forKey: "profile_pic") as! String), placeholderImage: UIImage.init(named: "Moderate Casts"));

        cell.notificationViewControllerDelegate = self;
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let notification = modeArray[indexPath.row] as AnyObject;

        let height = self.heightForView(text: (notification.value(forKey: "notification_message") as? String)!, font: UIFont.init(name: "VisbyCF-Regular", size: 16.0)!, width: self.view.frame.width - 85);

        return height + 20 + 20;
    }

}
