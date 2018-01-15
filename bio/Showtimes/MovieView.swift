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

        // Info
        infoView.textColor = UIColor.white
        infoView.font = UIFont.systemFont(ofSize: 14)
        infoView.backgroundColor = UIColor.clear
        infoView.isScrollEnabled = false
        infoView.textContainerInset = UIEdgeInsets.zero
        infoView.textContainer.lineFragmentPadding = 0.0
        infoView.isEditable = false

        var info = [String]()
        if let genres = movie.genres {
            let title = "Flokkur"
            let string = "\(title): \(genres.joined(separator: ", "))"
            info.append(string)
        }
        if let directors = movie.directors {
            let title = "Leikstjóri"
            let string = "\(title): \(directors.joined(separator: ", "))"
            info.append(string)
        }
        if let actors = movie.actors {
            let title = "Leikarar"
            let string = "\(title): \(actors.joined(separator: ", "))"
            info.append(string)
        }
        if let plot = movie.plot {
            let string = "\n\(plot)"
            info.append(string)
        }
        infoView.text = info.joined(separator: "\n")

        // Add subviews
        addSubview(posterView)
        addSubview(infoView)
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
        infoView.textContainer.exclusionPaths = [UIBezierPath(rect: posterView.bounds.insetBy(dx: -8, dy: -4).offsetBy(dx: 8, dy: 4))]
        infoView.setNeedsUpdateConstraints()
    }
}
