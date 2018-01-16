//
//  Schedule.swift
//  bio
//
//  Created by Bjorn Orri Saemundsson on 16/01/2018.
//  Copyright © 2018 Bjorn Orri Saemundsson. All rights reserved.
//

import UIKit
import SwiftyJSON

class Schedule: NSObject {

    var cinemaName: String!
    var screenings: [Screening]!

    convenience init(cinema: String, screenings: [Screening]) {
        self.init()
        self.cinemaName = cinema
        self.screenings = screenings
    }

    class func fromJSON(_ json: JSON) -> Schedule? {
        guard let cinema = json["cinema"].dictionary?["name"]?.string else { return nil }
        let screenings = Screening.fromJSON(json["schedule"])
        if screenings.isEmpty { return nil }
        return Schedule(cinema: cinema, screenings: screenings)
    }
}
