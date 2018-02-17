//
//  ScreeningCell.swift
//  bio
//
//  Created by Bjorn Orri Saemundsson on 25/01/2018.
//  Copyright © 2018 Bjorn Orri Saemundsson. All rights reserved.
//

import UIKit

class ScreeningCell: UICollectionViewCell {

    var screening: Screening! {
        didSet {
            displayScreening()
        }
    }

    let button = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColor.gray.withAlphaComponent(0.8), for: .disabled)
        button.contentEdgeInsets = UIEdgeInsets(top: 6, left: 0, bottom: 6, right: 0)
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        button.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        contentView.addSubview(button)
    }

    func setupConstraints() {
        button.snp.makeConstraints() { make in
            make.edges.equalToSuperview()
            make.width.equalTo(70)
        }
    }

    private func displayScreening() {
        button.setTitle(screening.time.timeString(), for: .normal)
        if !screening.time.isPast() {
            button.isEnabled = true
            button.layer.borderColor = UIColor.white.cgColor
        } else {
            button.isEnabled = false
            button.layer.borderColor = UIColor.gray.withAlphaComponent(0.8).cgColor
        }
        contentView.setNeedsLayout()
    }
}
