//
//  ShowtimeCell.swift
//  bio
//
//  Created by Bjorn Orri Saemundsson on 11/01/2018.
//  Copyright © 2018 Bjorn Orri Saemundsson. All rights reserved.
//

import UIKit
import Imaginary
import SnapKit

class ShowtimeCell: UITableViewCell {

    let backdropView = UIImageView()
    let posterView = UIImageView()
    let overlay = UIView()

    var movie: Movie!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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

        backdropView.contentMode = .scaleAspectFill
        backdropView.clipsToBounds = true

        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.5)

        backdropView.addSubview(overlay)
        contentView.addSubview(backdropView)
        contentView.addSubview(posterView)
    }

    func setupConstraints() {
        backdropView.snp.makeConstraints() { make in
            make.edges.equalTo(contentView)
        }
        overlay.snp.makeConstraints() { make in
            make.edges.equalTo(backdropView)
        }
        posterView.snp.makeConstraints() { make in
            make.top.equalTo(contentView).offset(20)
            make.left.equalTo(contentView).offset(16)
            make.bottom.equalTo(contentView).offset(-20)
            make.width.equalTo(posterView.snp.height).multipliedBy(2.0 / 3.0)
        }
    }

    func displayMovie(_ movie: Movie) {
        contentView.layoutIfNeeded()
        backdropView.setImage(url: movie.backdrop)
        posterView.setImage(url: movie.poster)
    }
}
