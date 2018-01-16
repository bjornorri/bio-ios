//
//  CinemaHeader.swift
//  bio
//
//  Created by Bjorn Orri Saemundsson on 16/01/2018.
//  Copyright © 2018 Bjorn Orri Saemundsson. All rights reserved.
//

import UIKit

class CinemaHeader: UIView {

    var schedule: Schedule!

    let nameLabel = UILabel()
    let separator = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    convenience init(schedule: Schedule) {
        self.init(frame: CGRect.zero)
        self.schedule = schedule
        setupViews()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        backgroundColor = UIColor.clear

        nameLabel.font = UIFont.myriadBoldCond.withSize(24)
        nameLabel.textColor = UIColor.white
        nameLabel.text = schedule.cinemaName.uppercased()

        separator.backgroundColor = UIColor.white

        addSubview(nameLabel)
        addSubview(separator)
    }

    func setupConstraints() {
        nameLabel.snp.makeConstraints() { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
        }
        separator.snp.makeConstraints() { make in
            make.height.equalTo(1)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-8)
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.bottom.equalToSuperview().offset(-8)
        }
    }
}
