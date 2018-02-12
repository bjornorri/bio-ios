//
//  Api.swift
//  bio
//
//  Created by Bjorn Orri Saemundsson on 11/01/2018.
//  Copyright © 2018 Bjorn Orri Saemundsson. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Api {

    private static let baseURL = "https://bio-server.herokuapp.com"

    class func getShowtimes(handler: @escaping ([Movie]) -> Void) {
        let url = "\(baseURL)/showtimes"
        Alamofire.request(url).responseData { response in
            if let data = response.result.value {
                let json = try? JSON(data: data)
                let movies = Movie.fromJSON(json: json!)
                handler(movies)
            }
        }
    }

    class func getUpcoming(handler: @escaping ([Movie]) -> Void) {
        let url = "\(baseURL)/coming_soon"
        Alamofire.request(url).responseJSON { response in
            if let data = response.result.value {
                let json = JSON(data)
                let movies = Movie.fromJSON(json: json)
                handler(movies)
            }
        }
    }
}
