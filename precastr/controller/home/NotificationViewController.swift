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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Do any additional setup after loading the view.
        notificationTableView.register(UINib.init(nibName: "NotificationTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "NotificationTableViewCell");
        self.hideKeyboadOnTapOutside();
        self.loggedInUser = User().loadUserDataFromUserDefaults(userDataDict: setting);
        
        
         self.postData["user_id"] = self.loggedInUser.userId;
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: NotificationTableViewCell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell") as! NotificationTableViewCell;
        let jsonURL = "posts/get_notifications/format/json"
        HttpService().postMethod(url: jsonURL, postData: self.postData, complete: {(response) in
            print(response)
            
            let success = Int(response.value(forKey: "status") as! String)
            if (success == 0) {
                cell.isHidden =  true;
            }
            else {
                let modeArray = response.value(forKey: "data") as! NSArray;
                
                if (modeArray.count != 0) {
                    cell.isHidden = false
                    for notification in modeArray{
                        cell.profileTextView.text = (notification as AnyObject).value(forKey: "notification_message") as? String;
                        cell.dateTextView.text = Date().ddspEEEEcmyyyy(dateStr: (notification as AnyObject).value(forKey: "created_on") as! String)
                       // cell.profileImageView.sd_setImage(with: URL(string: notification as AnyObject).value(forKey: "created_on") as! String), placeholderImage: UIImage.init(named: "Moderate Casts"));
                        
                        
                    }
                   
                    
                } else {
                    
                }
            }
        });
        cell.notificationViewControllerDelegate = self;
        
        activityIndicator.center = cell.center;
        activityIndicator.hidesWhenStopped = true;
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge;
        cell.addSubview(activityIndicator);
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (self.view.frame.height + 120);
    }

}
