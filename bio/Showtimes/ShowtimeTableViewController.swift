//
//  ShowtimeTableViewController.swift
//  bio
//
//  Created by Bjorn Orri Saemundsson on 11/01/2018.
//  Copyright © 2018 Bjorn Orri Saemundsson. All rights reserved.
//

import UIKit
import GradientLoadingBar

class ShowtimeTableViewController: UITableViewController {

    var movies: [Movie]?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sýningar"
        tableView.backgroundColor = UIColor.bioGray
        tableView.separatorStyle = .none
        tableView.register(ShowtimeCell.self, forCellReuseIdentifier: "showtimeCell")
        fetchData()
    }

    func fetchData() {
        GradientLoadingBar.shared.show()
        Api.getShowtimes() { movies in
            self.movies = movies
            self.tableView.reloadData()
            GradientLoadingBar.shared.hide()
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let movies = movies else { return 0 }
        return movies.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.width * (9.0 / 16.0)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: "showtimeCell", for: indexPath) as? ShowtimeCell) ?? ShowtimeCell()
        if let movies = movies {
            let movie = movies[indexPath.row]
            cell.movie = movie
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let movies = movies else { return }
        let detailVC = ShowtimeDetailViewController()
        detailVC.movie = movies[indexPath.row]
        show(detailVC, sender: nil)
    }
}

extension ShowtimeTableViewController {

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let statusBarFrame = UIApplication.shared.statusBarFrame
        guard let cells = tableView.visibleCells as? [MovieCell] else { return }
        for cell in cells {
            let cellRect = cell.frame.offsetBy(dx: 0, dy: -tableView.contentOffset.y)
            let intersection = cellRect.intersection(statusBarFrame)
            let maskY = intersection.maxY + tableView.contentOffset.y - cell.frame.minY
            cell.maskY = maskY == CGFloat.infinity ? 0 : maskY
        }
    }
}
