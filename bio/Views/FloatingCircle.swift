//
//  FloatingCircle.swift
//  bio
//
//  Created by Bjorn Orri Saemundsson on 19/02/2018.
//  Copyright © 2018 Bjorn Orri Saemundsson. All rights reserved.
//

import UIKit

class FloatingCircle: UIView {

    let background = UIView()
    let line1 = UIView()
    let line2 = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        background.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        background.layer.borderColor = UIColor.bioGold.cgColor
        background.layer.borderWidth = 2.0
        line1.backgroundColor = UIColor.white
        line2.backgroundColor = UIColor.white
        addSubview(background)
        addSubview(line1)
        addSubview(line2)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
        background.frame = bounds
        background.layer.cornerRadius = bounds.height / 2
    }

    func setTransformed(_ transformed: Bool) {
        background.alpha = transformed ? 0.0 : 1.0
        line1.backgroundColor = transformed ? UIColor.gray : UIColor.white
        line2.backgroundColor = transformed ? UIColor.gray : UIColor.white
        let length = CGFloat(30)
        if !transformed {
            line1.transform = .identity
            line2.transform = .identity
        }
        line1.frame = CGRect(x: bounds.midX - length / 2.0, y: bounds.midY - 4.0, width: length, height: 1)
        line2.frame = CGRect(x: bounds.midX - length / 2.0, y: bounds.midY + 4.0, width: length, height: 1)
        if transformed {
            let convert = CGFloat(.pi / 180.0)
            line1.transform = CGAffineTransform(rotationAngle: -45.0 * convert)
            line2.transform = CGAffineTransform(rotationAngle: 45.0 * convert)
            let center = CGPoint(x: bounds.midX, y: bounds.midY)
            line1.center = center
            line2.center = center
        }
    }
}
