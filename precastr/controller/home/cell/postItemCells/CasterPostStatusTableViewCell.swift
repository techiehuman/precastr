//
//  CasterPostStatusTableViewCell.swift
//  precastr
//
//  Created by Cenes_Dev on 16/02/2020.
//  Copyright © 2020 Macbook. All rights reserved.
//

import UIKit

class CasterPostStatusTableViewCell: UITableViewCell {

    @IBOutlet weak var viewDetailsBtn: UIButton!;
    @IBOutlet weak var postDateLbl: UILabel!
    @IBOutlet weak var postStatusLbl: UILabel!
    @IBOutlet weak var postStatusImg: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    
        viewDetailsBtn.layer.cornerRadius = 4;
        viewDetailsBtn.backgroundColor = blueLinkColor;
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
