//
//  ScreeningCell.swift
//  bio
//
//  Created by Bjorn Orri Saemundsson on 25/01/2018.
//  Copyright © 2018 Bjorn Orri Saemundsson. All rights reserved.
//

import UIKit

class ScreeningCell: UICollectionViewCell {

    var screening: Screening!

    let button = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        button.setTitleColor(UIColor.white, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 6, left: 0, bottom: 6, right: 0)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        contentView.addSubview(button)
    }

    func setupConstraints() {
        button.snp.makeConstraints() { make in
            make.edges.equalToSuperview()
            make.width.equalTo(70)
        }
    }

    func displayScreening(_ screening: Screening) {
        button.setTitle(screening.time.timeString(), for: .normal)
        contentView.setNeedsLayout()
    }
}
