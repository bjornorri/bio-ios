//
//  MovieView.swift
//  bio
//
//  Created by Bjorn Orri Saemundsson on 15/01/2018.
//  Copyright © 2018 Bjorn Orri Saemundsson. All rights reserved.
//

import UIKit

protocol MovieViewDelegate {
    func playTrailer()
}

class MovieView: UIView {

    var movie: Movie!
    var delegate: MovieViewDelegate!

    let titleLabel = UILabel()
    let posterView = UIImageView()
    let playButton = UIButton()
    let infoView = UITextView()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    convenience init(movie: Movie) {
        self.init(frame: CGRect.zero)
        self.movie = movie
        backgroundColor = UIColor.clear
        setupViews()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        // Title
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.myriadBoldCond.withSize(22)
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 2
        titleLabel.text = movie.title

        // Poster
        posterView.stylePosterView()
        posterView.kf.setImage(with: movie.poster)

        // Play button
        playButton.layer.borderColor = UIColor.white.cgColor
        playButton.tintColor = UIColor.white
        playButton.clipsToBounds = true
        playButton.layer.borderWidth = 2.0
        playButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        playButton.setImage(UIImage(named: "play_arrow")?.withRenderingMode(.alwaysTemplate), for: .normal)
        playButton.isHidden = movie.trailerId == nil
        playButton.addTarget(self, action: #selector(didPressPlayButton), for: .touchUpInside)

        // Info
        infoView.textColor = UIColor.white
        infoView.font = UIFont.systemFont(ofSize: 13)
        infoView.backgroundColor = UIColor.clear
        infoView.isScrollEnabled = false
        infoView.textContainerInset = UIEdgeInsets.zero
        infoView.textContainer.lineFragmentPadding = 0.0
        infoView.isEditable = false
        infoView.isSelectable = false
        infoView.attributedText = getAttributedInfoString(forMovie: movie)

        // Add subviews
        addSubview(infoView)
        addSubview(posterView)
        addSubview(titleLabel)
        addSubview(playButton)
    }

    func setupConstraints() {
        // Self
        self.snp.makeConstraints() { make in
            make.width.equalTo(UIScreen.main.bounds.width)
        }
        // Poster
        posterView.snp.makeConstraints() { make in
            make.height.equalTo(self.snp.width).multipliedBy(9.0 / 16.0).offset(-40)
            make.width.equalTo(posterView.snp.height).multipliedBy(2.0 / 3.0)
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(16)
            make.bottom.lessThanOrEqualToSuperview().offset(-20)
        }
        // Title
        titleLabel.snp.makeConstraints() { make in
            make.top.equalTo(posterView)
            make.left.equalTo(posterView.snp.right).offset(16)
            make.right.equalToSuperview().offset(-8)
        }
        // Play button
        playButton.snp.makeConstraints() { make in
            make.width.equalTo(posterView).multipliedBy(0.6)
            make.height.equalTo(playButton.snp.width)
            make.center.equalTo(posterView)
        }
        // Info
        infoView.snp.makeConstraints() { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.left.equalTo(posterView)
            make.right.equalToSuperview().offset(-8)
            make.bottom.lessThanOrEqualToSuperview().offset(-20)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        playButton.layer.cornerRadius = playButton.frame.width / 2.0
        var rect = infoView.frame.intersection(posterView.frame)
        rect.origin = CGPoint.zero
        infoView.textContainer.exclusionPaths = [UIBezierPath(rect: rect.insetBy(dx: -8, dy: -4).offsetBy(dx: 8, dy: 4))]
        infoView.setNeedsUpdateConstraints()
    }

    @objc func didPressPlayButton() {
        delegate.playTrailer()
    }
}
