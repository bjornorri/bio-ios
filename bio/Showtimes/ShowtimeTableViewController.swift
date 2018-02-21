//
//  ShowtimeTableViewController.swift
//  bio
//
//  Created by Bjorn Orri Saemundsson on 11/01/2018.
//  Copyright © 2018 Bjorn Orri Saemundsson. All rights reserved.
//

import UIKit

class ShowtimeTableViewController: FadeTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sýningar"
        tableView.backgroundColor = UIColor.bioGray
        tableView.separatorStyle = .none
        tableView.register(ShowtimeCell.self, forCellReuseIdentifier: "showtimeCell")
        listenForUpdates()
    }

    private func listenForUpdates() {
        NotificationCenter.default.addObserver(forName: DataStore.shared.showtimesUpdatedNotification, object: nil, queue: nil) { _ in
            self.tableView.reloadData(animated: true)
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let movies = DataStore.shared.showtimes else { return 0 }
        return movies.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.width * (9.0 / 16.0)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: "showtimeCell", for: indexPath) as? ShowtimeCell) ?? ShowtimeCell()
        if let movies = DataStore.shared.showtimes {
            let movie = movies[indexPath.row]
            cell.movie = movie
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let movies = DataStore.shared.showtimes else { return }
        let detailVC = ShowtimeDetailViewController()
        detailVC.movie = movies[indexPath.row]
        show(detailVC, sender: nil)
    }
}
