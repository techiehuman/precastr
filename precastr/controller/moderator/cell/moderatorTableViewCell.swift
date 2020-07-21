//
//  moderatorTableViewCell.swift
//  precastr
//
//  Created by Macbook on 31/05/19.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit

class moderatorTableViewCell: UITableViewCell {

    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var profileLabel: UILabel!
    
    @IBOutlet weak var acceptActionBtn: UIButton!
    
    @IBOutlet weak var removeActionBtn: UIButton!
    
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var moderatorCategory: UIButton!

    @IBOutlet weak var moderatorProfileContainerView: UIView!

    @IBOutlet weak var enableDisableModSwitch: UISwitch!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        acceptActionBtn.layer.cornerRadius = 4;
        moderatorCategory.layer.cornerRadius = 4;
        removeActionBtn.roundBtn();
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
