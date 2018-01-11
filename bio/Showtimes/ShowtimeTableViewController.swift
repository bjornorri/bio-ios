//
//  ShowtimeTableViewController.swift
//  bio
//
//  Created by Bjorn Orri Saemundsson on 11/01/2018.
//  Copyright © 2018 Bjorn Orri Saemundsson. All rights reserved.
//

import UIKit

class ShowtimeTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Api.getComingSoon() { movies in
            movies.forEach() { movie in
                print(movie.title!)
            }
        }
    }
}
