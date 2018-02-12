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

    var dates: [Date]?
    var movies = [Date : [Movie]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Væntanlegt"
        tableView.backgroundColor = UIColor.bioGray
        tableView.separatorStyle = .none
        tableView.register(ShowtimeCell.self, forCellReuseIdentifier: "showtimeCell")
        fetchData()
    }

    func fetchData() {
        GradientLoadingBar.shared.show()
        Api.getUpcoming() { movies in
            let dates = Set(movies.flatMap({ $0.release_date })).sorted()
            self.dates = dates
            for date in dates {
                self.movies[date] = movies.filter({ $0.release_date == date })
            }
            self.tableView.reloadData()
            GradientLoadingBar.shared.hide()
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return dates?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dates = dates else { return 0 }
        return movies[dates[section]]?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let date = dates?[section] else { return nil }
        let header = UpcomingHeader()
        header.displayDate(date)
        return header
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.width * (9.0 / 16.0)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: "showtimeCell", for: indexPath) as? ShowtimeCell) ?? ShowtimeCell()
        if let date = dates?[indexPath.section], let movie = movies[date]?[indexPath.row] {
            cell.displayMovie(movie)
        }
        return cell
    }
}
