//
//  UpdateProfileInfoView.swift
//  precastr
//
//  Created by Cenes_Dev on 26/05/2020.
//  Copyright © 2020 Macbook. All rights reserved.
//

import UIKit

class UpdateProfileInfoView: UIView {

    @IBOutlet weak var emailTextField: UITextField!;
    @IBOutlet weak var saveBtn: UIButton!;
    @IBOutlet weak var okBtn: UIButton!;
    @IBOutlet weak var closePopupBtn: UIImageView!;
    @IBOutlet weak var socialInfoLabel: UILabel!;

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        if (saveBtn != nil) {
            saveBtn.layer.cornerRadius = 4;
        }
        
        if (okBtn != nil) {
            okBtn.layer.cornerRadius = 4;
        }
    }
    
    class func instanceEmailAlertFromNib() -> UIView {
        return UINib(nibName: "UpdateProfileInfoView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    class func instanceSocialAlertFromNib() -> UIView {
        return UINib(nibName: "UpdateProfileInfoView", bundle: nil).instantiate(withOwner: nil, options: nil)[1] as! UIView
    }
}
