//
//  DataStore.swift
//  
//
//  Created by Bjorn Orri Saemundsson on 20/02/2018.
//

import Foundation
import Kingfisher

class DataStore {

    static let shared = DataStore()
    let showtimesUpdatedNotification = NSNotification.Name("showtimesUpdated")
    let upcomingUpdatedNotification = NSNotification.Name("upcomingUpdated")
    let loadingDataUpdatedNotification = NSNotification.Name("loadingDataUpdated")

    var showtimes: [Movie]? {
        didSet {
            NotificationCenter.default.post(name: showtimesUpdatedNotification, object: nil)
        }
    }

    var upcoming: [Movie]? {
        didSet {
            NotificationCenter.default.post(name: upcomingUpdatedNotification, object: nil)
        }
    }

    private var loadingShowtimes = false {
        didSet {
            loadingData = loadingShowtimes || loadingUpcoming
        }
    }
    private var loadingUpcoming = false {
        didSet {
            loadingData = loadingShowtimes || loadingUpcoming
        }
    }

    var loadingData = false {
        didSet {
            guard loadingData != oldValue else { return }
            NotificationCenter.default.post(name: loadingDataUpdatedNotification, object: nil)
        }
    }

    func fetchShowtimes() {
        loadingShowtimes = true
        Api.getShowtimes { movies in
            self.cacheImages(forMovies: movies)
            self.showtimes = movies
            self.loadingShowtimes = false
        }
    }

    func fetchUpcoming() {
        loadingUpcoming = true
        Api.getUpcoming { movies in
            self.cacheImages(forMovies: movies)
            self.upcoming = movies
            self.loadingUpcoming = false
        }
    }

    func fetchData() {
        fetchShowtimes()
        fetchUpcoming()
    }

    private func cacheImages(forMovies movies: [Movie]) {
        for movie in movies {
            if let poster = movie.poster {
                KingfisherManager.shared.retrieveImage(with: poster, options: nil, progressBlock: nil, completionHandler: nil)
            }
            if let backdrop = movie.backdrop {
                KingfisherManager.shared.retrieveImage(with: backdrop, options: nil, progressBlock: nil, completionHandler: nil)
            }
        }
    }
}
