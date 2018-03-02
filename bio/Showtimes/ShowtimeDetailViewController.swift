//
//  ShowtimeDetailViewController.swift
//  bio
//
//  Created by Bjorn Orri Saemundsson on 14/01/2018.
//  Copyright © 2018 Bjorn Orri Saemundsson. All rights reserved.
//

import UIKit
import SafariServices
import RxSwift

class ShowtimeDetailViewController: FadeTableViewController {

    let disposeBag = DisposeBag()

    var imdbId: String!
    var movie: Movie? {
        return DataStore.shared.showtimes.value?.first(where: { $0.imdbId == self.imdbId })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ScheduleCell.self, forCellReuseIdentifier: "scheduleCell")
        tableView.register(CinemaHeader.self, forCellReuseIdentifier: "cinemaHeader")
        tableView.backgroundColor = UIColor.black
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        listenToUpdates()
    }

    private func listenToUpdates() {
        DataStore.shared.showtimes.asObservable().subscribe(onNext: { movies in
            self.displayMovie()
        }).disposed(by: disposeBag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.setNeedsLayout()
        tableView.layoutIfNeeded()
    }

    func displayMovie() {
        guard let movie = movie else { return }
        // Navigation title
        title = movie.title

        // Background
        let backgroundView = UIImageView()
        backgroundView.alpha = 0.3
        backgroundView.contentMode = .scaleAspectFill
        backgroundView.kf.setImage(with: movie.backdrop)
        tableView.backgroundView = backgroundView

        // TableView header
        let movieView = MovieView(movie: movie)
        movieView.posterView.delegate = self
        tableView.tableHeaderView = movieView

        // TableView
        tableView.setNeedsLayout()
        tableView.layoutIfNeeded()
        tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = movie?.showtimes?.count {
            return count * 2
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 2 == 0 {
            return dequeueHeader(at: indexPath)
        } else {
            return dequeueCell(at: indexPath)
        }
    }

    private func dequeueHeader(at indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row / 2
        guard let schedule = movie?.showtimes?[index] else { return UITableViewCell(frame: CGRect.zero) }
        let header = tableView.dequeueReusableCell(withIdentifier: "cinemaHeader", for: indexPath) as! CinemaHeader
        header.schedule = schedule
        return header
    }

    private func dequeueCell(at indexPath: IndexPath) -> UITableViewCell {
        let index = (indexPath.row - 1) / 2
        guard let schedule = movie?.showtimes?[index] else { return UITableViewCell(frame: CGRect.zero) }
        let cell = tableView.dequeueReusableCell(withIdentifier: "scheduleCell", for: indexPath) as! ScheduleCell
        cell.schedule = schedule
        cell.delegate = self
        return cell
    }

    private func showActionSheet(forScreening screening: Screening) {
        var title = "\(screening.time.timeString()) - \(screening.cinemaName!)"
        if let room = screening.room {
            let roomString = room.count < 2 ? "Salur \(room)" : room
            title = "\(title) - \(roomString)"
        }
        var info = [String]()
        if screening.three_d { info.append("3D") }
        if screening.icelandic { info.append("Ísl. tal") }
        let message = info.isEmpty ? nil : info.joined(separator: " - ")
        let actionSheet = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let buyAction = UIAlertAction(title: "Kaupa miða", style: .default, handler: { _ in
            self.presentPurchaseController(withUrl: screening.purchaseURL)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(buyAction)
        actionSheet.addAction(cancelAction)
        // Workaround for action sheet delay.
        DispatchQueue.main.async {
            self.present(actionSheet, animated: true, completion: nil)
        }

    }

    private func presentPurchaseController(withUrl url: URL?) {
        guard let url = url else { return }
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredBarTintColor = UIColor.black
        safariVC.preferredControlTintColor = UIColor.bioYellow
        present(safariVC, animated: true, completion: nil)
    }
}

extension ShowtimeDetailViewController: ScreeningCellDelegate {

    func didPressItem(withScreening screening: Screening) {
        showActionSheet(forScreening: screening)
    }
}
