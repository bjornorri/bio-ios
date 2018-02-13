//
//  UpcomingCell.swift
//  bio
//
//  Created by Bjorn Orri Saemundsson on 13/02/2018.
//  Copyright © 2018 Bjorn Orri Saemundsson. All rights reserved.
//

import UIKit

class UpcomingCell: UITableViewCell {

    let posterView = UIImageView()
    let titleLabel = UILabel()
    let infoLabel = UILabel()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        // Background
        backgroundColor = UIColor.bioGray
        contentView.backgroundColor = UIColor.bioGray

        // Poster
        posterView.stylePosterView()

        // Title
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.myriadBoldCond.withSize(20)
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 1

        // Info
        infoLabel.textColor = UIColor.white
        infoLabel.font = UIFont.systemFont(ofSize: 13)
        infoLabel.numberOfLines = 0

        contentView.addSubview(posterView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(infoLabel)
    }

    func setupConstraints() {
        posterView.snp.makeConstraints() { make in
            make.left.equalToSuperview().offset(8)
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
            make.width.equalTo(posterView.snp.height).multipliedBy(2.0 / 3.0)
        }
        titleLabel.snp.makeConstraints() { make in
            make.top.equalTo(posterView)
            make.left.equalTo(posterView.snp.right).offset(16)
            make.right.equalToSuperview().offset(-8)
        }
        infoLabel.snp.makeConstraints() { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.left.equalTo(posterView.snp.right).offset(16)
            make.right.equalToSuperview().offset(-8)
        }
    }

    func displayMovie(_ movie: Movie) {
        posterView.kf.setImage(with: movie.poster)
        titleLabel.text = movie.title
        infoLabel.attributedText = getAttributedInfoString(forMovie: movie, skipPlot: true)
    }
}

