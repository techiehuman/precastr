//
//  CasterPostStatusTableViewCell.swift
//  precastr
//
//  Created by Cenes_Dev on 19/06/2019.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit

class CasterPostStatusTableViewCell: UITableViewCell {

    
    @IBOutlet weak var socialIconsView: UIView!
    
    @IBOutlet weak var sourceImageTwitter: UIImageView!
    
    @IBOutlet weak var sourceImageFacebook: UIImageView!
    
    @IBOutlet weak var statusImage: UIImageView!
    
    @IBOutlet weak var postStatusDateView: UIView!

    @IBOutlet weak var dateLabel: UILabel!

    @IBOutlet weak var profileLabel: UILabel!
    
    @IBOutlet weak var labelView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
