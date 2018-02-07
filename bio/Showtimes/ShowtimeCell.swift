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
    let foreground = UIView()
    let posterView = UIImageView()
    let titleLabel = UILabel()
    let imdbView = IMDbRatingView()

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
        // Content view
        contentView.backgroundColor = UIColor.black

        // Backdrop
        backdropView.alpha = 0.5

        // Foreground
        foreground.backgroundColor = UIColor.clear

        // Poster
        posterView.stylePosterView()

        // Title
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.myriadBoldCond.withSize(22)
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 2

        // Add subviews
        contentView.addSubview(foreground)
        foreground.addSubview(backdropView)
        foreground.addSubview(posterView)
        foreground.addSubview(titleLabel)
        foreground.addSubview(imdbView)
    }

    func setupConstraints() {
        // Foreground
        foreground.snp.makeConstraints() { make in
            make.edges.equalToSuperview()
        }
        // Poster
        posterView.snp.makeConstraints() { make in
            make.top.equalTo(contentView).offset(20)
            make.left.equalTo(contentView).offset(16)
            make.bottom.equalTo(contentView).offset(-20)
            make.width.equalTo(posterView.snp.height).multipliedBy(2.0 / 3.0)
        }
        // Title
        titleLabel.snp.makeConstraints() { make in
            make.top.equalTo(contentView).offset(20)
            make.right.equalTo(contentView).offset(-8)
            make.left.equalTo(posterView.snp.right).offset(16)
        }
        // IMDb
        imdbView.snp.makeConstraints() { make in
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
    }

    func displayMovie(_ movie: Movie) {
        backdropView.kf.setImage(with: movie.backdrop)
        posterView.kf.setImage(with: movie.poster)
        titleLabel.text = movie.title
        imdbView.rating = movie.imdbRating
    }
}
