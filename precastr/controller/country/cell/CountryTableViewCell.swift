//
//  CountryTableViewCell.swift
//  precastr
//
//  Created by mandeep singh on 15/10/19.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit

class CountryTableViewCell: UITableViewCell {

    @IBOutlet weak var countryLabel : UILabel!
    @IBOutlet weak var codeLabel : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
