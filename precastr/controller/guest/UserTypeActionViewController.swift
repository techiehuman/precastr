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
    
    @IBOutlet weak var userProfilePic: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loggedInUser = User().loadUserDataFromUserDefaults(userDataDict : setting);
        userProfilePic.roundImageView();
        userProfilePic.layer.borderWidth = 1
        userProfilePic.layer.borderColor = UIColor.white.cgColor
        userProfilePic.image = UIImage(url: URL(string: "https://cdn.pixabay.com/photo/2013/07/13/11/44/penguin-158551__340.png"))
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
