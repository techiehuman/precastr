//
//  NotificationTableViewCell.swift
//  precastr
//
//  Created by Macbook on 10/06/19.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var notificationTextView: UIView!
    
    @IBOutlet weak var dateTextView: UILabel!
    
    var notificationViewControllerDelegate : NotificationViewController!;
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.profileImageView.roundView();
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
