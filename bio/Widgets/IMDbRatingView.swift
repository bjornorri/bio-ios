//
//  IMDbRatingView.swift
//  bio
//
//  Created by Bjorn Orri Saemundsson on 30/01/2018.
//  Copyright © 2018 Bjorn Orri Saemundsson. All rights reserved.
//

import UIKit

class IMDbRatingView: UIView {

    var rating: String? {
        get {
            return ratingLabel.text
        }
        set {
            ratingLabel.text = newValue
        }
    }

    private let imdbLogo = UIImageView(image: UIImage(named: "imdb"))
    private let ratingLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        // Logo
        imdbLogo.contentMode = .scaleAspectFit

        // Label
        ratingLabel.textColor = UIColor.white
        ratingLabel.font = UIFont.myriadBoldCond.withSize(18)

        addSubview(imdbLogo)
        addSubview(ratingLabel)
    }

    func setupConstraints() {
        imdbLogo.snp.makeConstraints() { make in
            make.left.equalToSuperview()
            make.top.greaterThanOrEqualToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
            make.height.equalTo(18)
            make.width.equalTo(imdbLogo.snp.height).multipliedBy(2127.0 / 1024.0)
        }
        ratingLabel.snp.makeConstraints() { make in
            make.left.equalTo(imdbLogo.snp.right).offset(6)
            make.centerY.equalTo(imdbLogo)
            make.top.greaterThanOrEqualToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
    }
}
