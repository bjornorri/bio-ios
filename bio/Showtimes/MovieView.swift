//
//  MovieView.swift
//  bio
//
//  Created by Bjorn Orri Saemundsson on 15/01/2018.
//  Copyright © 2018 Bjorn Orri Saemundsson. All rights reserved.
//

import UIKit

class MovieView: UIView {

    var movie: Movie!

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
        playButton.addTarget(self, action: #selector(didPressPlayButton), for: .touchUpInside)

        // Info
        infoView.textColor = UIColor.white
        infoView.font = UIFont.systemFont(ofSize: 13)
        infoView.backgroundColor = UIColor.clear
        infoView.isScrollEnabled = false
        infoView.textContainerInset = UIEdgeInsets.zero
        infoView.textContainer.lineFragmentPadding = 0.0
        infoView.isEditable = false

        var info = [String]()
        if let genres = movie.genres {
            let string = "Flokkur: \(genres.joined(separator: ", "))"
            info.append(string)
        }
        if let directors = movie.directors {
            let string = "Leikstjóri: \(directors.joined(separator: ", "))"
            info.append(string)
        }
        if let actors = movie.actors {
            let string = "Leikarar: \(actors.joined(separator: ", "))"
            info.append(string)
        }
        if let plot = movie.plot {
            let string = "\n\(plot)"
            info.append(string)
        }
        let infoString = info.joined(separator: "\n").attributedInfoString()
        infoView.attributedText = infoString

        // Add subviews
        addSubview(infoView)
        addSubview(posterView)
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
        // Play button
        playButton.snp.makeConstraints() { make in
            make.width.equalTo(posterView).multipliedBy(0.6)
            make.height.equalTo(playButton.snp.width)
            make.center.equalTo(posterView)
        }

        // Info
        infoView.snp.makeConstraints() { make in
            make.top.equalTo(posterView)
            make.left.equalTo(posterView)
            make.right.equalToSuperview().offset(-8)
            make.bottom.lessThanOrEqualToSuperview().offset(-20)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        playButton.layer.cornerRadius = playButton.frame.width / 2.0
        infoView.textContainer.exclusionPaths = [UIBezierPath(rect: posterView.bounds.insetBy(dx: -8, dy: -4).offsetBy(dx: 8, dy: 4))]
        infoView.setNeedsUpdateConstraints()
    }

    @objc func didPressPlayButton() {
    }
}
