//
//  RightCommunicationTableViewCell.swift
//  precastr
//
//  Created by Macbook on 14/06/19.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit

class RightCommunicationTableViewCell: UITableViewCell {
 var communicationViewControllerDelegate : CommunicationViewController!;
    
    @IBOutlet weak var commentedDate: UILabel!
        
    @IBOutlet weak var commentorPic: UIImageView!
    
    @IBOutlet weak var descriptionView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.commentorPic.roundImageView();
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
