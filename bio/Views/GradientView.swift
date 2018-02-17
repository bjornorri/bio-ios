//
//  GradientView.swift
//  bio
//
//  Created by Bjorn Orri Saemundsson on 17/02/2018.
//  Copyright © 2018 Bjorn Orri Saemundsson. All rights reserved.
//

import UIKit

class GradientView: UIView {

    private let gradientLayer = CAGradientLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.white.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        updateEndpoint()
        layer.addSublayer(gradientLayer)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        updateEndpoint()
        gradientLayer.frame = bounds
        CATransaction.commit()
    }

    private func updateEndpoint() {
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let endPointY = (statusBarHeight * 2) / bounds.height
        gradientLayer.endPoint = CGPoint(x: 0.5, y: endPointY)
    }
}
