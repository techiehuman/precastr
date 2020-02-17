//
//  TableTableViewController.swift
//  precastr
//
//  Created by Macbook on 16/04/19.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit

class SideMenuTableViewController: UITableViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var moderatorRoleSwitch: UISwitch!
    @IBOutlet weak var casterRoleSwitch: UISwitch!
    @IBOutlet weak var moderatorTableCell : UITableViewCell!
    @IBOutlet weak var casterTableCell : UITableViewCell!

    private var dateCellExpanded: Bool = false
    var rowTypeVar : Bool = false
    var loggedInUser: User!;
    var sideMenuOpenedFromScreen = "";
     var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView();
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.loggedInUser = User().loadUserDataFromUserDefaults(userDataDict: setting);
        self.profilePic.roundImageView()
        if (self.loggedInUser.name != nil) {
            nameLabel.text = self.loggedInUser.name;
        } else {
            nameLabel.text = self.loggedInUser.username;
        }
    
        if (self.loggedInUser.isCastr == 1) {
            moderatorRoleSwitch.setOn(false, animated: false);
            casterRoleSwitch.setOn(true, animated: false);
            moderatorTableCell.backgroundColor = UIColor.white
            casterTableCell.backgroundColor = UIColor(red: 221/255, green: 223/255, blue: 226/255, alpha: 1)
            
        } else if (self.loggedInUser.isCastr == 2) {
            moderatorRoleSwitch.setOn(true, animated: false);
            casterRoleSwitch.setOn(false, animated: false);
            moderatorTableCell.backgroundColor = UIColor(red: 221/255, green: 223/255, blue: 226/255, alpha: 1)
            casterTableCell.backgroundColor = UIColor.white
            
        }
        //moderatorRoleSwitch.isEnabled = false;
        profilePic.sd_setImage(with: URL(string: self.loggedInUser.profilePic), placeholderImage: UIImage.init(named: "Moderate Casts"));
        
        print("Table Reloadedddd...");
        activityIndicator.center = self.view.center;
        activityIndicator.hidesWhenStopped = true;
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray;
        self.view.addSubview(activityIndicator);
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true;
        self.setUpNavigationBarItems();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "moderatorSegue") {
            let navVC = segue.destination as! ModeratorViewController
            navVC.moderatorBool = rowTypeVar
            
        }

    }
    
    @IBAction func moderatorSwitchChanged(_ sender: Any) {
        moderatorRoleSwitch.setOn(true, animated: false)
        casterRoleSwitch.setOn(false, animated: false)
       changeAccountStatus();
    }
    
    @IBAction func casterSwitchChanged(_ sender: Any) {
        casterRoleSwitch.setOn(true, animated: false)
        moderatorRoleSwitch.setOn(false, animated: false)

        changeAccountStatus();
    }
    
    func changeAccountStatus(){
        self.activityIndicator.startAnimating();
        if (casterRoleSwitch.isOn == true) {
            self.loggedInUser.isCastr = 1;
            User().updateUserRole(roleId: 1);
            
            var vewContrs = UIApplication.shared.keyWindow?.rootViewController?.tabBarController?.viewControllers
            vewContrs?.remove(at: 1);
            UIApplication.shared.keyWindow?.rootViewController?.tabBarController?.viewControllers = vewContrs;
            self.showToastMultipleLines(message: "You have turned ON the \"CASTER MODE\".\nPlease go on the \"Home Screen\" and manage your casts.")
            moderatorRoleSwitch.setOn(false, animated: false)
            casterRoleSwitch.setOn(true, animated: false)
            moderatorTableCell.backgroundColor = UIColor.white
            casterTableCell.backgroundColor = UIColor(red: 221/255, green: 223/255, blue: 226/255, alpha: 1)
        } else if(moderatorRoleSwitch.isOn == true) {
            self.loggedInUser.isCastr = 2;
            User().updateUserRole(roleId: 2);
            self.showToastMultipleLines(message: "You have turned ON the \"MODERATOR MODE\".\nPlease go on the \"Home Screen\" and moderate the casts..");
            moderatorRoleSwitch.setOn(true, animated: false)
            casterRoleSwitch.setOn(false, animated: false)
            moderatorTableCell.backgroundColor = UIColor(red: 221/255, green: 223/255, blue: 226/255, alpha: 1)
            casterTableCell.backgroundColor = UIColor.white
            
        }
        self.tableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5), execute:  {
//            self.showAlert(title: "alert", message: "ruk jao")
            self.activityIndicator.stopAnimating();
            UIApplication.shared.keyWindow?.rootViewController = HomeV2ViewController.MainViewController();
        })
        
        
        
    }
    
    func logout() {
        
        let alert = UIAlertController.init(title: "Logout!", message: "Are you sure?", preferredStyle: .alert);
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil));
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(response) in
            let defaults = UserDefaults.standard
            let dictionary = defaults.dictionaryRepresentation()
            dictionary.keys.forEach { key in
                if (key != "tokenData") {
                    defaults.removeObject(forKey: key);
                }
            }
            UIApplication.shared.keyWindow?.rootViewController = LoginScreenViewController.MainViewController();
        }));

        self.present(alert, animated: true)
    }
    
    func setUpNavigationBarItems() {
        
        let menuButton = UIButton();
        menuButton.setImage(UIImage.init(named: "left-arrow"), for: .normal);
        menuButton.addTarget(self, action: #selector(backButtonPressed), for: UIControlEvents.touchUpInside)
        menuButton.frame = CGRect.init(x: 0, y:0, width: 16.73, height: 10.89);
        
        let barButton = UIBarButtonItem(customView: menuButton)
        navigationItem.leftBarButtonItem = barButton;
        
        
        let homeButton = UIButton();
        homeButton.setImage(UIImage.init(named: "top-home"), for: .normal);
        homeButton.addTarget(self, action: #selector(homeButtonPressed), for: UIControlEvents.touchUpInside)
        homeButton.frame = CGRect.init(x: 0, y:0, width: 20, height: 20);
        
        let homeBarButton = UIBarButtonItem(customView: homeButton)
        
        navigationItem.rightBarButtonItem = homeBarButton;
        navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 12/255, green: 111/255, blue: 233/255, alpha: 1)
    }
    
    @objc func backButtonPressed() {
        if (sideMenuOpenedFromScreen == SideMenuSource.CREATE) {
            UIApplication.shared.keyWindow?.rootViewController = HomeV2ViewController.MainViewController();
        } else {
            self.navigationController?.popViewController(animated: true);
        }
    }
    
    @objc func homeButtonPressed() {
        UIApplication.shared.keyWindow?.rootViewController = HomeV2ViewController.MainViewController();
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0://Profile Tab
            print("")
        case 1://Moderator
            print("")
        case 2://Membership
            print("")

        case 3://Moderators
            self.performSegue(withIdentifier: "moderatorSegue", sender: self);
        case 4://Casters
            self.performSegue(withIdentifier: "casterSegue", sender: self);
        
            
        case 5://FAQ
            print("")
            
        case 6://FAQ
            print("")
           
        case 7://Terms ANd Conds
           self.performSegue(withIdentifier: "termSetting", sender: self)
            print("")
        case 8:
            self.logout();

        default:
            print("")
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 70;
        case 1://Moderator
            return 50;
        case 2:
            return 50;
        case 3://Moderators
            if (loggedInUser.isCastr == 1) {//If Logged In User is Caster We will show Moderators Row
                return 50
            } else {
                return 0;//If Logged In User is Moderator We will hide Moderators Row
            }
        case 4://Casters
            if (loggedInUser.isCastr == 2) {//If Logged In User is Caster We will show Moderators Row
                return 50
            } else {
                return 0;//If Logged In User is Moderator We will hide Moderators Row
            }
        case 5:
            return 50;
        case 6:
            return 50;
        default:
            return 50;
        }

    }
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
