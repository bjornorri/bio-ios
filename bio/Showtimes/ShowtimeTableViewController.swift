//
//  ShowtimeTableViewController.swift
//  bio
//
//  Created by Bjorn Orri Saemundsson on 11/01/2018.
//  Copyright © 2018 Bjorn Orri Saemundsson. All rights reserved.
//

import UIKit
import RxSwift

class ShowtimeTableViewController: FadeTableViewController {

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sýningar"
        tableView.backgroundColor = UIColor.bioGray
        tableView.separatorStyle = .none
        tableView.register(ShowtimeCell.self, forCellReuseIdentifier: "showtimeCell")
        let rowHeight = tableView.bounds.width * (9.0 / 16.0)
        tableView.estimatedRowHeight = rowHeight
        tableView.rowHeight = rowHeight
        registerForPreviewing(with: self, sourceView: tableView)
        listenForUpdates()
    }

    private func listenForUpdates() {
        DataStore.shared.showtimes.subscribe { movies in
            self.tableView.reloadData()
        }.disposed(by: disposeBag)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let movies = DataStore.shared.showtimes.value else { return 0 }
        return movies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "showtimeCell", for: indexPath)
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? MovieCell else { return }
        if let movies = DataStore.shared.showtimes.value {
            let movie = movies[indexPath.row]
            cell.movie = movie
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let movies = DataStore.shared.showtimes.value else { return }
        let detailVC = ShowtimeDetailViewController()
        detailVC.movie = movies[indexPath.row]
        show(detailVC, sender: nil)
    }
}

extension ShowtimeTableViewController: UIViewControllerPreviewingDelegate {

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = tableView.indexPathForRow(at: location),
        let movie = DataStore.shared.showtimes.value?[indexPath.row] else { return nil }
        previewingContext.sourceRect = tableView.rectForRow(at: indexPath)
        let detailVC = ShowtimeDetailViewController()
        detailVC.movie = movie
        return detailVC
    }

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: nil)
    }
}
