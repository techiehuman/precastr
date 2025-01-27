//
//  SplashViewController.swift
//  precastr
//
//  Created by Macbook on 11/05/19.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    @IBOutlet weak var splashStar: UIImageView!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 12/255, green: 111/255, blue: 233/255, alpha: 1)
        // Do any additional setup after loading the view.
        //splashStar.transform = CGAffineTransform(scaleX: -1, y: 1)
         
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.y")
        rotation.toValue = NSNumber(value: Double.pi * 1.5)
        rotation.duration = 2
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        self.splashStar.layer.add(rotation, forKey: "rotationAnimation")


        perform(#selector(navigateUser), with: nil, afterDelay: 4)
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
                
        if let user_id = setting.value(forKey: "user_id") as? Int32 {
            
            let userDefaultRole = setting.value(forKey: "default_role") as? Int8 ?? nil
            let user_cast_setting_id = setting.value(forKey: "user_cast_setting_id") as? Int32 ?? nil;
            let phone_number = setting.value(forKey: "phone_number") as? String ?? nil;
            
            if(phone_number == "" || phone_number == nil){
                self.performSegue(withIdentifier: "splashUpdatePhoneSegue", sender: self)
            } else if (userDefaultRole == nil || userDefaultRole == 0) {
                performSegue(withIdentifier: "userTypeSegue", sender: self)
                
            } else if(userDefaultRole == 1 && (user_cast_setting_id == nil || user_cast_setting_id == 0)) {
                 UIApplication.shared.keyWindow?.rootViewController = HomeV2ViewController.MainViewController();
               // performSegue(withIdentifier: "castTypeSegue", sender: self)
                
            } else {
                // Override point for customization after application launch.
                //performSegue(withIdentifier: "homeScreenSegue", sender: self)
                //window = UIWindow(frame: UIScreen.main.bounds)
                //window?.rootViewController = HomeViewController.MainViewController()

                UIApplication.shared.keyWindow?.rootViewController = HomeV2ViewController.MainViewController();
            }
        }else{
            UIApplication.shared.keyWindow?.rootViewController = LoginScreenViewController.MainViewController()
            //performSegue(withIdentifier: "loginScreenSegue", sender: self)

        }
    }
}
