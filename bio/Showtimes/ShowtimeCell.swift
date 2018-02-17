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

class ShowtimeCell: MovieCell {

    let imdbView = IMDbRatingView()

    override var normalAlpha: CGFloat {
        return 0.4
    }

    override var selectedAlpha: CGFloat {
        return 0.6
    }

    override func setupViews() {
        super.setupViews()
        posterView.playHidden = true
        foreground.addSubview(imdbView)
    }

    override func setupConstraints() {
        super.setupConstraints()
        imdbView.snp.makeConstraints() { make in
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
    }

    override func displayMovie() {
        super.displayMovie()
        imdbView.rating = movie.imdbRating
    }
}
