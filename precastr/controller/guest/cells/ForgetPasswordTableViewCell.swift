//
//  ForgetPasswordTableViewCell.swift
//  precastr
//
//  Created by Cenes_Dev on 08/06/2019.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit

class ForgetPasswordTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var resetPasswordBtn: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    var forgetPasswordCtrlDelegate: ForgetPasswordViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.emailTextField.attributedPlaceholder = NSAttributedString(string: "Email Address", attributes: [NSAttributedStringKey.foregroundColor : UIColor.white ])
        emailTextField.layer.borderColor = UIColor.white.cgColor;
        emailTextField.layer.borderWidth = 0.5;
        let emailIconContainerView: UIView = UIView(frame:
            CGRect(x: 20, y: 0, width: 40, height: self.emailTextField.frame.height));
        let emailImageView = UIImageView(frame: CGRect(x: 10, y: (emailIconContainerView.frame.height/2 - 30/2), width: 27, height: 30))
        let emailImage = UIImage(named: "email");
        emailImageView.image = emailImage;
        emailIconContainerView.addSubview(emailImageView)
        self.emailTextField.leftView = emailIconContainerView
        self.emailTextField.leftViewMode = .always
        
        let lineView = UIView(frame: CGRect(x: 2, y: self.loginButton.frame.size.height-1, width: self.loginButton.frame.size.width, height: 0.5))
        lineView.backgroundColor = UIColor.white
        self.loginButton.addSubview(lineView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func resetPasswordBtnPressed(_ sender: Any) {
        
        if (self.emailTextField.text == "") {
            forgetPasswordCtrlDelegate.showAlert(title: "Error", message: "Email cannot be empty")
        } else {
            var postData = [String: Any]();
            postData["email"] = self.emailTextField.text!;
            forgetPasswordCtrlDelegate.forgotPasswordRequest(postData: postData);
        }
    }
    
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        forgetPasswordCtrlDelegate.navigationController?.popViewController(animated: true);
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder();
        return true;
    }
}
