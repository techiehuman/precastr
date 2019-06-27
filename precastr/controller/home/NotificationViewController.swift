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
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView();
    var loggedInUser : User!
    var postData : [String : Any] = [String : Any]()
    var modeArray : NSArray = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // Do any additional setup after loading the view.
        notificationTableView.register(UINib.init(nibName: "NotificationTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "NotificationTableViewCell");
        self.hideKeyboadOnTapOutside();
        self.loggedInUser = User().loadUserDataFromUserDefaults(userDataDict: setting);
        
        
         self.postData["user_id"] = self.loggedInUser.userId;
        
        self.loadNotifications();
        let jsonURL = "posts/update_notification_status/format/json"
        
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
            }
        });

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.loadNotifications();
    }

    func loadNotifications() {
        let jsonURL = "posts/get_notifications/format/json"
       
        UserService().postDataMethod(jsonURL: jsonURL, postData: self.postData, complete: {(response) in
            print(response)
           
            let success = Int(response.value(forKey: "status") as! String)!
            if (success == 0) {
                self.notificationTableView.isHidden =  true;
                let message = response.value(forKey: "message") as! String;
                self.showAlert(title: "Error", message: message);
            }else{
                 self.modeArray = response.value(forKey: "data") as! NSArray;
                self.notificationTableView.isHidden =  false;
                self.notificationTableView.reloadData()
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
        
        let cell: NotificationTableViewCell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell") as! NotificationTableViewCell;
        
                
        cell.profileTextView.text = notification.value(forKey: "notification_message") as? String;
        print(notification.value(forKey: "created_on") as! String)
        cell.dateTextView.text = Date().ddspEEEEcmyyyyspHHclmmclaa(dateStr: notification.value(forKey: "created_on") as! String)
        cell.profileImageView.sd_setImage(with: URL(string: notification.value(forKey: "profile_pic") as! String), placeholderImage: UIImage.init(named: "Moderate Casts"));

        
        cell.notificationViewControllerDelegate = self;
        
        activityIndicator.center = cell.center;
        activityIndicator.hidesWhenStopped = true;
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge;
        //cell.addSubview(activityIndicator);
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80;
    }

}
