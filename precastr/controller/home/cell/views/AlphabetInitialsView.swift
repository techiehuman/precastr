//
//  AlphabetInitialsView.swift
//  precastr
//
//  Created by Cenes_Dev on 06/03/2020.
//  Copyright © 2020 Macbook. All rights reserved.
//

import UIKit

class AlphabetInitialsView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "AlphabetInitialsView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
}
