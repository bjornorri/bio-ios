//
//  ShowtimeDetailViewController.swift
//  bio
//
//  Created by Bjorn Orri Saemundsson on 14/01/2018.
//  Copyright © 2018 Bjorn Orri Saemundsson. All rights reserved.
//

import AVKit
import UIKit
import XCDYouTubeKit

class ShowtimeDetailViewController: UITableViewController {

    var movie: Movie!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ScheduleCell.self, forCellReuseIdentifier: "scheduleCell")
        tableView.backgroundColor = UIColor.black
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        displayMovie()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.setNeedsLayout()
        tableView.layoutIfNeeded()
    }

    func displayMovie() {
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
        movieView.delegate = self
        tableView.tableHeaderView = movieView

        // TableView
        tableView.setNeedsLayout()
        tableView.layoutIfNeeded()
        tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return movie.showtimes?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let schedule = movie.showtimes?[section] else { return nil }
        return CinemaHeader(schedule: schedule)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let screenings = movie.showtimes?[indexPath.section].screenings else { return UITableViewCell(frame: CGRect.zero) }
        let cell = tableView.dequeueReusableCell(withIdentifier: "scheduleCell", for: indexPath) as! ScheduleCell
        cell.displayScreenings(screenings)
        return cell
    }
}

extension ShowtimeDetailViewController: MovieViewDelegate {

    func playTrailer() {
        guard let trailerId = movie.trailerId else { return }

        let playerVC = AVPlayerViewController()
        playerVC.entersFullScreenWhenPlaybackBegins = true
        playerVC.exitsFullScreenWhenPlaybackEnds = true
        self.present(playerVC, animated: true)

        let keys: [AnyHashable] = [XCDYouTubeVideoQualityHTTPLiveStreaming, XCDYouTubeVideoQuality.HD720.rawValue, XCDYouTubeVideoQuality.medium360.rawValue, XCDYouTubeVideoQuality.small240.rawValue]

        XCDYouTubeClient.default().getVideoWithIdentifier(trailerId) { [weak playerVC] (video, error) in
            let streams = keys.map({ video?.streamURLs[$0] }).flatMap({ $0 })
            if let streamURL = streams.first {
                playerVC?.player = AVPlayer(url: streamURL)
                playerVC?.player?.play()
            } else {
                playerVC?.dismiss(animated: true)
            }
        }
    }
}

