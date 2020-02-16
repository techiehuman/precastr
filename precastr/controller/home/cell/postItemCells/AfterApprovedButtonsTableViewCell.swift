//
//  AfterApprovedButtonsTableViewCell.swift
//  precastr
//
//  Created by Cenes_Dev on 16/02/2020.
//  Copyright © 2020 Macbook. All rights reserved.
//

import UIKit

class AfterApprovedButtonsTableViewCell: UITableViewCell {

    @IBOutlet weak var deleteBtn: UIButton!;
    @IBOutlet weak var callButtonBtn: UIButton!;
    @IBOutlet weak var facebookInfoBtn: UIButton!;
    @IBOutlet weak var sharePostBtn: UIButton!;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        deleteBtn.roundBtn();
        callButtonBtn.roundBtn();
        facebookInfoBtn.roundBtn();
        sharePostBtn.roundBtn();
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
