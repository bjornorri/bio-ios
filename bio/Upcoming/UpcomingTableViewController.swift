//
//  UpcomingTableViewController.swift
//  bio
//
//  Created by Bjorn Orri Saemundsson on 11/02/2018.
//  Copyright © 2018 Bjorn Orri Saemundsson. All rights reserved.
//

import UIKit
import SafariServices
import GradientLoadingBar

class UpcomingTableViewController: FadeTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Væntanlegt"
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.bioGray
        tableView.register(UpcomingCell.self, forCellReuseIdentifier: "upcomingCell")
        tableView.estimatedRowHeight = round(UIScreen.main.bounds.width * (3.0 / 8.0)) + 16
        listenForUpdates()
    }

    private func listenForUpdates() {
        NotificationCenter.default.addObserver(forName: DataStore.shared.upcomingUpdatedNotification, object: nil, queue: nil) { _ in
            self.tableView.reloadData()
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataStore.shared.upcoming?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return round(UIScreen.main.bounds.width * (3.0 / 8.0)) + 16
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: "upcomingCell", for: indexPath) as? UpcomingCell) ?? UpcomingCell()
        if let movies = DataStore.shared.upcoming {
            let movie = movies[indexPath.row]
            cell.movie = movie
        }
        cell.posterView.delegate = self
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let movie = DataStore.shared.upcoming?[indexPath.row] else { return }
        showActionSheet(forMovie: movie)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }

    private func showActionSheet(forMovie movie: Movie) {
        let actionSheet = UIAlertController(title: movie.title, message: nil, preferredStyle: .actionSheet)
        let notifyAction = UIAlertAction(title: "Láta mig vita", style: .default, handler: nil)
        let imdbAction = UIAlertAction(title: "IMDb", style: .default, handler: { _ in
            self.presentIMDbController(forMovie: movie)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(notifyAction)
        actionSheet.addAction(imdbAction)
        actionSheet.addAction(cancelAction)
        // Workaround for action sheet delay.
        DispatchQueue.main.async {
            self.present(actionSheet, animated: true, completion: nil)
        }
    }

    private func presentIMDbController(forMovie movie: Movie) {
        guard let url = URL(string: "https://www.imdb.com/title/tt\(movie.imdbId)") else { return }
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredBarTintColor = UIColor.black
        safariVC.preferredControlTintColor = UIColor.bioOrange
        present(safariVC, animated: true, completion: nil)
    }
}
