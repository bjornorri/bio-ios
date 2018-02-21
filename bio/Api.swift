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
        let data = [
            "deviceId": getDeviceId()
        ]
        Alamofire.request(url, method: .get, parameters: data, encoding: URLEncoding.default, headers: nil)
            .responseJSON { response in
                if let data = response.result.value {
                    let json = JSON(data)
                    let movies = Movie.fromJSON(json: json)
                    handler(movies)
                }
        }
    }

    class func getUpcoming(handler: @escaping ([Movie]) -> Void) {
        let url = "\(baseURL)/coming_soon"
        let data = [
            "deviceId": getDeviceId()
        ]
        Alamofire.request(url, method: .get, parameters: data, encoding: URLEncoding.default, headers: nil)
            .responseJSON { response in
                if let data = response.result.value {
                    let json = JSON(data)
                    let movies = Movie.fromJSON(json: json)
                    handler(movies)
                }
        }
    }

    class func registerDevice(withId deviceId: String, apnsToken token: String) {
        let url = "\(baseURL)/device"
        let data = [
            "deviceId": deviceId,
            "apnsToken": token
        ]
        Alamofire.request(url, method: .post, parameters: data, encoding: JSONEncoding.default, headers: nil)
    }

    class func createNotification(withDeviceId deviceId: String, imdbId: String, handler: @escaping ([Movie]) -> Void) {
        let url = "\(baseURL)/notify"
        let data = [
            "deviceId": deviceId,
            "imdbId": imdbId
        ]
        Alamofire.request(url, method: .post, parameters: data, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in
                if let data = response.result.value {
                    let json = JSON(data)
                    let movies = Movie.fromJSON(json: json)
                    handler(movies)
                }
        }
    }

    class func deleteNotification(withDeviceId deviceId: String, imdbId: String, handler: @escaping ([Movie]) -> Void) {
        let url = "\(baseURL)/notify"
        let data = [
            "deviceId": deviceId,
            "imdbId": imdbId
        ]
        Alamofire.request(url, method: .delete, parameters: data, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in
                if let data = response.result.value {
                    let json = JSON(data)
                    let movies = Movie.fromJSON(json: json)
                    handler(movies)
                }
        }
    }
}
