//
//  HomeTableViewCell.swift
//  precastr
//
//  Created by Macbook on 29/04/19.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
   
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        sourceImage.roundImageView();
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    @IBOutlet weak var profileLabel: UILabel!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var sourceImage: UIImageView!
    
    
}
