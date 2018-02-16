//
//  UpcomingCell.swift
//  bio
//
//  Created by Bjorn Orri Saemundsson on 13/02/2018.
//  Copyright © 2018 Bjorn Orri Saemundsson. All rights reserved.
//

import UIKit

class UpcomingCell: MovieCell {

    let infoLabel = UILabel()

    override func setupViews() {
        super.setupViews()
        
        backdropView.alpha = 0.3

        infoLabel.textColor = UIColor.white
        infoLabel.font = UIFont.systemFont(ofSize: 14)
        infoLabel.numberOfLines = 0

        contentView.addSubview(infoLabel)
    }

    override func setupConstraints() {
        super.setupConstraints()
        infoLabel.snp.makeConstraints() { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.left.equalTo(posterView.snp.right).offset(16)
            make.right.equalToSuperview().offset(-8)
        }
    }

    override func displayMovie() {
        super.displayMovie()
        infoLabel.attributedText = getAttributedInfoString(forMovie: movie, skipPlot: true)
    }
}

