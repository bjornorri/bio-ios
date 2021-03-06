//
//  ScheduleCell.swift
//  bio
//
//  Created by Bjorn Orri Saemundsson on 17/01/2018.
//  Copyright © 2018 Bjorn Orri Saemundsson. All rights reserved.
//

import UIKit

class ScheduleCell: UITableViewCell {

    var delegate: ScreeningCellDelegate?

    var schedule: Schedule! {
        didSet {
            collectionView.reloadData()
        }
    }

    var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())


    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        collectionView.register(ScreeningCell.self, forCellWithReuseIdentifier: "screeningCell")
        setupViews()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = CGSize(width: 70.0, height: 34.0)
            layout.minimumLineSpacing = 16
        }

        backgroundColor = UIColor.clear

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.clear
        collectionView.isScrollEnabled = false
        contentView.addSubview(collectionView)
    }

    func setupConstraints() {
        collectionView.snp.makeConstraints() { make in
            make.top.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-24)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-8)
        }
    }

    func displaySchedule(_ screenings: [Screening]) {
        collectionView.reloadData()
    }

    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        collectionView.layoutIfNeeded()
        var size = collectionView.collectionViewLayout.collectionViewContentSize
        // Fix for margins
        size.height += 40
        return size
    }
}

extension ScheduleCell: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return schedule.screenings.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "screeningCell", for: indexPath) as! ScreeningCell
        cell.delegate = delegate
        cell.screening = schedule.screenings[indexPath.row]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
}

extension ScheduleCell: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if schedule.screenings.count == 1 {
            return UIEdgeInsets(top: 0, left: -collectionView.bounds.width + 70.0, bottom: 0, right: 0)
        }
        return UIEdgeInsets.zero
    }
}
