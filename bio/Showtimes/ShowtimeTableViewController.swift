//
//  ShowtimeTableViewController.swift
//  bio
//
//  Created by Bjorn Orri Saemundsson on 11/01/2018.
//  Copyright © 2018 Bjorn Orri Saemundsson. All rights reserved.
//

import UIKit
import Kingfisher

class ShowtimeTableViewController: UITableViewController {

    var movies: [Movie]?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.bioGray
        tableView.dataSource = self
        tableView.delegate = self
        fetchData()
    }

    func fetchData() {
        Api.getShowtimes() { movies in
            self.movies = movies
            self.tableView.reloadData()
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
        return tableView.bounds.width / 1.78
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "showtimeCell", for: indexPath) as? ShowtimeCell else { return UITableViewCell()}
        if let movies = movies {
            let movie = movies[indexPath.row]
            cell.backdropView.kf.setImage(with: movie.backdrop)
            cell.posterView.kf.setImage(with: movie.poster)
        }
        return cell
    }
}
