//
//  Screening.swift
//  bio
//
//  Created by Bjorn Orri Saemundsson on 16/01/2018.
//  Copyright © 2018 Bjorn Orri Saemundsson. All rights reserved.
//

import UIKit
import SwiftyJSON

class Screening: NSObject {

    var time: Date!
    var purchaseURL: URL?
    var cinemaName: String!
    var room: String?
    var three_d: Bool!
    var icelandic: Bool!

    convenience init(time: Date!, purchaseURL: URL?, cinemaName: String, room: String?, three_d: Bool!, icelandic: Bool!) {
        self.init()
        self.time = time
        self.purchaseURL = purchaseURL
        self.cinemaName = cinemaName
        self.room = room
        self.three_d = three_d
        self.icelandic = icelandic
    }

    class func fromJSON(_ json: JSON, cinemaName: String) -> [Screening] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXX"
        let screenings = json.array?.flatMap() { j -> Screening? in
            guard let timeString = j["time"].string, let time = formatter.date(from: timeString) else { return nil }
            let url = j["purchase_url"].string
            let room = j["room"].string
            let three_d = j["three_d"].bool ?? false
            let icelandic = j["icelandic"].bool ?? false
            let screening = Screening(time: time, purchaseURL: url?.toURL(), cinemaName: cinemaName, room: room, three_d: three_d, icelandic: icelandic)
            return screening
        }
        return screenings ?? []
    }
}
