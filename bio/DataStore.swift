//
//  DataStore.swift
//  
//
//  Created by Bjorn Orri Saemundsson on 20/02/2018.
//

import Foundation
import Kingfisher
import RxSwift

class DataStore {

    static let shared = DataStore()

    let showtimesUpdatedNotification = NSNotification.Name("showtimesUpdated")
    let upcomingUpdatedNotification = NSNotification.Name("upcomingUpdated")

    let showtimes = Variable<[Movie]?>(nil)
    let upcoming = Variable<[Movie]?>(nil)
    let loadingShowtimes = Variable<Bool>(false)
    let loadingUpcoming = Variable<Bool>(false)

    private init() {
        NotificationCenter.default.addObserver(forName: .UIApplicationWillEnterForeground, object: nil, queue: nil) { _ in
            self.fetchData()
        }
    }

    func fetchShowtimes() {
        loadingShowtimes.value = true
        Api.getShowtimes { movies in
            self.cacheImages(forMovies: movies)
            self.showtimes.value = movies
            self.loadingShowtimes.value = false
        }
    }

    func fetchUpcoming() {
        loadingUpcoming.value = true
        Api.getUpcoming { movies in
            self.cacheImages(forMovies: movies)
            self.upcoming.value = movies
            self.loadingUpcoming.value = false
        }
    }

    func fetchData() {
        fetchShowtimes()
        fetchUpcoming()
    }

    func requestNotification(forMovie movie: Movie) {
        Api.createNotification(withDeviceId: getDeviceId(), imdbId: movie.imdbId) { movies in
            DataStore.shared.upcoming.value = movies
        }
    }

    func deleteNotification(forMovie movie: Movie) {
        Api.deleteNotification(withDeviceId: getDeviceId(), imdbId: movie.imdbId) { movies in
            DataStore.shared.upcoming.value = movies
        }
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
