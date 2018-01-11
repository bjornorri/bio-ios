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

    class func fromJSON(json: JSON) -> [Movie] {
        return json.arrayValue.map() { movieJSON in
            return Movie(json: movieJSON)
        }
    }

    init(json: JSON) {
        title = json["title"].string
        imdbId = json["imdb_id"].string
    }
}
