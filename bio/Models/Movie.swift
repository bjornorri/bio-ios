//
//  Movie.swift
//  bio
//
//  Created by Bjorn Orri Saemundsson on 11/01/2018.
//  Copyright © 2018 Bjorn Orri Saemundsson. All rights reserved.
//

import UIKit
import SwiftyJSON

class Movie: NSObject {

    let title: String?
    let imdbId: String?
    let poster: URL?
    let backdrop: URL?
    let trailerId: String?
    let imdbRating: String?
    let plot: String?
    let genres: [String]?
    let directors: [String]?
    let actors: [String]?
    let duration: Int?

    class func fromJSON(json: JSON) -> [Movie] {
        return json.arrayValue.map() { movieJSON in
            return Movie(json: movieJSON)
        }
    }

    init(json: JSON) {
        title = json["title"].string
        imdbId = json["imdb_id"].string
        let posterURL = json["poster"].string
        poster = posterURL != nil ? URL(string: posterURL!) : nil
        let backdropURL = json["backdrop"].string
        backdrop = backdropURL != nil ? URL(string: backdropURL!) : nil
        trailerId = json["trailer"].dictionary?["key"]?.string
        imdbRating = json["ratings"].dictionary?["imdb"]?.string
        plot = json["plot"].string
        genres = json["genres"].array?.flatMap({ $0.string })
        directors = json["directors"].array?.flatMap({ $0.string })
        actors = json["actors"].array?.flatMap({ $0.string })
        duration = json["durationMinutes"].int
    }
}
