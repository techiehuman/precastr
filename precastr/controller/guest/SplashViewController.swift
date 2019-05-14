//
//  SplashViewController.swift
//  precastr
//
//  Created by Macbook on 11/05/19.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 12/255, green: 111/255, blue: 233/255, alpha: 1)
        // Do any additional setup after loading the view.
        perform(#selector(navigateUser), with: nil, afterDelay: 3)
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

    @objc func navigateUser() {
        if let user_id = setting.value(forKey: "user_id") {
            let user_cast_setting_id = (setting.value(forKey: "user_cast_setting_id") as! NSNumber);
                
            if(user_cast_setting_id == 0){
                performSegue(withIdentifier: "userTypeSegue", sender: self)
            }else{
                
            
            // Override point for customization after application launch.
            performSegue(withIdentifier: "homeScreenSegue", sender: self)
            //window = UIWindow(frame: UIScreen.main.bounds)
            //window?.rootViewController = HomeViewController.MainViewController()
            }
        }else{
            //window = UIWindow(frame: UIScreen.main.bounds)
            
            //window?.rootViewController = LoginStep1ViewController.MainViewController()
            performSegue(withIdentifier: "loginScreenSegue", sender: self)

        }
    }
}
