//
//  TableTableViewController.swift
//  precastr
//
//  Created by Macbook on 16/04/19.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit

class TableTableViewController: UITableViewController {

    private var dateCellExpanded: Bool = false
    var rowTypeVar : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navVC = segue.destination as! ModeratorViewController
       navVC.moderatorBool = rowTypeVar
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       /* if  indexPath.row == 0 {
            if dateCellExpanded {
                dateCellExpanded = false
            } else {
                dateCellExpanded = true
            }
            tableView.beginUpdates()
            tableView.endUpdates()
        } */
        if indexPath.row == 2 {
            
            
            
          /*
            if dateCellExpanded {
                dateCellExpanded = false
            } else {
                dateCellExpanded = true
            }
            tableView.beginUpdates()
            tableView.endUpdates() */
            rowTypeVar = true
           // let viewController: ModeratorViewController = self.storyboard?.instantiateViewController(withIdentifier: "ModeratorViewController") as! ModeratorViewController;
          //  self.navigationController?.pushViewController(viewController, animated: true);
            self.performSegue(withIdentifier: "moderatorSegue", sender: self);
            
        }
        if(indexPath.row == 3){
            rowTypeVar = false
           // let viewController: ModeratorViewController = self.storyboard?.instantiateViewController(withIdentifier: "ModeratorViewController") as! ModeratorViewController;
           // self.navigationController?.pushViewController(viewController, animated: true);
            self.performSegue(withIdentifier: "moderatorSegue", sender: self);
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       // if indexPath.row == 0 {
           /* if dateCellExpanded {
                return 110
            } else {
                return 50
            } */
       // }
        return 107
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
