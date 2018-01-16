//
//  CinemaCell.swift
//  bio
//
//  Created by Bjorn Orri Saemundsson on 16/01/2018.
//  Copyright © 2018 Bjorn Orri Saemundsson. All rights reserved.
//

import UIKit

class CinemaCell: UITableViewCell {

    let cinemaLabel = UILabel()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupViews()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        // Content view
        contentView.backgroundColor = UIColor.clear

        // Cinema label
        cinemaLabel.font = UIFont.myriadBoldCond.withSize(24)
        cinemaLabel.textColor = UIColor.white
    }

    func setupConstraints() {
        cinemaLabel.snp.makeConstraints() { make in
            make.top.equalToSuperview().offset(8)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-8)
        }
    }
}
