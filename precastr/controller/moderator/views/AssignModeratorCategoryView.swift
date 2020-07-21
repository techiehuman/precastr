//
//  AssignModeratorCategoryView.swift
//  precastr
//
//  Created by Cenes_Dev on 01/06/2020.
//  Copyright © 2020 Macbook. All rights reserved.
//

import UIKit

class AssignModeratorCategoryView: UIView {

    @IBOutlet weak var categoryScrollView: UIScrollView!;
    @IBOutlet weak var btnSave: UIButton!;
    @IBOutlet weak var closePopupBtn: UIImageView!;
    @IBOutlet weak var dropDownCategoryLabel: UILabel!;
    @IBOutlet weak var dropDownCategoryLabelView: UIView!;

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        if (btnSave != nil) {
            btnSave.layer.cornerRadius = 4;
        }
    }
    
    class func instanceDropDownAlertFromNib() -> UIView {
        return UINib(nibName: "AssignModeratorCategoryView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    class func instanceDropDownItemAlertFromNib() -> UIView {
        return UINib(nibName: "AssignModeratorCategoryView", bundle: nil).instantiate(withOwner: nil, options: nil)[1] as! UIView
    }
}
