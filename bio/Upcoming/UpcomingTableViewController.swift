//
//  UpcomingTableViewController.swift
//  bio
//
//  Created by Bjorn Orri Saemundsson on 11/02/2018.
//  Copyright © 2018 Bjorn Orri Saemundsson. All rights reserved.
//

import UIKit
import GradientLoadingBar

class UpcomingTableViewController: UITableViewController {

    var movies: [Movie]?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Væntanlegt"
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.bioGray
        tableView.register(UpcomingCell.self, forCellReuseIdentifier: "upcomingCell")
        tableView.estimatedRowHeight = round(UIScreen.main.bounds.width * (3.0 / 8.0)) + 16
        fetchData()
    }

    func fetchData() {
        GradientLoadingBar.shared.show()
        Api.getUpcoming() { movies in
            self.movies = movies
            self.tableView.reloadData()
            GradientLoadingBar.shared.hide()
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return round(UIScreen.main.bounds.width * (3.0 / 8.0)) + 16
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: "upcomingCell", for: indexPath) as? UpcomingCell) ?? UpcomingCell()
        if let movies = movies {
            let movie = movies[indexPath.row]
            cell.movie = movie
        }
        cell.posterView.delegate = self
        return cell
    }
}
