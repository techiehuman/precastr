//
//  EditProfileTableViewCell.swift
//  precastr
//
//  Created by Macbook on 07/06/19.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit

class EditProfileTableViewCell: UITableViewCell {

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
        
       
      //  self.nameTextField.addBorder(toSide: .Bottom, withColor: UIColor(red: 146/255, green: 147/255, blue: 149/255, alpha: 1.0).cgColor, andThickness: 1.0)
        nameTextField.borderStyle = UITextBorderStyle.none;
       
        let lineView = UIView(frame: CGRect(x: 0, y: self.nameTextField.frame.size.height, width: self.nameTextField.frame.size.width, height: 2))
        lineView.backgroundColor = UIColor.red
        self.nameTextField.addSubview(lineView)
        
    }
  var editProfileViewControllerDelegate : EditProfileViewController!;
    @IBOutlet weak var profileImageView: UIImageView!
    
    
    @IBOutlet weak var nameUIView: UIView!
    @IBOutlet weak var cameraUIView: UIView!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var invitationUIView: UIView!
    @IBOutlet weak var invitationCodeLabel: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
