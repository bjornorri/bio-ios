//
//  UpcomingTableViewController.swift
//  bio
//
//  Created by Bjorn Orri Saemundsson on 11/02/2018.
//  Copyright © 2018 Bjorn Orri Saemundsson. All rights reserved.
//

import UIKit
import SafariServices
import RxSwift

class UpcomingTableViewController: FadeTableViewController {

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Væntanlegt"
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.bioGray
        tableView.register(UpcomingCell.self, forCellReuseIdentifier: "upcomingCell")
        let rowHeight = round(UIScreen.main.bounds.width * (3.0 / 8.0)) + 16
        tableView.estimatedRowHeight = rowHeight
        tableView.rowHeight = rowHeight
        registerForPreviewing(with: self, sourceView: tableView)
        listenForUpdates()
        setupLoadingIndicator()
    }

    private func listenForUpdates() {
        DataStore.shared.upcoming.subscribe { movies in
            self.tableView.reloadData()
        }.disposed(by: disposeBag)
    }

    private func setupLoadingIndicator() {
        refreshControl = UIRefreshControl()
        refreshControl?.tintColor = UIColor.white
        refreshControl?.layer.zPosition = -1
        refreshControl?.addTarget(self, action: #selector(fetchData), for: .valueChanged)
        DataStore.shared.loadingUpcoming.subscribe { loading in
            loading ? self.refreshControl?.beginRefreshing() : self.refreshControl?.endRefreshing()
            }.disposed(by: disposeBag)
    }

    @objc private func fetchData() {
        DataStore.shared.fetchUpcoming()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataStore.shared.upcoming.value?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "upcomingCell", for: indexPath)
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? MovieCell else { return }
        if let movies = DataStore.shared.upcoming.value {
            let movie = movies[indexPath.row]
            cell.movie = movie
        }
        cell.posterView.delegate = self
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let movie = DataStore.shared.upcoming.value?[indexPath.row] else { return }
        showActionSheet(forMovie: movie)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }

    private func showActionSheet(forMovie movie: Movie) {
        let actionSheet = UIAlertController(title: movie.title, message: nil, preferredStyle: .actionSheet)
        let notifyAction = getNotifyAction(forMovie: movie)
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

    private func imdbController(forMovie movie: Movie) -> SFSafariViewController? {
        guard let url = URL(string: "https://www.imdb.com/title/tt\(movie.imdbId)") else { return nil }
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredBarTintColor = UIColor.black
        safariVC.preferredControlTintColor = UIColor.bioYellow
        return safariVC
    }

    private func presentIMDbController(forMovie movie: Movie) {
        guard let safariVC = imdbController(forMovie: movie) else { return }
        present(safariVC, animated: true, completion: nil)
    }

    private func showNotificationWarning() {
        let alert = UIAlertController(title: "Hey!", message: "Þú ert með slökkt á tilkynningum. Vinsamlegast breyttu stillingunum til þess að fá tilkynningar frá okkur.", preferredStyle: .alert
        )
        let noAction = UIAlertAction(title: "Nei takk", style: .cancel, handler: nil)
        let settingsAction = UIAlertAction(title: "Stillingar", style: .default) { _ in
            self.openAppSettings()
        }
        alert.addAction(noAction)
        alert.addAction(settingsAction)
        present(alert, animated: true, completion: nil)
    }

    private func openAppSettings() {
        guard let url = URL(string: UIApplicationOpenSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }

    private func getNotifyAction(forMovie movie: Movie) -> UIAlertAction {
        return (movie.notify && UIApplication.shared.isRegisteredForRemoteNotifications) ? abortNotificationAction(forMovie: movie) : requestNotificationAction(forMovie: movie)
    }

    private func requestNotificationAction(forMovie movie: Movie) -> UIAlertAction {
        return UIAlertAction(title: "Fá tilkynningu", style: .default) { _ in
            if UIApplication.shared.isRegisteredForRemoteNotifications {
                DataStore.shared.requestNotification(forMovie: movie)
                return
            }
            NotificationManager.shared.registerForPushNotifications() { success in
                success ? DataStore.shared.requestNotification(forMovie: movie) : self.showNotificationWarning()
            }
        }
    }

    private func abortNotificationAction(forMovie movie: Movie) -> UIAlertAction {
        return UIAlertAction(title: "Hætta við tilkynningu", style: .destructive) { _ in
            DataStore.shared.deleteNotification(forMovie: movie)
        }
    }
}

extension UpcomingTableViewController: UIViewControllerPreviewingDelegate {

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = tableView.indexPathForRow(at: location),
            let movie = DataStore.shared.upcoming.value?[indexPath.row] else { return nil }
        previewingContext.sourceRect = tableView.rectForRow(at: indexPath)
        let imdbVC = imdbController(forMovie: movie)
        return imdbVC
    }

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        present(viewControllerToCommit, animated: false, completion: nil)
    }
}
