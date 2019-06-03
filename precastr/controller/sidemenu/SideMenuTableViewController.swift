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
    
    private var dateCellExpanded: Bool = false
    var rowTypeVar : Bool = false
    var loggedInUser: User!;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.loggedInUser = User().loadUserDataFromUserDefaults(userDataDict: setting);
        self.profilePic.roundImageView()
        if (self.loggedInUser.name == nil) {
            nameLabel.text = self.loggedInUser.name;
        } else {
            nameLabel.text = self.loggedInUser.username;
        }
    
        profilePic.sd_setImage(with: URL(string: self.loggedInUser.profilePic), placeholderImage: UIImage.init(named: "profile"));
        
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navVC = segue.destination as! ModeratorViewController
       navVC.moderatorBool = rowTypeVar
        
    }
    
    func logout() {
        
        let alert = UIAlertController.init(title: "Logout!", message: "Are you sure?", preferredStyle: .alert);
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil));
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(response) in
            let defaults = UserDefaults.standard
            let dictionary = defaults.dictionaryRepresentation()
            dictionary.keys.forEach { key in
                defaults.removeObject(forKey: key)
            }
            UIApplication.shared.keyWindow?.rootViewController = LoginStep1ViewController.MainViewController();
        }));

        self.present(alert, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if indexPath.row == 2 {
            
            
            
          
            rowTypeVar = true
           // let viewController: ModeratorViewController = self.storyboard?.instantiateViewController(withIdentifier: "ModeratorViewController") as! ModeratorViewController;
          //  self.navigationController?.pushViewController(viewController, animated: true);
            self.performSegue(withIdentifier: "moderatorSegue", sender: self);
            
        } else if(indexPath.row == 3){
            rowTypeVar = true
           // let viewController: ModeratorViewController = self.storyboard?.instantiateViewController(withIdentifier: "ModeratorViewController") as! ModeratorViewController;
           // self.navigationController?.pushViewController(viewController, animated: true);
            self.performSegue(withIdentifier: "moderatorSegue", sender: self);
        } else if(indexPath.row == 7){
            self.logout();
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
