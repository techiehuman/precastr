//
//  CastModeratorTableViewCell.swift
//  precastr
//
//  Created by Cenes_Dev on 20/02/2020.
//  Copyright © 2020 Macbook. All rights reserved.
//

import UIKit

class CastModeratorTableViewCell: UITableViewCell {

    @IBOutlet weak var moderatorProfilePic: UIImageView!
    @IBOutlet weak var moderatorName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.moderatorProfilePic.roundImageView();
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
