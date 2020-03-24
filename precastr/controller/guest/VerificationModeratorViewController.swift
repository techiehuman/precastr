//
//  VerificationModeratorViewController.swift
//  precastr
//
//  Created by Macbook on 14/05/19.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit

class VerificationModeratorViewController: UIViewController,UITextFieldDelegate {

     var loggedInUser : User!
    
    @IBOutlet weak var userProfilePic: UIImageView!
    
    
    @IBOutlet weak var verifyCode1: UITextField!
    
    @IBOutlet weak var verifyCode2: UITextField!
    
    @IBOutlet weak var verifyCode3: UITextField!
    
    @IBOutlet weak var verifyCode4: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        verifyCode1.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged);
        verifyCode2.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged);
        verifyCode3.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged);
        verifyCode4.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged);
        
        verifyCode1.becomeFirstResponder();
        
        loggedInUser = User().loadUserDataFromUserDefaults(userDataDict : setting);
        userProfilePic.roundImageView();
        userProfilePic.layer.borderWidth = 2
        userProfilePic.layer.borderColor = UIColor.white.cgColor
        if(String(loggedInUser.profilePic) != ""){
            userProfilePic.sd_setImage(with: URL(string: loggedInUser.profilePic!), placeholderImage: UIImage.init(named: "Profile-1"));
            // Do any additional setup after loading the view.
        }
        // Do any additional setup after loading the view.
        self.hideKeyboadOnTapOutside();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        
        let text = textField.text;
        
        if (text!.count == 1) {
            
            switch textField {
            case verifyCode1:
                verifyCode2.text = "";
                verifyCode2.becomeFirstResponder();
                
            case verifyCode2:
                verifyCode3.text = "";
                verifyCode3.becomeFirstResponder();
                
            case verifyCode3:
                verifyCode4.text = "";
                verifyCode4.becomeFirstResponder();
                
            case verifyCode4:
                verifyCode4.resignFirstResponder();
                
            default:
                break;
            }
            
        }
    }
    
    @IBAction func verifyBtnClicked(_ sender: Any) {
        
        var postData = [String: Any]();
        postData["user_id"] = self.loggedInUser.userId
        let otp = "\(self.verifyCode1.text!)\(self.verifyCode2.text!)\(self.verifyCode3.text!)\(self.verifyCode4.text!)";
        if (otp.count < 4) {
            let alert = UIAlertController.init(title: "Error", message: "Please enter the code", preferredStyle: .alert);
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil));
            self.present(alert, animated: true)
        } else {
            postData["otp"] = String(otp)
            let jsonURL = "user/verify_user_otp/format/json";
            UserService().postDataMethod(jsonURL: jsonURL,postData:postData,complete:{(response) in
                print(response)
                 if (Int(response.value(forKey: "status") as! String)! == 0) {
                    let message = response.value(forKey: "message") as! String;
                    
                    let alert = UIAlertController.init(title: "Error", message: message, preferredStyle: .alert);
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil));
                    self.present(alert, animated: true)
                    
                 }else{
                    UIApplication.shared.keyWindow?.rootViewController = HomeV2ViewController.MainViewController();
                }
            });
        }
        
    }
}
