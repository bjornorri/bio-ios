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

    convenience init(time: Date!, purchaseURL: URL?) {
        self.init()
        self.time = time
        self.purchaseURL = purchaseURL
    }

    class func fromJSON(_ json: JSON) -> [Screening] {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let screenings = json.array?.flatMap() { j -> Screening? in
            guard let string = j["time"].string, let substr = string.split(separator: " ").first else { return nil }

            let timeString = String(substr)
            guard let time = formatter.date(from: timeString) else { return nil }
            let url = j["purchase_url"].string
            return Screening(time: time, purchaseURL: url?.toURL())
        }
        return screenings ?? []
    }
}
