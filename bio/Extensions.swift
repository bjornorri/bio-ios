//
//  Extensions.swift
//  bio
//
//  Created by Bjorn Orri Saemundsson on 11/01/2018.
//  Copyright © 2018 Bjorn Orri Saemundsson. All rights reserved.
//

import UIKit

extension UIColor {

    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    static let bioGray = UIColor(red: 31, green: 31, blue: 31)
}

extension UIFont {

    static let myriadBoldCond = UIFont(name: "MyriadPro-BoldCond", size: 17)!
}
