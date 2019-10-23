//
//  UpdatePhoneNumberTableViewCell.swift
//  precastr
//
//  Created by mandeep singh on 23/10/19.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit

class UpdatePhoneNumberTableViewCell: UITableViewCell,UITextFieldDelegate {

   
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    @IBOutlet weak var countryCodeUIView: UIView!
    @IBOutlet weak var countryCodelabel: UILabel!
    @IBOutlet weak var btnUpdatePhoneNumber: UIButton!
    
    var updatePhoneNumberViewControllerDelegate : UpdatePhoneNumberViewController!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let phoneIconContainerView: UIView = UIView(frame:
            CGRect(x: 70, y: 0, width: 40, height: self.phoneNumberTextField.frame.height));
        let phoneImageView = UIImageView(frame: CGRect(x: 10, y: (phoneIconContainerView.frame.height/2 - 30/2), width: 27, height: 30))
        let phoneImage = UIImage(named: "phone");
        phoneImageView.image = phoneImage;
        phoneIconContainerView.addSubview(phoneImageView)
        self.phoneNumberTextField.leftView = phoneIconContainerView
        self.phoneNumberTextField.leftViewMode = .always
        
        self.phoneNumberTextField.attributedPlaceholder = NSAttributedString(string: "Phone Number", attributes: [NSAttributedStringKey.foregroundColor : UIColor.white ])
        
        self.phoneNumberTextField.layer.borderColor = UIColor.white.cgColor
        self.phoneNumberTextField.layer.borderWidth = 0.5
        self.countryCodeUIView.layer.borderWidth = 0.5
        self.countryCodeUIView.layer.borderColor = UIColor.white.cgColor as! CGColor
        // Do any additional setup after loading the view.
        let countryCodeTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(countryPhoneCodeViewPressed));
        countryCodeUIView.addGestureRecognizer(countryCodeTapGesture);
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @objc func countryPhoneCodeViewPressed() {
        
        updatePhoneNumberViewControllerDelegate.openCountryCodeList();
    }    
    
    @IBAction func submitButtonClicked(_ sender: Any) {
        var message = ""
        if (phoneNumberTextField.text == "") {
            message = "Phone number cannot be empty..."
            let alert = UIAlertController.init(title: "Error", message: message, preferredStyle: .alert);
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil));
            self.updatePhoneNumberViewControllerDelegate.present(alert, animated: true)
        }else{
            
            var postData = [String: Any]();
            postData["name"] = self.updatePhoneNumberViewControllerDelegate.loggedInUser.name!
            postData["user_id"] = "\(self.updatePhoneNumberViewControllerDelegate.loggedInUser.userId!)";
            postData["country_code"] = self.countryCodelabel.text!
            postData["phone_number"] = self.phoneNumberTextField.text!
            
            updatePhoneNumberViewControllerDelegate.updatePhoneNumber(postData: postData);
        }
    }
}
