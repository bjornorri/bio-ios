//
//  ShowtimeDetailViewController.swift
//  bio
//
//  Created by Bjorn Orri Saemundsson on 14/01/2018.
//  Copyright © 2018 Bjorn Orri Saemundsson. All rights reserved.
//

import UIKit

class ShowtimeDetailViewController: UITableViewController {

    var movie: Movie!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor.black
        tableView.separatorStyle = .none
        displayMovie()
    }

    func displayMovie() {
        title = movie.title
        let backgroundView = UIImageView()
        backgroundView.alpha = 0.5
        backgroundView.contentMode = .scaleAspectFill
        backgroundView.kf.setImage(with: movie.backdrop)
        tableView.backgroundView = backgroundView

    }
}
