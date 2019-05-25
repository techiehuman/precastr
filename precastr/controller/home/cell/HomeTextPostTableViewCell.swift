//
//  HomeTextPostTableViewCell.swift
//  precastr
//
//  Created by Macbook on 25/05/19.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit

class HomeTextPostTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var postTextLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    
    @IBOutlet weak var profileLabel: UILabel!
    
    
    @IBOutlet weak var sourceImageTwitter: UIImageView!
    
    @IBOutlet weak var sourceImageFacebook: UIImageView!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
