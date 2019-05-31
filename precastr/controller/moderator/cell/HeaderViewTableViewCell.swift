//
//  HeaderViewTableViewCell.swift
//  precastr
//
//  Created by Macbook on 31/05/19.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit

class HeaderViewTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var headerTitleLabel: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
