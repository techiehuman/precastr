//
//  LeftCommunicationTableViewCell.swift
//  precastr
//
//  Created by Macbook on 14/06/19.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit

class LeftCommunicationTableViewCell: UITableViewCell {
 var communicationViewControllerDelegate : CommunicationViewController!;
    
    
    @IBOutlet weak var commentedDate: UILabel!
    
    @IBOutlet weak var commentText: UILabel!
    
    @IBOutlet weak var commentorPic: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
