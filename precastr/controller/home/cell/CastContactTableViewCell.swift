//
//  CastContactTableViewCell.swift
//  precastr
//
//  Created by mandeep singh on 19/10/19.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit

class CastContactTableViewCell: UITableViewCell {

    
    @IBOutlet weak var moderatorProfilePic: UIImageView!
    @IBOutlet weak var moderatorName: UILabel!
    @IBOutlet weak var moderatorPhone: UILabel!
    @IBOutlet weak var callToModeratorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.callToModeratorView.roundView();
        self.moderatorProfilePic.roundImageView();
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
