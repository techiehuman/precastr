//
//  UserTypeActionViewController.swift
//  precastr
//
//  Created by Macbook on 12/04/19.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit

class UserTypeActionViewController: UIViewController {

    @IBOutlet weak var casterButton: UIButton!
    
    @IBOutlet weak var moderatorButton: UIButton!
    
    var loggedInUser : User!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loggedInUser = User().loadUserDataFromUserDefaults(userDataDict : setting);
        // Do any additional setup after loading the view.
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

    @IBAction func casterButtonAction(_ sender: Any) {
        let viewController: PrecastTypeSectionViewController = self.storyboard?.instantiateViewController(withIdentifier: "PrecastTypeSectionViewController") as! PrecastTypeSectionViewController;
        self.navigationController?.pushViewController(viewController, animated: true);
    }
    
    @IBAction func moderatorButtonAction(_ sender: Any) {
    }
    
   
}