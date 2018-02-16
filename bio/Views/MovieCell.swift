//
//  MovieCell.swift
//  bio
//
//  Created by Bjorn Orri Saemundsson on 16/02/2018.
//  Copyright © 2018 Bjorn Orri Saemundsson. All rights reserved.
//

import UIKit
import MMParallaxCell

class MovieCell: MMParallaxCell {

    var movie: Movie! {
        didSet {
            displayMovie()
        }
    }
    var playHidden = false {
        didSet {
            posterView.playHidden = playHidden
        }
    }

    internal var backdropView: UIImageView!
    internal let posterView = PosterView()
    internal let titleLabel = UILabel()

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
        backdropView.alpha = 0.3

        // Title
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.myriadBoldCond.withSize(22)
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 2

        // Add subviews
        contentView.addSubview(backdropView)
        contentView.addSubview(posterView)
        contentView.addSubview(titleLabel)
    }

    func setupConstraints() {
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
    }

    internal func displayMovie() {
        backdropView.kf.setImage(with: movie.backdrop)
        posterView.movie = movie
        titleLabel.text = movie.title
    }
}
