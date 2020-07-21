//
//  UISwitch+extension.swift
//  precastr
//
//  Created by Cenes_Dev on 30/05/2020.
//  Copyright © 2020 Macbook. All rights reserved.
//

import Foundation
import UIKit

extension UISwitch {

    func set(width: CGFloat, height: CGFloat) {

        let standardHeight: CGFloat = 31
        let standardWidth: CGFloat = 51

        let heightRatio = height / standardHeight
        let widthRatio = width / standardWidth

        transform = CGAffineTransform(scaleX: widthRatio, y: heightRatio)
    }
}

