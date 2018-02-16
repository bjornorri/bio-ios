//
//  Utils.swift
//  bio
//
//  Created by Bjorn Orri Saemundsson on 13/02/2018.
//  Copyright © 2018 Bjorn Orri Saemundsson. All rights reserved.
//

import Foundation

func getAttributedInfoString(forMovie movie: Movie, skipPlot: Bool = false) -> NSAttributedString {

    var info = [String]()
    if let releaseDate = movie.releaseDate {
        let string = "Frumsýnd: \(releaseDate.releaseDateString())"
        info.append(string)
    }
    if let genres = movie.genres {
        let string = "Flokkur: \(genres.joined(separator: ", "))"
        info.append(string)
    }
    if let rating = movie.imdbRating {
        let string = "IMDb: \(rating)"
        info.append(string)
    }
    if let duration = movie.duration {
        let string = "Lengd: \(duration) mín"
        info.append(string)
    }
    if let directors = movie.directors {
        let string = "Leikstjóri: \(directors.joined(separator: ", "))"
        info.append(string)
    }
    if let actors = movie.actors {
        let string = "Leikarar: \(actors.joined(separator: ", "))"
        info.append(string)
    }
    if let plot = movie.plot, !skipPlot {
        let string = "\n\(plot)"
        info.append(string)
    }
    let infoString = info.joined(separator: "\n").attributedInfoString()
    return infoString
}
