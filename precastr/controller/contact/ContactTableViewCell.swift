//
//  ContactTableViewCell.swift
//  precastr
//
//  Created by mandeep singh on 30/09/19.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    @IBOutlet weak var contactPhoneLbl: UILabel!
    @IBOutlet weak var contactNameLbl: UILabel!

    @IBOutlet weak var checkBox: UIButton!
    
    @IBOutlet weak var contactItemView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        checkBox.layer.cornerRadius = checkBox.frame.width/2
        checkBox.layer.borderColor = UIColor.black.cgColor;
    }

   
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
