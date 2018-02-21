//
//  PosterView.swift
//  bio
//
//  Created by Bjorn Orri Saemundsson on 13/02/2018.
//  Copyright © 2018 Bjorn Orri Saemundsson. All rights reserved.
//

import UIKit
import Kingfisher

protocol PosterViewDelegate {
    func playTrailer(_ movie: Movie)
}

class PosterView: UIView {

    private let imageView = UIImageView()
    private let playButton = UIButton()

    var movie: Movie? {
        didSet {
            imageView.kf.setImage(with: movie?.poster, placeholder: nil, options: [.keepCurrentImageWhileLoading])
            playButton.isHidden = playHidden || movie?.trailerId == nil
        }
    }
    var playHidden = false {
        didSet {
            playButton.isHidden = playHidden || movie?.trailerId == nil
        }
    }
    var delegate: PosterViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        clipsToBounds = true

        imageView.layer.borderColor = UIColor.white.withAlphaComponent(0.7).cgColor
        imageView.layer.borderWidth = 1.0
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        playButton.layer.borderColor = UIColor.white.cgColor
        playButton.tintColor = UIColor.white
        playButton.clipsToBounds = true
        playButton.layer.borderWidth = 2.0
        playButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        playButton.setImage(UIImage(named: "play_arrow")?.withRenderingMode(.alwaysTemplate), for: .normal)
        playButton.isHidden = playHidden
        playButton.addTarget(self, action: #selector(didPressPlayButton), for: .touchUpInside)

        addSubview(imageView)
        addSubview(playButton)
    }

    func setupConstraints() {
        playButton.snp.makeConstraints() { make in
            make.width.greaterThanOrEqualTo(60)
            make.width.greaterThanOrEqualTo(imageView.snp.width).multipliedBy(0.6)
            make.height.equalTo(playButton.snp.width)
            make.center.equalTo(imageView)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
        playButton.layer.cornerRadius = playButton.frame.width / 2.0
    }

    @objc func didPressPlayButton() {
        guard let movie = movie else { return }
        delegate?.playTrailer(movie)
    }
}
