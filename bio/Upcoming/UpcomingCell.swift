//
//  UpcomingCell.swift
//  bio
//
//  Created by Bjorn Orri Saemundsson on 13/02/2018.
//  Copyright © 2018 Bjorn Orri Saemundsson. All rights reserved.
//

import UIKit
import ionicons

class UpcomingCell: MovieCell {

    let infoLabel = UILabel()
    let notifyIcon = UIImageView()

    override func setupViews() {
        super.setupViews()

        notifyIcon.image = IonIcons.image(withIcon: ion_ios_bell, size: 24, color: UIColor.bioOrange)

        titleLabel.numberOfLines = 1
        infoLabel.textColor = UIColor.white
        infoLabel.font = UIFont.systemFont(ofSize: 14)
        infoLabel.numberOfLines = 0

        foreground.addSubview(infoLabel)
        foreground.addSubview(notifyIcon)
    }

    override func setupConstraints() {
        super.setupConstraints()
        notifyIcon.snp.makeConstraints() { make in
            make.top.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-8)
            make.height.equalTo(24)
            make.width.equalTo(24)
        }
        titleLabel.snp.remakeConstraints() { make in
            make.top.equalTo(contentView).offset(20)
            make.left.equalTo(posterView.snp.right).offset(16)
            make.right.lessThanOrEqualTo(notifyIcon.snp.left).offset(-4)
        }
        infoLabel.snp.makeConstraints() { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.left.equalTo(posterView.snp.right).offset(16)
            make.right.equalToSuperview().offset(-8)
        }
    }

    override func displayMovie() {
        super.displayMovie()
        infoLabel.attributedText = getAttributedInfoString(forMovie: movie, skipPlot: true)
        notifyIcon.isHidden = !movie.notify
    }
}

