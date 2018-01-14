//
//  ShowtimeCell.swift
//  bio
//
//  Created by Bjorn Orri Saemundsson on 11/01/2018.
//  Copyright © 2018 Bjorn Orri Saemundsson. All rights reserved.
//

import UIKit
import Kingfisher
import MMParallaxCell
import SnapKit

class ShowtimeCell: MMParallaxCell {

    var movie: Movie!

    var backdropView: UIImageView!
    let posterView = UIImageView()
    let overlay = UIView()

    let titleLabel = UILabel()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backdropView = parallaxImage
        parallaxRatio = 1.25
        setupViews()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        contentView.backgroundColor = UIColor.bioGray

        posterView.layer.borderColor = UIColor.white.withAlphaComponent(0.7).cgColor
        posterView.layer.borderWidth = 1.0
        posterView.contentMode = .scaleAspectFill
        posterView.clipsToBounds = true

        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.5)

        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont(name: "MyriadPro-BoldCond", size: 22)
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 2

        backdropView.addSubview(overlay)
        contentView.addSubview(backdropView)
        contentView.addSubview(posterView)
        contentView.addSubview(titleLabel)
    }

    func setupConstraints() {
        overlay.snp.makeConstraints() { make in
            make.edges.equalTo(backdropView)
        }
        posterView.snp.makeConstraints() { make in
            make.top.equalTo(contentView).offset(20)
            make.left.equalTo(contentView).offset(16)
            make.bottom.equalTo(contentView).offset(-20)
            make.width.equalTo(posterView.snp.height).multipliedBy(2.0 / 3.0)
        }
        titleLabel.snp.makeConstraints() { make in
            make.top.equalTo(contentView).offset(20)
            make.right.equalTo(contentView).offset(-8)
            make.left.equalTo(posterView.snp.right).offset(16)
        }
    }

    func displayMovie(_ movie: Movie) {
        backdropView.kf.setImage(with: movie.backdrop)
        posterView.kf.setImage(with: movie.poster)
        titleLabel.text = movie.title
    }
}
