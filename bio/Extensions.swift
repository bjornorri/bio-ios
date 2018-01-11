//
//  Extensions.swift
//  bio
//
//  Created by Bjorn Orri Saemundsson on 11/01/2018.
//  Copyright © 2018 Bjorn Orri Saemundsson. All rights reserved.
//

import UIKit
import Imaginary

extension UIColor {

    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    static let bioGray = UIColor(red: 31, green: 31, blue: 31)
}

extension UIImage {

    func resize(toSize newSize: CGSize) -> (UIImage) {

        let newRect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height).integral
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        let context = UIGraphicsGetCurrentContext()

        // Set the quality level to use when rescaling
        context!.interpolationQuality = CGInterpolationQuality.default
        let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: newSize.height)

        context!.concatenate(flipVertical)
        // Draw into the context; this scales the image
        context?.draw(self.cgImage!, in: CGRect(x: 0.0,y: 0.0, width: newRect.width, height: newRect.height))

        let newImageRef = context!.makeImage()! as CGImage
        let newImage = UIImage(cgImage: newImageRef)

        // Get the resized image from the context and a UIImage
        UIGraphicsEndImageContext()

        return newImage
    }
}
