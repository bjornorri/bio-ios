//
//  UpcomingHeader.swift
//  bio
//
//  Created by Bjorn Orri Saemundsson on 12/02/2018.
//  Copyright © 2018 Bjorn Orri Saemundsson. All rights reserved.
//

import UIKit

class UpcomingHeader: UIView {

    let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupContstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        backgroundColor = UIColor.bioGray
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 17)
        addSubview(label)
    }

    func setupContstraints() {
        label.snp.makeConstraints() { make in
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
        }
    }

    func displayDate(_ date: Date) {
        if Calendar.current.isDateInTomorrow(date) {
            label.text = "Á morgun"
            return
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "d. MMMM"
        formatter.locale = Locale(identifier: "is-IS")
        label.text = formatter.string(from: date)
    }
}
