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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Do any additional setup after loading the view.
        notificationTableView.register(UINib.init(nibName: "NotificationTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "NotificationTableViewCell");
        self.hideKeyboadOnTapOutside();
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
