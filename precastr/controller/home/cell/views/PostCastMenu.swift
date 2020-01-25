//
//  PostCastMenu.swift
//  precastr
//
//  Created by Cenes_Dev on 24/01/2020.
//  Copyright © 2020 Macbook. All rights reserved.
//

import UIKit

class PostCastMenu: UIView {

    
    @IBOutlet weak var facebookItem: UIView!;
    @IBOutlet weak var twitterItem: UIView!;
    @IBOutlet weak var messageItem: UIView!;

    @IBOutlet weak var facebookChecked: UIImageView!;
    @IBOutlet weak var twitterChecked: UIImageView!;
    @IBOutlet weak var messageChecked: UIImageView!;

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "PostCastMenu", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
}
