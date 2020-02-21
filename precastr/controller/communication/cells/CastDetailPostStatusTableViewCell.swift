//
//  CastDetailPostStatusTableViewCell.swift
//  precastr
//
//  Created by Cenes_Dev on 20/02/2020.
//  Copyright © 2020 Macbook. All rights reserved.
//

import UIKit

class CastDetailPostStatusTableViewCell: UITableViewCell {

    @IBOutlet weak var editDetailsBtn: UIButton!;
    @IBOutlet weak var postDateLbl: UILabel!
    @IBOutlet weak var postStatusLbl: UILabel!
    @IBOutlet weak var postStatusImg: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
