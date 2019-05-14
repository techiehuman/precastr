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
        
        verifyCode1.keyboardType = UIKeyboardType.numberPad
        verifyCode2.keyboardType = UIKeyboardType.numberPad
        verifyCode3.keyboardType = UIKeyboardType.numberPad
        verifyCode4.keyboardType = UIKeyboardType.numberPad
        loggedInUser = User().loadUserDataFromUserDefaults(userDataDict : setting);
        userProfilePic.roundImageView();
        userProfilePic.layer.borderWidth = 2
        userProfilePic.layer.borderColor = UIColor.white.cgColor
        if(String(loggedInUser.profilePic) != ""){
            userProfilePic.sd_setImage(with: URL(string: loggedInUser.profilePic!), placeholderImage: UIImage.init(named: "default_profile_pic"));
            // Do any additional setup after loading the view.
        }else{
            let profileImage: UIImage = UIImage(named: "profile")!
            userProfilePic.image = profileImage
        }
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
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if(textField == verifyCode1 && verifyCode1.text!.count==1){
            verifyCode2.becomeFirstResponder()
        }else if(textField == verifyCode2 && verifyCode2.text!.count==1){
            verifyCode3.becomeFirstResponder()
        }else if(textField == verifyCode3 && verifyCode3.text!.count==1){
            verifyCode4.becomeFirstResponder()
        }else if(textField == verifyCode4 && verifyCode4.text!.count==1){
            verifyCode4.resignFirstResponder()
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == verifyCode1 && verifyCode1.text!.count==1){
            verifyCode2.becomeFirstResponder()
        }else if(textField == verifyCode2 && verifyCode2.text!.count==1){
            verifyCode3.becomeFirstResponder()
        }else if(textField == verifyCode3 && verifyCode3.text!.count==1){
            verifyCode4.becomeFirstResponder()
        }else if(textField == verifyCode4 && verifyCode4.text!.count==1){
            verifyCode4.resignFirstResponder()
        }
        return true
    }
}
