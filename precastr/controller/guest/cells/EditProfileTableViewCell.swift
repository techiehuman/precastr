//
//  EditProfileTableViewCell.swift
//  precastr
//
//  Created by Macbook on 07/06/19.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit

class EditProfileTableViewCell: UITableViewCell,UITextFieldDelegate, EditProfileTableViewCellProtocol {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameUIView: UIView!
    @IBOutlet weak var cameraUIView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var invitationUIView: UIView!
    @IBOutlet weak var invitationCodeLabel: UILabel!
    
    @IBOutlet weak var updateNameButton: UIButton!
    
    @IBOutlet weak var currentPasswordTextField: UITextField!
    
    @IBOutlet weak var confirmPasswordTxtField: UITextField!
    
    @IBOutlet weak var updatePasswordBtn: UIButton!
    @IBOutlet weak var emailTextLabel: UILabel!
    
    var editProfileViewControllerDelegate: EditProfileViewController!;
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
        self.cameraUIView.roundView();
        self.cameraUIView.layer.backgroundColor = UIColor.white.cgColor
        self.cameraUIView.layer.borderWidth = 1
        self.cameraUIView.layer.borderColor = UIColor(red: 12/255, green: 111/255, blue: 233/255, alpha: 1.0).cgColor
        self.profileImageView.roundView();
        self.profileImageView.layer.borderWidth = 2
        self.profileImageView.layer.borderColor = UIColor(red: 12/255, green: 111/255, blue: 233/255, alpha: 1.0).cgColor
        
        let cameraTap = UITapGestureRecognizer.init(target: self, action: #selector(cameraViewPressed));
        cameraUIView.addGestureRecognizer(cameraTap);
        
        let lineView = UIView(frame: CGRect(x: 0, y: self.nameTextField.frame.height-1, width: self.nameTextField.bounds.width - 30, height: 0.5))
        lineView.backgroundColor = UIColor.init(red: 146/255, green: 147/255, blue: 149/255, alpha: 1)
        self.nameTextField.addSubview(lineView)
        
        let uplineView = UIView(frame: CGRect(x: 0, y: self.currentPasswordTextField.frame.height - 1, width: self.currentPasswordTextField.bounds.width - 30, height: 0.5))
        uplineView.backgroundColor = UIColor.init(red: 146/255, green: 147/255, blue: 149/255, alpha: 1)
        self.currentPasswordTextField.addSubview(uplineView)
        
        
        let cplineView = UIView(frame: CGRect(x: 0, y: self.confirmPasswordTxtField.frame.height - 1, width: self.confirmPasswordTxtField.bounds.width - 30, height: 0.5))
        cplineView.backgroundColor = UIColor.init(red: 146/255, green: 147/255, blue: 149/255, alpha: 1)
        self.confirmPasswordTxtField.addSubview(cplineView)
        
        updateNameButton.layer.cornerRadius = 4;
        updatePasswordBtn.layer.cornerRadius = 4;
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func updateNameButtonPressed(_ sender: Any) {
        
        if (nameTextField.text == "") {
            editProfileViewControllerDelegate.showAlert(title: "Alert", message: "Name cannot be empty");
        } else {
            var postData = [String: Any]();
            postData["name"] = nameTextField.text!;
            postData["user_id"] = "\(editProfileViewControllerDelegate.loggedInUser.userId!)";
            editProfileViewControllerDelegate.updateNameProfilePic(postData: postData)
        }
    }
    
    
    @IBAction func updatePasswordBtnPressed(_ sender: Any) {
        
        if (currentPasswordTextField.text == "") {
            editProfileViewControllerDelegate.showAlert(title: "Alert", message: "Password cannot be empty");
        } else if (currentPasswordTextField.text != confirmPasswordTxtField.text) {
            editProfileViewControllerDelegate.showAlert(title: "Alert", message: "Password do not match");
        } else {
            
            var postData = [String: Any]();
            postData["password"] = currentPasswordTextField.text!;
            postData["user_id"] = "\(editProfileViewControllerDelegate.loggedInUser.userId!)";
            editProfileViewControllerDelegate.updatePassword(postData: postData);
        }
    }
    
    @objc func cameraViewPressed() {
        editProfileViewControllerDelegate.imageUploadClicked();
    }
    
    func pictureSelected(selectedImage: UIImage) {
        
        DispatchQueue.main.async {
            self.profileImageView.image = selectedImage;
            self.profileImageView.setNeedsDisplay();
        }

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == nameTextField) {
            nameTextField.resignFirstResponder();
        } else if (textField == currentPasswordTextField) {
            confirmPasswordTxtField.becomeFirstResponder();
        } else if (textField == confirmPasswordTxtField) {
            confirmPasswordTxtField.resignFirstResponder();
        }
        
        return true;
    }
}
