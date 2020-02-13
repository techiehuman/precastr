//
//  CastOptionApprovedView.swift
//  precastr
//
//  Created by Cenes_Dev on 13/02/2020.
//  Copyright © 2020 Macbook. All rights reserved.
//

import UIKit

class CastOptionApprovedView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBOutlet weak var deleteBtn: UIButton!;
    @IBOutlet weak var callButtonBtn: UIButton!;
    @IBOutlet weak var facebookInfoBtn: UIButton!;
    @IBOutlet weak var sharePostBtn: UIButton!;
    
    override func draw(_ rect: CGRect) {
        deleteBtn.roundBtn();
        callButtonBtn.roundBtn();
        facebookInfoBtn.roundBtn();
        sharePostBtn.roundBtn();
    }

}
